SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- CREATE SCHEMA [stn]
IF OBJECT_ID('[stn].[UF_GetVBType]') IS NULL
	EXEC ('CREATE FUNCTION [stn].[UF_GetVBType]()RETURNS VARCHAR(50)AS BEGIN RETURN ''''END')
GO
-- =============================================
-- Author:		Artyom
-- Create date: 27.05.21
-- Description:	Перевод типа из SQL в .Net
-- =============================================
ALTER FUNCTION [stn].[UF_GetVBType](
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
			   WHEN 'uniqueidentifier' THEN 'Guid'
		   ELSE @SQLType
		   END + IIF(@IsNull = 'NO' OR @IsNull = '0' OR @SQLType LIKE '%char', '', '?')
END
GO

IF OBJECT_ID('[stn].[UF_GetDBType]') IS NULL
	EXEC ('CREATE FUNCTION [stn].[UF_GetDBType]()RETURNS VARCHAR(50)AS BEGIN RETURN ''''END')
GO
-- =============================================
-- Author:		Artyom
-- Create date: 05.01.2022
-- Description:	Перевод типа из SQL в SqlDbType
-- =============================================
ALTER FUNCTION [stn].[UF_GetDBType](
	@SQLType VARCHAR(50))
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN CASE @SQLType
			   WHEN 'int' THEN 'Int'
			   WHEN 'bigint' THEN 'BigInt'
			   WHEN 'decimal' THEN 'Decimal'
			   WHEN 'money' THEN 'Money'
			   WHEN 'char' THEN 'Char'
			   WHEN 'nchar' THEN 'NChar'
			   WHEN 'varchar' THEN 'VarChar'
			   WHEN 'nvarchar' THEN 'NVarChar'
			   WHEN 'date' THEN 'Date'
			   WHEN 'smalldatetime' THEN 'SmallDateTime'
			   WHEN 'datetime' THEN 'DateTime'
			   WHEN 'bit' THEN 'Bit'
			   WHEN 'uniqueidentifier' THEN 'UniqueIdentifier'
		   ELSE @SQLType
		   END
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
	 , ISNULL([DOMAIN_NAME], [stn].[UF_GetVBType]([DATA_TYPE], [IS_NULLABLE])) AS [NType]
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
	 , [stn].[UF_GetVBType]([T].[name], 'NO') AS [NType]
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
	 , [stn].[UF_GetVBType]([T].[name], [C].[IS_NULLABLE]) AS [NType]
	 , [stn].[UF_GetDBType]([T].[name]) AS                    [DBType]
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
	 , [stn].[UF_GetVBType]([T].[name], [C].[IS_NULLABLE]) AS [NType]
	 , [T].[name] AS                                          [DBType]
   FROM
	   [sys].[dm_exec_describe_first_result_set_for_object](OBJECT_ID(@UP), NULL) [C]
   LEFT JOIN [sys].[types] [T] ON [T].[system_type_id] = [C].[system_type_id] AND
								  [T].[user_type_id] = ISNULL([C].[user_type_id], [C].[system_type_id]))
GO