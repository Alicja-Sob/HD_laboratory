USE HurtowniaDanychRel
GO

DELETE FROM dbo.Decyzja;
DBCC CHECKIDENT ('dbo.Decyzja', RESEED, 0);
GO

INSERT INTO [dbo].Decyzja
SELECT c FROM 
(VALUES 
	(0),
	(1)
	)
	AS czy_przyznane(c)