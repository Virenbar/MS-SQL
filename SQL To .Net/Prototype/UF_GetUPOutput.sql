SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Artyom
-- Create date: 19.01.2021
-- Description:	 Возвращает типы выходных данных процедуры
-- =============================================
CREATE FUNCTION [dbo].[UF_GetUPOutput](
	@UP AS VARCHAR(50))
RETURNS TABLE
AS
RETURN
   (
   SELECT
	   [C].[name] AS                                               [name]
	 , [C].[IS_NULLABLE] AS                                        [Null]
	 , CASE [T].[name]
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
	   ELSE [T].[name]
	   END + IIF([C].[IS_NULLABLE] = 0 OR
				 [T].[name] IN('varchar', 'nvarchar'), '', '?') AS [NType]
	 , [T].[name] AS                                               [DBType]
   FROM
	   [sys].[dm_exec_describe_first_result_set_for_object](OBJECT_ID(@UP), NULL) [C]
   LEFT JOIN
	   [sys].[types] [T] ON [T].[system_type_id] = [C].[system_type_id] AND
							[T].[user_type_id] = ISNULL([C].[user_type_id], [C].[system_type_id])
   )