﻿CREATE TABLE [dbo].[Posts] (
    [Id]                    INT            IDENTITY (1, 1) NOT NULL,
    [AcceptedAnswerId]      INT            NULL,
    [AnswerCount]           INT            NULL,
    [Body]                  NVARCHAR (MAX) NOT NULL,
    [ClosedDate]            DATETIME       NULL,
    [CommentCount]          INT            NULL,
    [CommunityOwnedDate]    DATETIME       NULL,
    [CreationDate]          DATETIME       NOT NULL,
    [FavoriteCount]         INT            NULL,
    [LastActivityDate]      DATETIME       NOT NULL,
    [LastEditDate]          DATETIME       NULL,
    [LastEditorDisplayName] NVARCHAR (40)  NULL,
    [LastEditorUserId]      INT            NULL,
    [OwnerUserId]           INT            NULL,
    [ParentId]              INT            NULL,
    [PostTypeId]            INT            NOT NULL,
    [Score]                 INT            NOT NULL,
    [Tags]                  NVARCHAR (150) NULL,
    [Title]                 NVARCHAR (250) NULL,
    [ViewCount]             INT            NOT NULL,
    CONSTRAINT [PK_Posts_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE NONCLUSTERED INDEX [IX_Posts_demo]
    ON [dbo].[Posts]([PostTypeId], [Id])
    INCLUDE([OwnerUserId], [CreationDate], [Score], [ViewCount], [CommentCount]);