# Wytyczne na LAB4 (z wprowadzenia)

## Do realizacji

- [ ] Dodac po 2/3 rzedy danych do relacyjnej BD (zeby sprawdzic czy kostka sie przetwarza) (np. 3 dla faktu, po jednym dla wymiarow)
- [ ] Implementacja Hurtowni (jak baza na lab2) (creates)
- [ ] Projekt visual studio dla hurtowni na podstawie ksiegarni
- [ ] 2 widoki (data tools) (np. filtrowanie danych - przeklikanie sumy sprzedazy wg. klienta)

## Inne info

* Pamietaj o zaznaczeniu 'multidimensional server' podczas instalacji sql server
* data tools - definicja kostki (hierarchia, tabele faktu itd)
* Przyklad / instrukcja z eneauczania to "Books bookstoree implementation" (baza relacyjna i instrukcja tworzenia kostki)
* tabele przechodnie to wymiar przechodni i fakt w jednym
* na enauczanie wystarczy wyslac projekt z visual studio

## Co jest sprawdzane na zajeciach
* KPI, wymiary hierarchiczne
* Czy relacyjna baza danych ma odpowiednie klucze (sk=pk i bk), klucze zbiorowe w faktach
* W kostce:
  * Wymiary hierarchiczne, zdegenerowane (dd), agregacje
  * Czy sa wszystkie wymiary
  * Definicja KPI (z lab1 ?)
  * Kosta musi sie przetworzyc bezblednie na zajeciach
* 2 Widoki robione na zajeciach (nie zapisane)