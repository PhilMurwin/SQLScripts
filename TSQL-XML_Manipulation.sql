-- This is a collection of SQL Scraps useful in manipulating XML in a SQL Stored proc or script

--== get rid of NULL values, since the .modify() doesn't know how to handle NULL
UPDATE TableName
   SET XMLParam = ''
 WHERE XMLParam IS NULL

--== Insert the parameter "paramname" if it does not already exist.  Default value is "0"
UPDATE TableName
   SET XMLParam.modify('
		insert
		  into (/paramlist)[1]')
 WHERE XMLParam.exist('(/paramlist/param[@name="paramname"])[1]')=0

--== Modify the parameter "paramname"
UPDATE TableName
   SET XMLParam.modify('
		replace value of (/paramlist/param[@name="paramname"]/@value)[1]
		with "1"
		')
 
--== How to pull out the item name and item value from XML
DECLARE @iXML XML
SELECT @iXML = '<root><ID>1</ID><ThingNumber>2</ThingNumber></root>'

SELECT c.query('local-name(.)').value('.','varchar(50)') as 'ElementName',
	   c.value('.', 'varchar(200)') as 'ElementValue'
  FROM @iXML.nodes('root/node()') t(c)


--Insert a new attribute
declare @test xml
set @test = '
'

set @test.modify('
insert attribute MiddleName {"Smith" }
into (/root/Employee[@EmployeeID=6700])[1] ')
select @test