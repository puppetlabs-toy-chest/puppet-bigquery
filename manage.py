import uuid
import os
import json
from os import walk
from os.path import splitext
from datetime import datetime

from google.cloud import bigquery
from filecache import filecache
from terminaltables import AsciiTable, GithubFlavoredMarkdownTable
import pygal


CACHE_TIME_SECONDS = 5 * 24 * 60 * 60

@filecache(CACHE_TIME_SECONDS)
def run_query(q):
    client = bigquery.Client()
    query_job = client.run_async_query(str(uuid.uuid4()), q)
    query_job.begin()
    query_job.result()
    destination_table = query_job.destination
    destination_table.reload()
    result = []
    for row in destination_table.fetch_data():
        result.append(row)
    return result
	

def table(query, header, builder=AsciiTable):
    data = run_query(query)
    data.insert(0, header)
    table = builder(data)
    return table.table


def line_chart(query, label, name):
    data = run_query(query)
    if len(data[0]) == 2:
        chart = pygal.Line()
        chart.x_labels = [item[0] for item in data]
        chart.add(label, [item[1] for item in data])
        chart.render_to_file(name)
        return True
    else:
        return False


def data(query, path):
    title = path.replace("-", " ").capitalize()
    results = run_query(query)
    date = datetime.now().strftime("%Y-%m-%d")
    directory = "output/%s" % date
    if not os.path.exists(directory):
        os.makedirs(directory)
    with open("%s/%s.json" % (directory, path), 'w') as json_file:
        json_file.write(json.dumps(results))



def markdown(query, path, header):
    title = path.replace("-", " ").capitalize()
    date = datetime.now().strftime("%Y-%m-%d")
    directory = "output/%s" % date
    if not os.path.exists(directory):
        os.makedirs(directory)
    assets = "%s/assets" % directory
    if not os.path.exists(assets):
        os.makedirs(assets)
    chart = line_chart(query, title, "%s/%s.svg" % (assets, path))
    with open("%s/%s.md" % (directory, path), 'w') as md:
        data = table(query, header, GithubFlavoredMarkdownTable)
        code = "```sql\n%s\n```" % query
        if chart:
            image = "![Commits](assets/%s.png)" % path
        else:
            image = ""
        title = "# %s" % title
        out = "%s\n\n%s\n\n%s\n\n%s" % (title, code, data, image)
        md.write(out)


paths = []
for (dirpath, dirnames, filenames) in walk('queries'):
    paths.extend(filenames)

for path in paths:
    with open("queries/%s" % path, 'r') as sql:
        query = sql.read()
    header = query.split("\n")[0].strip('-- ').split(',')
    identifier = splitext(path)[0]
    markdown(query, identifier, header)
    data(query, identifier)
