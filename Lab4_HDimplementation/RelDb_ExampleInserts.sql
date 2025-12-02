USE HurtowniaDanychRel
GO
-- ----- ----- ----- TABELE WYMIAROW ----- ----- ----- --

-- tabela Dokumentacja
/*INSERT INTO Dokumentacja (Autor, ilosc_dokumentow, srednie_opoznienie, glowny_typ_dokumentow) VALUES
    ('Norris', '15-20', 'ponizej tygodnia', 'Zaswiadczenie'),
    ('Odonnell', '5-10', 'ponizej tygodnia', 'Faktura'),
    ('Washington', 'powy¿ej 30', '2 tygodnie - 3 tygodnie', 'Faktura'),
    ('Burns', '1-5', '3 tygodnie - miesiac', 'Faktura'),
    ('Hopkins', '1-5', 'powyzej miesiaca', 'Protoko³');

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
*/

-- ----- ----- ----- TABELE FAKTOW ----- ----- ----- --
DELETE FROM Kompilacja_Dokumentacji;

DELETE FROM Zakup_Polisy;

DELETE FROM Postepowanie;

-- tabela Analiza Dokumentow
INSERT INTO Postepowanie (ID_dataRozpoczecia_Postepowania, ID_dataZakonczenia_Postepowania, ID_dataRozpoczecia_Polisy, ID_dataZakonczeniaPolisy, ID_data_Zdarzenia, ID_zdarzenie, ID_decyzja, ID_polisa, ID_odszkodowanie, ID_postepowanie, ilosc_dokumentow, ilosc_analitykow, czas_trwania, wartosc_odszkodowania) VALUES
    (4,1,5,1,4,1,2,1,1,'b7e129ad6af64200981c',2,2,1010,5432.21),
    (4,1,3,2,5,2,1,2,1,'5b371c3c564f49f09e98',3,5,900,112233.44),
    (4,2,5,1,4,3,1,3,2,'efe2f4ee04ca4eac9d24',5,3,300,234.22),
    (4,2,3,2,5,4,2,4,3,'a0e270b68f704f9c80e5',5,3,200,12324.23),
    (3,5,3,1,3,5,1,4,4,'1a186ed4d8334c659f14',3,4,500,112322.44),
    (3,5,3,4,3,3,2,5,2,'5f766b2617184039a443',4,4,666,1112.23),
    (5,4,3,2,3,2,2,2,4,'976dda9a327f49598705',1,5,123,123.45),
    (5,1,3,1,3,5,1,3,3,'163c8555f8764962b12b',4,5,321,100.40);

-- ----- ----- ----- TABELE POSREDNICZACE ----- ----- ----- --

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


-- tabela Zebranie Dokumentu
INSERT INTO Kompilacja_Dokumentacji (ID_postepowanie, ID_dokumentacja) VALUES
    ('5b371c3c564f49f09e98',1),
    ('163c8555f8764962b12b',2),
    ('efe2f4ee04ca4eac9d24',3),
    ('5b371c3c564f49f09e98',4),
    ('5f766b2617184039a443',5),
    ('163c8555f8764962b12b',5),
    ('163c8555f8764962b12b',4);

    /*
SELECT COUNT(*) FROM Dokumentacja;
SELECT TOP 10 * FROM Dokumentacja;
SELECT COUNT(*) FROM Polisa;
SELECT COUNT(*) FROM Klient;
SELECT COUNT(*) FROM Agent;
SELECT COUNT(*) FROM Zdarzenie;


SELECT 
    k.ID_klient,
    k.Pelne_ImieNazwisko,
    COUNT(zp.ID_polisa) AS Liczba_Polis
FROM Klient k
LEFT JOIN Zakup_Polisy zp
        ON k.ID_klient = zp.ID_klient
GROUP BY 
    k.ID_klient,
    k.Pelne_ImieNazwisko
ORDER BY 
    Liczba_Polis DESC;



SELECT 
    ilosc_dokumentow,
    COUNT(*) AS liczba
FROM Dokumentacja
GROUP BY ilosc_dokumentow
ORDER BY 
    CASE ilosc_dokumentow
        WHEN '1-5' THEN 1
        WHEN '5-10' THEN 2
        WHEN '15-20' THEN 3
        WHEN '25-30' THEN 4
        WHEN 'powy¿ej 30' THEN 5
    END;


*/
