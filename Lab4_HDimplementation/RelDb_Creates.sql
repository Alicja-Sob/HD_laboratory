/*USE master;
ALTER DATABASE SystemPrzechowujacyDane 
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE SystemPrzechowujacyDane;
GO*/

CREATE database HurtowniaDanychRel
GO
-- ----- ----- ----- TABELE WYMIAROW ----- ----- ----- --

-- tabela Odszkodowanie
CREATE TABLE Odszkodowanie (
	ID_odszkodowanie INT IDENTITY(1,1) PRIMARY KEY,
	NR_odszkodowania VARCHAR(20) NOT NULL, -- BK
	rodzaj_odszkodowania VARCHAR(8) CHECK (rodzaj_odszkodowania IN ('Naprawa','Platnosc')) NOT NULL
);

-- tabela Typ Dokumentu
CREATE TABLE Typ_Dokument (
	ID_typ INT IDENTITY(1,1) PRIMARY KEY,
	typ_dokumentu VARCHAR(13) CHECK (typ_dokumentu IN ('Umowa', 'Raport', 'Faktura', 'Notatka', 'Protoko³', 'Zaswiadczenie', 'Zawiadomienie', 'Inne')) NOT NULL
);

-- tabela Dokument
CREATE TABLE Dokument (
	ID_dokument INT IDENTITY(1,1) PRIMARY KEY,
	ID_typ INT FOREIGN KEY REFERENCES Typ_Dokument(ID_typ),
	Nazwa VARCHAR(50) NOT NULL,
	Autor VARCHAR(50) NOT NULL,
	Data_dostarczenia DATE NOT NULL,
	Opoznienie_dostarczenia VARCHAR(16) CHECK (Opoznienie_dostarczenia IN ('ponizej tygodnia', 'tydzien', '2 tygodnie', '3 tygodnie', 'miesiac', 'powyzej miesiaca')),
	rozszerzenie VARCHAR(5) CHECK (rozszerzenie IN ('.pdf', '.docx', '.xlsx', '.txt', '.pptx', '.csv'))
);

-- tabela Data
CREATE TABLE _Data (
	ID_data INT IDENTITY(1,1) PRIMARY KEY,
	Dzien INT CHECK (Dzien BETWEEN 1 AND 31) NOT NULL,
	Miesiac INT CHECK (Miesiac BETWEEN 1 AND 12) NOT NULL,
	Rok INT NOT NULL
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

-- tabela Analityk
CREATE TABLE Analityk (
	ID_analityk INT IDENTITY(1,1) PRIMARY KEY,
	ID_pracownika VARCHAR(20) NOT NULL, --BK
	Pelne_ImieNazwisko VARCHAR(255) NOT NULL, --idk if this is way too much or not enough 
	Data_zakonczenia DATE,
	Data_zatrudnienia DATE NOT NULL,
	Rola VARCHAR(100) NOT NULL,
	Dzial VARCHAR(100) NOT NULL
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
	ID_zdarzenie INT FOREIGN KEY REFERENCES Zdarzenie(ID_zdarzenie) NOT NULL, -- should all of these just reference SKs since they're numerical?? or should they not be numerical at all? 
	ID_decyzja INT FOREIGN KEY REFERENCES Decyzja(ID_decyzja) NOT NULL,
	PRIMARY KEY (ID_dataRozpoczecia_Postepowania,ID_dataZakonczenia_Postepowania,ID_dataRozpoczecia_Polisy,ID_dataZakonczeniaPolisy,ID_data_Zdarzenia, ID_zdarzenie, ID_decyzja),
	ID_polisa INT FOREIGN KEY REFERENCES Polisa(ID_polisa) NOT NULL,
	ID_postepowanie VARCHAR(20) NOT NULL, --DD (should this be PK in the database?? so that the later tables can reference this??)
	ilosc_dokumentow INT,
	ilosc_analitykow INT,
	czas_trwania INT,
	wartosc_odszkodowania DECIMAL(10,2)
);

-- tabela Analiza Dokumentow
CREATE TABLE Analiza_Dokumentow(
	ID_postepowanie VARCHAR(20) FOREIGN KEY REFERENCES Postepowanie(ID_postepowanie), --FIX ME: how to reference this???
	ID_typ INT FOREIGN KEY REFERENCES Typ_dokumentu(ID_typ),
	PRIMARY KEY(ID_postepowanie, ID_typ),
	ID_analizaDokumentow VARCHAR(33) NOT NULL, -- DD, a made up key, but still a varchar (idk, we can make it a mix of id_postepowanie + typ_dokumentu ig?)
	ilosc_dokumentow INT,
	ilosc_dokumentow_klienta INT,
	sredni_czas_dostarczenia INT
);

-- tabela Zakup Polisy
CREATE TABLE Zakup_Polisy (
	ID_agent INT FOREIGN KEY REFERENCES Agent(ID_agent),
	ID_klient INT FOREIGN KEY REFERENCES Klient(ID_klient),
	ID_polisa INT FOREIGN KEY REFERENCES Polisa(ID_polisa),
	PRIMARY KEY(ID_agent, ID_klient, ID_polisa)
);

GO
-- ----- ----- ----- TABELE POSREDNICZACE ----- ----- ----- --

-- tabela Rozliczenie Odszkodowanie
CREATE TABLE Rozliczenie_odszkodowania (
	ID_odszkodowanie INT FOREIGN KEY REFERENCES Odszkodowanie(ID_odszkodowanie),
	ID_postepowanie VARCHAR(20) FOREIGN KEY REFERENCES Postepowanie(ID_postepowanie),
	PRIMARY KEY(ID_odszkodowanie, ID_postepowanie)
);

-- tabela Kompilacja Analizy
CREATE TABLE Kompilacja_analizy (
	ID_analizaDokumentow VARCHAR(33) FOREIGN KEY REFERENCES Analiza_Dokumentow(ID_analizaDokumentow), -- should this be referenced?? or smth else
	ID_postepowanie VARCHAR(20) FOREIGN KEY REFERENCES Postepowanie(ID_postepowanie),
	PRIMARY KEY(ID_analizaDokumentow, ID_postepowanie)
);

-- tabela Zebranie Dokumentu
CREATE TABLE Zebranie_Dokumentu  (
	ID_postepowanie VARCHAR(20) FOREIGN KEY REFERENCES Postepowanie(ID_postepowanie),
	ID_dokument INT FOREIGN KEY REFERENCES Dokument(ID_dokument),-- Idk if this is correct or if this should be to a buisness key somehow? but it wuld have to be a composite foreign key
	PRIMARY KEY(ID_postepowanie, ID_dokument)
);

-- tabela Przypisanie Pracownika
CREATE TABLE Przypisanie_pracownika (
	ID_postepowanie VARCHAR(20) FOREIGN KEY REFERENCES Postepowanie(ID_postepowanie),
	ID_analityk INT FOREIGN KEY REFERENCES Analityk(ID_analityk), -- this is to the buissnes key, so it was also wrong in the project i think??
	PRIMARY KEY(ID_postepowanie, ID_analityk)
);

GO