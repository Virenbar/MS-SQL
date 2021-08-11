-- #SQL Procedure code
-- Insert/Update
SELECT '@' + [Name] +' '+ DBtype + IIF(size IS NULL, '', '(' + Size+')')+IIF([Null] ='NO','',' = null')+','
FROM [stn].[UF_GetTColumns]('Table')
-- Insert
SELECT '@' + [Name]+','
FROM [stn].[UF_GetTColumns]('Table')
-- Update
SELECT [Name] +'='+'@' + [Name]+','
FROM [stn].[UF_GetTColumns]('Table')

-- #VB.NET Class code
-- ##From procedure
-- Data Property
SELECT 'Public Property ' + [Name] + ' As ' + [NType]
FROM [stn].[UF_GetUPOutput]('Procedure')
-- Class Property
SELECT 'Public Property '+[Name]+' As '+NType+'
	Get
		Return Data.'+[Name]+'
	End Get
	Set(value As '+NType+')
		Data.'+[Name]+' = value
		NotifyPropertyChanged()
	End Set
End Property'
FROM [stn].[UF_GetUPOutput]('Procedure')
-- Row to Property
SELECT [Name] + ' = R.Field(Of ' + [NType]+')("'+[Name]+'")'
FROM [stn].[UF_GetUPOutput]('Procedure')
-- Data to Parameter
SELECT '.Add(New SqlParameter("@' + [Name] + '", SqlDbType.' + [DBType] + IIF([size] IS NULL, '', ', ' + [Size]) + ') With {.Value = Data.' + [Name] + '})'
FROM [stn].[UF_GetUPOutput]('Procedure')

-- ##From table
-- Data Property
SELECT 'Public Property ' + [Name] + ' As ' + NType
FROM [stn].[UF_GetTColumns]('Table')
-- Class Property
SELECT 'Public Property '+[Name]+' As '+NType+'
	Get
		Return Data.'+[Name]+'
	End Get
	Set(value As '+NType+')
		Data.'+[Name]+' = value
		NotifyPropertyChanged()
	End Set
End Property'
FROM [stn].[UF_GetTColumns]('Table')
-- Row to Property
SELECT [Name] + ' = R.Field(Of ' + [NType]+')("'+[Name]+'")'
FROM [stn].[UF_GetTColumns]('Table')
-- Data to Parameter
SELECT '.Add(New SqlParameter("@' + [Name] + '", SqlDbType.' + [DBType] + IIF([size] IS NULL, '', ', ' + [Size]) + ') With {.Value = Data.' + [Name] + '})'
FROM [stn].[UF_GetTColumns]('Table')

-- #VB.Net DataTable
-- From UP output
SELECT 'Columns.Add(New DataColumn With {.ColumnName = "' + [Name] + '", .DataType = GetType(' + [Ntype] + ')})'
FROM [stn].[UF_GetUPOutput]('Procedure')
-- From user table type
SELECT 'Columns.Add(New DataColumn With {.ColumnName = "' + [Name] + '", .DataType = GetType(' + [Ntype] + ')})'
FROM [stn].[UF_GetTTColumns]('Table Type')
-- From table
SELECT 'Columns.Add(New DataColumn With {.ColumnName = "' + [Name] + '", .DataType = GetType(' + [Ntype] + ')})'
FROM [stn].[UF_GetTColumns]('Table')

-- Property to Row
SELECT 'R("' + [Name] + '")=A.' + [Name] + ''
FROM [stn].[UF_GetTTColumns]('Table Type')
-- Property to Row
SELECT 'R("' + [Name] + '")=A.' + [Name] + ''
FROM [stn].[UF_GetTColumns]('Table')

SELECT [Name] +'='+'P.' + [Name]+','
FROM [stn].[UF_GetTTColumns]('Table Type')
SELECT 'P.' + [Name]+','
FROM [stn].[UF_GetTTColumns]('Table Type')

-- #VB.Net Function
-- List of function parameter
SELECT Name + ' As ' +NType +','
FROM [stn].[UF_GetUPInput]('Procedure')
-- Parameters as function parameters
SELECT '.Add(New SqlParameter("@' + Name + '", SqlDbType.' + DBType + IIF(size IS NULL, '', ', ' + Size) + ') With {.Value = ' +  Name + '})'	 
FROM [stn].[UF_GetUPInput]('Procedure')

-- List of properties of Object
SELECT 'Public Property ' + Name + ' As ' + NType
FROM [stn].[UF_GetUPInput]('Procedure')
-- Parameters as properties of Object
SELECT '.Add(New SqlParameter("@' + Name + '", SqlDbType.' + DBType + IIF(size IS NULL, '', ', ' + Size) + ') With {.Value = Data.' +  Name + '})'	 
FROM [stn].[UF_GetUPInput]('Procedure')