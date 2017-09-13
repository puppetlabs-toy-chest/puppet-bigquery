-- Class,Count
SELECT
  package,
  COUNT(*) count
FROM (
  SELECT
    REGEXP_EXTRACT(line, r'class (\S+) {') package,
    id
  FROM (
    SELECT
      SPLIT(content, '\n') line,
      id
    FROM
      [puppet.puppet_content]
    WHERE
      content CONTAINS 'class' )
  GROUP BY
    package,
    id )
WHERE
  package IS NOT NULL
GROUP BY
  1
ORDER BY
  count DESC
LIMIT
  30
