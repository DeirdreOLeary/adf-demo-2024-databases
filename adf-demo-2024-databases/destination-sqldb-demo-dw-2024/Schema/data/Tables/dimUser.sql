CREATE TABLE [data].[dimUser] (
    [UserId]                 INT            IDENTITY (1, 1) NOT NULL,        /* Surrogate key */
    [VersionStartDate]       DATETIME2(2)   DEFAULT GETUTCDATE() NOT NULL,   /* DATETIME2(2) uses 6 bytes & has ms precision whereas DATETIME uses 8 bytes */
	[VersionEndDate]         DATETIME2(2)   DEFAULT '9999-12-31' NOT NULL,
	[Version]                INT            DEFAULT 1 NOT NULL,
	[IsActive]               BIT            DEFAULT 0 NOT NULL,
    [UserKey]                INT            NOT NULL,                        /* Natural key */
    [DisplayName]            NVARCHAR (40)  NOT NULL,
    [Reputation]             INT            NOT NULL,
    [LatestBadgeName]        NVARCHAR (40)  NULL,
    [DateLatestBadgeAwarded] DATETIME2(2)   NULL,
    CONSTRAINT [PK_dimUser]  PRIMARY KEY CLUSTERED ([UserId]),
    CONSTRAINT [UC_dimUser]  UNIQUE ([VersionStartDate], [VersionEndDate], [UserKey])
);