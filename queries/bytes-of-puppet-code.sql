-- Bytes
SELECT
  SUM(language.bytes) AS bytes
FROM
  [bigquery-public-data:github_repos.languages]
WHERE
  language.name = "Puppet"
GROUP BY
  language.name
