#! /bin/sh

#===============================================================================
# Repositories containing puppet code/modules
#===============================================================================
# VIEW: puppet_files
bq rm --force --table puppet.puppet_files
bq mk --view "SELECT *
              FROM [bigquery-public-data:github_repos.files]
              WHERE RIGHT(path, 3) = '.pp'
              AND ref = 'refs/heads/master'" puppet.puppet_files

# TABLE: puppet_content
bq --format none query --destination_table puppet.puppet_content --replace   \
         "SELECT *
          FROM [bigquery-public-data:github_repos.contents]
          WHERE id IN (SELECT id FROM [puppet.puppet_files])"


#===============================================================================
# Control Repositories containing Puppetfiles
#===============================================================================
# VIEW: puppetfile_files
bq rm --force --table puppet.puppetfile_files
bq mk --view "SELECT *
          FROM [bigquery-public-data:github_repos.files]
          WHERE path CONTAINS 'Puppetfile'
          AND NOT path CONTAINS 'Puppetfile.lock'
          AND ref = 'refs/heads/master'" puppet.puppetfile_files

# TABLE: puppetfile_content
bq --format none query --destination_table puppet.puppetfile_content --replace  \
         "SELECT *
          FROM [bigquery-public-data:github_repos.contents]
          WHERE id IN (SELECT id FROM [puppet.puppetfile_files])"


#===============================================================================
# Gemfiles associated with Puppet code
#===============================================================================
# VIEW: gemfile_files
bq rm --force --table puppet.gemfile_files
bq mk --view "SELECT *
          FROM [bigquery-public-data:github_repos.files]
          WHERE path CONTAINS 'Gemfile'
          AND NOT path CONTAINS 'Gemfile.lock'
          AND ref = 'refs/heads/master'
          AND repo_name IN (SELECT repo_name FROM [puppet.puppet_files])" puppet.gemfile_files

# TABLE: gemfile_content
bq --format none query --destination_table puppet.gemfile_content --replace  \
         "SELECT *
          FROM [bigquery-public-data:github_repos.contents]
          WHERE id IN (SELECT id FROM [puppet.gemfile_files])"
