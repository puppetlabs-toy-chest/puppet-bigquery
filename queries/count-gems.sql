-- Package,Count
SELECT package, COUNT(*) count
FROM (
  SELECT REGEXP_EXTRACT(line, r'gem [\'|"](.*)[\'|"]') package, id
  FROM (
    SELECT SPLIT(content, '\n') line, id
    FROM [puppet.gemfile_contents]
    WHERE content CONTAINS 'gem' )
    GROUP BY package, id
  )
GROUP BY 1
ORDER BY count DESC
LIMIT 50;
