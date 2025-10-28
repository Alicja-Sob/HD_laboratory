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

-- loading snapshots\snapshot2 updates
-- i have no idea how to do that??