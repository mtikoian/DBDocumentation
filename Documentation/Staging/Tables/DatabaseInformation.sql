﻿CREATE TABLE [Staging].[DatabaseInformation] (
    [ServerName]                    NVARCHAR (128) NULL,
    [DatabaseName]                  NVARCHAR (128) NULL,
    [is_auto_close_on]              BIT            NOT NULL,
    [is_auto_shrink_on]             BIT            NULL,
    [is_in_standby]                 BIT            NULL,
    [is_ansi_null_default_on]       BIT            NULL,
    [is_ansi_nulls_on]              BIT            NULL,
    [is_ansi_padding_on]            BIT            NULL,
    [is_ansi_warnings_on]           BIT            NULL,
    [is_arithabort_on]              BIT            NULL,
    [is_auto_create_stats_on]       BIT            NULL,
    [is_auto_update_stats_on]       BIT            NULL,
    [is_cursor_close_on_commit_on]  BIT            NULL,
    [is_fulltext_enabled]           BIT            NULL,
    [is_local_cursor_default]       BIT            NULL,
    [is_concat_null_yields_null_on] BIT            NULL,
    [is_numeric_roundabort_on]      BIT            NULL,
    [is_quoted_identifier_on]       BIT            NULL,
    [is_recursive_triggers_on]      BIT            NULL,
    [is_published]                  BIT            NOT NULL,
    [is_subscribed]                 BIT            NOT NULL,
    [is_sync_with_backup]           BIT            NOT NULL,
    [recovery_model_desc]           NVARCHAR (60)  NULL,
    [snapshot_isolation_state_desc] NVARCHAR (60)  NULL,
    [collation_name]                [sysname]      NULL,
    [compatibility_level]           TINYINT        NOT NULL,
    [create_date]                   DATETIME       NOT NULL,
    [DocumentationDescription]      NVARCHAR (MAX) NULL,
    [StagingId]                     INT            IDENTITY (1, 1) NOT NULL,
    [StagingDateTime]               DATETIME2 (7)  CONSTRAINT [DF_Staging_DatabaseInformation_StagingDateTime] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_DatabaseInformation] PRIMARY KEY CLUSTERED ([StagingId] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_DatabaseInformation_Server_Database_Schema_Object]
    ON [Staging].[DatabaseInformation]([ServerName] ASC, [DatabaseName] ASC);

