-- Module,Count
SELECT package, COUNT(*) count
FROM (
  SELECT REGEXP_EXTRACT(line, r'mod [\'|"](.*)[\'|"]') package, id
  FROM (
    SELECT SPLIT(content, '\n') line, id
    FROM [puppet.puppetfile_content]
    WHERE content CONTAINS 'mod' )
    GROUP BY package, id
  )
WHERE package IS NOT NULL
GROUP BY 1
ORDER BY count DESC
LIMIT 30;
