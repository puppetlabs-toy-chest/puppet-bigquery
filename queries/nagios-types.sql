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
