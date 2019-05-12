﻿CREATE TYPE [dbo].[ColumnDocTableType] AS TABLE (
    [ServerName]                VARCHAR (100)  NULL,
    [DatabaseName]              NVARCHAR (128) NULL,
    [objectType]                VARCHAR (10)   NOT NULL,
    [object_id]                 INT            NOT NULL,
    [TableSchemaName]           NVARCHAR (128) NOT NULL,
    [TableName]                 NVARCHAR (128) NOT NULL,
    [name]                      [sysname]      NULL,
    [DocumentationDescription]  NVARCHAR (MAX) NULL,
    [column_id]                 INT            NULL,
    [datatype]                  [sysname]      NULL,
    [max_length]                SMALLINT       NULL,
    [precision]                 TINYINT        NULL,
    [scale]                     TINYINT        NULL,
    [collation_name]            [sysname]      NULL,
    [is_nullable]               BIT            NULL,
    [is_identity]               BIT            NULL,
    [ident_col_seed_value]      INT            NULL,
    [ident_col_increment_value] INT            NULL,
    [is_computed]               BIT            NULL,
    [Column_Default]            NVARCHAR (MAX) NULL,
    [PK]                        BIT            NULL,
    [FK_NAME]                   [sysname]      NULL,
    [ReferencedTableObject_id]  INT            NULL,
    [ReferencedTableSchemaName] NVARCHAR (128) NULL,
    [ReferencedTableName]       NVARCHAR (128) NULL,
    [referenced_column]         [sysname]      NULL);

