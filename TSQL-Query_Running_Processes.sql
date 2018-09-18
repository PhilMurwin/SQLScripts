-- This query can be run in a database to see what queries are actively being executed.

select session_id, request_id, start_time, status,
	left(txt.text, 100) as BeginningText, 
	( SELECT TOP 1 SUBSTRING(txt.text,  statement_start_offset/2, ( (CASE WHEN statement_end_offset = -1 THEN (LEN(CONVERT(nvarchar(max),txt.text)) * 2) ELSE statement_end_offset END)  - statement_start_offset) / 2)  )  AS sql_statement, 
	prev_error, nest_level,
	blocking_session_id,
	open_transaction_count, open_resultset_count,
	row_count,
	wait_type, wait_time, last_wait_type, wait_resource,
	percent_complete, estimated_completion_time
from sys.dm_exec_requests r
cross apply sys.dm_exec_sql_text(sql_handle) AS txt
where database_id = db_id() 
and status <> 'sleeping'
and session_id <> @@spid
