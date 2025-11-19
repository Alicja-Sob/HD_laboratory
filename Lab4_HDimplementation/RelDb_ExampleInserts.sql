USE HurtowniaDanychRel
GO
-- ----- ----- ----- TABELE WYMIAROW ----- ----- ----- --

-- tabela Odszkodowanie
INSERT INTO Odszkodowanie (NR_odszkodowania, rodzaj_odszkodowania) VALUES
    ('31c83cbb982248a39679', 'Naprawa'),
    ('5d8dc930972749e59c24', 'Platnosc'),
    ('95dc25dad50c404e9c57', 'Naprawa'),
    ('25b70c6cf37143b6ad40', 'Platnosc'),
    ('4ee27d80ddd64fa894b5', 'Naprawa');

-- tabela Typ Dokumentu
INSERT INTO Typ_dokument (typ_dokumentu) VALUES
    ('Umowa'),
    ('Faktura'),
    ('Raport'),
    ('Protoko³'),
    ('Inne');

-- tabela Dokument
INSERT INTO Dokument (ID_typ, Nazwa, Autor, Data_dostarczenia, Opoznienie_dostarczenia, rozszerzenie) VALUES
    (1,'umowa1308pl', 'Norris', '2014-02-03', 'tydzien', '.docx'),
    (2,'Faktura1234567', 'Odonnell', '2015-05-15', '3 tygodnie', '.pdf'),
    (2,'RachunekWash', 'Washington', '2019-02-23', '2 tygodnie', '.docx'),
    (4,'ProtPracy', 'Burns', '2009-01-31', 'miesiac', '.pdf'),
    (5,'ListaUszkodzen', 'Hopkins', '2016-07-17', '2 tygodnie', '.csv');

-- tabela Data
INSERT INTO _Data (Dzien, Miesiac, Rok) VALUES
    (31,12,2015),
    (15,1,2019),
    (2,8,2005),
    (17,6,2014),
    (6,2,2009);

-- tabela Zdarzenie
INSERT INTO Zdarzenie (NR_zdarzenia, Lokalizacja, Rodzaj) VALUES
    ('4b7791fc66e64fd19b4b','431 Barker Village','uszkodzenie mienia'),
    ('4f20ba8b10fb40f5b0b6','12556 Donaldson Glens','upadek'),
    ('86ec95014d1d46faade0','7023 Martinez Hill Apt. 581','zalanie'),
    ('a2dab10885124856b643','7286 Carla Plaza Apt. 776','wlamanie'),
    ('7d74b79e9fa44ede95f9','730 Reed Lodge Suite 648','wandalizm');

-- tabela Polisa
INSERT INTO Polisa (NR_polisy, Kategoria) VALUES
    ('c7c5fd0d92044d8faeed','turystyczne'),
    ('e7bfcb2572ce4421b34b','turystyczne'),
    ('d6465bad5abb4dd2b0a3','komunikacyjne'),
    ('00090b8d90ca4868a145','osobowe'),
    ('9767873a245f44809e12','majatkowe');

-- tabela Decyzja
INSERT INTO Decyzja (czy_przyznane) VALUES
    (1),
    (1),
    (0),
    (0),
    (1);

-- tabela Analityk
INSERT INTO Analityk (ID_pracownika, Pelne_ImieNazwisko, Data_zakonczenia, Data_zatrudnienia, Rola, Dzial) VALUES
    ('720baa29fa0345088d57','Michael Robes',NULL,'2013-08-11','mlodszy analityk danych','analiza i bi'),
    ('8257270a125e47a68370','Sara Cunningham','2010-03-31','2005-01-15','starszy analityk danych','IT'),
    ('e99cc35ec08e458e9a55','Carlos Nicole Young','2015-02-20','2005-11-19','analityk biznesowy','ryzyko'),
    ('4c3a08e2f5d749c3ba54','Kenneth Allen',NULL,'2010-05-28','analityk procesow','operacje'),
    ('a0cdbbbd535340d3a88c','Chase Charles',NULL,'2005-10-04','analityk biznesowy','finanse');

