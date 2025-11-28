USE HurtowniaDanychRel
GO

-- TABELE POSREDNICZACE
DELETE FROM Kompilacja_Dokumentacji;

DELETE FROM Zakup_Polisy;

DELETE FROM Postepowanie;
DBCC CHECKIDENT ('dbo.Postepowanie', RESEED, 0);

DELETE FROM Dokumentacja;
DBCC CHECKIDENT ('dbo.Dokumentacja', RESEED, 0);

DELETE FROM Zdarzenie;
DBCC CHECKIDENT ('dbo.Zdarzenie', RESEED, 0);
DELETE FROM Polisa;
DBCC CHECKIDENT ('dbo.Polisa', RESEED, 0);
DELETE FROM Klient;
DBCC CHECKIDENT ('dbo.Klient', RESEED, 0);
DELETE FROM Agent;
DBCC CHECKIDENT ('dbo.Agent', RESEED, 0);

-- DANE STATYCZNE
DELETE FROM Decyzja;
DBCC CHECKIDENT ('dbo.Decyzja', RESEED, 0);

DELETE FROM _Data;
DBCC CHECKIDENT ('dbo._Data', RESEED, 0);

DELETE FROM Odszkodowanie;
DBCC CHECKIDENT ('dbo.Odszkodowanie', RESEED, 0);

--SELECT * FROM _Data;
--SELECT * FROM Typ_Dokument;
GO