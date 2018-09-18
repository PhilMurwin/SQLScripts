/*******************************************************************************
Sometimes it would be convenient to be able to check a particular table in 
every database on a server.  Handy if you have multiple databases with the same schema
on a single server (as is the case in some boxed products like veracore/promail).

In this example we're looking for any database with more than 4 employees
in the HumanResources Employee table.

1. This script gets a list of online databases that have a name matching your filter.

2. Once it has that list it uses a cursor to run a small bit of code in each database
and lists any database that matches the criteria…
*******************************************************************************/

declare @cDBName	varchar(150)
		,@sql		varchar(max)

declare cDB cursor local fast_forward for
select name
from sys.databases
where state_desc = 'ONLINE'
and name like '%Adventure%' --This is simply a filter you might apply to the name
order by name

open cDB

while 1=1
begin
	fetch next from cDB into @cDBName
	if @@fetch_status <> 0
	begin
		break;
	end
	
	select @sql = 'if exists(select 1
	from [{DBNAME}].HumanResources.Employee
	where EmployeeID > 4
	select ''{DBNAME}'''
	
	set @sql = replace(@sql, '{DBNAME}',@cDBName)

	exec(@sql)
	--print @sql
end

close cDB
deallocate cDB
