
class Zbir extends Thread{
	/**Poziom energii zbir.*/
	  int energia;
	  /**Ilosc zlota jaka posiada zbir.*/
	  int zloto;
	  /**Poziom sily zbira.*/
	  int sila;
	  protected Labirynt l;
	  /**Pozycja zbira*/
	  int x,y;
	  String nazwa;


	}

class Zlodziej extends Zbir {
	Zlodziej(Labirynt lab,int x, int y)
	  {
	    energia=50;
	    zloto=(int)(Math.random()*50);
	    l=lab;
	    this.x=x;
	    this.y=y;
	    nazwa = "Zlodziej";
	  }
	public void run(){
	      Komnata k;
	      do{
	        k=l.komnata[y][x];
	        /*jesli jest bohater w tej samej komnacie to trzeba go okrasc*/
	        if (k.jest_bohater)
	            if (l.bohater.zloto>0){
	              if (l.bohater.zloto>30) {
	                l.bohater.zloto-=30;
	                zloto+=30;
	              }
	              else {
	                zloto+=l.bohater.zloto;
	                l.bohater.zloto=0;
	              }
	              l.bohater.kradzierz();
	            }

	        /*zmianda lokacji*/
	        int d=((int)(Math.random()*19))/4;
	        if (d==0) {
	          if (x+1<50 && !l.komnata[y][x+1].sciana) {
	            k.zbir=null;
	            x++;
	            l.komnata[y][x].zbir=this;
	          }
	        }
	        else if (d==1){
	          if (x-1>=0 && !l.komnata[y][x-1].sciana) {
	            k.zbir=null;
	            x--;
	            l.komnata[y][x].zbir=this;
	          }
	        }
	        else if (d==2){
	          if (y+1<50 && !l.komnata[y+1][x].sciana) {
	            k.zbir=null;
	            y++;
	            l.komnata[y][x].zbir=this;
	          }
	        }
	        else {
	          if (y-1>=0 && !l.komnata[y-1][x].sciana) {
	            k.zbir=null;
	            y--;
	            l.komnata[y][x].zbir=this;
	          }
	        }

	        /*spanie(czekanie)*/
	        try{sleep(2000);}catch(Exception e){}
	      } while(energia>0 && l.gra);
	      if (energia<1) {
	        System.out.println("<Zabiles zbira>");
	        l.komnata[y][x].zbir=null;
	      }
	  }
	}



class Bandyta extends Zbir {
	Bandyta(Labirynt lab,int x, int y)
	  {
	    energia=50;
	    sila=(int)(Math.random()*20)+20;
	    l=lab;
	    this.x=x;
	    this.y=y;
	    nazwa = "Bandyta";

	  }
	public void run(){
	      Komnata k;
	      do{
	        k=l.komnata[y][x];
	        /*jesli jest bohater w tej samej komnacie to trzeba go napasc*/
	        if (k.jest_bohater){
	          l.bohater.energia-=(sila-5);
	          l.bohater.napad();
	        }

	        /*zmianda lokacji*/
	        int d=((int)(Math.random()*19))/4;
	        if (d==0) {
	          if (x+1<50 && !l.komnata[y][x+1].sciana) {
	            k.zbir=null;
	            x++;
	            l.komnata[y][x].zbir=this;
	          }
	        }
	        else if (d==1){
	          if (x-1>=0 && !l.komnata[y][x-1].sciana) {
	            k.zbir=null;
	            x--;
	            l.komnata[y][x].zbir=this;
	          }
	        }
	        else if (d==2){
	          if (y+1<50 && !l.komnata[y+1][x].sciana) {
	            k.zbir=null;
	            y++;
	            l.komnata[y][x].zbir=this;
	          }
	        }
	        else {
	          if (y-1>=0 && !l.komnata[y-1][x].sciana) {
	            k.zbir=null;
	            y--;
	            l.komnata[y][x].zbir=this;
	          }
	        }

	        /*spanie(czekanie)*/
	        try{sleep(2000);}catch(Exception e){}
	      } while(energia>0 && l.gra);
	      if (energia<1) {
	        System.out.println("<Zabiles zbira>");
	        l.komnata[y][x].zbir=null;
	      }
	  }
	}

