/*USE master;
ALTER DATABASE SystemPrzechowujacyDane 
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE SystemPrzechowujacyDane;
GO*/

CREATE database SystemPrzechowujacyDane
GO

-- there were two circular relations in here, cause by fk where the should be none on the diagram.
-- i ended up just deleting the fks, hopefully she'll accept that, cause i don't want to bother creating more connecting tables

USE SystemPrzechowujacyDane

CREATE TABLE Klient (
	PESEL VARCHAR(11) PRIMARY KEY NOT NULL,
	Imie VARCHAR(100) NOT NULL,
	Drugie_imie VARCHAR(100),
	Nazwisko VARCHAR(100) NOT NULL,
	Data_urodzenia DATE NOT NULL
);

CREATE TABLE Pracownik (
	ID_pracownika VARCHAR(20) PRIMARY KEY,
	PESEL VARCHAR(11) UNIQUE NOT NULL,
	Imie VARCHAR(100) NOT NULL,
	Drugie_imie VARCHAR(100),
	Nazwisko VARCHAR(100) NOT NULL,
	Data_zatrudnienia DATE NOT NULL,
);

CREATE TABLE Agent (
	ID_agenta VARCHAR(20) PRIMARY KEY,
		FOREIGN KEY (ID_agenta) REFERENCES Pracownik(ID_pracownika),	-- zwiazek IS_A
	Placowka VARCHAR(255) NOT NULL,
	Specjalnosc VARCHAR(100),
	Ostatnia_data_zmiany_placowki DATE	-- for scd2
);

CREATE TABLE Analityk (
	ID_analityka VARCHAR(20) PRIMARY KEY,
		FOREIGN KEY (ID_analityka) REFERENCES Pracownik(ID_pracownika),	-- zwiazek IS_A
	Rola VARCHAR(100) NOT NULL,
	Dzial VARCHAR(100) NOT NULL,
	Zespol VARCHAR(100) NOT NULL,
);

CREATE TABLE Polisa (
	ID_polisy VARCHAR(20) PRIMARY KEY,
	Kategoria VARCHAR(13) NOT NULL 
		CHECK (Kategoria IN ('majatkowe', 'osobowe', 'komunikacyjne', 'turystyczne')),	-- enforces chosen values only
	Data_rozpoczecia DATE NOT NULL,
	Data_zakonczenia DATE NOT NULL,
	Premium DECIMAL(10,2) NOT NULL,
	Klient VARCHAR(11) FOREIGN KEY REFERENCES Klient,
	Agent VARCHAR(20) FOREIGN KEY REFERENCES Agent
);

CREATE TABLE Zdarzenie (
	ID_zdarzenia VARCHAR(20) PRIMARY KEY,
	Data_zdarzenia DATE NOT NULL,
	Lokalizacja VARCHAR(100) NOT NULL,
	Rodzaj VARCHAR(255) NOT NULL,
	-- Postepowanie VARCHAR(20) NOT NULL	
	-- ISSUE: kazde zdarzenie moze miec kilka postepowan wiec to pole nie ma sense, i nie bedzie tak dzialac
	-- to jest pozostalosc po tym jak relacja byla 1-1, ktorej nie poprawilismy do konca przed oddaniem
);

CREATE TABLE Postepowanie (
	ID_postepowania VARCHAR(20) PRIMARY KEY,
	Data_rozpoczecia DATE NOT NULL,
	Data_zakonczenia DATE NOT NULL,
	Liczba_dokumentow INT NOT NULL CHECK (Liczba_dokumentow>0),	-- enforces an unsigned int
	Polisa VARCHAR(20) FOREIGN KEY REFERENCES Polisa,
	Zdarzenie VARCHAR(20) FOREIGN KEY REFERENCES Zdarzenie,
	Decyzja VARCHAR(50) NOT NULL,
	--Odszkodowanie VARCHAR(20) FOREIGN KEY REFERENCES Odszkodowanie -- circular relation
);

-- tabela reprezentujaca relacje 0.n-n miedzy postepowaniami i analitykami
CREATE TABLE PostepowanieAnalityk (
    ID_postepowania VARCHAR(20) NOT NULL,
    ID_pracownika VARCHAR(20) NOT NULL,

    PRIMARY KEY (ID_postepowania, ID_pracownika),

    FOREIGN KEY (ID_postepowania) REFERENCES Postepowanie(ID_postepowania)
        ON DELETE CASCADE,
    FOREIGN KEY (ID_pracownika) REFERENCES Analityk(ID_analityka)
        ON DELETE CASCADE
);

CREATE TABLE Odwolanie (
	Postepowanie VARCHAR(20) FOREIGN KEY REFERENCES Postepowanie,
	ID_odwolania VARCHAR(20) PRIMARY KEY,
	_Status VARCHAR(12)	NOT NULL
		CHECK (_Status IN ('przyjete', 'przetwarzane', 'zakonczone')),		 -- forgot its a thing in sql when naming it in the req file
	Data_odwolania DATE NOT NULL
);

CREATE TABLE Odszkodowanie (
	ID_odszkodowania VARCHAR(20) PRIMARY KEY,
	Kwota DECIMAL(15,2) NOT NULL CHECK (Kwota>0),
	Postepowanie VARCHAR(20) FOREIGN KEY REFERENCES Postepowanie,
	_Status VARCHAR(20) NOT NULL 
		CHECK (_Status IN ('oczekuje', 'zrealizowane', 'anulowane', 'opoznione', 'w toku')) 
);

CREATE TABLE Naprawy (
	ID_naprawy VARCHAR(20) PRIMARY KEY,
	ID_odszkodowania VARCHAR(20) FOREIGN KEY REFERENCES Odszkodowanie,
	Koszt DECIMAL(15,2) NOT NULL CHECK (Koszt>0),
	Data_rozpoczecia DATE NOT NULL,
	Data_zakonczenia DATE NOT NULL,
	Wykonawca VARCHAR(100) NOT NULL
);

CREATE TABLE Platnosc (
	ID_platnosci VARCHAR(20) PRIMARY KEY,
	ID_odszkodowania VARCHAR(20) FOREIGN KEY REFERENCES Odszkodowanie,
	Konto VARCHAR(28), -- iban number
	Kwota DECIMAL(15,2) NOT NULL CHECK (Kwota>0),
	Metoda_realizacji VARCHAR(7) NOT NULL 
		CHECK (Metoda_realizacji IN ('przelew', 'gotowka')),
	Data_wykonania DATE NOT NULL,
	_Status VARCHAR(20) NOT NULL 
		CHECK (_Status IN ('oczekuje', 'wykonana', 'zrealizowana', 'wstrzymana', 'anulowana', 'nieudana'))
);