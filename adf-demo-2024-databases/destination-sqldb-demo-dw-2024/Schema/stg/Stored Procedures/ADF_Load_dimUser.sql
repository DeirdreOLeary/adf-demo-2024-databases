/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory ETL process to load data 
			from the staging Transformed_Data_dimUser table to the data.dimUser table.

Pipeline:	pl_etl_dims (adf-demo-2024-01)

Activity:	Load dimUser

***********************************************************************************************/
CREATE PROCEDURE [stg].[ADF_Load_dimUser]
    @ETLTimestamp DATETIME2(2)
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Wrap all the changes to data.dimUser in a transaction so that they are all rolled back if any part fails */
        BEGIN TRANSACTION

            /* The dimUser table always needs a default "zero" record for No User. If it doesn't exist, insert it */
            IF NOT EXISTS (
                SELECT * 
                FROM [data].[dimUser]
                WHERE [UserId] = 0
            )
            BEGIN
            
                SET IDENTITY_INSERT [data].[dimUser] ON;

                INSERT INTO [data].[dimUser] (
                    [UserId],
                    [VersionStartDate],
	                [VersionEndDate],
	                [Version],
	                [IsActive],
                    [UserKey],
                    [DisplayName],
                    [Reputation]
                )
                VALUES (
                    0,            /* [UserId] */
                    '1900-01-01', /* [VersionStartDate] should be before the earliest data 
                                     so it is valid for the lifetime of the data warehouse */
                    DEFAULT,      /* [VersionEndDate] */
                    DEFAULT,      /* [Version] */
                    1,            /* [IsActive] */
                    0,            /* [UserKey] */
                    'No User',    /* [DisplayName] */
                    0             /* [Reputation] */
                );

                SET IDENTITY_INSERT [data].[dimUser] OFF;

            END

            /* Update 1 of 2: Insert new records & set removed & replaced records to inactive */

            ;WITH tdu AS (
                SELECT @ETLTimestamp AS [VersionStartDate],
                    [Version],
                    1 AS [IsActive],
                    [UserKey],
                    [DisplayName],
                    [Reputation],
                    [LatestBadgeName],
                    [DateLatestBadgeAwarded],
                    [IsReplacement]
                FROM [stg].[Transformed_Data_User]
            )
            MERGE [data].[dimUser] AS u
            USING tdu
            ON tdu.[UserKey] = u.[UserKey]
            /* Set records in the target to inactive & set the end date for the version where they have been replaced, 
               i.e. the dimension has changed */
            WHEN MATCHED AND (
                tdu.[IsReplacement] = 1
                AND u.[IsActive] = 1
            )
            THEN UPDATE
                SET u.[IsActive] = 0,
                u.[VersionEndDate] = @ETLTimestamp
            /* Insert new records where they exist in the source (stg.Transformed_Data_User) but not the target (data.dimUser) */
            WHEN NOT MATCHED BY TARGET
                THEN INSERT (
                    [VersionStartDate],
	                [Version],
	                [IsActive],
                    [UserKey],
                    [DisplayName],
                    [Reputation],
                    [LatestBadgeName],
                    [DateLatestBadgeAwarded]
                )
                VALUES (
                    tdu.[VersionStartDate],
	                tdu.[Version],
	                tdu.[IsActive],
                    tdu.[UserKey],
                    tdu.[DisplayName],
                    tdu.[Reputation],
                    tdu.[LatestBadgeName],
                    tdu.[DateLatestBadgeAwarded]
                )
            /* Set records in the target to inactive & set the end date for the version where they no longer appear in the source, 
               i.e. they've been removed from the source database */
            WHEN NOT MATCHED BY SOURCE
                AND u.[IsActive] = 1
                AND u.[UserId] <> 0 /* Ignore "No User" record */
            THEN UPDATE
                SET u.[IsActive] = 0,
                u.[VersionEndDate] = @ETLTimestamp;

            /* Update 2 of 2: Insert replacement records */
            INSERT INTO [data].[dimUser] (
                [VersionStartDate],
	            [Version],
	            [IsActive],
                [UserKey],
                [DisplayName],
                [Reputation],
                [LatestBadgeName],
                [DateLatestBadgeAwarded]
            )
            SELECT @ETLTimestamp AS [VersionStartDate],
                [Version],
                1 AS [IsActive],
                [UserKey],
                [DisplayName],
                [Reputation],
                [LatestBadgeName],
                [DateLatestBadgeAwarded]
            FROM [stg].[Transformed_Data_User]
            WHERE [IsReplacement] = 1;

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
        BEGIN
            
            ROLLBACK
            
        END
            
        ;THROW

    END CATCH

GO