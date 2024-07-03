CREATE TABLE [data].[factPost] (
    [PostId]          INT           NOT NULL,   /* Surrogate key */
    [DateLastUpdated] DATETIME2(2)  NOT NULL,
    [PostKey]         INT           NOT NULL,   /* Natural key */
    [OwnerUserId]     INT           NOT NULL,
    [CreationDate]    DATETIME2(2)  NOT NULL,
    [Score]           INT           NOT NULL,
    [ViewCount]       INT           NOT NULL,
    [CommentCount]    INT           NULL,
);