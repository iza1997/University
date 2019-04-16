public class Figura implements Comparable<Figura>
{
  protected int pole;
  
  public String toString() { return Integer.toString(pole); }
  
  public int compareTo(Figura o)
  {
    if (pole > o.pole)
      return 1;
    
    if (pole < o.pole)
      return -1;
      
    return 0;
  }
}