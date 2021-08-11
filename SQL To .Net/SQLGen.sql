-- VB.NET Class code
-- Data Property
SELECT 'Public Property ' + Name + ' As ' + NType
FROM [stn].[UF_GetTColumns]('Table')
-- Class Property
SELECT 'Public Property '+Name+' As '+NType+'
	Get
		Return Data.'+Name+'
	End Get
	Set(value As '+NType+')
		Data.'+Name+' = value
		NotifyPropertyChanged()
	End Set
End Property'
FROM [stn].[UF_GetTColumns]('Table')
-- Row to Property
SELECT Name + ' = R.Field(Of ' + NType+')("'+Name+'")'
FROM [stn].[UF_GetTColumns]('Table')
-- Data to Parameter
SELECT '.Add(New SqlParameter("@' + Name + '", SqlDbType.' + DBType + IIF(size IS NULL, '', ', ' + Size) + ') With {.Value = Data.' + Name + '})'
FROM [stn].[UF_GetTColumns]('Table')
-- SQL Procedure code
-- Insert/Update
SELECT '@' + Name +' '+ DBtype + IIF(size IS NULL, '', '(' + Size+')')+IIF([Null] ='NO','',' = null')+','
FROM [stn].[UF_GetTColumns]('Table')
-- Insert
SELECT '@' + Name+','
FROM [stn].[UF_GetTColumns]('Table')
-- Update
SELECT name +'='+'@' + Name+','
FROM [stn].[UF_GetTColumns]('Table')

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/
--SELECT *
--FROM [stn].[UF_GetUPInput]('Procedure')
-- Report
-- VB.Net Class
SELECT
	'<DisplayName("' + [name] + '")>
Public Property ' + [name] + ' As ' + [NType]
FROM [stn].[UF_GetUPOutput]('Procedure')
-- Property
SELECT 'Public Property ' + [name] + ' As ' + [NType]
FROM [stn].[UF_GetUPOutput]('Procedure')
-- Property assign
SELECT [Name] + ' = R.Field(Of ' + [NType]+')("'+[Name]+'")'
FROM [stn].[UF_GetUPOutput]('Procedure')

-- VB.Net DataTable Parameter
-- From UP output
SELECT 'Columns.Add(New DataColumn With {.ColumnName = "' + [name] + '", .DataType = GetType(' + [Ntype] + ')})'
FROM [stn].[UF_GetUPOutput]('Procedure')
-- From user table type
SELECT 'Columns.Add(New DataColumn With {.ColumnName = "' + [name] + '", .DataType = GetType(' + [Ntype] + ')})'
FROM [stn].[UF_GetTTColumns]('Table Type')
SELECT 'R("' + [name] + '")=A.' + [name] + ''
FROM [stn].[UF_GetTTColumns]('Table Type')
SELECT [name] +'='+'P.' + [Name]+','
FROM [stn].[UF_GetTTColumns]('Table Type')
SELECT 'P.' + [Name]+','
FROM [stn].[UF_GetTTColumns]('Table Type')
-- From table
SELECT 'Columns.Add(New DataColumn With {.ColumnName = "' + [name] + '", .DataType = GetType(' + [Ntype] + ')})'
FROM [stn].[UF_GetTColumns]('Table')
SELECT 'R("' + [name] + '")=A.' + [name] + ''
FROM [stn].[UF_GetTColumns]('Table')

-- VB.Net Command
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