﻿CREATE TABLE [dbo].[Users] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [AboutMe]        NVARCHAR (MAX) NULL,
    [Age]            INT            NULL,
    [CreationDate]   DATETIME       NOT NULL,
    [DisplayName]    NVARCHAR (40)  NOT NULL,
    [DownVotes]      INT            NOT NULL,
    [EmailHash]      NVARCHAR (40)  NULL,
    [LastAccessDate] DATETIME       NOT NULL,
    [Location]       NVARCHAR (100) NULL,
    [Reputation]     INT            NOT NULL,
    [UpVotes]        INT            NOT NULL,
    [Views]          INT            NOT NULL,
    [WebsiteUrl]     NVARCHAR (200) NULL,
    [AccountId]      INT            NULL,
    CONSTRAINT [PK_Users_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE NONCLUSTERED INDEX [IX_Users_demo]
    ON [dbo].[Users]([DisplayName], [Reputation], [Id]);