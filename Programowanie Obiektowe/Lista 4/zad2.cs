using System;
using System.Collections;

namespace PrimeCollection
{
    public class PrimeCollection : IEnumerable
    {
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new PrimeCollectionEnum();
        }
    }

    public class PrimeCollectionEnum : IEnumerator
    {
        int value;

        public PrimeCollectionEnum()
        {
            value = 1;
        }

        public object Current
        {
            get
            {
                return value;
            }
        }

        // to bedzie wolane przed Current zeby pobrac pierwsza wartosc, false jesli koniec "listy"
        public bool MoveNext()
        {
            // nie ma juz wieksze libczy do sprawdzenia
            if (value == int.MaxValue)
                return false;

            int next = value + 1;
            bool pierwsza = next == 2;

            // to tutaj to tylko do testow zeby nie wypisywac wszystkich liczb
            if (next > 50)
                return false;

            while (!pierwsza)
            {
                pierwsza = true;

                for (int p = 2; p <= Math.Sqrt(next); p++)
                {
                    // podzielna przez p wiec nie pierwsza
                    if (next % p == 0)
                    {
                        // jesli sprawdzamy maxymalna to juz nie mozemy zwiekszyc
                        if (next == int.MaxValue)
                            return false;

                        next++;
                        pierwsza = false;
                        break;
                    }

                }

            }

            value = next;

            return true;
        }

        public void Reset()
        {
            value = 1;
        }
    }

    class zad2
    {
        static void Main()
        {
            PrimeCollection pc = new PrimeCollection();

            foreach (int i in pc)
            {
                Console.WriteLine(i);
            }
            Console.ReadKey();
        }
    }
}