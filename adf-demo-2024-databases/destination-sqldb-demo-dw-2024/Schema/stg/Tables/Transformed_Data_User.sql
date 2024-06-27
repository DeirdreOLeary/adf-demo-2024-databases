CREATE TABLE [stg].[Transformed_Data_User] (
    [UserKey]                INT           NOT NULL,
    [DisplayName]            NVARCHAR (40) NOT NULL,
    [Reputation]             INT           NOT NULL,
    [LatestBadgeName]        NVARCHAR (40) NULL,
    [DateLatestBadgeAwarded] DATETIME2(2)  NULL,
    [Version]                INT           DEFAULT 1 NOT NULL,
    [IsReplacement]          BIT           DEFAULT 0 NOT NULL
    CONSTRAINT [UC_Transformed_Data_User] UNIQUE ([UserKey])
);