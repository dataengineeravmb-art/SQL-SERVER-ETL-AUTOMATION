USE SALES_DATA
GO

IF OBJECT_ID('DBO.SALE_FILELOG') IS NOT NULL
    DROP TABLE DBO.SALE_FILELOG
GO

CREATE TABLE DBO.SALE_FILELOG
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FILENAME VARCHAR(255),
    IMPORT_DATA DATETIME DEFAULT GETDATE()
)
GO

IF OBJECT_ID('DBO.SALES_TEMP') IS NOT NULL
    DROP TABLE DBO.SALES_TEMP
GO

CREATE TABLE DBO.SALES_TEMP
(
    [S.No] VARCHAR(100),
    [Outlet Name] VARCHAR(150),
    [Bill Date] VARCHAR(50),
    [Cust Name] VARCHAR(150),
    [PBill No(T)] VARCHAR(100),
    [Bill Time] VARCHAR(50),
    [Sales Type] VARCHAR(100),
    [Cust_Code] VARCHAR(100),
    [Customer Name] VARCHAR(150),
    [Item Code] VARCHAR(100),
    [Item Name] VARCHAR(200),
    [User Name] VARCHAR(150),
    [HSN/SAC Code] VARCHAR(150),
    [SMS_ALERT_NO] VARCHAR(150),
    [Item_Master_Base_UOM] VARCHAR(50),
    [Supplier] VARCHAR(150),
    [Item Conversion] VARCHAR(50),
    [Expiry Dt] VARCHAR(50),
    [GST BILL NO] VARCHAR(100),
    [Customer GST No] VARCHAR(50),
    [Location Type] VARCHAR(50),
    [Customer Address] VARCHAR(255),
    [Customer City] VARCHAR(100),
    [Price Level Name] VARCHAR(100),
    [Rate Edit Reason] VARCHAR(150),
    [Max Conversion Type] VARCHAR(50),
    [Qty] VARCHAR(100),
    [Free Qty] VARCHAR(100),
    [Bill Amt(WOT Charges)] VARCHAR(100),
    [Item Amt] VARCHAR(100),
    [Item Rate] VARCHAR(100),
    [Item Disc Amt] VARCHAR(100),
    [Bill Disc Amt] VARCHAR(100),
    [Total Disc Amt] VARCHAR(100),
    [Tax%] VARCHAR(100),
    [Tax Amt] VARCHAR(100),
    [Service Tax%] VARCHAR(100),
    [Service Tax Amt] VARCHAR(100),
    [Amt With Tax] VARCHAR(100),
    [CESS %] VARCHAR(100),
    [CESS Amt] VARCHAR(100),
    [CGST %] VARCHAR(100),
    [CGST Amt] VARCHAR(100),
    [IGST %] VARCHAR(100),
    [IGST Amt] VARCHAR(100),
    [SGST %] VARCHAR(100),
    [SGST Amt] VARCHAR(100),
    [Total Amt] VARCHAR(100),
    [GoodsValue] VARCHAR(100),
    [Combo Qty] VARCHAR(100),
    [Total Qty] VARCHAR(100),
    [Item Free Qty in(Weight)KG] VARCHAR(100),
    [Extra Cess Amount] VARCHAR(100),
    [Item Conversion Qty] VARCHAR(100),
    [Item MRP] VARCHAR(100),
    [Purchase amount WOT] VARCHAR(100),
    [GST Tax Amt WOT Cess] VARCHAR(100),
    [GST Cess Amt] VARCHAR(100),
    [Bill Qty with Max Conv] VARCHAR(100),
    [Min Conversion Qty] VARCHAR(100),
    [Bill Qty with Min Conv] VARCHAR(100),
    [Conversion Rate] VARCHAR(100),
    [Order Type] VARCHAR(200)
)
GO

IF OBJECT_ID('DBO.SALES_MAIN') IS NOT NULL
    DROP TABLE DBO.SALES_MAIN
GO

