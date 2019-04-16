class Kwadrat extends Figura

{
  
	public Kwadrat(int bok)
  
	{
     
		pole = bok * bok;
  
	}

}



class Trojkat extends Figura
{
  
	public Trojkat(int podstawa, int wysokosc)
  
	{
     
		pole = (podstawa * wysokosc)/2;
  
	}

}



class Trapez extends Figura

{
  
	public Trapez(int podstawa1, int podstawa2, int wysokosc)
  
	{
     
		pole = ((podstawa1 + podstawa2)/2) * wysokosc;
  
	}

}



class Prostokat extends Figura

{
  
	public Prostokat(int bok1, int bok2)
  
	{
     
		pole = bok1 * bok2;
  
	}

}