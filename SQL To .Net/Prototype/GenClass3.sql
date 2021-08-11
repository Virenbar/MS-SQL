--select * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'S_Address'

-- Update temp date
IF OBJECT_ID('tempdb..##GenTemp', 'U') IS NOT NULL DROP TABLE ##GenTemp
SELECT
	[G].[Name],
	[G].[Null],
	[G].[Size],
	[G].[DBType],
	IIF([CType] IS NULL, [ntype], [CType]) AS [Ntype]
INTO [##GenTemp]
FROM [UF_GenClassData]('D_Request') [G]
SELECT * FROM ##GenTemp

-- VB.NET Class code
SELECT 'Public Property ' + Name + ' As ' + NType
FROM ##GenTemp
SELECT 'Public Property '+Name+' As '+NType+'
	Get
		Return Data.'+Name+'
	End Get
	Set(value As '+NType+')
		Data.'+Name+' = value
		NotifyPropertyChanged()
	End Set
End Property'
FROM ##GenTemp
SELECT Name + ' = R.Field(Of ' + NType+')("'+Name+'")'
FROM ##GenTemp
SELECT '.Add(New SqlParameter("@' + Name + '", SqlDbType.' + DBType + IIF(size IS NULL, '', ', ' + Size) + ') With {.Value = ' + Name + '})'	 
FROM ##GenTemp
SELECT Name + ' = obj.' + Name + ' And'
FROM ##GenTemp

-- SQL Procedure code
SELECT '@' + Name +' '+ DBtype + IIF(size IS NULL, '', '(' + Size+')')+IIF([Null] ='NO','',' = null')+','
FROM ##GenTemp
SELECT name +'='+'@' + Name+','
FROM ##GenTemp
SELECT '@' + Name+','
FROM ##GenTemp
--SELECT '@' + Name +' '+ DBtype + IIF(size IS NULL, '', '(' + Size+')')+','
--FROM ##GenTemp
