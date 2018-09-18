-- The following query can be run against the msdb database to find jobs that utilize a specific command regardless of if that’s an exe or a stored procedure, etc…

select *
from sysjobs j
join sysjobsteps s on s.job_id = j.job_id
where s.command like '%pStoredProc%'
