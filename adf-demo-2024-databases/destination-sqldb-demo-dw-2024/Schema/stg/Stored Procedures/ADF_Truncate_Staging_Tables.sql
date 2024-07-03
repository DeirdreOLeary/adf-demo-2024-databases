/***********************************************************************************************
Purpose:	This stored proc is called by the Azure Data Factory ETL process to truncate all 
			staging Source & Transformed_Data tables in the data warehouse's stg schema.

Pipeline:	

Activity:	

***********************************************************************************************/
CREATE PROCEDURE [stg].[ADF_Truncate_Staging_Tables]
AS
	/* Truncate all Source tables */
	TRUNCATE TABLE [stg].[Source_Badges];
	TRUNCATE TABLE [stg].[Source_Posts];
	TRUNCATE TABLE [stg].[Source_PostTypes];
	TRUNCATE TABLE [stg].[Source_Users];

	/* Truncate all Transformed_Data tables */
	TRUNCATE TABLE [stg].[Transformed_Data_Post];
	TRUNCATE TABLE [stg].[Transformed_Data_User];

GO