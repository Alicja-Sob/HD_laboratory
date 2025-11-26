USE HurtowniaDanychRel
GO

/* is DW table not having a unique constraint on this create issues?
prob the ability to double the entries but we're supposed to add these only once anyway?
so does it even matter like that? */

INSERT INTO [dbo].[Typ_Dokument]
SELECT t FROM 
(VALUES 
	('Umowa'), 
	('Raport'), 
	('Faktura'), 
	('Notatka'), 
	('Protoko³'), 
	('Zaswiadczenie'), 
	('Zawiadomienie'), 
	('Inne')
	)
	AS typ_dokumentu(t)