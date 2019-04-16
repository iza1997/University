
/**Klasa reprezentujaca bohatera gry, w ktorego wciela sie gracz.*/
class Bohater {
  /**Pozycja w labiryncie.*/
  int x;
  /**Pozycja w labiryncie.*/
  int y;
  /**Okresla do ktorego miejsca ma byc wyswietlana mapa*/
  int kres;
  /**Stan energii bohatera*/
  int energia;
  /**Ilosc zebranego zlota*/
  int zloto;
  /**Sila bohatera*/
  int sila;
  /**Posiadana bron*/
  Bron bron;
  /**referencje do klasy labirynt*/
  private Labirynt l;

  /**W konstruktorze ustalane sa domyslne wartosci*/
  Bohater(Labirynt l,int x,int kres){
    this.x=x;
    y=0;
    this.kres=kres;
    energia=100;
    sila=10;
    zloto=0;
    bron=null;
    this.l=l;
  }

  /**sygnalizuje ze bohater zostal okradziony*/
  void kradzierz(){
    System.out.println("Zostalem okradziony!");
  }

  /**sygnalizuje ze bohater zostal okradziony*/
  void napad(){
    System.out.println("Zostalem zaatakowany!");
    if (energia<1) l.zgon();
  }

}