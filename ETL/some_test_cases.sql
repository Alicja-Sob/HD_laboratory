USE HurtowniaDanychRel
GO

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

-- FIXME - THIS DOESNT WORK FOR POSTEPOWANIE AT LEAST (AND THIS IS THE ONLY ONE WE CAN REALISTUCALLY CHECK)

-- ------------------------------------------------------------------------------------------------------------------------
-- TEST CASE 3 (scd2)

SELECT 
    (SELECT COUNT(*) FROM Agent) AS Agent_dim_count,
    (SELECT COUNT(*) FROM SystemPrzechowujacyDane.dbo.Agent) AS Agent_src_count;

-- update one agent
UPDATE SystemPrzechowujacyDane.dbo.Agent 
    SET Placowka = 'Robinchester', Ostatnia_data_zmiany_placowki = '2023-04-29' WHERE ID_agenta = 'f18dc73b00114cc08320';
-- run the script for agent again (seperate file)

-- run zakup_polisy etl again?
SELECT 
    (SELECT COUNT(*) FROM Agent) AS Agent_dim_count,
    (SELECT COUNT(*) FROM SystemPrzechowujacyDane.dbo.Agent) AS Agent_src_count;