
using dll;
using System;


namespace Slownik
{
    class zad2
    {
        static void Main()
        {


            Slownik<double, string> Slownik1 = new Slownik<double, string>();
            
            Slownik1.add(1, "Iza");
            Slownik1.add(2, "Kasjan");
            Slownik1.add(3, "Grześ");
            Slownik1.add(4, "Jagoda");
            Slownik1.add(3, "Mama");

            Slownik1.write();
            Console.WriteLine("\n");

       
            Slownik1.search(2);
            Console.WriteLine("\n");

            Slownik1.delete(3);
            Slownik1.write();
            Console.WriteLine("\n");

            Slownik1.search(1);

            Console.ReadKey();

        }
    }
}


