import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;


/**Klasa odpowiedzialna za nacisniecie klawisza na klawiaturze.
 * Dziedziczy po standardowym obiekcie javy
 */
class Klawisze extends KeyAdapter{
  private Labirynt lab;

  /**W konstruktorze przekazywana jest referencja do klasy labirynt*/
  Klawisze(Labirynt l)
  {
    lab=l;
  }

  /**Metoda wywolywana po nacisnieciu klawisza na klawiaturze*/
  public void keyPressed(KeyEvent e)
  {
    int key=e.getKeyCode();
    int x=lab.bohater.x;
    int y=lab.bohater.y;
    Komnata k=lab.komnata[y][x];

    if (lab.gra) {
      if (key==KeyEvent.VK_ESCAPE) System.exit(0);
      if (key==KeyEvent.VK_K) {    //klawiszologia
        System.out.println("Strzalki - przejscie do sasiedniej komnaty");
        System.out.println("M - mapa\nR - rozgladniecie sie\nZ - branie zlota");
        System.out.println("B - branie broni\nL - branie lekarstwa\nA - atak");
        System.out.println("S - statystyki  Escape - wyjscie z gry");
      }
      if (key==KeyEvent.VK_M) lab.wydrukuj(lab.bohater.kres);  //mapa
      if (key==KeyEvent.VK_S) {  //informacje o stanie bohatera
        System.out.println("Energia: "+lab.bohater.energia);
        System.out.println("Zloto: "+lab.bohater.zloto);
        System.out.print("Bron: ");
        if (lab.bohater.bron!=null) System.out.println(lab.bohater.bron.nazwa);
        else System.out.println("Reka?");
      }
      if (key==KeyEvent.VK_R) {  //rozgladniecie sie
        if (k.zloto>0) System.out.println("Znalezione zloto: "+k.zloto);
        if (k.lekarstwo>0) System.out.println("Znalezione lekarstwo: "+k.lekarstwo+"%");
        if (k.bron!=null) System.out.println("Znaleziona bron: "+k.bron.nazwa);
        if (k.zloto==0 && k.lekarstwo==0 && k.bron==null) System.out.println("W tej komnacie nic nie ma:(");
        if (k.zbir!=null) System.out.println("Zbir: " + k.zbir.nazwa + "!");
        k.przejrzana=true;
      }
      if (key==KeyEvent.VK_A) {  //atak
        Zbir z=k.zbir;
        if (z!=null ) {   //czy jest ktos do zaatakowania
          int rand=(int)(Math.random()*100);
          if (rand<90) {    //udany atak
            System.out.println("Zgin!!!");
            if (lab.bohater.bron!=null) { //jest bron
              z.energia-=lab.bohater.bron.sila;
              lab.bohater.bron.trwalosc--;
            }
            else {    //nie ma broni
              z.energia-=lab.bohater.sila;
            }
          }
          else System.out.println("Aaaah");   //nie udany atak
          if (lab.bohater.bron!=null && lab.bohater.bron.trwalosc==0) lab.bohater.bron=null;
        }
        else System.out.println("Nie ma kogo zaatakowac:<");
      }
      if (key==KeyEvent.VK_Z || key==KeyEvent.VK_L || key==KeyEvent.VK_B)    //branie przedmiotow
        if (! k.przejrzana) System.out.println("Musze sie tu troche rozejrzec.");
        else {
          if (key==KeyEvent.VK_Z)  //branie zlota
            if (k.zloto>0) {
              lab.bohater.zloto+=k.zloto;
              k.zloto=0;
              System.out.println("Wzialem zloto.");
            } else System.out.println("Tutaj nie ma zlota.");
          if (key==KeyEvent.VK_L)  //branie leku
            if (k.lekarstwo>0) {
              lab.bohater.energia+=k.lekarstwo;
              if (lab.bohater.energia>100) lab.bohater.energia=100;
              k.lekarstwo=0;
              System.out.println("Zazylem lekarstwo.");
            } else System.out.println("Tutaj nie ma lekarstwa.");
          if (key==KeyEvent.VK_B)  //podniesienie broni
            if (k.bron!=null) {
              Bron b=lab.bohater.bron;
              lab.bohater.bron=k.bron;
              k.bron=b;
              System.out.println("Wzialem bron.");
            } else System.out.println("Tutaj nie ma broni.");
        }
      if (key==KeyEvent.VK_DOWN||key==KeyEvent.VK_LEFT||key==KeyEvent.VK_RIGHT||key==KeyEvent.VK_UP) {  //strzalki
        if (key==KeyEvent.VK_DOWN)
          if ((y+1)<50 && ! lab.komnata[y+1][x].sciana) {
            lab.bohater.y++;
            if (((y+3)>lab.bohater.kres) && (lab.bohater.kres<50)) lab.bohater.kres++;
            System.out.println("Udales sie na poludnie.");
          }
          else if (y+1>49) lab.koniec();
            else System.out.println("?");
        if (key==KeyEvent.VK_RIGHT)
          if (x+1<50 && ! lab.komnata[y][x+1].sciana) {
            lab.bohater.x++;
            System.out.println("Udales sie na wschod.");
          }
          else System.out.println("?");

        if (key==KeyEvent.VK_UP)
          if (y-1>=0 && ! lab.komnata[y-1][x].sciana) {
            lab.bohater.y--;
            System.out.println("Udales sie na polnoc.");
          }
          else System.out.println("?");

        if (key==KeyEvent.VK_LEFT)
          if (x-1>=0 && ! lab.komnata[y][x-1].sciana) {
            lab.bohater.x--;
            System.out.println("Udales sie na zachod.");
          }
          else System.out.println("?");

        /*zaznaczenie ze bohater zmienil komnate*/
        if (x!=lab.bohater.x || y!=lab.bohater.y) {
          lab.komnata[y][x].jest_bohater=false;
          x=lab.bohater.x;
          y=lab.bohater.y;
          lab.komnata[y][x].jest_bohater=true;
        }

        /*sprawdzenie okolicy wokol bohater*/
        if (y-1>=0 && !lab.komnata[y-1][x].sciana) lab.komnata[y-1][x].dostepna=true;
        if (x+1<50 && !lab.komnata[y][x+1].sciana) lab.komnata[y][x+1].dostepna=true;
        if (x-1>=0 && !lab.komnata[y][x-1].sciana) lab.komnata[y][x-1].dostepna=true;
        if (y+1<50 && !lab.komnata[y+1][x].sciana) lab.komnata[y+1][x].dostepna=true;

      }
    }

  }

}