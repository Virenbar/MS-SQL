SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- CREATE SCHEMA [stn]
IF OBJECT_ID('[stn].[UF_GetCSType]') IS NULL
	EXEC ('CREATE FUNCTION [stn].[UF_GetCSType]()RETURNS VARCHAR(50)AS BEGIN RETURN ''''END')
GO
-- =============================================
-- Author:		Artyom
-- Create date: 27.05.21
-- Description:	Перевод типа из SQL в .Net
-- =============================================
ALTER FUNCTION [stn].[UF_GetCSType](
	@SQLType VARCHAR(50),
	@IsNull  VARCHAR(10))
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN CASE @SQLType
			   WHEN 'int' THEN 'int'
			   WHEN 'bigint' THEN 'long'
			   WHEN 'decimal' THEN 'decimal'
			   WHEN 'money' THEN 'decimal'
			   WHEN 'char' THEN 'string'
			   WHEN 'nchar' THEN 'string'
			   WHEN 'varchar' THEN 'string'
			   WHEN 'nvarchar' THEN 'string'
			   WHEN 'date' THEN 'DateTime'
			   WHEN 'smalldatetime' THEN 'DateTime'
			   WHEN 'datetime' THEN 'DateTime'
			   WHEN 'bit' THEN 'bool'
		   ELSE @SQLType
		   END + IIF(@IsNull = 'NO' OR @SQLType LIKE '%char', '', '?')
END
GO

IF OBJECT_ID('[stn].[UF_GetTColumns]') IS NULL
	EXEC ('CREATE FUNCTION [stn].[UF_GetTColumns]()RETURNS TABLE AS RETURN (SELECT 0 N)')
GO
-- =============================================
-- Author:		Artyom
-- Create date: 25.09.20
-- Description:	 Возвращает типы столбцов таблицы
-- =============================================
ALTER FUNCTION [stn].[UF_GetTColumns](
	@Table AS VARCHAR(50))
RETURNS TABLE
AS
RETURN
   (
   SELECT
	   [COLUMN_NAME] AS                                                           [Name]
	 , [IS_NULLABLE] AS                                                           [Null]
	 , CAST([CHARACTER_MAXIMUM_LENGTH] AS VARCHAR) AS                             [Size]
	 , ISNULL([DOMAIN_NAME], [stn].[UF_GetCSType]([DATA_TYPE], [IS_NULLABLE])) AS [NType]
	 , [DOMAIN_NAME] AS                                                           [CType]
	 , [DATA_TYPE] AS                                                             [DBType]
   FROM
	   [INFORMATION_SCHEMA].[COLUMNS]
   WHERE [TABLE_NAME] = @Table AND
		 [COLUMN_NAME] NOT IN('CRdate', 'CRuser', 'EDdate', 'EDuser', 'DLDate', 'DLUser'))
GO

IF OBJECT_ID('[stn].[UF_GetTTColumns]') IS NULL
	EXEC ('CREATE FUNCTION [stn].[UF_GetTTColumns]()RETURNS TABLE AS RETURN (SELECT 0 N)')
GO
-- =============================================
-- Author:		Artyom
-- Create date:	26.05.2021
-- Description:	Возвращает типы столбцов табличного типа
-- =============================================
ALTER FUNCTION [stn].[UF_GetTTColumns](
	@Name AS VARCHAR(50))
RETURNS TABLE
AS
RETURN
   (
   SELECT
	   [C].[name] AS                             [Name]
	 , [C].[IS_NULLABLE] AS                      [Null]
	 , [stn].[UF_GetCSType]([T].[name], 'NO') AS [NType]
	 , [T].[name] AS                             [DBType]
   FROM
	   [sys].[columns] [C]
   LEFT JOIN [sys].[types] [T] ON [T].[system_type_id] = [C].[system_type_id] AND
								  [T].[user_type_id] = ISNULL([C].[user_type_id], [C].[system_type_id])
   WHERE [C].object_id IN
	  (SELECT
		   [type_table_object_id]
	   FROM
		   [sys].[table_types]
	   WHERE [name] = @Name))
GO

IF OBJECT_ID('[stn].[UF_GetUPInput]') IS NULL
	EXEC ('CREATE FUNCTION [stn].[UF_GetUPInput]()RETURNS TABLE AS RETURN (SELECT 0 N)')
GO
-- =============================================
-- Author:		Artyom
-- Create date: 21.01.2021
-- Description:	 Возвращает типы входных данных процедуры
-- =============================================
ALTER FUNCTION [stn].[UF_GetUPInput](
	@UP AS VARCHAR(50))
RETURNS TABLE
AS
RETURN
   (
   SELECT
	   [C].[IS_NULLABLE] AS                                   [Null]
	 , replace([C].[name], '@', '') AS                        [Name]
	 , CASE
		   WHEN [T].[name] LIKE 'n%char' THEN CAST([C].[max_length] / 2 AS VARCHAR)
		   WHEN [T].[name] LIKE '%char' THEN CAST([C].[max_length] AS VARCHAR)
									   ELSE NULL
	   END AS                                                 [Size]
	 , [stn].[UF_GetCSType]([T].[name], [T].[IS_NULLABLE]) AS [NType]
	 , [T].[name] AS                                          [DBType]
   FROM
	   [sys].[parameters] AS [C]
   JOIN [sys].[procedures] AS [p] ON [C].object_id = [p].object_id
   JOIN [sys].[types] AS [T] ON [C].[system_type_id] = [T].[system_type_id] AND
								[C].[user_type_id] = [T].[user_type_id]
   WHERE [p].[name] = @UP)
GO

IF OBJECT_ID('[stn].[UF_GetUPOutput]') IS NULL
	EXEC ('CREATE FUNCTION [stn].[UF_GetUPOutput]()RETURNS TABLE AS RETURN (SELECT 0 N)')
GO
-- =============================================
-- Author:		Artyom
-- Create date: 19.01.2021
-- Description:	 Возвращает типы выходных данных процедуры
-- =============================================
ALTER FUNCTION [stn].[UF_GetUPOutput](
	@UP AS VARCHAR(50))
RETURNS TABLE
AS
RETURN
   (
   SELECT
	   [C].[name] AS                                          [Name]
	 , [C].[IS_NULLABLE] AS                                   [Null]
	 , [stn].[UF_GetCSType]([T].[name], [T].[IS_NULLABLE]) AS [NType]
	 , [T].[name] AS                                          [DBType]
   FROM
	   [sys].[dm_exec_describe_first_result_set_for_object](OBJECT_ID(@UP), NULL) [C]
   LEFT JOIN [sys].[types] [T] ON [T].[system_type_id] = [C].[system_type_id] AND
								  [T].[user_type_id] = ISNULL([C].[user_type_id], [C].[system_type_id]))
GO