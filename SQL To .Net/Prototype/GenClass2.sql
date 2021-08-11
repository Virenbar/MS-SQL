
IF OBJECT_ID('tempdb..##GenTemp', 'U') IS NOT NULL
DROP TABLE ##GenTemp
--select * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'S_Address'

SELECT COLUMN_NAME AS Name,
	   DATA_TYPE AS DBType,
	   IS_NULLABLE AS [Null],
	   CAST(CHARACTER_MAXIMUM_LENGTH as varchar) AS Size,
	   CASE DATA_TYPE
		   WHEN 'int' THEN 'Integer'
		   WHEN 'money' THEN 'Decimal'
		   WHEN 'varchar' THEN 'String'
		   WHEN 'nvarchar' THEN 'String'
		   WHEN 'date' THEN 'Date'
		   WHEN 'datetime' THEN 'Date'
		   WHEN 'bit' THEN 'Boolean'
		   ELSE DATA_TYPE
	   END+IIF(IS_NULLABLE IS NULL OR DATA_TYPE in ('varchar','nvarchar'), '', '?') AS NType
INTO ##GenTemp
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'S_PipeLine'

SELECT 'Public Property ' + Name + ' As ' + NType
FROM ##GenTemp
SELECT Name + ' = R.Field(Of ' + NType+')("'+Name+'")'
FROM ##GenTemp
SELECT 'command.Parameters.Add(New SqlParameter() With {
            .ParameterName = "@' + Name + '",
            .SqlDbType = SqlDbType.' + DBType + ',
			' + IIF(size IS NULL, '', '.Size = ' + Size + ' ,
			') + '.Value = ' + Name + '})'
FROM ##GenTemp

SELECT '@' + Name +' '+ DBtype + IIF(size IS NULL, '', '(' + Size+')')+IIF([Null] IS null,'',' = null')+','
FROM ##GenTemp
SELECT name +'='+'@' + Name+','
FROM ##GenTemp
SELECT '@' + Name+','
FROM ##GenTemp
--SELECT '@' + Name +' '+ DBtype + IIF(size IS NULL, '', '(' + Size+')')+','
--FROM ##GenTemp