CREATE TABLE DBO.SALES_MAIN
(
    [S.No] INT,
    [Outlet Name] VARCHAR(150),
    [Bill Date] DATE,
    [Cust Name] VARCHAR(150),
    [PBill No(T)] VARCHAR(100),
    [Bill Time] VARCHAR(50),
    [Sales Type] VARCHAR(100),
    [Cust_Code] VARCHAR(100),
    [Customer Name] VARCHAR(150),
    [Item Code] VARCHAR(100),
    [Item Name] VARCHAR(200),
    [User Name] VARCHAR(150),
    [HSN/SAC Code] VARCHAR(150),
    [SMS_ALERT_NO] VARCHAR(150),
    [Item_Master_Base_UOM] VARCHAR(50),
    [Supplier] VARCHAR(150),
    [Item Conversion] VARCHAR(50),
    [Expiry Dt] VARCHAR(50),
    [GST BILL NO] VARCHAR(100),
    [Customer GST No] VARCHAR(50),
    [Location Type] VARCHAR(50),
    [Customer Address] VARCHAR(255),
    [Customer City] VARCHAR(100),
    [Price Level Name] VARCHAR(100),
    [Rate Edit Reason] VARCHAR(150),
    [Max Conversion Type] VARCHAR(50),
    [Qty] DECIMAL(18,2),
    [Free Qty] DECIMAL(18,2),
    [Bill Amt(WOT Charges)] DECIMAL(18,2),
    [Item Amt] DECIMAL(18,2),
    [Item Rate] DECIMAL(18,2),
    [Item Disc Amt] DECIMAL(18,2),
    [Bill Disc Amt] DECIMAL(18,2),
    [Total Disc Amt] DECIMAL(18,2),
    [Tax%] DECIMAL(18,2),
    [Tax Amt] DECIMAL(18,2),
    [Service Tax%] DECIMAL(18,2),
    [Service Tax Amt] DECIMAL(18,2),
    [Amt With Tax] DECIMAL(18,2),
    [CESS %] DECIMAL(18,2),
    [CESS Amt] DECIMAL(18,2),
    [CGST %] DECIMAL(18,2),
    [CGST Amt] DECIMAL(18,2),
    [IGST %] DECIMAL(18,2),
    [IGST Amt] DECIMAL(18,2),
    [SGST %] DECIMAL(18,2),
    [SGST Amt] DECIMAL(18,2),
    [Total Amt] DECIMAL(18,2),
    [GoodsValue] DECIMAL(18,2),
    [Combo Qty] DECIMAL(18,2),
    [Total Qty] DECIMAL(18,2),
    [Item Free Qty in(Weight)KG] DECIMAL(18,2),
    [Extra Cess Amount] DECIMAL(18,2),
    [Item Conversion Qty] DECIMAL(18,2),
    [Item MRP] DECIMAL(18,2),
    [Purchase amount WOT] DECIMAL(18,2),
    [GST Tax Amt WOT Cess] DECIMAL(18,2),
    [GST Cess Amt] DECIMAL(18,2),
    [Bill Qty with Max Conv] DECIMAL(18,2),
    [Min Conversion Qty] DECIMAL(18,2),
    [Bill Qty with Min Conv] DECIMAL(18,2),
    [Conversion Rate] DECIMAL(18,2),
    [Order Type] VARCHAR(200),
    [SourceFileName] VARCHAR(255)
)
GO

