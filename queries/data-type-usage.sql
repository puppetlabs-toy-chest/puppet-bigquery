-- Type,Count
SELECT
  type,
  COUNT(*) count
FROM (
  SELECT
    REGEXP_EXTRACT(line, r'(String|Integer|Float|Numeric|Boolean|Array|Hash|Regexp|Undef|Default)\s\$') type,
    id
  FROM (
    SELECT
      SPLIT(content, '\n') line,
      id
    FROM
      [puppet.puppet_content]
  )
  GROUP BY
    type,
    id )
WHERE
  type IS NOT NULL
GROUP BY
  1
ORDER BY
  count DESC
