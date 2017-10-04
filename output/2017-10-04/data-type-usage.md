# Data type usage

```sql
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

```

| Type    | Count |
|---------|-------|
| String  | 603   |
| Boolean | 411   |
| Integer | 174   |
| Hash    | 132   |
| Array   | 82    |
| Default | 14    |
| Float   | 5     |
| Numeric | 3     |
| Undef   | 1     |

![Data type usage](assets/data-type-usage.png)