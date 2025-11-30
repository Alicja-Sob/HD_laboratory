USE HurtowniaDanychRel
GO

--DELETE FROM dbo.Zdarzenie;
--DBCC CHECKIDENT ('dbo.Zdarzenie', RESEED, 0);
--GO

IF (OBJECT_ID('vDataForZdarzenie') is NOT NULL) DROP VIEW vDataForZdarzenie;
GO

CREATE VIEW vDataForZdarzenie
AS 
SELECT DISTINCT
	[ID_zdarzenia] as [NR_zdarzenia],
	[Lokalizacja],
	[Rodzaj]
FROM [SystemPrzechowujacyDane].dbo.[Zdarzenie]
JOIN [SystemPrzechowujacyDane].dbo.[Postepowanie] -- tylko zdarzenia ktore sa przypisane do jakiegos postepowania
	ON [SystemPrzechowujacyDane].dbo.[Postepowanie].[Zdarzenie]   = [SystemPrzechowujacyDane].dbo.[Zdarzenie].[ID_zdarzenia]
GO

MERGE INTO Zdarzenie AS TT
	USING vDataForZdarzenie AS ST
		ON TT.NR_zdarzenia = ST.NR_zdarzenia
		AND TT.Lokalizacja = ST.Lokalizacja
		AND TT.Rodzaj = ST.Rodzaj
		WHEN NOT MATCHED THEN -- wstawianie NOWYCH polis
			INSERT VALUES (ST.NR_zdarzenia, Lokalizacja, Rodzaj)
		WHEN NOT MATCHED BY SOURCE THEN -- USUWANIE zdarzen bez pasujacej tabeli faktu
			DELETE;
GO

-- istniejace wpisy pozostaja bez zmian (nie ma WHEN MATCHED)

DROP VIEW vDataForZdarzenie;