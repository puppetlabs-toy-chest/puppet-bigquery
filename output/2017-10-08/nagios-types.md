# Nagios types

```sql
-- Type,Count
SELECT
  type,
  COUNT(*) count
FROM (
  SELECT
    REGEXP_EXTRACT(line, r'(nagios_command|nagios_contact|nagios_contactground|nagios_host|nagios_hostdependency|nagios_hostescalation|nagios_hostextinfo|nagios_hostground|nagios_service|nagios_servicedependency|nagios_serviceescalation|nagios_serviceextinfo|nagios_servicegroup|nagios_timeperiod)\s?{') type,
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

| Type                     | Count |
|--------------------------|-------|
| nagios_service           | 160   |
| nagios_command           | 56    |
| nagios_host              | 49    |
| nagios_servicedependency | 35    |
| nagios_contact           | 18    |
| nagios_servicegroup      | 10    |
| nagios_hostextinfo       | 8     |
| nagios_timeperiod        | 5     |
| nagios_hostdependency    | 3     |
| nagios_serviceescalation | 2     |
| nagios_hostescalation    | 1     |

![Nagios types](assets/nagios-types.png)