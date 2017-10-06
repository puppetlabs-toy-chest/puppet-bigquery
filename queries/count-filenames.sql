-- Filename,Count
SELECT filename, COUNT(*) as n
FROM (
    SELECT LAST(SPLIT(path, '/')) as filename
    FROM [puppet.puppet_files]
)
GROUP BY filename
ORDER BY n DESC
LIMIT 10
