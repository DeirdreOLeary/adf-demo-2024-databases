CREATE TABLE [stg].[factPost] (
    [PostId]          INT           IDENTITY(1, 1) NOT NULL,         /* Surrogate key */
    [DateLastUpdated] DATETIME2(2)  DEFAULT GETUTCDATE() NOT NULL,   /* DATETIME2(2) uses 6 bytes & has ms precision whereas DATETIME uses 8 bytes */
    [PostKey]         INT           NOT NULL,                        /* Natural key */
    [OwnerUserId]     INT           NOT NULL,
    [CreationDate]    DATETIME2(2)  NOT NULL,
    [Score]           INT           NOT NULL,
    [ViewCount]       INT           NOT NULL,
    [CommentCount]    INT           NULL,
    CONSTRAINT [PK_factPost] PRIMARY KEY CLUSTERED ([PostId]),
    CONSTRAINT [FK_factPost_OwnerUserId] FOREIGN KEY ([OwnerUserId]) REFERENCES [stg].[dimUser] ([UserId]),
    CONSTRAINT [UC_factPost] UNIQUE ([PostKey])
);