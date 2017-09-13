# Count lines of puppet code

```sql
-- Lines
SELECT 
  COUNT(line) total_lines
FROM (
  SELECT SPLIT(content, '\n') AS line
  FROM [puppet.puppet_content]
)

```

| Lines   |
|---------|
| 7512483 |

