/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory ETL process to load data 
			from the staging Transformed_Data_factPost table to the data.factPost table.

Pipeline:	

Activity:	

***********************************************************************************************/
CREATE PROCEDURE [stg].[ADF_Load_factPost]
    @ETLTimestamp DATETIME2(2)
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Wrap all the changes to data.dimUser in a transaction so that they are all rolled back if any part fails */
        BEGIN TRANSACTION

            /* Insert new rows. */
            INSERT INTO [data].[factPost] (
                [DateLastUpdated],
                [PostKey],
                [OwnerUserId],
                [CreationDate],
                [Score],
                [ViewCount],
                [CommentCount]
            )
            SELECT @ETLTimestamp AS [DateLastUpdated],
                [PostKey],
                [OwnerUserId],
                [CreationDate],
                [Score],
                [ViewCount],
                [CommentCount]
            FROM [stg].[Transformed_Data_Post]
            WHERE [IsNewRow] = 1;

            /* Update the rows that have changed with the new data. */
            UPDATE p
            SET [DateLastUpdated] = @ETLTimestamp,
                [OwnerUserId] = tdp.[OwnerUserId],
                [CreationDate] = tdp.[CreationDate],
                [Score] = tdp.[Score],
                [ViewCount] = tdp.[ViewCount],
                [CommentCount] = tdp.[CommentCount]
            FROM [data].[factPost] p
            INNER JOIN [stg].[Transformed_Data_Post] tdp
            ON p.[PostKey] = tdp.[PostKey]
            WHERE tdp.[IsUpdate] = 1;

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