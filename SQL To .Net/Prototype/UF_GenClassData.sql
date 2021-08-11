SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Artyom
-- Create date: 25.09.20
-- Description:	 Возвращает данные для генерации кода классов и процедур
-- =============================================
CREATE FUNCTION [dbo].[UF_GenClassData](
	@Table AS VARCHAR(50))
RETURNS TABLE
AS
RETURN
   (
   SELECT
	   [COLUMN_NAME] AS                                             [Name]
	 , [IS_NULLABLE] AS                                             [Null]
	 , CAST([CHARACTER_MAXIMUM_LENGTH] AS VARCHAR) AS               [Size]
	 , CASE [DATA_TYPE]
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
	   ELSE [DATA_TYPE]
	   END + IIF([IS_NULLABLE] = 'NO' OR
				 [DATA_TYPE] IN('varchar', 'nvarchar'), '', '?') AS [NType]
	 , [DOMAIN_NAME] AS                                             [CType]
	 , [DATA_TYPE] AS                                               [DBType]
   FROM
	   [INFORMATION_SCHEMA].[COLUMNS]
   WHERE [TABLE_NAME] = @Table
   )