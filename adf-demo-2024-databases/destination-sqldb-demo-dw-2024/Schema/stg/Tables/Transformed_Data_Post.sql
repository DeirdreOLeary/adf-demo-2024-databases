CREATE TABLE [stg].[Transformed_Data_Post] (
    [PostKey]      INT          NOT NULL,
    [OwnerUserId]  INT          NOT NULL,
    [CreationDate] DATETIME2(2) NOT NULL,
    [Score]        INT          NOT NULL,
    [ViewCount]    INT          NOT NULL,
    [CommentCount] INT          NULL,
    [IsUpdate]     BIT          DEFAULT 0 NOT NULL
    CONSTRAINT [UC_Transformed_Data_Post] UNIQUE ([PostKey])
);