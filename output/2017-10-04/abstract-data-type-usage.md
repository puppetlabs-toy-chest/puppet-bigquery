# Abstract data type usage

```sql
-- Type,Count
SELECT
  type,
  COUNT(*) count
FROM (
  SELECT
    REGEXP_EXTRACT(line, r'(Scalar|Collection|Variant|Data|Patter|Enum|Tuple|Struct|Optional|Catalogentry|Type|All|Callable).+\s\$') type,
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

| Type       | Count |
|------------|-------|
| Optional   | 611   |
| Enum       | 277   |
| Data       | 162   |
| Type       | 145   |
| Variant    | 134   |
| All        | 127   |
| Patter     | 73    |
| Tuple      | 13    |
| Collection | 11    |
| Struct     | 11    |
| Scalar     | 2     |

![Abstract data type usage](assets/abstract-data-type-usage.png)