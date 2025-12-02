USE HurtowniaDanychRel
GO

--DELETE FROM dbo.Polisa;
--DBCC CHECKIDENT ('dbo.Polisa', RESEED, 0);
--GO

IF (OBJECT_ID('vDataForKlient') is NOT NULL) DROP VIEW vDataForKlient;
GO

CREATE VIEW vDataForKlient
AS 
SELECT DISTINCT
	[PESEL],
	[Pelne_ImieNazwisko] = CAST([Imie] + ' ' + IsNull([Drugie_imie] + ' ', '') + [Nazwisko] as VARCHAR(255))
FROM [SystemPrzechowujacyDane].dbo.[Klient]
JOIN [SystemPrzechowujacyDane].dbo.[Polisa] -- tylko klienci ktorzy kupili jakas polise
	ON [SystemPrzechowujacyDane].dbo.[Polisa].[Klient]   = [SystemPrzechowujacyDane].dbo.[Klient].[PESEL]
GO

MERGE INTO Klient AS TT
	USING vDataForKlient AS ST
		ON TT.PESEL = ST.PESEL
		AND TT.Pelne_ImieNazwisko = ST.Pelne_ImieNazwisko
		WHEN NOT MATCHED THEN	-- wstawianie NOWYCH klientow
			INSERT VALUES (ST.PESEL, ST.Pelne_ImieNazwisko)
		WHEN NOT MATCHED BY SOURCE THEN -- USUWANIE klientow bez pasujacych polis (not in the created view)
			DELETE;
/*		WHEN MATCHED AND (ST.Pelne_ImieNazwisko <> TT.Pelne_ImieNazwisko) THEN 
			UPDATE
			SET TT.Pelne_ImieNazwisko = ST.Pelne_ImieNazwisko;
*/

GO

DROP VIEW vDataForKlient;