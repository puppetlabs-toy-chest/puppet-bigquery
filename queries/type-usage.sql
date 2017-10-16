-- Type,Count
SELECT
  type,
  COUNT(*) count
FROM (
  SELECT
    REGEXP_EXTRACT(line, r'(augeas|computer|cron|exec|file|filebucket|group|host|interface|k5login|macauthorization|mailalias|maillist|mcx|mount|notify|package|resources|router|schedule|scheduled_task|selboolean|selmodule|service|ssh_authorized_key|sshkey|stage|tidy|user|vlan|yumrepo|zfs|zone|zpool)\s?{') type,
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
