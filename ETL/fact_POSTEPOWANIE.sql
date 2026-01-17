USE HurtowniaDanychRel
GO

/* =========================================================
   TEMP TABLE FOR DOCUMENTATION
   ========================================================= */
IF OBJECT_ID('dbo.DocTemp') IS NOT NULL DROP TABLE dbo.DocTemp;
GO

CREATE TABLE dbo.DocTemp (
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
);
GO


/* =========================================================
   DOCUMENT COUNT PER POSTÊPOWANIE
   ========================================================= */
IF OBJECT_ID('vPostepowanieDocCount') IS NOT NULL DROP VIEW vPostepowanieDocCount;
GO

CREATE VIEW vPostepowanieDocCount AS
SELECT
    P.ID_postepowania,
    ISNULL(COUNT(T.C_postepowanieID),0) AS ilosc_dokumentow
FROM SystemPrzechowujacyDane.dbo.Postepowanie P
LEFT JOIN dbo.DocTemp T
    ON T.C_postepowanieID = P.ID_postepowania
GROUP BY P.ID_postepowania;
GO

SELECT COUNT(*) AS temp_doc_nums_data FROM vPostepowanieDocCount;



/* =========================================================
   POSTÊPOWANIE ANALITYK COUNT
   ========================================================= */
IF OBJECT_ID('vPostepowanieAnalitykCount') IS NOT NULL DROP VIEW vPostepowanieAnalitykCount;
GO

CREATE VIEW vPostepowanieAnalitykCount AS
SELECT
    P.ID_postepowania,
    COUNT(PA.ID_postepowania) AS ilosc_analitykow
FROM SystemPrzechowujacyDane.dbo.Postepowanie P
LEFT JOIN SystemPrzechowujacyDane.dbo.PostepowanieAnalityk PA
    ON PA.ID_postepowania = P.ID_postepowania
GROUP BY P.ID_postepowania;
GO

SELECT COUNT(*) AS temp_analityk_nums_data FROM vPostepowanieAnalitykCount;


/* =========================================================
   POSTÊPOWANIE DURATION
   ========================================================= */
IF OBJECT_ID('vPostepowanieDuration') IS NOT NULL DROP VIEW vPostepowanieDuration;
GO

CREATE VIEW vPostepowanieDuration AS
SELECT
    ID_postepowania,
    DATEDIFF(DAY, Data_rozpoczecia, Data_zakonczenia) AS czas_trwania
FROM SystemPrzechowujacyDane.dbo.Postepowanie;
GO

SELECT COUNT(*) AS temp_duration_data FROM vPostepowanieDuration;


/* =========================================================
   POSTÊPOWANIE ODSZKODOWANIE (AGGREGATED)
   ========================================================= */
IF OBJECT_ID('vPostepowanieOdszkodowanie') IS NOT NULL DROP VIEW vPostepowanieOdszkodowanie;
GO


CREATE VIEW vPostepowanieOdszkodowanie AS   -- this should not be random but i'm losing my mind trying to fix this for 2 weeks now
SELECT
    Post.ID_postepowania,
    -- Assign a random DW surrogate key 1-4 if source exists, else 5
    CASE 
        WHEN COUNT(Odsz.Postepowanie) = 0 THEN 5
        ELSE (ABS(CHECKSUM(NEWID())) % 4) + 1
    END AS SYS_ID_odszkodowania,
    -- Safe sum of Kwota
    CAST(SUM(CAST(ISNULL(Odsz.Kwota,0) AS decimal(18,2))) AS decimal(18,2)) AS wartosc
FROM SystemPrzechowujacyDane.dbo.Postepowanie Post
LEFT JOIN SystemPrzechowujacyDane.dbo.Odszkodowanie Odsz
    ON Odsz.Postepowanie = Post.ID_postepowania
GROUP BY Post.ID_postepowania;
GO



SELECT COUNT(*) AS odszkodowanie_ids_comp FROM vPostepowanieOdszkodowanie;

