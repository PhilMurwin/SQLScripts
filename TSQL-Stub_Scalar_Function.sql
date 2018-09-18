/*******************************************************************************
It should be noted that this manner of stubbing a function does not work for both
scalar and table universally.
The below example is scalar only, once the stub is created, altering it to become
a table based function will not work.
*******************************************************************************/

if object_id('[dbo].[FunctionStub]') is null
  begin
    Declare @sql nvarchar(max)
	set @sql = N'CREATE FUNCTION [dbo].[FunctionStub] ( @a datetime ) RETURNS datetime AS BEGIN return @a END'
	exec(@sql)
end
GO