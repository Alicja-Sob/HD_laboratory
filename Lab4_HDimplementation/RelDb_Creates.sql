/*USE master;
ALTER DATABASE HurtowniaDanychRel 
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE HurtowniaDanychRel;
GO

CREATE database HurtowniaDanychRel
GO*/

USE HurtowniaDanychRel;  
GO

-- ----- ----- ----- TABELE WYMIAROW ----- ----- ----- --

-- tabela Odszkodowanie
CREATE TABLE Odszkodowanie (
	ID_odszkodowanie INT IDENTITY(1,1) PRIMARY KEY,
	rodzaj_odszkodowania VARCHAR(25) CHECK (rodzaj_odszkodowania IN ('Naprawa','Platnosc','Naprawa i Platnosc','Inne','Nie przyznane')) NOT NULL
);

-- tabela Dokument
CREATE TABLE Dokumentacja (
	ID_dokumentacja INT IDENTITY(1,1) PRIMARY KEY,
	Autor VARCHAR(50) NOT NULL,
	ilosc_dokumentow VARCHAR(10) CHECK (ilosc_dokumentow IN ('1-5', '5-10', '15-20', '25-30', 'powy¿ej 30'))  NOT NULL,
	srednie_opoznienie VARCHAR(25) CHECK (srednie_opoznienie IN ('ponizej tygodnia', 'tydzien - 2 tygodnie','2 tygodnie - 3 tygodnie', '3 tygodnie - miesiac', 'powyzej miesiaca'))  NOT NULL,
	glowny_typ_dokumentow VARCHAR(13) CHECK (glowny_typ_dokumentow IN ('Umowa', 'Raport', 'Faktura', 'Notatka', 'Protoko³', 'Zaswiadczenie', 'Zawiadomienie', 'Inne')) NOT NULL
);

-- tabela Data
CREATE TABLE _Data (
	ID_data INT IDENTITY(1,1) PRIMARY KEY,
	_Data_full DATE NOT NULL,
	Dzien VARCHAR(2) NOT NULL,
	Miesiac VARCHAR(9) NOT NULL,
	Miesiac_numer INT CHECK (Miesiac_numer BETWEEN 1 AND 12) NOT NULL,
	Rok VARCHAR(4) NOT NULL
);


-- tabela Zdarzenie
CREATE TABLE Zdarzenie (
	ID_zdarzenie INT IDENTITY(1,1) PRIMARY KEY,
	NR_zdarzenia VARCHAR(20) NOT NULL, --BK
	Lokalizacja VARCHAR(100) NOT NULL,
	Rodzaj VARCHAR(255) NOT NULL
);

-- tabela Polisa
CREATE TABLE Polisa (
	ID_polisa INT IDENTITY(1,1) PRIMARY KEY,
	NR_polisy VARCHAR(20) NOT NULL, --BK
	Kategoria VARCHAR(13) CHECK (Kategoria IN ('majatkowe', 'osobowe', 'komunikacyjne', 'turystyczne')) NOT NULL
);

-- tabela Decyzja
CREATE TABLE Decyzja (
	ID_decyzja INT IDENTITY(1,1) PRIMARY KEY,
	czy_przyznane BIT NOT NULL -- boolean doesnt work in this?? so the closest is bit ig
);

-- tabela Agent
CREATE TABLE Agent (
	ID_agent INT IDENTITY(1,1) PRIMARY KEY,
	ID_pracownika VARCHAR(20) NOT NULL, --BK
	Pelne_ImieNazwisko VARCHAR(255) NOT NULL,
	Data_zakonczenia DATE,
	Data_zatrudnienia DATE NOT NULL,
	Placowka VARCHAR(255) NOT NULL
);

-- tabela Klient
CREATE TABLE Klient (
	ID_klient INT IDENTITY(1,1) PRIMARY KEY,
	PESEL VARCHAR(11) NOT NULL, --BK
	Pelne_ImieNazwisko VARCHAR(255) NOT NULL
);

GO

-- ----- ----- ----- TABELE FAKTOW ----- ----- ----- --

-- tabela Postepowanie
CREATE TABLE Postepowanie (
	ID_dataRozpoczecia_Postepowania INT FOREIGN KEY REFERENCES _Data(ID_data) NOT NULL,
	ID_dataZakonczenia_Postepowania INT FOREIGN KEY REFERENCES _Data(ID_data) NOT NULL,
	ID_dataRozpoczecia_Polisy INT FOREIGN KEY REFERENCES _Data(ID_data) NOT NULL,
	ID_dataZakonczeniaPolisy INT FOREIGN KEY REFERENCES _Data(ID_data) NOT NULL,
	ID_data_Zdarzenia INT FOREIGN KEY REFERENCES _Data(ID_data) NOT NULL,
	ID_zdarzenie INT FOREIGN KEY REFERENCES Zdarzenie(ID_zdarzenie) NOT NULL,
	ID_decyzja INT FOREIGN KEY REFERENCES Decyzja(ID_decyzja) NOT NULL,
	ID_polisa INT FOREIGN KEY REFERENCES Polisa(ID_polisa) NOT NULL,
	ID_odszkodowanie INT FOREIGN KEY REFERENCES Odszkodowanie(ID_odszkodowanie) NOT NULL,	-- completely forgot to put this one in the HD project
	ID_postepowanie VARCHAR(20) PRIMARY KEY, --DD (can a DD even be a PK?)
	ilosc_dokumentow INT,
	ilosc_analitykow INT,
	czas_trwania INT,
	wartosc_odszkodowania DECIMAL(10,2),

	UNIQUE(ID_dataRozpoczecia_Postepowania, ID_dataZakonczenia_Postepowania, ID_dataRozpoczecia_Polisy, ID_dataZakonczeniaPolisy,
		ID_data_Zdarzenia, ID_zdarzenie, ID_decyzja, ID_polisa, ID_odszkodowanie, ID_postepowanie)
);

GO

-- ----- ----- ----- TABELE POSREDNICZACE ----- ----- ----- --

-- tabela Zakup Polisy
CREATE TABLE Zakup_Polisy (
	ID_agent INT FOREIGN KEY REFERENCES Agent(ID_agent),
	ID_klient INT FOREIGN KEY REFERENCES Klient(ID_klient),
	ID_polisa INT FOREIGN KEY REFERENCES Polisa(ID_polisa),
	PRIMARY KEY(ID_agent, ID_klient, ID_polisa)
);

-- tabela Zebranie Dokumentu
CREATE TABLE Kompilacja_Dokumentacji  (
	ID_postepowanie VARCHAR(20) FOREIGN KEY REFERENCES Postepowanie(ID_postepowanie),
	ID_dokumentacja INT FOREIGN KEY REFERENCES Dokumentacja(ID_dokumentacja),
	PRIMARY KEY(ID_postepowanie, ID_dokumentacja)
);

GO