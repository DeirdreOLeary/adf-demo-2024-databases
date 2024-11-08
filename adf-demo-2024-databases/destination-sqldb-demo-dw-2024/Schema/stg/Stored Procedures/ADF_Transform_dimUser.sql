/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory ETL process to transform data 
			from the staging Source tables to the Transformed_Data_dimUser table as SCDs Type 2.

Pipeline:	pl_etl_dims (adf-demo-2024-01)

Activity:	Transform User data

***********************************************************************************************/
CREATE PROCEDURE [stg].[ADF_Transform_dimUser]
AS
    SET NOCOUNT ON;

    BEGIN TRY
        
        /* Use CTEs to get the details of the latest badge awarded to each user.
           We could also create a view for this. */
        ;WITH [LatestBadgeDatePerUser] AS (
	        SELECT [UserKey],
		        MAX([Date]) AS [LatestBadgeDate]
	        FROM [stg].[Source_Badges]
	        GROUP BY [UserKey]
        )
        ,[LatestBadgePerUser] AS (
	        SELECT lbd.[UserKey],
		        lbd.[LatestBadgeDate],
		        MAX(b.[Name]) AS [LatestBadgeName]
			        /* A decision is required where multiple badges were awarded to a user 
                       at the same time. In this case, we arbitrarily choose the maximum. */
	        FROM [stg].[Source_Badges] b
	        INNER JOIN [LatestBadgeDatePerUser] lbd
	        ON b.[UserKey] = lbd.[UserKey]
		        AND b.[Date] = lbd.[LatestBadgeDate]
	        GROUP BY lbd.[UserKey],
		        lbd.[LatestBadgeDate]
        )
        INSERT INTO [stg].[Transformed_Data_User] (
            [UserKey],
            [DisplayName],
            [Reputation],
            [LatestBadgeName],
            [DateLatestBadgeAwarded]
        )
        SELECT u.[Key] AS [UserKey],
	        u.[DisplayName],
	        u.[Reputation],
	        lb.[LatestBadgeName],
	        lb.[LatestBadgeDate] AS [DateLatestBadgeAwarded]
        FROM [stg].[Source_Users] u
        LEFT OUTER JOIN [LatestBadgePerUser] lb
        ON u.[Key] = lb.[UserKey];

        /* Update the replacement indicator & version number in the Transformed_Data table 
           if the dimension has changed since the last time the ETL was run. */
        ;WITH [Versions] AS (
            SELECT [UserKey],
                MAX([Version]) + 1 AS [NextVersion]
            FROM [data].[dimUser]
            GROUP BY [UserKey]
        )
        UPDATE tdu
        SET [IsReplacement] = 1
            ,[Version] = [Versions].[NextVersion]
        FROM [stg].[Transformed_Data_User] tdu
        INNER JOIN [Versions]
        ON tdu.[UserKey] = [Versions].[UserKey]
        INNER JOIN [data].[dimUser] u
        ON tdu.[UserKey] = u.[UserKey]
            AND (
                tdu.[DisplayName] <> u.[DisplayName]
                OR tdu.[Reputation] <> u.[Reputation]
                OR ISNULL(tdu.[LatestBadgeName], '') <> ISNULL(u.[LatestBadgeName], '')
                OR ISNULL(tdu.[DateLatestBadgeAwarded], '99991231') <> ISNULL(u.[DateLatestBadgeAwarded], '99991231')
                    /* Nullable columns need to have default values to allow for comparison, 
                       e.g. an emtpy string or highly unlikely date. */
            )
        WHERE u.[IsActive] = 1;

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO