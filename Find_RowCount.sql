-- Retrieve a list of tables and their associated row counts
SELECT OBJECT_NAME(OBJECT_ID) TableName, st.row_count
FROM sys.dm_db_partition_stats st
WHERE index_id < 2
and st.row_count > 100000 -- Return only those tables that have more rows than specified
and object_Name(object_id) not like 'sys%'
ORDER BY OBJECT_NAME(OBJECT_ID), st.row_count DESC