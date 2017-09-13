# Count committers

```sql
-- Committers
SELECT COUNT(*) count
FROM (
  SELECT author_name
  FROM [puppet.puppet_commits]
  GROUP BY author_name
)


```

| Committers |
|------------|
| 15795      |

