-- License,Count
SELECT
  license,
  COUNT(*) count
FROM (
  SELECT
    files.repo_name AS repo_name,
    licenses.license AS license
  FROM
    [puppet.puppet_files] AS files
  JOIN
    [bigquery-public-data:github_repos.licenses] AS licenses
  ON
    files.repo_name = licenses.repo_name
  GROUP BY
    repo_name,
    license )
GROUP BY
  1
ORDER BY
  count DESC
LIMIT
  10
