import java.util.Random;
import java.util.ArrayList;
import java.io.*;

class ListaLeniwa implements Serializable
    {
        protected ArrayList<Integer> lista;
        protected Random rand;
        
        public ListaLeniwa()
        {
          lista = new ArrayList<Integer>();
          rand = new Random();
        }
        
        public  int element(int i)
        {
            while (i > lista.size())
            {
              dodajElement();
            }
          
            int var = lista.get(i-1);
            
            return var;
        }
        
        public int size()
        {
            int count = lista.size();
            return count;
        }
        
        public void print()
        {
          for(int i=0; i<lista.size(); i++)
          {
            System.out.print(lista.get(i) + " ");
          }
          System.out.println();
        }
        
        protected  void dodajElement()
        {
              lista.add(rand.nextInt(1000000));
        }
     
    }
    
    class Pierwsze extends ListaLeniwa
    {
      protected  void dodajElement()
      {
        if (lista.size() == 0)
        {
          lista.add(2);
          return;
        }
        
        boolean pierwsza = false;
        int next = lista.get(lista.size()-1) + 1;
        
        while (!pierwsza)
        {
           for (int p=2; p<next; p++)
           {
              if (next%p != 0)
              {
                next++;
                break;
              }
              
              pierwsza = true;
           }
        }
         
         lista.add(next); 
      }

}

class Main 
{
  public static void main(String [] args) throws IOException, ClassNotFoundException
          {
            Pierwsze lp = new Pierwsze();
            lp.element(11) ;
            
            	try 
            	{
                  ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream("Obiekt.ser"));
					        out.writeObject(lp);

					        out.close();
                  System.out.println( "Pierwsze zapisane" );
                  lp.print();
                  
				      } 
				      catch (FileNotFoundException e1) 
				      {
					      e1.printStackTrace();
				        
				      }
				      try 
				      {
	                ObjectInputStream read = new ObjectInputStream(new FileInputStream("Obiekt.ser"));

			            Pierwsze obiekt1 = (Pierwsze) read.readObject();

						      read.close();
						      System.out.println( "Pierwsze odczytane" );
						      
						      obiekt1.print();

				      } 
				      catch (FileNotFoundException e) 
				      {					
					      e.printStackTrace();
				      }
          }
}


