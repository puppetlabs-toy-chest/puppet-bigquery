import uuid

from google.cloud import bigquery
from filecache import filecache
from terminaltables import AsciiTable, GithubFlavoredMarkdownTable
import pygal


CACHE_TIME_SECONDS = 24 * 60 * 60

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
    chart = pygal.Line()
    chart.x_labels = [item[0] for item in data]
    chart.add(label, [item[1] for item in data])
    chart.render_to_file(name)


def markdown(query, title, header):
    path = title.lower().replace(' ', '-')
    line_chart(query, title, "output/assets/%s.svg" % path)
    with open("output/%s.md" % path, 'w') as md:
        data = table(query, header, GithubFlavoredMarkdownTable)
        code = "```sql\n%s\n```" % query
        image = "![Commits](assets/%s.png)" % path
        title = "# %s" % title
        out = "%s\n\n%s\n\n%s\n\n%s" % (title, code, data, image)
        md.write(out)


query = """SELECT author_date, COUNT(*) as commits
FROM (
  SELECT YEAR(author_date) as author_date
  FROM [puppet.puppet_commits]
)
GROUP BY author_date
ORDER BY author_date DESC"""

markdown(query, 'Commits by Year', ('Year', 'Commit'))
