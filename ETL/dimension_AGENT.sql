USE HurtowniaDanychRel
GO

--DELETE FROM dbo.Agent;
--DBCC CHECKIDENT ('dbo.Agent', RESEED, 0);
--GO

-- SCD IMPLEMENTATION!! (when new row with same id_pracownika added, add data_zakonczenia to old version)
-- the change for the dimensions is the PLACOWKA - if this changes then we add new row etc etc

IF (OBJECT_ID('vDataForAgent') is NOT NULL) DROP VIEW vDataForAgent;
GO

CREATE VIEW vDataForAgent
AS 
SELECT DISTINCT
	p.[ID_pracownika] AS [ID_pracownika],
	[Pelne_ImieNazwisko] = CAST (p.[Imie] + ' ' + IsNull(p.[Drugie_imie] + ' ', '') + p.[Nazwisko] as VARCHAR(255)),
	p.[Data_zatrudnienia] AS [Data_zatrudnienia],
	a.[Placowka] AS [Placowka],
	a.[Ostatnia_data_zmiany_placowki] AS [Ostatnia_data_zmiany_placowki]
FROM [SystemPrzechowujacyDane].dbo.[Agent] AS a
JOIN [SystemPrzechowujacyDane].dbo.[Pracownik] AS p
	ON a.[ID_agenta] = p.[ID_pracownika]
JOIN SystemPrzechowujacyDane.dbo.Polisa AS pol
	ON pol.Agent = a.ID_agenta;
GO

IF (OBJECT_ID('updatedAgents') IS NOT NULL) DROP TABLE updatedAgents;

CREATE TABLE updatedAgents (
	ID_pracownika VARCHAR(20),
	Pelne_ImieNazwisko VARCHAR(255),
	Data_zakonczenia DATE,
	Data_zatrudnienia DATE,
	Placowka VARCHAR(255)
);

-- no idea if this is how scd should work, the enauczanie example overcomplcates thigs so much it's barely readable ngl
MERGE INTO Agent AS TT
	USING vDataForAgent AS ST
	ON TT.ID_pracownika = ST.ID_pracownika
		WHEN NOT MATCHED THEN	-- w hurtowni nie ma pracownika z tym numerem ID
			INSERT (ID_pracownika, Pelne_ImieNazwisko, Data_zatrudnienia, Data_zakonczenia, Placowka)
			VALUES (ST.[ID_pracownika], ST.[Pelne_ImieNazwisko], ST.[Data_zatrudnienia], NULL, ST.[Placowka])
		-- pracownik z ID istnieje, ale PLACOWKA sie zmienila (scd2)
		WHEN MATCHED 
			AND (ST.Placowka <> TT.Placowka)
			AND TT.[Data_zakonczenia] IS NULL
			THEN UPDATE	-- UPDATE existing one
				SET TT.Data_zakonczenia = DATEADD(DAY, -1, ST.Ostatnia_data_zmiany_placowki)	-- one day before placowka change from agent
			OUTPUT
				ST.[ID_pracownika],
				ST.[Pelne_ImieNazwisko],
				ST.[Data_zatrudnienia],
				NULL,  -- new row is active
				ST.[Placowka]
			INTO updatedAgents ([ID_pracownika], [Pelne_ImieNazwisko], [Data_zatrudnienia], [Data_zakonczenia], [Placowka]);
GO

INSERT INTO Agent (ID_pracownika, Pelne_ImieNazwisko, Data_zatrudnienia, Data_zakonczenia, Placowka)
SELECT ua.[ID_pracownika], ua.[Pelne_ImieNazwisko], ua.[Data_zatrudnienia], ua.[Data_zakonczenia], ua.[Placowka]
FROM updatedAgents ua
JOIN Agent a 
	ON ua.[ID_pracownika] = a.[ID_pracownika]
	WHERE a.[Data_zakonczenia] IS NOT NULL;
GO

DROP VIEW vDataForAgent;
DROP TABLE updatedAgents;