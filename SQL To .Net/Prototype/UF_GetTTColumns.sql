/****** Object:  UserDefinedFunction [dbo].[UF_GetUPOutput]    Script Date: 18.02.2021 11:41:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Artyom
-- Create date:	26.05.2021
-- Description:	Возвращает типы столбцов табличного типа
-- =============================================
CREATE FUNCTION [dbo].[UF_GetTTColumns](
	@Name AS VARCHAR(50))
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
	   [sys].[columns] [C]
   LEFT JOIN
	   [sys].[types] [T] ON [T].[system_type_id] = [C].[system_type_id] AND
							[T].[user_type_id] = ISNULL([C].[user_type_id], [C].[system_type_id])
   WHERE [C].object_id IN
	  (SELECT
		   [type_table_object_id]
	   FROM
		   [sys].[table_types]
	   WHERE [name] = @Name
	  )
   )