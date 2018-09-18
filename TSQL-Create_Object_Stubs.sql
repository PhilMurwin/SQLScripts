/*******************************************************************************
In the event we want to update/modify a sql object we can drop the object 
	and re-create it which is really easy but causes issues.
Alternatively we can check for object existence and create a stub first.
Then we can alter the existing proc (which may be a stub if it never existed).
*******************************************************************************/

USE AdventureWorks
   GO

   IF OBJECT_ID('dbo.uspGetEmployeeDetails') IS NULL -- Check if SP Exists
    EXEC('CREATE PROCEDURE dbo.uspGetEmployeeDetails AS SET NOCOUNT ON;') -- Create dummy/empty SP
   GO

   ALTER PROCEDURE dbo.uspGetEmployeeDetails -- Alter the SP Always
    @EmployeeID INT
   AS
   BEGIN

	SET NOCOUNT ON;

	SELECT
 	HRE.EmployeeID
 	, PC.FirstName + ' ' + PC.LastName AS EmployeeName
 	, HRE.Title AS EmployeeTitle
 	, PC.EmailAddress AS EmployeeEmail
 	, PC.Phone AS EmployeePhone
	FROM
 	HumanResources.Employee AS HRE
 	LEFT JOIN Person.Contact AS PC
  	ON HRE.ContactID = PC.ContactID
	WHERE HRE.EmployeeID = @EmployeeID

END
GO