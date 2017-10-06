# Count filenames

```sql
-- Filename,Count
SELECT filename, COUNT(*) as n
FROM (
    SELECT LAST(SPLIT(path, '/')) as filename
    FROM [puppet.puppet_files]
)
GROUP BY filename
ORDER BY n DESC
LIMIT 10

```

| Filename   | Count |
|------------|-------|
| init.pp    | 55380 |
| params.pp  | 19990 |
| config.pp  | 11715 |
| install.pp | 9591  |
| service.pp | 9074  |
| site.pp    | 8398  |
| server.pp  | 6609  |
| python.pp  | 3695  |
| db.pp      | 3233  |
| client.pp  | 3203  |

![Count filenames](assets/count-filenames.png)