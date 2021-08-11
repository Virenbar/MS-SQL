SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- CREATE SCHEMA [stn]

IF OBJECT_ID('[stn].[UF_GetNetType]') IS NULL
	EXEC ('CREATE FUNCTION [stn].[UF_GetNetType]()RETURNS VARCHAR(50)AS BEGIN RETURN ''''END')
GO
-- =============================================
-- Author:		Artyom
-- Create date: 27.05.21
-- Description:	Перевод типа из SQL в .Net
-- =============================================
ALTER FUNCTION [stn].[UF_GetNetType](
	@SQLType VARCHAR(50),
	@IsNull  VARCHAR(10))
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN CASE @SQLType
			   WHEN 'int' THEN 'Integer'
			   WHEN 'bigint' THEN 'Long'
			   WHEN 'decimal' THEN 'Decimal'
			   WHEN 'money' THEN 'Decimal'
			   WHEN 'char' THEN 'String'
			   WHEN 'nchar' THEN 'String'
			   WHEN 'varchar' THEN 'String'
			   WHEN 'nvarchar' THEN 'String'
			   WHEN 'date' THEN 'Date'
			   WHEN 'smalldatetime' THEN 'Date'
			   WHEN 'datetime' THEN 'Date'
			   WHEN 'bit' THEN 'Boolean'
		   ELSE @SQLType
		   END + IIF(@IsNull = 'NO' OR @SQLType IN('varchar', 'nvarchar'), '', '?')
END
GO

IF OBJECT_ID('[stn].[UF_GetTColumns]') IS NULL
	EXEC ('CREATE FUNCTION [stn].[UF_GetTColumns]()RETURNS TABLE AS RETURN (SELECT 0 N)')
GO
-- =============================================
-- Author:		Artyom
-- Create date: 25.09.20
-- Description:	 Возвращает данные для генерации кода классов и процедур
-- =============================================
ALTER FUNCTION [stn].[UF_GetTColumns](
	@Table AS VARCHAR(50))
RETURNS TABLE
AS
RETURN
   (
   SELECT
	   [COLUMN_NAME] AS                               [Name]
	 , [IS_NULLABLE] AS                               [Null]
	 , CAST([CHARACTER_MAXIMUM_LENGTH] AS VARCHAR) AS [Size]
	 , [stn].[UF_GetNetType]
	   ([DATA_TYPE], [IS_NULLABLE]) AS                [NType]
	 , [DOMAIN_NAME] AS                               [CType]
	 , [DATA_TYPE] AS                                 [DBType]
   FROM
	   [INFORMATION_SCHEMA].[COLUMNS]
   WHERE [TABLE_NAME] = @Table
   )
GO
