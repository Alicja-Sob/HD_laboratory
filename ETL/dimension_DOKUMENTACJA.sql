USE HurtowniaDanychRel
GO

--DELETE FROM dbo.Dokumentacja;
--DBCC CHECKIDENT ('dbo.Dokumentacja', RESEED, 0);
--GO

-- needs data from EXCEL and DB

IF (OBJECT_ID('dbo.DocTemp') is NOT NULL) DROP TABLE dbo.DocTemp;
CREATE TABLE dbo.DocTemp(
	A_lp varchar(10),
	B_nazwa varchar(255),
	C_postepowanieID varchar(20),
	D_typDok varchar(255),
	E_autor varchar(255),
	F_dataDostarczenia date,
	G_info varchar(100)	
	);
GO

-- ADJUST THIS PART TO RUN THIS: "C:\Users\sobal\PycharmProjects\generating_inserts" !!
BULK INSERT dbo.DocTemp
	FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\dokumenty_snapshot1.csv' 
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',  --CSV field delimiter
		ROWTERMINATOR = '\n',   --Use to shift the control to next row
		TABLOCK
	)
GO

CREATE VIEW vDataForDokumentacja
AS 
SELECT
	[E_autor] AS [Autor],
	Src.[ID_postepowania] AS [PostepowanieID],
	-- ilosc dokumentow (count how many of the same autors are per one postepowanie)
	CASE
		WHEN COUNT(*) BETWEEN 1 AND 5 THEN '1-5'
		WHEN COUNT(*) BETWEEN 6 AND 10 THEN '5-10'
		WHEN COUNT(*) BETWEEN 11 AND 15 THEN '10-15'
		WHEN COUNT(*) BETWEEN 16 AND 20 THEN '15-20'
		WHEN COUNT(*) BETWEEN 21 AND 25 THEN '20-25'
		WHEN COUNT(*) BETWEEN 26 AND 30 THEN '25-30'
		WHEN COUNT(*) > 30 THEN 'powyzej 30'
		--ELSE 'ERROR!'
	END AS [ilosc_dokumentow],
	-- srednie opoznienie - avg (all of the czas_dostarczenia - czas rozpoczecia postepowania) 
	CASE 
		WHEN AVG(DATEDIFF(DAY, Src.[Data_rozpoczecia], Temp.[F_dataDostarczenia])) BETWEEN 0 AND 7 THEN 'ponizej tygodnia'
		WHEN AVG(DATEDIFF(DAY, Src.[Data_rozpoczecia], Temp.[F_dataDostarczenia])) BETWEEN 8 AND 14 THEN 'tydzien - 2 tygodnie'
		WHEN AVG(DATEDIFF(DAY, Src.[Data_rozpoczecia], Temp.[F_dataDostarczenia])) BETWEEN 15 AND 21 THEN '2 tygodnie - 3 tygodnie'
		WHEN AVG(DATEDIFF(DAY, Src.[Data_rozpoczecia], Temp.[F_dataDostarczenia])) BETWEEN 22 AND 30 THEN '3 tygodnie - miesiac'
		WHEN AVG(DATEDIFF(DAY, Src.[Data_rozpoczecia], Temp.[F_dataDostarczenia])) > 30 THEN 'powyzej miesiaca'
	--	ELSE 'ERROR!'
	END AS [srednie_opoznienie],
	-- glowny typ (dla odpowienich dokumentow wybierz typ ktory najczescie (>=50%) sie powtarza)
(
    SELECT TOP 1 D_typDok
    FROM (
        SELECT 
            DTtemp.D_typDok,
            COUNT(*) AS Cnt
        FROM dbo.DocTemp DTtemp
        WHERE DTtemp.E_autor = Temp.E_autor
          AND DTtemp.C_postepowanieID = Temp.C_postepowanieID
        GROUP BY DTtemp.D_typDok
    ) AS X
    ORDER BY X.Cnt DESC
) AS [glowny_typ_dokumentow]
FROM dbo.[DocTemp] AS Temp
JOIN [SystemPrzechowujacyDane].dbo.[Postepowanie] AS Src	-- tylko dokumenty przypisane do istniejacego postepowania
	ON Src.[ID_postepowania] = Temp.[C_postepowanieID]
GROUP BY
	Temp.E_autor, 
	Src.ID_postepowania,
	Temp.C_postepowanieID;
GO



MERGE INTO Dokumentacja AS TT
	USING vDataForDokumentacja AS ST
		ON TT.Autor LIKE '%' + ST.Autor + '%'
		WHEN NOT MATCHED THEN	-- wstawianie NOWYCH dokumentacji
			INSERT VALUES (ST.Autor, ST.ilosc_dokumentow, ST.srednie_opoznienie ,ST.glowny_typ_dokumentow)
		WHEN NOT MATCHED BY SOURCE THEN	-- USUWANIE dokumentacji bez pasujacej tablei faktu?
			DELETE;
GO

--SELECT COUNT(*) FROM Dokumentacja;


DROP TABLE dbo.DocTemp;
DROP VIEW vDataForDokumentacja;
GO

