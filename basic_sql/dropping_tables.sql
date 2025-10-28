USE SystemPrzechowujacyDane

DROP TABLE Polisa; 
DROP TABLE Klient; 
DROP TABLE Pracownik; 
DROP TABLE Agent; 
DROP TABLE Analityk; 
DROP TABLE PostepowanieAnalityk; 
DROP TABLE Postepowanie; 
DROP TABLE Zdarzenie; 
DROP TABLE Odwolanie; 
DROP TABLE Odszkodowanie; 
DROP TABLE Naprawy; 
DROP TABLE Platnosc;

/*
-- drop whole database
USE master;
ALTER DATABASE SystemPrzechowujacyDane 
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE SystemPrzechowujacyDane;

*/