﻿
CREATE PROCEDURE [dbo].[upSqlDocDatabaseObjects] (
	@Server VARCHAR(255) = NULL
	,@DatabaseName VARCHAR(255) = NULL
	)
AS
SELECT [ServerName]
	,[DatabaseName]
	,TypeGroup
	,[TypeDescriptionUser]
	,[TableSchemaName]
	,[TableName]
	,[DocumentationDescription]
	,TypeGroupOrder
	,TypeOrder
	,TypeCount
FROM dbo.vwObjectDoc
WHERE DatabaseName = @DatabaseName
	AND ServerName = @Server
	AND Typecode != 'C' -- Check Constraint
ORDER BY [ServerName]
	,[DatabaseName]
	,TypeGroupOrder
	,TypeOrder
	,TypeGroup
	,[TypeDescriptionUser]
	,[TableSchemaName]
	,[TableName]
