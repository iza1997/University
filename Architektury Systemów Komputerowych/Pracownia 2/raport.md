# Raport do zadań z pracowni #2

 - Autor: Izabela Strumecka
 - Numer indeksu: 292969

Konfiguracja
---

Informacje o systemie:
 - Dystrybucja: macOS 10.12.6 (16G1212)
 - Jądro systemu: Darwin 16.7.0
 - Kompilator: clang
 - Procesor: Intel Core i5 1,8 GHz
 - Liczba rdzeni: 2

Pamięć podręczna:
 * L1d: 32 KiB, 8-drożny, rozmiar linii 64B
 * L2: 256 KiB, 4-drożny, rozmiar linii 64B
 * L3: 3MiB, 12-drożny, rozmiar linii 64B

Pamięć TLB:
 * L1d: 64 wpisy
 * L2: 512 wpisów

 Informacje uzyskane na podstawie raportu systemowego.

Zadanie 1
——————————

1. Czy uzyskane wyniki różnią się od tych uzyskanych na slajdzie? (zad1.png)

Wykres jest bardzo zbliżony do tego ze slajdu. 

2. Z czego wynika rozbieżność między wynikami dla poszczególnych wersji mnożenia macierzy?

Rozmiar i wyrównanie do rozmiaru cache jest ważne, dlatego wersja Block*Block jest jedną z najwydajniejszych. Wpływ ma na to też to, czy idziemy najpierw po kolumnach, czy po wierszach, ponieważ w przypadku kolumn wykonywane są duże skoki.

3. Jaki wpływ ma rozmiar kafelka na wydajność «multiply3»? (zad1ad3.png)

Rozmiar kafelka ma znaczny wpływ na wydajność, gdyż jesteśmy w stanie przyspieszyć program o ponad 3x. Najefektywniej program działa dla bloku o rozmiarze 8 i 16. Potem wydajność się zmniejsza z małymi zawahaniami. Najszybciej działa jak operuje się na blokach równych rozmiarowi lini cache.



Zadanie 2
——————————
Chodzi o wyrównanie adresu pamięci.
Przy pewnych instrukcjach procesora, wskazana pamięć musi być wyrównana do pewnej wielkości, także adres i rozmiar musi być modulo ustalona wartość. 

1. Dla jakich wartości n obserwujesz znaczny spadek wydajności?

Spadek wydajności rośnie wraz z wartością n.


2. Czy rozmiar kafelka ma znaczenie?

Tak, ma znaczenie. Do kafelka o rozmiarze 8 wydajność rośnie, potem już tylko spada.__


3. Czy inny wybór wartości domyślnych «OFFSET» daje poprawę wydajności? (zad2.png)

Tak, daje poprawę. Najmniej wydajne jest ustawienie wszystkich offsetów na tą samą wartość.

Zadanie 3
——————————

1. Jaki wpływ na wydajność «transpose2» ma rozmiar kafelka? (zad3.png)


Widoczne jest, że rozmiar kafelka ma wpływ na wydajność <<transpose2>>. Od bloku o rozmiaru 1 wydajność zdecydowanie wzrasta do bloku o rozmiarze 8 (dla którego program jest najwydajniejszy). Zwiększając następnie rozmiar kafelka wydajność jest coraz mniej korzystna z niewielkimi wahaniami. Żeby jak najlepiej wykorzystać cache, najlepiej pracować na kawałkach, które mieszczą się w cache. Najszybciej działa jak operuje się na blokach równych rozmiarowi lini cache.


2. Czy czas wykonania programu z różnymi rozmiarami macierzy identyfikuje rozmiary poszczególnych poziomów pamięci podręcznej? 

Raczej nie.

Zadanie 4
——————————

1. Ile instrukcji maszynowych ma ciało pętli przed i po optymalizacji?

Przed optymalizacją jest ok.45 instrukcji maszynowych. Po optymalizacji są 4 instrukcje sete.

2. Ile spośród nich to instrukcje warunkowe?

Przed optymalizacją - ok. 7. Po optymalizacji nie występuje żaden skok warunkowy.

3. Czy rozmiar tablicy ma duży wpływ na działanie programu?

Istotnie, gdyż pętla przechodzi po każdym elemencie tablicy. 

Zadanie 5
——————————
 
1. Czemu zmiana organizacji danych spowodowała przyspieszenie algorytmu wyszukiwania? 

W oryginalnej implementacji wyszukując wartość x najpierw występują duże skoki, a potem coraz mniejsze. W kopcowej implementacji jest na odwrót. W cache ma się to tak, że na początku będziemy robili dużo wymian (implementacja kopcowa),kolejność wkładania bloków pamięci do cache jest lepsza, więc w dalszych etapach mamy większą szansę trafienia tego, co już w pamięci cache jest. 

2. Czy odpowiednie ułożenie instrukcji w ciele «heap_search» poprawia wydajność wyszukań?

Tak. Zamiana  warunków sprawia, że wydajność programu różni się o ok. 1 s.
			