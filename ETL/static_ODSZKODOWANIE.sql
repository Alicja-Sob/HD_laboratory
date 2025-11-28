USE HurtowniaDanychRel
GO

DELETE FROM dbo.Odszkodowanie;
DBCC CHECKIDENT ('dbo.Odszkodowanie', RESEED, 0);
GO

INSERT INTO [dbo].Odszkodowanie
SELECT r FROM 
(VALUES 
	('Naprawa'),
	('Platnosc'),
	('Naprawa i Platnosc'),
	('Inne'),
	('Nie przyznane')
	)
	AS rodzaj_odszkodowania(r)