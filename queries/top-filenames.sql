-- Name,Count
SELECT TOP(filename, 24), COUNT(*) as n
FROM (
    SELECT LAST(SPLIT(path, '/')) as filename
    FROM [puppet.puppet_files]
)
