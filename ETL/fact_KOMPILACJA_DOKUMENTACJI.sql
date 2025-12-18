
USE HurtowniaDanychRel;
GO

IF OBJECT_ID('dbo.DocTemp') IS NOT NULL DROP TABLE dbo.DocTemp;
GO

CREATE TABLE dbo.DocTemp(
	A_lp varchar(10),
	B_nazwa varchar(255),
	C_postepowanieID varchar(20),
	D_typDok varchar(255),
	E_autor varchar(255),
	F_dataDostarczenia date,
	G_info varchar(100)
);
GO

BULK INSERT dbo.DocTemp
FROM 'C:\Users\sobal\PycharmProjects\generating_inserts\snapshots\dokumenty_snapshot1.csv' 
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
);
GO

IF OBJECT_ID('dbo.Kompilacja_dokumentacji') IS NOT NULL
    DROP TABLE dbo.Kompilacja_dokumentacji;
GO

CREATE TABLE dbo.Kompilacja_dokumentacji
(
    ID_postepowanie   varchar(20) NOT NULL,
    ID_dokumentacja   INT NOT NULL,

    CONSTRAINT PK_Kompilacja_dokumentacji
        PRIMARY KEY CLUSTERED (ID_postepowanie, ID_dokumentacja)
);
GO
INSERT INTO dbo.Kompilacja_dokumentacji (ID_postepowanie, ID_dokumentacja)
SELECT DISTINCT
    Pwh.ID_postepowanie,
    Dwh.ID_dokumentacja
FROM dbo.DocTemp Temp
JOIN dbo.Postepowanie Pwh
    ON Pwh.ID_postepowanie = Temp.C_postepowanieID
JOIN dbo.Dokumentacja Dwh
    ON Dwh.Autor = Temp.E_autor;
GO


SELECT COUNT(*) FROM dbo.Kompilacja_dokumentacji;

SELECT TOP 10 *
FROM dbo.Kompilacja_dokumentacji;

SELECT ID_postepowanie, COUNT(*) AS dokumentacje
FROM dbo.Kompilacja_dokumentacji
GROUP BY ID_postepowanie;

DROP TABLE dbo.DocTemp;
GO
