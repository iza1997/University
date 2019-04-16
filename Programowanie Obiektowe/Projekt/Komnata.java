
/**Klasa reprezentujaca pojedyncza komnate w labiryncie.*/
class Komnata{
  /**Ilosc zlota w komnacie.
   * Mozliwe wielkosci to: 25, 50, 75, 100
   */
  int zloto;
  /**Ilosc lekarstwa w komnacie.
   * Dostepne wielkosci: 25, 50, 75, 100
   */
  int lekarstwo;
  /**Okresla czy w komnacie jest bohater.*/
  boolean jest_bohater;
  /**Okresla czy to jest komnata dostepna dla gracza.*/
  boolean sciana;
  /**Okresla czy dana komnata ma byc wyswietlana na mapie*/
  boolean dostepna;
  /**Okresla czy komnata zostala przegladnieta*/
  boolean przejrzana;
  /**Bron w komnacie*/
  Bron bron;
  /**Zlodziej w komnacie*/
  Zbir zbir;
 
 

  /**W konstruktorze inicjowane sa wartosci zmiennych.
   * Domyslnie w labiryncie nie ma dostepnych komnat dla gracza.
   * Okreslenie rodzaju komnaty odbywa sie prze generowaniu labiryntu
   */
  Komnata(Labirynt l){
    sciana=true;
    jest_bohater=false;
    dostepna=false;
    przejrzana=false;
    zloto=0;
    lekarstwo=0;
    bron=null;
    zbir=null;
  
  }
}