-- tabela Agent
INSERT INTO Agent (ID_pracownika, Pelne_ImieNazwisko, Data_zakonczenia, Data_zatrudnienia, Placowka) VALUES
    ('17c79e4fd464494da33b','Micheal Mayers','2015-01-03','2005-11-11','Sanchezview'),
    ('272843ee87ae435493fe','Carlos Sanchez',NULL,'2010-10-30','South Chase'),
    ('81cb6c49b7f9460191ab','Monica Lewsinsky',NULL,'2007-03-08','Kimberlyport'),
    ('b6dc4c0372a442f7b7ea','Billiam William Clinton','2007-08-15','2006-08-15','Port Carlos'),
    ('1e65b5bbdbd64d07899e','Hillary Green',NULL,'2001-09-11','Maureenborough');

-- tabela Klient
INSERT INTO Klient (PESEL, Pelne_ImieNazwisko) VALUES
    ('19052724998','Theresha Price'),
    ('54071993620','Darryl Ortega'),
    ('20251331726','Steven Stevenson'),
    ('21320565318','Mckeanziegh Smith'),
    ('09222796148','Jeffrey Joffrey Robbinson');

GO

-- ----- ----- ----- TABELE FAKTOW ----- ----- ----- --

-- tabela Analiza Dokumentow
INSERT INTO Postepowanie (ID_dataRozpoczecia_Postepowania, ID_dataZakonczenia_Postepowania, ID_dataRozpoczecia_Polisy, ID_dataZakonczeniaPolisy, ID_data_Zdarzenia, ID_zdarzenie, ID_decyzja, ID_polisa, ID_postepowanie, ilosc_dokumentow, ilosc_analitykow, czas_trwania, wartosc_odszkodowania) VALUES
    (4,1,5,1,4,1,2,1,'06e0c8473e9d4809bc37',2,2,1010,5432.21),
    (4,1,3,2,5,2,1,2,'5370cf8e4f044111837b',3,5,900,112233.44),
    (4,2,5,1,4,3,3,3,'33369530fbb94f77be2f',5,3,300,234.22),
    (4,2,3,2,5,4,5,4,'fa38a57a9ba24838a88f',5,3,200,12324.23),
    (3,5,3,1,3,5,4,4,'e870c40d3c1d415d8297',3,4,500,112322.44),
    (3,5,3,4,3,3,3,5,'03fdb30fbb2e4d968c76',4,4,666,1112.23),
    (5,4,3,2,3,2,2,2,'aa34a70dd9f54004a5a6',1,5,123,123.45),
    (5,1,3,1,3,5,1,3,'352fb2e456b447e19336',4,5,321,100.40);

GO

-- tabela Postepowanie
INSERT INTO Analiza_Dokumentow (ID_postepowanie, ID_typ, ilosc_dokumentow, ilosc_dokumentow_klienta,sredni_czas_dostarczenia) VALUES
    (1,1,1,0,13),
    (2,2,2,1,12),
    (3,1,4,4,24),
    (4,3,3,2,1),
    (5,4,1,1,2),
    (6,2,3,1,34),
    (7,4,2,1,54),
    (8,5,3,2,14);

GO

-- tabela Zakup Polisy
INSERT INTO Zakup_Polisy (ID_agent, ID_klient, ID_polisa) VALUES
    (1,1,1),
    (1,2,1),
    (2,3,2),
    (2,4,3),
    (3,5,4),
    (4,1,2),
    (4,2,5),
    (5,1,4);

GO
-- ----- ----- ----- TABELE POSREDNICZACE ----- ----- ----- --

-- tabela Rozliczenie Odszkodowanie
INSERT INTO Rozliczenie_odszkodowania (ID_odszkodowanie, ID_postepowanie) VALUES
    (1,1),
    (2,2),
    (3,3),
    (4,4),
    (5,5),
    (1,5),
    (2,4);

-- tabela Kompilacja Analizy
INSERT INTO Kompilacja_analizy (ID_analizaDokumentow, ID_postepowanie) VALUES
    (1,1),
    (2,2),
    (3,3),
    (4,4),
    (5,5),
    (1,5),
    (2,4);

-- tabela Zebranie Dokumentu
INSERT INTO Zebranie_Dokumentu (ID_postepowanie, ID_dokument) VALUES
    (1,1),
    (2,2),
    (3,3),
    (4,4),
    (5,5),
    (1,5),
    (2,4);

-- tabela Przypisanie Pracownika
INSERT INTO Przypisanie_pracownika (ID_postepowanie, ID_analityk) VALUES
    (1,1),
    (2,2),
    (3,3),
    (4,4),
    (5,5),
    (1,5),
    (2,4);