CREATE OR ALTER PROCEDURE DBO.AUTO_SALES_CSV
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FOLDERPATH VARCHAR(255) = 'D:\SQL DATA\SALES FILE\';
    DECLARE @FILENAME VARCHAR(255);
    DECLARE @FULLPATH VARCHAR(500);
    DECLARE @SQL NVARCHAR(MAX);

    CREATE TABLE #TEMP_FILE
    (
        FILENAME VARCHAR(255)
    );

    INSERT INTO #TEMP_FILE
    EXEC xp_cmdshell 'dir "D:\SQL DATA\SALES FILE\*.csv" /b';

    DELETE FROM #TEMP_FILE
    WHERE FILENAME IS NULL
       OR LTRIM(RTRIM(FILENAME)) = '';
    DELETE M
    FROM DBO.SALES_MAIN M
    WHERE M.SourceFileName IS NOT NULL
      AND NOT EXISTS
      (
          SELECT 1
          FROM #TEMP_FILE F
          WHERE F.FILENAME = M.SourceFileName
      );

    DELETE L
    FROM DBO.SALE_FILELOG L
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM #TEMP_FILE F
        WHERE F.FILENAME = L.FILENAME
    );

    DECLARE FILE_CURSOR CURSOR FOR
        SELECT FILENAME
        FROM #TEMP_FILE;

    OPEN FILE_CURSOR;
    FETCH NEXT FROM FILE_CURSOR INTO @FILENAME;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM DBO.SALE_FILELOG
            WHERE FILENAME = @FILENAME
        )
        BEGIN
            SET @FULLPATH = @FOLDERPATH + @FILENAME;

            SET @SQL = '
                BULK INSERT DBO.SALES_TEMP
                FROM ''' + @FULLPATH + '''
                WITH
                (
                    FORMAT = ''CSV'',
                    FIRSTROW = 6,
                    FIELDQUOTE = ''"'',
                    FIELDTERMINATOR = '','',
                    ROWTERMINATOR = ''0x0d0a'',
                    TABLOCK,
                    KEEPNULLS,
                    CODEPAGE = ''65001''
                );';

            BEGIN TRY
                EXEC (@SQL);

                INSERT INTO DBO.SALES_MAIN
                (
                    [S.No],
                    [Outlet Name],
                    [Bill Date],
                    [Cust Name],
                    [PBill No(T)],
                    [Bill Time],
                    [Sales Type],
                    [Cust_Code],
                    [Customer Name],
                    [Item Code],
                    [Item Name],
                    [User Name],
                    [HSN/SAC Code],
                    [SMS_ALERT_NO],
                    [Item_Master_Base_UOM],
                    [Supplier],
                    [Item Conversion],
                    [Expiry Dt],
                    [GST BILL NO],
                    [Customer GST No],
                    [Location Type],
                    [Customer Address],
                    [Customer City],
                    [Price Level Name],
                    [Rate Edit Reason],
                    [Max Conversion Type],
                    [Qty],
                    [Free Qty],
                    [Bill Amt(WOT Charges)],
                    [Item Amt],
                    [Item Rate],
                    [Item Disc Amt],
                    [Bill Disc Amt],
                    [Total Disc Amt],
                    [Tax%],
                    [Tax Amt],
                    [Service Tax%],
                    [Service Tax Amt],
                    [Amt With Tax],
                    [CESS %],
                    [CESS Amt],
                    [CGST %],
                    [CGST Amt],
                    [IGST %],
                    [IGST Amt],
                    [SGST %],
                    [SGST Amt],
                    [Total Amt],
                    [GoodsValue],
                    [Combo Qty],
                    [Total Qty],
                    [Item Free Qty in(Weight)KG],
                    [Extra Cess Amount],
                    [Item Conversion Qty],
                    [Item MRP],
                    [Purchase amount WOT],
                    [GST Tax Amt WOT Cess],
                    [GST Cess Amt],
                    [Bill Qty with Max Conv],
                    [Min Conversion Qty],
                    [Bill Qty with Min Conv],
                    [Conversion Rate],
                    [Order Type],
                    [SourceFileName]
                )
                SELECT DISTINCT
                    TRY_CONVERT(INT, T.[S.No]),
                    T.[Outlet Name],
                    TRY_CONVERT(DATE, T.[Bill Date], 103),
                    T.[Cust Name],
                    T.[PBill No(T)],
                    T.[Bill Time],
                    T.[Sales Type],
                    T.[Cust_Code],
                    T.[Customer Name],
                    T.[Item Code],
                    T.[Item Name],
                    T.[User Name],
                    T.[HSN/SAC Code],
                    T.[SMS_ALERT_NO],
                    T.[Item_Master_Base_UOM],
                    T.[Supplier],
                    T.[Item Conversion],
                    T.[Expiry Dt],
                    T.[GST BILL NO],
                    T.[Customer GST No],
                    T.[Location Type],
                    T.[Customer Address],
                    T.[Customer City],
                    T.[Price Level Name],
                    T.[Rate Edit Reason],
                    T.[Max Conversion Type],

                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Qty])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Free Qty])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Bill Amt(WOT Charges)])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Item Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Item Rate])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Item Disc Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Bill Disc Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Total Disc Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Tax%])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Tax Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Service Tax%])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Service Tax Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Amt With Tax])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[CESS %])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[CESS Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[CGST %])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[CGST Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[IGST %])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[IGST Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[SGST %])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[SGST Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Total Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[GoodsValue])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Combo Qty])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Total Qty])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Item Free Qty in(Weight)KG])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Extra Cess Amount])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Item Conversion Qty])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Item MRP])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Purchase amount WOT])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[GST Tax Amt WOT Cess])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[GST Cess Amt])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Bill Qty with Max Conv])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Min Conversion Qty])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Bill Qty with Min Conv])), ''), ',', '')), 0),
                    ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Conversion Rate])), ''), ',', '')), 0),
                    T.[Order Type],
                    @FILENAME
                FROM DBO.SALES_TEMP T
                WHERE NOT EXISTS
                (
                    SELECT 1
                    FROM DBO.SALES_MAIN M
                    WHERE M.[Outlet Name] = T.[Outlet Name]
                      AND M.[Bill Date] = TRY_CONVERT(DATE, T.[Bill Date], 103)
                      AND M.[PBill No(T)] = T.[PBill No(T)]
                      AND M.[Item Name] = T.[Item Name]
                      AND M.[Bill Time] = T.[Bill Time]
                      AND M.[Qty] = ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[Qty])), ''), ',', '')), 0)
                      AND M.[GoodsValue] = ISNULL(TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(LTRIM(RTRIM(T.[GoodsValue])), ''), ',', '')), 0)
                      AND M.[Cust Name] = T.[Cust Name]
                      AND M.[GST BILL NO] = T.[GST BILL NO]
                );

                INSERT INTO DBO.SALE_FILELOG(FILENAME)
                VALUES(@FILENAME);

                TRUNCATE TABLE DBO.SALES_TEMP;
            END TRY
            BEGIN CATCH
                PRINT 'ERROR IN FILE : ' + @FILENAME;
                PRINT ERROR_MESSAGE();
                TRUNCATE TABLE DBO.SALES_TEMP;
            END CATCH
        END

        FETCH NEXT FROM FILE_CURSOR INTO @FILENAME;
    END

    CLOSE FILE_CURSOR;
    DEALLOCATE FILE_CURSOR;
    DROP TABLE #TEMP_FILE;
END
GO

EXEC DBO.AUTO_SALES_CSV
GO
SELECT * FROM SALE_FILELOG
SELECT [Outlet Name],SUM([GOODSVALUE]) AS TOTAL FROM SALES_MAIN
WHERE [Bill Date] > '2026-04-01'
GROUP BY [Outlet Name]
ORDER BY [Outlet Name]

