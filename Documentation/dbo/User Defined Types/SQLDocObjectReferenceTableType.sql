﻿CREATE TYPE [dbo].[SQLDocObjectReferenceTableType] AS TABLE (
    [ServerName]                     VARCHAR (100)  NOT NULL,
    [DatabaseName]                   NVARCHAR (128) NOT NULL,
    [referencing_schema_name]        NVARCHAR (128) NOT NULL,
    [referencing_entity_name]        NVARCHAR (128) NOT NULL,
    [referencing_TypeCode]           VARCHAR (10)   NULL,
    [referenced_server_name]         NVARCHAR (128) NULL,
    [referenced_database_name]       NVARCHAR (128) NULL,
    [referenced_TypeCode]      VARCHAR (10)   NULL,
    [referenced_schema_name]         NVARCHAR (128) NULL,
    [referenced_entity_name]         NVARCHAR (128) NOT NULL);