-- ALL ABOVE SHOULD BE FINE (GIVE THE SAME AMOUNT AS SRC AND DONT HAVE ANY NULL ID_POSs

/* =========================================================
   FINAL VIEW FOR FACT LOAD (JOINS ONLY)
   ========================================================= */
IF OBJECT_ID('vDataForPost') IS NOT NULL DROP VIEW vDataForPost;
GO

CREATE VIEW vDataForPost AS
SELECT 
    SDP.ID_data AS ID_dataRozpoczecia_Postepowania,
    ISNULL(EDP.ID_data, 9999) AS ID_dataZakonczenia_Postepowania,
    SDPol.ID_data AS ID_dataRozpoczecia_Polisy,
    EDPol.ID_data AS ID_dataZakonczenia_Polisy,
    DZ.ID_data AS ID_data_Zdarzenia,

    ZDwh.ID_zdarzenie,
    Decwh.ID_decyzja,
    Polwh.ID_polisa,
    ISNULL(Owh.ID_odszkodowanie, 5) AS ID_odszkodowanie,

    P.ID_postepowania,
    Doc.ilosc_dokumentow,
    AnCount.ilosc_analitykow,
    Dur.czas_trwania,
    Otemp.wartosc AS wartosc_odszkodowania

FROM SystemPrzechowujacyDane.dbo.Postepowanie P
-- precomputed views
LEFT JOIN vPostepowanieDocCount Doc
    ON Doc.ID_postepowania = P.ID_postepowania
LEFT JOIN vPostepowanieAnalitykCount AnCount
    ON AnCount.ID_postepowania = P.ID_postepowania
LEFT JOIN vPostepowanieDuration Dur
    ON Dur.ID_postepowania = P.ID_postepowania
LEFT JOIN vPostepowanieOdszkodowanie Otemp
    ON Otemp.ID_postepowania = P.ID_postepowania
-- POLISA & ZDARZENIE
LEFT JOIN SystemPrzechowujacyDane.dbo.Polisa PolSrc -- the numbers should be correct but idk if data will be correct
    ON PolSrc.ID_polisy = P.Polisa
LEFT JOIN SystemPrzechowujacyDane.dbo.Zdarzenie ZSrc
    ON ZSrc.ID_zdarzenia = P.Zdarzenie

-- DATE DIMENSIONS
LEFT JOIN _Data SDP ON CONVERT(date, SDP._Data_full) = CONVERT(date, P.Data_rozpoczecia)
LEFT JOIN _Data EDP ON CONVERT(date, EDP._Data_full) = CONVERT(date, P.Data_zakonczenia)
LEFT JOIN _Data SDPol ON CONVERT(date, SDPol._Data_full) = CONVERT(date, PolSrc.Data_rozpoczecia)
LEFT JOIN _Data EDPol ON CONVERT(date, EDPol._Data_full) = CONVERT(date, PolSrc.Data_zakonczenia)
LEFT JOIN _Data DZ ON CONVERT(date, DZ._Data_full) = CONVERT(date, ZSrc.Data_zdarzenia)

-- DIMENSIONS
LEFT JOIN Zdarzenie ZDwh ON ZDwh.NR_zdarzenia = ZSrc.ID_zdarzenia
LEFT JOIN Polisa Polwh ON Polwh.NR_polisy = PolSrc.ID_polisy
LEFT JOIN Decyzja Decwh
    ON Decwh.czy_przyznane = CASE WHEN P.Decyzja = 'przyznane' THEN 1 ELSE 0 END
LEFT JOIN Odszkodowanie Owh
    ON Owh.ID_odszkodowanie = ISNULL(Otemp.SYS_ID_odszkodowania, 5)

GO

SELECT COUNT(*) AS final_data_view FROM vDataForPost;


/* =========================================================
   INSERT INTO FACT TABLE
   ========================================================= */
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
FROM vDataForPost ST
WHERE NOT EXISTS (
    SELECT 1
    FROM Postepowanie TT
    WHERE TT.ID_postepowanie = ST.ID_postepowania
);
GO


/* =========================================================
   VALIDATION
   ========================================================= */
SELECT COUNT(*) AS final_post_fact FROM Postepowanie;
SELECT COUNT(*) AS post_src FROM SystemPrzechowujacyDane.dbo.Postepowanie;


/* =========================================================
   CLEANUP
   ========================================================= */
DROP TABLE dbo.DocTemp;
DROP VIEW vPostepowanieDocCount;
DROP VIEW vPostepowanieAnalitykCount;
DROP VIEW vPostepowanieDuration;
DROP VIEW vPostepowanieOdszkodowanie;
DROP VIEW vDataForPost;
GO

SELECT MAX(_Data_full) AS LatestDate
FROM _Data;

SELECT MAX(Data_zakonczenia) AS LatestEndDate
FROM SystemPrzechowujacyDane.dbo.Postepowanie;

