USE HurtowniaDanychRel
GO

DELETE FROM dbo._Data;
DBCC CHECKIDENT ('dbo._Data', RESEED, 0);
GO

-- DECLARING START AND END DATES

DECLARE @EarliestDate date;	-- for dates of birth etc

DECLARE @StartDateT1 date;
DECLARE @EndDateT1 date;

DECLARE @StartDateT2 date;
DECLARE @EndDateT2 date;

SELECT @EarliestDate ='1937-01-01', @StartDateT1 = '2005-01-01', @EndDateT1 = '2020-12-31', @StartDateT2 = '2021-02-01', @EndDateT2 = '2025-12-31';

-- WHILE LOOP

DECLARE @DateInProcess date = @EarliestDate

-- loop is for both snapshots at once, idk if that's how it's supposed to be for the lab
WHILE @DateInProcess <= @EndDateT2	
	BEGIN
		INSERT INTO [dbo].[_Data] ( [Dzien], [Miesiac], [Rok])
		VALUES (
			CAST (Day(@DateInProcess) as INT),
			CAST (Month(@DateInProcess) as INT),
			CAST (Year(@DateInProcess) as INT)
		);
		SET @DateInProcess = DateAdd(d, 1, @DateInProcess);
	END
GO