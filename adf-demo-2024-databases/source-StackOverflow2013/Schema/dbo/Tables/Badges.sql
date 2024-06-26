CREATE TABLE [dbo].[Badges] (
    [Id]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]   NVARCHAR (40) NOT NULL,
    [UserId] INT           NOT NULL,
    [Date]   DATETIME      NOT NULL,
    CONSTRAINT [PK_Badges_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO

CREATE NONCLUSTERED INDEX [IX_Badges_demo]
    ON [dbo].[Badges]([Date], [UserId], [Name], [Id]);