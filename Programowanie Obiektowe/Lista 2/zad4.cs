using System;
using System.Collections.Generic;


namespace LeniwaLista
{
    public class ListaLeniwa
    {
      
        protected List<int> lista;
        protected Random rand;

        public ListaLeniwa()
        {
            lista = new List<int>();
            rand = new Random();
        }

        public virtual int element(int i)
        {
            
            while (i > lista.Count)
            {
                dodajElement();
            }

            int var = lista[i - 1];

            return var;
        }

        public int size()
        {
            int count = lista.Count;
            return count;
        }

  
        protected virtual void dodajElement()
        {
            lista.Add(rand.Next());
        }
    };

    public class Pierwsze : ListaLeniwa
    {
        protected override void dodajElement()
        {
            if (lista.Count == 0)
            {
                lista.Add(2);
                return;
            }

            bool pierwsza = false;
            int next = lista[lista.Count - 1] + 1;

            while (!pierwsza)
            {
                for (int p = 2; p < next; p++)
                {
                    if (next % p != 0)
                    {
                        next++;
                        break;
                    }

                    pierwsza = true;
                }
            }

            lista.Add(next);
        }
    }

    class Program
    {
        static void Main()
        {
            ListaLeniwa ll = new ListaLeniwa();

            Console.WriteLine("Rozmiar Listy: " + ll.size());     
            Console.WriteLine("Rozmiar Listy: " + ll.size());

            Console.WriteLine("40 element Listy: " + ll.element(40));
            Console.WriteLine("Rozmiar: " + ll.size());

            Console.WriteLine("38 element Listy: " + ll.element(38));
            Console.WriteLine("Rozmiar: " + ll.size());

            Pierwsze lp = new Pierwsze();
            Console.WriteLine("11 element Pierwszej: " + lp.element(11));
            Console.WriteLine("30 element Pierwszej: " + lp.element(30));
            Console.WriteLine("Rozmiar Pierwszej: " + lp.size());
            Console.WriteLine("11 elemnt Pierwszej: " + lp.element(11));
            Console.WriteLine("Rozmiar Pierwszej: " + lp.size());
            Console.ReadKey();
        }

    }

}