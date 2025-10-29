USE SystemPrzechowujacyDane
GO
-- should this be in two different files?

-- ADJUST THIS PART TO RUN THIS: "C:\Users\sobal\PycharmProjects\generating_inserts" !!
BULK INSERT dbo.Klient FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Klient_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Pracownik FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Pracownik_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Agent FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Agent_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Analityk FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Analityk_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Polisa FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Polisa_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Zdarzenie FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Zdarzenie_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Postepowanie FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Postepowanie_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.PostepowanieAnalityk FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Pol_An_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Odwolanie FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Odwolanie_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Odszkodowanie FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Odszkodowanie_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Naprawy FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Naprawy_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Platnosc FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot1\Platnosc_inserts.bulk' WITH (FIELDTERMINATOR='|')
GO

-- SELECT queries presenting the data for snapshot 1

SELECT
	-- showing min and maxes dates in whole database
	(SELECT MIN(Data_zdarzenia) FROM Zdarzenie) AS Min_data_zdarzenie,    
	(SELECT MIN(Data_zatrudnienia) FROM Pracownik) AS Min_data_zatrudnienia,
    (SELECT MAX(Data_rozpoczecia) FROM Postepowanie) AS Max_data_postepowanie,    
	(SELECT MAX(Data_zatrudnienia) FROM Pracownik) AS Max_data_zatrudnienia,
	-- showing count of entities in 2-3 tables
	(SELECT COUNT(*) FROM Klient) AS Liczba_klientow,
    (SELECT COUNT(*) FROM Postepowanie) AS Liczba_postepowan,
    (SELECT COUNT(*) FROM Zdarzenie) AS Liczba_zdarzen;
-- showing full example enity for a table
SELECT TOP 1 * FROM Klient ORDER BY Data_urodzenia;
GO

-- loading snapshots\snapshot2 inserts
BULK INSERT dbo.Klient FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Klient_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Pracownik FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Pracownik_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Agent FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Agent_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Analityk FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Analityk_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Polisa FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Polisa_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Zdarzenie FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Zdarzenie_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Postepowanie FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Postepowanie_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.PostepowanieAnalityk FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Pol_An_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Odwolanie FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Odwolanie_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Odszkodowanie FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Odszkodowanie_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Naprawy FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Naprawy_inserts.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT dbo.Platnosc FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\snapshot2\Platnosc_inserts.bulk' WITH (FIELDTERMINATOR='|')
GO

-- SELECT queries presenting the data for snapshot 2
SELECT
	-- showing min and maxes dates in whole database
	(SELECT MAX(Data_zdarzenia) FROM Zdarzenie) AS Max_data_zdarzenie,
    (SELECT MAX(Data_zatrudnienia) FROM Pracownik) AS Max_data_zatrudnienia,
	-- showing count of entities in 2-3 tables
	(SELECT COUNT(*) FROM Klient) AS Liczba_klientow,
    (SELECT COUNT(*) FROM Postepowanie) AS Liczba_postepowan,
    (SELECT COUNT(*) FROM Zdarzenie) AS Liczba_zdarzen;
-- showing full example enity for a table
SELECT TOP 1 * FROM Klient ORDER BY Data_urodzenia;
GO

-- for later comparison with state after updates
SELECT _Status, COUNT(*) AS status_odszkodowanie FROM Odszkodowanie GROUP BY _Status ORDER BY _Status;
SELECT _Status, COUNT(*) AS status_Odwolanie FROM Odwolanie GROUP BY _Status ORDER BY _Status;