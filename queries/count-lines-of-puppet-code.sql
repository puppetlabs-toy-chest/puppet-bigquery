-- Lines
SELECT 
  SUM(num) total_lines
FROM (
  SELECT ARRAY_LENGTH(SPLIT(content, '\n')) AS num
  FROM `puppet.puppet_content`
)
