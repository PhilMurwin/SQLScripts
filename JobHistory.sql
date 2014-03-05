DECLARE @JobName VARCHAR(MAX) = ''

SELECT DISTINCT
        s2.name
		, CASE s.run_status
                   WHEN 1 THEN 'success'
                   WHEN 0 THEN 'failed'
                   ELSE CONVERT(VARCHAR, s.run_status)
                 END AS 'Status'
                 ,s.message
                 ,s.run_time
				 ,s.run_status
FROM    msdb..sysjobhistory s
JOIN    msdb..sysjobs s2 ON s.job_id = s2.job_id
WHERE   s2.name LIKE '%' + isnull(nullif(@JobName,''),s2.name) + '%'
AND CONVERT(DATETIME,CONVERT(VARCHAR,s.run_date)) > (GETUTCDATE() - 1) -- Only look 24 hrs in the past
--AND s.message NOT LIKE '%There is not enough space on the disk.%' -- ignore disk space issues
--AND s.message NOT LIKE 'The job failed.%'
--and s.run_status <> 1 -- Uncomment this line to check for only failed runs
