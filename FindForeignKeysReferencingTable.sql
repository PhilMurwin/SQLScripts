-- This script is useful for finding forgotten foreign keys that link one table to another.
-- Useful when trying to put together a deletion script either for data or for the tables themselves.

select t.name as TableWithForeignKey, fk.constraint_column_id as FK_PartNo , c.name as ForeignKeyColumn 
from sys.foreign_key_columns as fk
join sys.tables as t on fk.parent_object_id = t.object_id
join sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
where fk.referenced_object_id = (select object_id from sys.tables where name = 'HumanResources.Employee')
order by TableWithForeignKey, FK_PartNo
