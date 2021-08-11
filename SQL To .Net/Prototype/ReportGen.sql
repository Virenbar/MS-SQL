-- VB.NET Class code
SELECT 'Public Property ' + Name + ' As ' + NType
FROM [stn].[UF_GetTColumns]('D_Pipeline')
SELECT 'Public Property '+Name+' As '+NType+'
	Get
		Return Data.'+Name+'
	End Get
	Set(value As '+NType+')
		Data.'+Name+' = value
		NotifyPropertyChanged()
	End Set
End Property'
FROM [stn].[UF_GetTColumns]('D_Pipeline')
SELECT Name + ' = R.Field(Of ' + NType+')("'+Name+'")'
FROM [stn].[UF_GetTColumns]('D_Pipeline')
SELECT '.Add(New SqlParameter("@' + Name + '", SqlDbType.' + DBType + IIF(size IS NULL, '', ', ' + Size) + ') With {.Value = ' + Name + '})'	 
FROM [stn].[UF_GetTColumns]('D_Pipeline')
SELECT Name + ' = obj.' + Name + ' And'
FROM [stn].[UF_GetTColumns]('D_Pipeline')

-- SQL Procedure code
SELECT '@' + Name +' '+ DBtype + IIF(size IS NULL, '', '(' + Size+')')+IIF([Null] ='NO','',' = null')+','
FROM [stn].[UF_GetTColumns]('D_Pipeline')
SELECT name +'='+'@' + Name+','
FROM [stn].[UF_GetTColumns]('D_Pipeline')
SELECT '@' + Name+','
FROM [stn].[UF_GetTColumns]('D_Pipeline')

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/
-- Report
SELECT *
FROM [stn].[UF_GetUPInput]('UP_INSP_UpdateUL')
-- VB.Net Class
SELECT
	'<DisplayName("' + [name] + '")>
Public Property ' + [name] + ' As ' + [NType]
FROM [stn].[UF_GetUPOutput]('UP_PIR_Report_ReestrEGRN')

-- VB.Net DataTable
-- From UP output
SELECT 'Columns.Add(New DataColumn With {.ColumnName = "' + [name] + '", .DataType = GetType(' + [Ntype] + ')})'
FROM [stn].[UF_GetUPOutput]('UP_INSP_SelectAnketList')
-- From user table type
SELECT 'Columns.Add(New DataColumn With {.ColumnName = "' + [name] + '", .DataType = GetType(' + [Ntype] + ')})'
FROM [stn].[UF_GetTTColumns]('Anketa')
SELECT 'R("' + [name] + '")=A.' + [name] + ''
FROM [stn].[UF_GetTTColumns]('Anketa')

-- VB.Net Command
-- List of function parameter
SELECT Name + ' As ' +NType +','
FROM [stn].[UF_GetUPInput]('UP_INSP_UpdateUL')
-- Parameters as function parameters
SELECT '.Add(New SqlParameter("@' + Name + '", SqlDbType.' + DBType + IIF(size IS NULL, '', ', ' + Size) + ') With {.Value = ' +  Name + '})'	 
FROM [stn].[UF_GetUPInput]('UP_INSP_del_from_table')

-- List of properties of Object
SELECT 'Public Property ' + Name + ' As ' + NType
FROM [stn].[UF_GetUPInput]('up_PIR_Report_AllInf')
-- Parameters as properties of Object
SELECT '.Add(New SqlParameter("@' + Name + '", SqlDbType.' + DBType + IIF(size IS NULL, '', ', ' + Size) + ') With {.Value = Data.' +  Name + '})'	 
FROM [stn].[UF_GetUPInput]('UP_INSP_del_from_table')


SELECT
	* FROM
	[stn].[UF_GetUPInput]
	('up_PIR_Report_AllInf')