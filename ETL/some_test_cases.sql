USE HurtowniaDanychRel
GO

-- TODO: fix SCD cause now it just broke completely for no reason (only the code i DIDNT change managed to get broken somehow)
-- TODO: add the UNKNOWN things, whatever that is 
-- ------------------------------------------------------------------------------------------------------------------------
-- Prep
-- clear src db -> clear dw db -> snapshots 1 to src -> run dim/fact etl -> check tc1 -> ...

-- ------------------------------------------------------------------------------------------------------------------------
-- TEST CASE 1 + (rows in fact = rows in src / no duplicating)

SELECT 
    (SELECT COUNT(*) FROM Postepowanie) AS Post_fact_count,
    (SELECT COUNT(*) FROM SystemPrzechowujacyDane.dbo.Postepowanie) AS Post_src_count;
GO

-- recznie uruchomic skrypt w ssms
-- ponownie uruchomic powyzsze selecty


-- ------------------------------------------------------------------------------------------------------------------------
-- TEST CASE 2 + (snapshot 2 data)
-- zaladuj snapshot 2 
-- check again
SELECT 
    (SELECT COUNT(*) FROM Postepowanie) AS Post_fact_count,
    (SELECT COUNT(*) FROM SystemPrzechowujacyDane.dbo.Postepowanie) AS Post_src_count;

-- ------------------------------------------------------------------------------------------------------------------------
-- TEST CASE 3 (scd2)

SELECT 
    (SELECT COUNT(*) FROM Agent) AS Agent_dim_count,
    (SELECT COUNT(*) FROM SystemPrzechowujacyDane.dbo.Agent) AS Agent_src_count,
    (SELECT COUNT(*) FROM Zakup_Polisy) AS zakup_pol_1;

-- update one agent
UPDATE SystemPrzechowujacyDane.dbo.Agent 
    SET Placowka = 'Robincsdvdver', Ostatnia_data_zmiany_placowki = '2023-04-29' WHERE ID_agenta = 'f18dc73b00114cc08320';
-- run the script for agent again (seperate file)

INSERT INTO SystemPrzechowujacyDane.dbo.Polisa (ID_polisy, Kategoria, Data_rozpoczecia, Data_zakonczenia, Premium, Klient, Agent)
    VALUES ('f18dc555ccc444111112', 'majatkowe', '2023-09-09', '2025-09-09', 99.99, '00210362046', 'f18dc73b00114cc08320')

    -- run zakup_polisy again

SELECT * FROM Agent WHERE ID_pracownika = 'f18dc73b00114cc08320';
SELECT * FROM Polisa WHERE NR_polisy = 'f18dc555ccc444111111';
SELECT * FROM SystemPrzechowujacyDane.dbo.Polisa WHERE ID_polisy = 'f18dc555ccc444111111';
SELECT * FROM SystemPrzechowujacyDane.dbo.Polisa WHERE Agent = 'f18dc73b00114cc08320';
SELECT TOP 100 * FROM Zakup_Polisy WHERE ID_agent = '79';
SELECT * FROM Agent;
SELECT COUNT(*) FROM Zakup_Polisy WHERE ID_agent = '79';
SELECT TOP 100 * FROM Zakup_Polisy WHERE ID_agent = '3501';
SELECT COUNT(*) FROM Zakup_Polisy WHERE ID_agent = '3501';


-- run zakup_polisy etl again?
SELECT 
    (SELECT COUNT(*) FROM Agent) AS Agent_dim_count,
    (SELECT COUNT(*) FROM SystemPrzechowujacyDane.dbo.Agent) AS Agent_src_count,
    (SELECT COUNT(*) FROM Zakup_Polisy) AS zakup_pol_2;