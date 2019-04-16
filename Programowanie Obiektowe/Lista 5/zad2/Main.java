import java.util.Hashtable;

public class Main
{
	public static void main(String[] args)
	{
		Hashtable<String, Integer> Tree = new Hashtable<String, Integer>();
		Tree.put("x",2);
		Tree.put("y",5);
    		Tree.put("z",6);
		
		Wyrazenie dzialanie = new Add(new Constant(2), new Variable("z", Tree));
		dzialanie = new Sub(dzialanie, new Constant(1));
		dzialanie = new Add(dzialanie, new Variable("x", Tree));
		dzialanie = new Div(dzialanie, new Variable("y", Tree));
		dzialanie = new Mult(new Constant(9), dzialanie);
		System.out.println(dzialanie.toString() + " = " + dzialanie.oblicz());
		
		Wyrazenie dzialanie1 = new Add(new Constant(2), new Variable("z", Tree));
		dzialanie1 = new Div(dzialanie, new Constant(1));
		dzialanie1 = new Sub(dzialanie, new Variable("x", Tree));
		dzialanie1 = new Mult(dzialanie, new Variable("y", Tree));
		dzialanie1 = new Add(new Constant(9), dzialanie);
	  System.out.println(dzialanie1.toString() + " = " + dzialanie1.oblicz());
	  
		Wyrazenie dzialanie2 = new Add(new Constant(2), new Variable("z", Tree));
		dzialanie2 = new Div(dzialanie, new Constant(0));
		System.out.println(dzialanie2.toString() + " = " + dzialanie2.oblicz());
	}
}