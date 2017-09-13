-- Modules
SELECT COUNT(DISTINCT repo_name) FROM [puppet.puppet_files] WHERE repo_name NOT LIKE '%boxen%'
