﻿CREATE PROCEDURE [dbo].[upSqlDocObjectChildFK] (
	@Server VARCHAR(255)
	,@DatabaseName VARCHAR(255)
	,@Schema VARCHAR(255) = NULL
	,@Object VARCHAR(255) = NULL
	,@FKType bit =0
	)
AS
BEGIN
	DECLARE @BoxSize INT;
	DECLARE @Stretch FLOAT;

	SET @BoxSize = 250;
	SET @Stretch = 1.4;

WITH CTE
AS (
	SELECT [ServerName]
		,[DatabaseName]
		,ObjectName AS FKName --AS [referenced_database_name]
		,IIF(ReferencedTableSchemaName = @Schema AND ReferencedTableName = @Object, ParentSchemaName, ReferencedTableSchemaName) AS [referencing_schema_name]
		,IIF(ReferencedTableSchemaName = @Schema AND ReferencedTableName = @Object, ParentObjectName, ReferencedTableName) AS [referencing_entity_name]
		,IIF(ReferencedTableSchemaName = @Schema AND ReferencedTableName = @Object, ReferencedTableSchemaName, ParentSchemaName) AS [referenced_schema_name]
		,IIF(ReferencedTableSchemaName = @Schema AND ReferencedTableName = @Object, ReferencedTableName, ParentObjectName) AS [referenced_entity_name]
		,referenced_column
		,TypeGroup
		,TypeCode
		,DocumentationLoadDate
		,CASE WHEN ReferencedTableSchemaName = @Schema AND ReferencedTableName = @Object THEN 1 ELSE 0 END AS isChildFK
	FROM dbo.vwChildObjects
	WHERE TypeCode = 'F'
		AND DatabaseName = @DatabaseName
		AND SERVERNAME = @Server
		AND (
			(
				ParentSchemaName = @Schema
				AND ParentObjectName = @Object
				)
			OR (
				ReferencedTableSchemaName = @Schema
				AND ReferencedTableName = @Object
				)
			)
		)
,
 BaseData
	AS (
	SELECT ServerName
		,DatabaseName
		,FKName
		,referencing_schema_name
		,referencing_entity_name
		,referenced_schema_name
		,referenced_entity_name
		,referenced_column
		,TypeGroup
		,TypeCode
		,DocumentationLoadDate
		,isChildFK

		,CONCAT (
			[referencing_schema_name]
			,[referencing_entity_name]
			,FKName
			,referenced_column
			) AS Seq
		,CONCAT (
			[referencing_schema_name]
			,'.'
			,[referencing_entity_name]
			) AS DimensionCaption
		,@Object AS MeasureGroupCaption
		
		,'Table' as ReferencedObjectType
		,'Table' AS [TypeDescriptionUser]
	FROM CTE
	where isChildFK=@FKType 
)
		,TotCount
	AS (
		SELECT COUNT(*) AS RecCount, isChildFK  
		FROM BaseData
		group by isChildFK
		)
		,RecCount
	AS (
		SELECT RANK() OVER (partition by bd.isChildFK
				ORDER BY CAST(Seq AS VARCHAR(255))
				) AS RecID
			,tc.RecCount
			,bd.*
		FROM BaseData BD
		inner join TotCount TC on tc.isChildFK  =bd.isChildFK  
		)	
		,Angles
	AS (
		--[noformat]
(    SELECT 
        * 
        , SIN(RADIANS((CAST(RecID AS FLOAT)/CAST(RecCount AS FLOAT)) * 360)) * 1000 AS x
        , COS(RADIANS((CAST(RecID AS FLOAT)/CAST(RecCount AS FLOAT)) * 360)) * 1000 AS y
    FROM RecCount
)
			--[/noformat]
		)
		,Results
	AS (
		--[noformat]
(    SELECT 
        *
        , geometry::STGeomFromText('POINT(' + CAST(y AS VARCHAR(20)) + ' ' + CAST(x AS VARCHAR(20))  + ')',4326) AS Posn
        , geometry::STPolyFromText('POLYGON ((' + 
            CAST((y*@Stretch)+@BoxSize AS VARCHAR(20)) + ' ' + CAST(x+(@BoxSize/2) AS VARCHAR(20)) + ', ' +
            CAST((y*@Stretch)-@BoxSize AS VARCHAR(20)) + ' ' + CAST(x+(@BoxSize/2) AS VARCHAR(20)) + ', ' +
            CAST((y*@Stretch)-@BoxSize AS VARCHAR(20)) + ' ' + CAST(x-(@BoxSize/2) AS VARCHAR(20)) + ', ' +
            CAST((y*@Stretch)+@BoxSize AS VARCHAR(20)) + ' ' + CAST(x-(@BoxSize/2) AS VARCHAR(20)) + ', ' +
            CAST((y*@Stretch)+@BoxSize AS VARCHAR(20)) + ' ' + CAST(x+(@BoxSize/2) AS VARCHAR(20)) + '            
            ))',0) AS Box
         , geometry::STLineFromText('LINESTRING (0 0, ' + CAST((y*@Stretch) AS VARCHAR(20)) + ' ' + CAST(x AS VARCHAR(20))  + ')', 0) AS Line
         , geometry::STPolyFromText('POLYGON ((' + 
            CAST(0+@BoxSize AS VARCHAR(20)) + ' ' + CAST(0+(@BoxSize/2) AS VARCHAR(20)) + ', ' +
            CAST(0-@BoxSize AS VARCHAR(20)) + ' ' + CAST(0+(@BoxSize/2) AS VARCHAR(20)) + ', ' +
            CAST(0-@BoxSize AS VARCHAR(20)) + ' ' + CAST(0-(@BoxSize/2) AS VARCHAR(20)) + ', ' +
            CAST(0+@BoxSize AS VARCHAR(20)) + ' ' + CAST(0-(@BoxSize/2) AS VARCHAR(20)) + ', ' +
            CAST(0+@BoxSize AS VARCHAR(20)) + ' ' + CAST(0+(@BoxSize/2) AS VARCHAR(20)) + '            
            ))',0) AS CenterBox
         
         
    FROM Angles
)
			--[/noformat]
		)
	SELECT *
	FROM Results;

END