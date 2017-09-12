-- Year,Commits
SELECT author_date, COUNT(*) as commits
FROM (
  SELECT YEAR(author_date) as author_date
  FROM [puppet.puppet_commits]
)
GROUP BY author_date
ORDER BY author_date DESC
