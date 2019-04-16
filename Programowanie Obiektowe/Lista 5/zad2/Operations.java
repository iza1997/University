import java.util.*;

interface Wyrazenie
{
	public int oblicz();
}

class Constant implements Wyrazenie
{
	int val;
	
	public Constant(int value) { val = value; }
	public int oblicz() { return val; }
	public String toString() { return Integer.toString(val); }
}

class Variable implements Wyrazenie
{
	String var; 
	Hashtable<String, Integer> w;
	
	public  Variable(String var, Hashtable<String, Integer> w)
	{
		this.var = var;
		this.w = w;
	}
	public int oblicz() { return w.get(var); }
	public String toString() { return var; }
}


class Add implements Wyrazenie 
{
	Wyrazenie a;
	Wyrazenie b;
	
	public Add (Wyrazenie a,Wyrazenie b)	{ this.a = a; this.b = b; }
	public int oblicz() { return a.oblicz() + b.oblicz(); }
	public String toString() { return "(" + a + "+" + b + ")"; }	
}

class Sub implements Wyrazenie 
{
	Wyrazenie a;
	Wyrazenie b;
	
	public Sub (Wyrazenie a, Wyrazenie b) { this.a = a; this.b = b; }
	public int oblicz() { return a.oblicz() - b.oblicz(); }
	public String toString() { return "(" + a + "-" + b + ")"; }	
}

class Div implements Wyrazenie 
{
	Wyrazenie a;
	Wyrazenie b;
	
	public Div (Wyrazenie a, Wyrazenie b) { this.a = a; this.b = b; }
	public int oblicz() {if (b.oblicz() == 0) {return 0;} return a.oblicz() / b.oblicz(); }
	public String toString() { if (b.oblicz() == 0) {return "Nie dzielimy przez zero";} else {return "(" + a + "/" + b + ")"; }}
	  
}

class Mult implements Wyrazenie 
{
	Wyrazenie a;
	Wyrazenie b;
	
	public Mult (Wyrazenie a, Wyrazenie b) { this.a = a; this.b = b; }
	public int oblicz() { return a.oblicz() * b.oblicz(); }
	public String toString() { return "(" + a + "*" + b + ")"; }	
}