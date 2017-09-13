-- Lines
SELECT 
  COUNT(line) total_lines
FROM (
  SELECT SPLIT(content, '\n') AS line
  FROM [puppet.puppet_content]
)
