
This repository contains a series of tools and queries for interrogating Puppet code available in the BigQuery index of GitHub.

* [BigQuery Console](https://bigquery.cloud.google.com/)
* [Installing `bq` CLI tool](https://cloud.google.com/bigquery/bq-command-line-tool)

See the presentation [How people actually write Puppet](https://speakerdeck.com/garethr/how-people-actually-write-puppet-code) from PuppetConf 2017 for more details.


# Setup

You will first need to register for Google Cloud, and ensure you have access to the BigQuery service. It would be advisable to run through one of the [quickstart](https://cloud.google.com/bigquery/docs/quickstarts) guides to familiar yourself with the tooling.

Now head over to the [console](https://bigquery.cloud.google.com) and create a new dataset called `puppet` (the tools in this repository assume that name). Before we start writing interesting queries we need to setup a few tables and views so we can isolate the Puppet code we're interested in from the entire contents of GitHub.

```
$ ./refresh_tables.sh
```

This script will use the command line `bq` tool to generate each table and view we'll use. If you need to customize its invocation and specify a project ID, for example, then you can do so in your `~/.bigqueryrc` file.

Depending on your account you may need to [create and download a credential file for a service account](https://developers.google.com/identity/protocols/application-default-credentials). If so you'll likely see the message `Could not automatically determine credentials. Please set GOOGLE_APPLICATION_CREDENTIALS`. If that is the case then download the file as described and then

```
export GOOGLE_APPLICATION_CREDENTIALS=<path/to/file>
```

The schemas are described at the end of this document in the [manual setup](#manual-setup) section.


## Usage

With the above all set up you can now make queries against those tables. As a simple example, try running the following query, to count the lines of Puppet code in your table, from the console:

```sql
SELECT
  COUNT(line) total_lines
FROM (
  SELECT SPLIT(content, '\n') AS line
  FROM [puppet.puppet_content]
)
```

Or via `bq`:

```
$ bq query "SELECT COUNT(line) total_lines FROM (SELECT SPLIT(content, '\n') AS line FROM [puppet.puppet_content])"
Waiting on bqjob_r1b4d8418_000001604fa5218b_1 ... (2s) Current status: DONE
+-------------+
| total_lines |
+-------------+
|     7512483 |
+-------------+
```

This repository also contains a simple script to help generate output from queries. Using that requires Python installed and a few dependencies:

```
virtualenv .
bin/activate
pip install -r requirements.txt
```

With that setup you can run the CLI tool:

```
$ ./manage.py generate queries/count-puppet.sql
Processing count-puppet
  Generating markdown for count-puppet
  Running query
  Saving data for count-puppet
```

This should create a new directory in the `output` folder for today's date, and generate a report. If you don't specify a specific query then it will run against all queries in the `queries` folder. This tooling isn't required, it's just a nice way of creating basic reports from stored queries, and archiving those reports for later viewing in the git repository.


----------------

## Manual Setup

If the shell script doesn't work for you, or if you're curious about the schemas, or if you're masochistic and would like to build the tables and views by hand, this section will describe how to do so. Otherwise, you may skip it.

### Puppet code

Create a view in the `puppet` project called `puppet_files` based on the following query. This will provide a very long list of `.pp` files in master branches.

```sql
SELECT *
FROM [bigquery-public-data:github_repos.files]
WHERE RIGHT(path, 3) = '.pp'
AND ref = 'refs/heads/master'
```

Next create a table called `puppet_content` with the following query. Note this is a table rather than a view due to the size, this contains all of the contents of the files in the above view. The view does not need updating, but you will want to periodically rerun this query and repopulate the table. Doing so is relatively expensive so querying against a cached data set is advisable.

```sql
SELECT *
FROM [bigquery-public-data:github_repos.contents]
WHERE id IN (SELECT id FROM [puppet.puppet_files])
```

### Puppetfiles

As well as having tables of all the Puppet code itself it's useful to store data about related content too. The following query can be used for create a view called `puppetfile_files`, which stores a list of all the `Puppetfiles` found on GitHub.

```sql
SELECT *
FROM [bigquery-public-data:github_repos.files]
WHERE path CONTAINS 'Puppetfile'
AND NOT path CONTAINS 'Puppetfile.lock'
AND ref = 'refs/heads/master'
```

And similar to the above, we also want to create a table containing all of the contents of those files, called `puppetfile_content`:

```sql
SELECT *
FROM [bigquery-public-data:github_repos.contents]
WHERE id IN (SELECT id FROM [puppet.puppetfile_files])
```

### Gemfiles associated with Puppet code

Lots of Puppet projects also have a Gemfile so we'll snag those too. First in a view of files called `gemfile_files`:

```sql
SELECT *
FROM [bigquery-public-data:github_repos.files]
WHERE path CONTAINS 'Gemfile'
AND NOT path CONTAINS 'Gemfile.lock'
AND ref = 'refs/heads/master'
AND repo_name IN (SELECT repo_name FROM [puppet.puppet_files])
```

And then create a table based on that view of the file contents called `gemfile_content`:

```sql
SELECT *
FROM [bigquery-public-data:github_repos.contents]
WHERE id IN (SELECT id FROM [puppet.gemfile_files])
```
