USE HurtowniaDanychRel
GO

IF(OBJECT_ID('vDataForZakupPolisy') is NOT NULL) DROP VIEW vDataForZakupPolisy;
GO

CREATE VIEW vDataForZakupPolisy
AS
SELECT DISTINCT	--SKs not BKs
	[ID_polisa] = Hpolisa.[ID_polisa],
	[ID_klient] = Hklient.[ID_klient],
	[ID_agent] = Hagent.[ID_agent]
FROM [SystemPrzechowujacyDane].dbo.[Polisa] AS polisa
JOIN [HurtowniaDanychRel].dbo.[Polisa] AS Hpolisa
	ON Hpolisa.[NR_polisy] = polisa.[ID_polisy]	-- match polisa dimension
JOIN [HurtowniaDanychRel].dbo.[Klient] AS Hklient
	ON Hklient.[PESEL] = polisa.[Klient] -- match klient dimension
/*JOIN [HurtowniaDanychRel].dbo.[Agent] Hagent
	ON Hagent.[ID_pracownika] = polisa.[Agent]; -- match agent dimension*/
JOIN [HurtowniaDanychRel].dbo.[Agent] AS Hagent	-- matching agent dimension, considering scd
	ON Hagent.[ID_pracownika] = polisa.[Agent]
	WHERE polisa.[Data_rozpoczecia] between Hagent.[Data_zatrudnienia] AND COALESCE(Hagent.[Data_zakonczenia], CAST(GETDATE() AS DATE));

	--AND polisa.[Data_rozpoczecia] < COALESCE(Hagent.[Data_zakonczenia], '9999-12-31');

GO

INSERT INTO Zakup_Polisy (ID_polisa, ID_klient, ID_agent)	-- normal merge didnt work, not sure if this one inserts correct amount tho
SELECT ST.ID_polisa, ST.ID_klient, ST.ID_agent
FROM vDataForZakupPolisy AS ST
WHERE NOT EXISTS (
    SELECT 1 
    FROM Zakup_Polisy TT
    WHERE TT.ID_polisa = ST.ID_polisa
      AND TT.ID_klient = ST.ID_klient
      AND TT.ID_agent = ST.ID_agent
);

--SELECT COUNT(*) FROM Zakup_Polisy;
--SELECT TOP 10 * FROM Zakup_Polisy;
--SELECT COUNT(*) FROM Agent;
--SELECT TOP 10 * FROM Agent;

DROP VIEW vDataForZakupPolisy;