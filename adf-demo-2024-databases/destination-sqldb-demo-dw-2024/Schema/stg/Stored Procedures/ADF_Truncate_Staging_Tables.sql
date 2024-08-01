/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory ETL process to truncate all 
			staging Source & Transformed_Data tables in the data warehouse's stg schema.

Pipeline:	pl_etl_dims (adf-demo-2024-01)

Activity:	Truncate staging tables

***********************************************************************************************/
CREATE PROCEDURE [stg].[ADF_Truncate_Staging_Tables]
AS
    SET NOCOUNT ON;

    BEGIN TRY

        /* Truncate all Source tables */
		TRUNCATE TABLE [stg].[Source_Badges];
		TRUNCATE TABLE [stg].[Source_Posts];
		TRUNCATE TABLE [stg].[Source_PostTypes];
		TRUNCATE TABLE [stg].[Source_Users];

		/* Truncate all Transformed_Data tables */
		TRUNCATE TABLE [stg].[Transformed_Data_Post];
		TRUNCATE TABLE [stg].[Transformed_Data_User];

    END TRY
    BEGIN CATCH

        ;THROW

    END CATCH

GO