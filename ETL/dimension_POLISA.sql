USE HurtowniaDanychRel
GO

--DELETE FROM dbo.Polisa;
--DBCC CHECKIDENT ('dbo.Polisa', RESEED, 0);
--GO

IF (OBJECT_ID('vDataForPolisa') is NOT NULL) DROP VIEW vDataForPolisa;
GO

CREATE VIEW vDataForPolisa
AS 
SELECT DISTINCT
	[ID_polisy] AS [NR_polisy],
	[Kategoria]
FROM [SystemPrzechowujacyDane].dbo.[Polisa]
JOIN [SystemPrzechowujacyDane].dbo.[Postepowanie] -- tylko polisy ktore sa przypisane do jakiegos postepowania
	ON [SystemPrzechowujacyDane].dbo.[Postepowanie].[Polisa]   = [SystemPrzechowujacyDane].dbo.[Polisa].[ID_polisy]
GO

MERGE INTO Polisa AS TT
	USING vDataForPolisa as ST
		ON TT.NR_polisy = ST.NR_polisy
		AND TT.Kategoria = ST.Kategoria
		WHEN NOT MATCHED THEN	-- wstawianie NOWYCH polis
			INSERT VALUES (ST.Nr_polisy, ST.Kategoria)
		WHEN NOT MATCHED BY SOURCE THEN	-- USUWANIE polis, bez pasujacej tabeli faktu
			DELETE;
GO	

-- istniejace wpisy pozostaja bez zmian (nie ma WHEN MATCHED)

DROP VIEW vDataForPolisa;


