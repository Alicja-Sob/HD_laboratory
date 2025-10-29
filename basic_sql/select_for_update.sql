USE SystemPrzechowujacyDane
GO

-- Updates need to be called in a different file

-- can compare this with results from loading_bulk file

SELECT _Status, COUNT(*) AS status_odszkodowanie FROM Odszkodowanie GROUP BY _Status ORDER BY _Status;
SELECT _Status, COUNT(*) AS status_Odwolanie FROM Odwolanie GROUP BY _Status ORDER BY _Status;