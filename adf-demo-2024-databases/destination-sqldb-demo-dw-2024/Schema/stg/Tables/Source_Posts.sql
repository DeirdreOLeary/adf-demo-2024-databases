CREATE TABLE [stg].[Source_Posts] (
    [Key]          INT      NOT NULL,
    [CommentCount] INT      NULL,
    [CreationDate] DATETIME NOT NULL,
    [OwnerUserId]  INT      NULL,
    [Score]        INT      NOT NULL,
    [ViewCount]    INT      NOT NULL,
);