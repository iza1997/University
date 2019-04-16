class Main
{
  public static void main(String [ ] args)
  {
     Lista<Figura> abc = new Lista<Figura>();
        
		abc.add(new Trapez(2,5,3));
		abc.add(new Kwadrat(2));
		abc.add(new Trojkat(4,3));
		abc.add(new Prostokat(5,3));
		
		abc.write();
		
		abc.get();

		abc.write();

	  }
}

        