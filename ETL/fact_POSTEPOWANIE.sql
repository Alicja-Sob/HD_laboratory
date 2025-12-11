USE HurtowniaDanychRel
GO

-- temp table for documentation (to exact count the amount)
IF (OBJECT_ID('dbo.DocTemp') IS NOT NULL) DROP TABLE dbo.DocTemp;
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

BULK INSERT dbo.DocTemp
	FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\dokumenty_snapshot1.csv' 
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',  
		ROWTERMINATOR = '\n',   
		TABLOCK
	)
GO

-- temp data collected from excel 
IF(OBJECT_ID('vtempDocData') IS NOT NULL) DROP VIEW vtempDocData;
GO

CREATE VIEW vtempDocData
AS
SELECT
	Src.ID_postepowania,
	COUNT(*) AS ilosc_dokumentow
FROM dbo.DocTemp AS Temp
JOIN SystemPrzechowujacyDane.dbo.Postepowanie AS Src
	ON Src.ID_postepowania = Temp.C_postepowanieID
GROUP BY Src.ID_postepowania;
GO

-- DROP previous Odszkodowanie view if exists
IF(OBJECT_ID('vOdszkodowanieTemp') IS NOT NULL) DROP VIEW vOdszkodowanieTemp;
GO

-- vOdszkodowanieTemp using only Kwota from Odszkodowanie
CREATE VIEW vOdszkodowanieTemp
AS
SELECT
    Post.ID_postepowania,
    Odsz.ID_odszkodowania AS SYS_ID_odszkodowania,
    CASE
        WHEN Odsz.ID_odszkodowania IS NULL THEN 'Nie przyznane'
        ELSE 'Odszkodowanie'
    END AS rodzaj_odszkodowania,
    CAST(ISNULL(Odsz.Kwota,0) AS NUMERIC(38,2)) AS wartosc
FROM SystemPrzechowujacyDane.dbo.Postepowanie Post
LEFT JOIN SystemPrzechowujacyDane.dbo.Odszkodowanie Odsz
    ON Odsz.Postepowanie = Post.ID_postepowania;
GO

-- FINAL VIEW FOR MERGE
IF(OBJECT_ID('vDataForPost') is NOT NULL) DROP VIEW vDataForPost;
GO

CREATE VIEW vDataForPost
AS
SELECT DISTINCT
	SDP.ID_data AS ID_dataRozpoczecia_Postepowania,
	EDP.ID_data AS ID_dataZakonczenia_Postepowania,
	SDPol.ID_data AS ID_dataRozpoczecia_Polisy,
	EDPol.ID_data AS ID_dataZakonczenia_Polisy,
	DZ.ID_data AS ID_data_Zdarzenia,

	ZDwh.ID_zdarzenie,
	Decwh.ID_decyzja,
	Polwh.ID_polisa,
	Owh.ID_odszkodowanie,

	P.ID_postepowania AS [ID_postepowania],

	Doc.ilosc_dokumentow,
	
	(SELECT COUNT(*) 
	 FROM SystemPrzechowujacyDane.dbo.PostepowanieAnalityk PA
	 WHERE PA.ID_postepowania = P.ID_postepowania) AS ilosc_analitykow,

	DATEDIFF(DAY, P.Data_rozpoczecia, P.Data_zakonczenia) AS czas_trwania,

	Otemp.wartosc AS wartosc_odszkodowania

FROM SystemPrzechowujacyDane.dbo.Postepowanie P
JOIN vtempDocData Doc ON Doc.ID_postepowania = P.ID_postepowania
JOIN SystemPrzechowujacyDane.dbo.Polisa PolSrc ON PolSrc.ID_polisy = P.Polisa
JOIN SystemPrzechowujacyDane.dbo.Zdarzenie ZSrc ON ZSrc.ID_zdarzenia = P.Zdarzenie

LEFT JOIN vOdszkodowanieTemp Otemp
	ON Otemp.ID_postepowania = P.ID_postepowania

-- DATE DIM
JOIN _Data SDP ON CONVERT(VARCHAR(10), SDP._Data_full, 111) = CONVERT(VARCHAR(10), P.Data_rozpoczecia, 111)
JOIN _Data EDP ON CONVERT(VARCHAR(10), EDP._Data_full, 111) = CONVERT(VARCHAR(10), P.Data_zakonczenia, 111)
JOIN _Data SDPol ON CONVERT(VARCHAR(10), SDPol._Data_full, 111) = CONVERT(VARCHAR(10), PolSrc.Data_rozpoczecia, 111)
JOIN _Data EDPol ON CONVERT(VARCHAR(10), EDPol._Data_full, 111) = CONVERT(VARCHAR(10), PolSrc.Data_zakonczenia, 111)
JOIN _Data DZ ON CONVERT(VARCHAR(10), DZ._Data_full, 111) = CONVERT(VARCHAR(10), ZSrc.Data_zdarzenia, 111)

-- ZDARZENIE DIM
JOIN Zdarzenie ZDwh ON ZDwh.NR_zdarzenia = ZSrc.ID_zdarzenia

-- POLISA DIM
JOIN Polisa Polwh ON Polwh.NR_polisy = PolSrc.ID_polisy

-- DECYZJA DIM
JOIN Decyzja Decwh ON Decwh.czy_przyznane =
	CASE WHEN P.Decyzja = 'przyznane' THEN 1 ELSE 0 END

-- ODSZKODOWANIE DIM
JOIN Odszkodowanie Owh ON Owh.rodzaj_odszkodowania = Otemp.rodzaj_odszkodowania;
GO

-- Insert into Postepowanie fact table, avoiding duplicates
INSERT INTO Postepowanie (
	ID_dataRozpoczecia_Postepowania,
	ID_dataZakonczenia_Postepowania,
	ID_dataRozpoczecia_Polisy,
	ID_dataZakonczeniaPolisy,
	ID_data_Zdarzenia,
	ID_zdarzenie,
	ID_decyzja,
	ID_polisa,
	ID_odszkodowanie,
	ID_postepowanie,
	ilosc_dokumentow,
	ilosc_analitykow,
	czas_trwania,
	wartosc_odszkodowania
)
SELECT
	ST.ID_dataRozpoczecia_Postepowania,
	ST.ID_dataZakonczenia_Postepowania,
	ST.ID_dataRozpoczecia_Polisy,
	ST.ID_dataZakonczenia_Polisy,
	ST.ID_data_Zdarzenia,
	ST.ID_zdarzenie,
	ST.ID_decyzja,
	ST.ID_polisa,
	ST.ID_odszkodowanie,
	ST.ID_postepowania,
	ST.ilosc_dokumentow,
	ST.ilosc_analitykow,
	ST.czas_trwania,
	ST.wartosc_odszkodowania
FROM vDataForPost AS ST
WHERE NOT EXISTS (
	SELECT 1
	FROM Postepowanie TT
	WHERE TT.ID_postepowanie = ST.ID_postepowania
);
GO

SELECT COUNT(*) FROM Postepowanie;	-- smth is definetely wrong cause the numbers are WAY too small
SELECT COUNT(*) FROM SystemPrzechowujacyDane.dbo.Postepowanie;

-- Cleanup
DROP TABLE dbo.DocTemp;
DROP VIEW vtempDocData;
DROP VIEW vOdszkodowanieTemp;
DROP VIEW vDataForPost;
GO
