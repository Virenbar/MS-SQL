SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Artyom
-- Create date: 21.01.2021
-- Description:	 Возвращает типы входных данных процедуры
-- =============================================
CREATE FUNCTION [dbo].[UF_GetUPInput](
	@UP AS VARCHAR(50))
RETURNS TABLE
AS
RETURN
   (
   SELECT
   --[C].[parameter_id] AS                                       [Order]
	   [C].[IS_NULLABLE] AS                                                     [Null]
	 , replace([C].[name], '@', '') AS                                          [Name]
	 , IIF([T].[name] LIKE '%char', CAST([C].[max_length] AS VARCHAR), NULL) AS [Size]
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
		   WHEN 'datetime' THEN 'Date'
		   WHEN 'bit' THEN 'Boolean'
	   ELSE [T].[name]
	   END + IIF([C].[IS_NULLABLE] = 0 OR
				 [T].[name] IN('varchar', 'nvarchar'), '', '?') AS              [NType]
	 , [T].[name] AS                                                            [DBType]
   FROM
	   [sys].[parameters] AS [C]
   JOIN
	   [sys].[procedures] AS [p] ON [C].object_id = [p].object_id
   JOIN
	   [sys].[types] AS [T] ON [C].[system_type_id] = [T].[system_type_id] AND
							   [C].[user_type_id] = [T].[user_type_id]
   WHERE [p].[name] = @UP
   )