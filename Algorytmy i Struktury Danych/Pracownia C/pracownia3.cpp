#include <stdio.h>
#include <iostream>
#include <iomanip>
#include <vector>
#include <list>
#include <algorithm>
using namespace std;

#define MAX_UNITS 1000000
//#define MAX_UNITS 10
#define MAX_PRICE 1000000000

struct stacja
{
	int dist;
	int cena;

    long long koszt;
};

stacja g_stacje[MAX_UNITS];

long long najtansza(int n, int b, int l)
{
    list<int> kolejka;
    bool szukaj_min = true;
    long long koszt = MAX_PRICE + 1;

    for (int i = n - 1; i >= 0; i--)
    {
        // usuwamy stacje nieosiagalne
        while (kolejka.size() > 0 && g_stacje[kolejka.front()].dist - g_stacje[i].dist > b)
        {
            int s = kolejka.front();
            if (g_stacje[s].koszt + g_stacje[s].cena == koszt)
            {
                // usuwamy nasze minimum, trzeba poszukac nowe
                szukaj_min = true;
            }

            kolejka.pop_front();
        }

        if (szukaj_min)
        {
            koszt = MAX_PRICE + 1;

            for (int& s : kolejka)
            {
                // szukamy min koszt
                koszt = min(koszt, (g_stacje[s].koszt + g_stacje[s].cena));
            }
            
            szukaj_min = false;
        }

        // jesli koniec osiagalny z tej stacji
        if (l - g_stacje[i].dist <= b)
        {
            g_stacje[i].koszt = 0;
        }
        else
        {
            g_stacje[i].koszt = koszt;
        }

        koszt = min(koszt, (g_stacje[i].koszt + g_stacje[i].cena));

        kolejka.push_back(i);
    }

    // szukamy pierwsza stacji
    long long min_koszt = g_stacje[0].koszt + g_stacje[0].cena;

    for (int i = 0; i < n && g_stacje[i].dist <= b; i++)
    {
        if ((g_stacje[i].koszt + g_stacje[i].cena) < min_koszt)
            min_koszt = g_stacje[i].koszt + g_stacje[i].cena;
    }

    return min_koszt;
}


int main()
{
	int n, l, b;

	cin >> n >> l >> b;

	for (int i = 0; i < n; i++)
	{
		cin >> g_stacje[i].dist >> g_stacje[i].cena;

        if (i > 0 && (g_stacje[i].dist - g_stacje[i - 1].dist) > b)
        {
            cout << "NIE";
            return 0;
        }
	}

    if (l - g_stacje[n - 1].dist > b)
    {
        cout << "NIE";
        return 0;
    }

    long long wynik = 0;
    
    if (b < l)
        wynik = najtansza(n, b, l);

    cout << wynik;

	return 0;
}