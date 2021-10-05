-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Artyom
-- Create date:	01.10.2021
-- Description:	Convert Base64 string to GUID
-- =============================================
ALTER FUNCTION [Base64ToGUID](
	@Base64 CHAR(24))
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	-- SELECT CAST(CAST('EBQN5QlZQH6xkK/DYjfdDg==' AS XML).value('.', 'varbinary(16)') AS UNIQUEIDENTIFIER) --Invalid
	-- 10140de5-0959-407e-b190-afc36237dd0e --Valid
	-- SELECT [dbo].[Base64ToGUID]('EBQN5QlZQH6xkK/DYjfdDg==')

	DECLARE @Result BINARY(16)
	SET @Result = CAST(@Base64 AS XML).value('.', 'varbinary(16)')
	SET @Result = CAST(REVERSE(SUBSTRING(@Result, 1, 4)) + REVERSE(SUBSTRING(@Result, 5, 2)) + REVERSE(SUBSTRING(@Result, 7, 2)) AS VARBINARY(8)) + SUBSTRING(@Result, 9, 8)
	RETURN CAST(@Result AS UNIQUEIDENTIFIER)
END
GO