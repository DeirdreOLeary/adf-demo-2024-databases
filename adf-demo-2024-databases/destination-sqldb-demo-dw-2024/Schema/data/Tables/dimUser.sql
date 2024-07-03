CREATE TABLE [data].[dimUser] (
    [UserId]                 INT            NOT NULL,   /* Surrogate key */
    [VersionStartDate]       DATETIME2(2)   NOT NULL,
	[VersionEndDate]         DATETIME2(2)   NOT NULL,
	[Version]                INT            NOT NULL,
	[IsActive]               BIT            NOT NULL,
    [UserKey]                INT            NOT NULL,   /* Natural key */
    [DisplayName]            NVARCHAR (40)  NOT NULL,
    [Reputation]             INT            NOT NULL,
    [LatestBadgeName]        NVARCHAR (40)  NULL,
    [DateLatestBadgeAwarded] DATETIME2(2)   NULL,
);