import uuid
import os
import json
from os import walk
from os.path import splitext
from datetime import datetime
import ntpath

import click
from google.cloud import bigquery
from filecache import filecache
from terminaltables import AsciiTable, GithubFlavoredMarkdownTable
import pygal


CACHE_TIME_SECONDS = 5 * 24 * 60 * 60

@filecache(CACHE_TIME_SECONDS)
def run_query(q):
    debug("Running query")
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

def prepare_output_dir(path):
    date = datetime.now().strftime("%Y-%m-%d")
    directory = "%s/%s" % (path, date)
    if not os.path.exists(directory):
        debug("Preparing output folder %s" % directory)
        os.makedirs(directory)
    assets = "%s/assets" % directory
    if not os.path.exists(assets):
        debug("Preparing assets folder %s" % assets)
        os.makedirs(assets)
    return directory

def save_data(query, path, directory):
    debug("Saving data for %s" % path)
    results = run_query(query)
    with open("%s/%s.json" % (directory, path), 'w') as json_file:
        json_file.write(json.dumps(results))

def save_markdown(query, path, directory):
    header = query.split("\n")[0].strip('-- ').split(',')
    title = path.replace("-", " ").capitalize()
    debug("Generating markdown for %s" % path)
    chart = line_chart(query, title, "%s/assets/%s.svg" % (directory, path))
    with open("%s/%s.md" % (directory, path), 'w') as md:
        data = table(query, header, GithubFlavoredMarkdownTable)
        code = "```sql\n%s\n```" % query
        if chart:
            image = "![%s](assets/%s.png)" % (title, path)
        else:
            image = ""
        title = "# %s" % title
        out = "%s\n\n%s\n\n%s\n\n%s" % (title, code, data, image)
        md.write(out)

def list_queries(path):
    paths = []
    for (dirpath, dirnames, filenames) in walk(path):
        for filename in filenames:
            if filename.endswith(".sql"):
                paths.append("%s/%s" % (dirpath, filename))
    return paths

def info(message):
    click.echo(click.style(message, fg='green'))

def debug(message):
    click.echo(click.style("  %s" % message, fg='yellow'))

@click.command()
@click.option('--queries', default='queries', metavar='PATH', help='Directory to store SQL queries')
@click.option('--output', default='output', metavar='PATH', help='Directory to generated reports')
@click.argument('query', required=False, type=click.Path(exists=True))
def generate(queries, output, query):
    """
    Generate runs one or more BigQuery queries and saves the results 
    """
    if query:
        paths = [query]
    else:
        paths = list_queries(queries)

    directory = prepare_output_dir(output)

    for path in paths:
        with open(path, 'r') as sql:
            query = sql.read()
        filename = ntpath.basename(path)
        identifier = splitext(filename)[0]
        info("Processing %s" % identifier)
        save_markdown(query, identifier, directory)
        save_data(query, identifier, directory)

@click.group()
def cli():
    """
    This CLI is intended to provide a nice interface for interacting
    with this repository including triggering queries on Google BigQuery
    and saving the results in useful formats for analysis.
    """
    pass

cli.add_command(generate)

if __name__ == '__main__':
    cli()
