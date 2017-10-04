-- Gemfiles
SELECT COUNT(DISTINCT repo_name) FROM [puppet.gemfile_files] WHERE repo_name NOT LIKE '%boxen%'
