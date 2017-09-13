-- Name,Count
SELECT author_name, COUNT(1) count
FROM [puppet.puppet_commits] AS commits
GROUP BY author_name
ORDER BY count DESC
LIMIT 30
