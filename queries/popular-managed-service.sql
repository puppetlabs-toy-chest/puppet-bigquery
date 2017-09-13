-- Service,Count
SELECT
  name,
  COUNT(*) count
FROM (
  SELECT
    REGEXP_EXTRACT(line, r'service\s?{\s?[\"|\'](\S+)[\"|\']:') name,
    id
  FROM (
    SELECT
      SPLIT(content, '\n') line,
      id
    FROM
      [puppet.puppet_content] )
  GROUP BY
    name,
    id )
WHERE
  name IS NOT NULL
GROUP BY
  1
ORDER BY
  count DESC
LIMIT
  15
