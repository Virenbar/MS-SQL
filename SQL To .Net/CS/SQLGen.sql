-- #SQL Procedure code
-- ##From Procedure
SELECT [Name] +' = ISNULL(@' + [Name] + ',' + [Name] + '),'
FROM [stn].[UF_GetUPOutput]('Table')

-- ##From Table
-- Insert/Update
SELECT '@' + [Name] +' '+ DBtype + IIF(size IS NULL, '', '(' + Size+')')+IIF([Null] ='NO','',' = null')+','
FROM [stn].[UF_GetTColumns]('Table')
-- Insert
SELECT '@' + [Name]+','
FROM [stn].[UF_GetTColumns]('Table')
-- Update
SELECT [Name] +' = @' + [Name] + ','
FROM [stn].[UF_GetTColumns]('Table')
-- Update OR Keep
SELECT [Name] +' = ISNULL(@' + [Name] + ',' + [Name] + '),'
FROM [stn].[UF_GetTColumns]('Table')

-- #CS Class code
-- ##From Procedure
-- Data Property
SELECT 'public ' + [NType] + ' '+ [Name]
FROM [stn].[UF_GetUPOutput]('Procedure')
-- Class Property
SELECT 'public '+NType +' '+[Name]+'{
	get => Data.'+[Name]+';
	set {
		if(Data.'+[Name]+' == value){return;}
		Data.'+[Name]+' = value;
		NotifyPropertyChanged();
	}
}'
FROM [stn].[UF_GetUPOutput]('Procedure')
-- Row to Property
SELECT [Name] + ' = R.Field<' + [NType]+'>("'+[Name]+'")'
FROM [stn].[UF_GetUPOutput]('Procedure')
-- Data to Parameter
SELECT 'P.Add(New SqlParameter("@' + [Name] + '", SqlDbType.' + [DBType] + IIF([size] IS NULL, '', ', ' + [Size]) + ') {Value = Data.' + [Name] + '})'
FROM [stn].[UF_GetUPOutput]('Procedure')

-- ##From table
-- TODO

-- #CS.Net DataTable
-- TODO