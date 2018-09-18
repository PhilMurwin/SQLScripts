/*******************************************************************************
TSQL doesn't offer any native RegEx functionality but it does offer the PATINDEX
	function which allows us to perform some very basic character searches.
The sample below allows us to search for the presence of multiple characters 
	within a string.
The sample is specifcally looking for XML reserved characters.

Testing of PATINDEX against a table with 11,000 records shows little difference
between this and a separate OR statement for each character to test for. It does
appear to offer a bit more consistency in timings than the stack of OR statements.
It's also a bit cleaner should we need to include other items in the where clause.
*******************************************************************************/

declare @testvalue varchar(max)
set @testvalue = 'San<t>aC%l"a''u&s'
   
select patindex('%[&''"%><]%',@testvalue)