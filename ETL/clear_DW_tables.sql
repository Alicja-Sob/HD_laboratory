USE HurtowniaDanychRel
GO

-- TABELE POSREDNICZACE
DELETE FROM Rozliczenie_odszkodowania;
DELETE FROM Zebranie_Dokumentu;
DELETE FROM Kompilacja_analizy;
DELETE FROM Przypisanie_pracownika;


DELETE FROM Analiza_Dokumentow;
DBCC CHECKIDENT ('dbo.Analiza_Dokumentow', RESEED, 0);
DELETE FROM Zakup_Polisy;
DELETE FROM Postepowanie;
DBCC CHECKIDENT ('dbo.Postepowanie', RESEED, 0);

DELETE FROM Dokument;
DBCC CHECKIDENT ('dbo.Dokument', RESEED, 0);

DELETE FROM Odszkodowanie;
DBCC CHECKIDENT ('dbo.Odszkodowanie', RESEED, 0);
DELETE FROM Zdarzenie;
DBCC CHECKIDENT ('dbo.Zdarzenie', RESEED, 0);
DELETE FROM Decyzja;
DBCC CHECKIDENT ('dbo.Decyzja', RESEED, 0);
DELETE FROM Polisa;
DBCC CHECKIDENT ('dbo.Polisa', RESEED, 0);
DELETE FROM Klient;
DBCC CHECKIDENT ('dbo.Klient', RESEED, 0);
DELETE FROM Agent;
DBCC CHECKIDENT ('dbo.Agent', RESEED, 0);
DELETE FROM Analityk;
DBCC CHECKIDENT ('dbo.Analityk', RESEED, 0);

-- DANE STATYCZNE
DELETE FROM Typ_dokument;
DBCC CHECKIDENT ('dbo.Typ_dokument', RESEED, 0);
DELETE FROM _Data;
DBCC CHECKIDENT ('dbo._Data', RESEED, 0);

--SELECT * FROM _Data;
--SELECT * FROM Typ_Dokument;
GO