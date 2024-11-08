/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory ETL process to transform data 
			from the staging Source tables to the Transformed_Data_factPost table.

Pipeline:	pl_etl_facts (adf-demo-2024-01)

Activity:	Transform Post data

***********************************************************************************************/
CREATE PROCEDURE [stg].[ADF_Transform_factPost]
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* We are only interested in the Answer posts. */
        INSERT INTO [stg].[Transformed_Data_Post] (
            [PostKey],
            [OwnerUserId],
            [CreationDate],
            [Score],
            [ViewCount],
            [CommentCount]
        )
        SELECT p.[Key] AS [PostKey],
            ISNULL(u.[UserId], 0) AS [OwnerUserId],
                /* Where there is no Owner User, set the Id to the default of 0. */
            p.[CreationDate],
            p.[Score],
            p.[ViewCount],
            p.[CommentCount]
        FROM [stg].[Source_Posts] p
        INNER JOIN [stg].[Source_PostTypes] pt
        ON p.[PostTypeKey] = pt.[Key]
        LEFT OUTER JOIN [data].[dimUser] u
        ON p.[OwnerUserKey] = u.[UserKey]    
            /* The following is required to handle the SCDs (Type 2) where 
               the Post's creation date indicates which version of the User it is owned by. */
            AND (
                (
                    u.[Version] = 1
                    AND p.[CreationDate] < u.[VersionEndDate]
                )
                OR (
                    u.[Version] > 1
                    AND p.[CreationDate] >= u.[VersionStartDate]
                    AND p.[CreationDate] < u.[VersionEndDate]
                )
            )
        WHERE pt.[Type] = 'Answer';

        /* Identify which Posts are new rows. */
        UPDATE tdp
        SET [IsNewRow] = 1
        FROM [stg].[Transformed_Data_Post] tdp
        WHERE tdp.[PostKey] NOT IN (
            SELECT p.[PostKey]
            FROM [data].[factPost] p
        );

        /* Identify which Posts are updates. */
        UPDATE tdp
        SET [IsUpdate] = 1
        FROM [stg].[Transformed_Data_Post] tdp
        INNER JOIN [data].[factPost] p
        ON tdp.[PostKey] = p.[PostKey]
            AND (
                tdp.[OwnerUserId] <> p.[OwnerUserId]
                OR tdp.[CreationDate] <> p.[CreationDate]
                OR tdp.[Score] <> p.[Score]
                OR tdp.[ViewCount] <> p.[ViewCount]
                OR ISNULL(tdp.[CommentCount], 0) <> ISNULL(p.[CommentCount], 0)
                    /* Nullable columns need to have default values to allow for comparison, e.g. a zero value. */
            );

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO