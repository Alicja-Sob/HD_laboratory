# Notes from lab intro (20-11-2025)

## Etapy zadania

* __ETAP 1 - ladowanie wymiarow statycznych__
  * wymiary statyczne to dane niezmienne, ladowane raz albo raz na dluzszy  czas/z wyprzedzeniem
  * Przykladowe wymiary to czas, data, junk (u nas to chyba typ_dokumentu)
  * Czescia tego etapu jest tez przeglad dostepnych na enauczaniu materialow zwiazanych z ETL (kurs microsoft, instrukcje itd) 
* __ETAP 2 - ladowanie pozostalych wymiarow__
  * Wymiary ktorych moze przybywac (np. klienci), wymiary w ktorych moze nastepowac zmiana danych
  * Sprawdzany tu jest mechanizm SCD
* __ETAP 3 - ladowanie faktow__
  * Sprawdzane jest czy fakty sie nie duplikuja czy wgrywaniu kolejnego snapshotu i/lub ponownym zaladowaniu tych samych danych (moze to oznaczac bledy w kluczach)
  * Poprawne przypisanie dla nowych i starych tabel SCD 

## Narzedzia

* Przeplywy __SSIS__ (do tej metody zrobiona jest instrukcja na przykladzie ksiegarni)
* Skrypty __TSQL__ (szczegolnie polecenie MERGE)
* Hybryda SSIS i TSQL (wgranie skrytu TSQL do blokow SSIS)

* Ostateczne skrypty i tak trzeba laczyc w SSIS (przebieg ma sie konczyc poprawnym przetwarzaniem kostki 

## Co jest sprawdzane?

* __27-11-2025__ - sprawdzanie implementacji (lab4) i pierwszego etapu ETL (lab5)
  * mozliwe przepytanie (na dodatkowe punkty) z materialow o ETL 
* Wybrana metoda implementacji nie jest oceniana. Liczy się tylko efekt
* Sprawdzanie działania jest na podstawie 'Test cases' z enauczania

## Inne

* Terminy oddawania etapu 2 i 3 są w miarę elastyczne (bo Nabozny przewiduje ze moga byc problemy przy ich implementacji)

