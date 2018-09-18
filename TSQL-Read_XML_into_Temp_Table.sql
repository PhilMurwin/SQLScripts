--=========================================================
-- SQL Server 2008 apparently has a bug that causes issues when trying to read from XML into a temporary table.
-- This can be overcome with the simple addition of an option to your query.
--=========================================================
-- Additional information can be found at the links below
--
-- http://connect.microsoft.com/SQLServer/feedback/details/562092/an-insert-statement-using-xml-nodes-is-very-very-very-slow-in-sql2008-sp1
-- http://stackoverflow.com/questions/3978807/why-insert-select-to-variable-table-from-xml-variable-so-slow
--=========================================================


Insert into #TaxRate(DealerCode, City, [State], Zip, Name, CityZip, TaxRateText)
select c.value('(Column1)[1]','varchar(50)')
    ,c.value('(Column2)[1]','varchar(50)')
	,c.value('(Column3)[1]','varchar(20)')
	,c.value('(Column4)[1]','varchar(20)')
	,c.value('(Column5)[1]','varchar(200)')
	,c.value('(Column6)[1]','varchar(75)')
	,c.value('(Column7)[1]','varchar(max)')
from @XML.nodes('DocumentElement/Rates') t(c)
where c.value('(Column1)[1]','varchar(50)') <> 'DlrPCode'
Option (optimize for(@xml = null))
