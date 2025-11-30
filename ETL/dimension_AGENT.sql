USE HurtowniaDanychRel
GO

--DELETE FROM dbo.Polisa;
--DBCC CHECKIDENT ('dbo.Polisa', RESEED, 0);
--GO

-- SCD IMPLEMENTATION!! (when new row added, add data_zakonczenia to old version)

-- can do update on the name? cause its not important for the buissnes part?