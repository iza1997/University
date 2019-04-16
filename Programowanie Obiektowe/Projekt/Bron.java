
/**Klasa opisuja bron.*/
class Bron {
  /**Nazwa broni.*/
  String nazwa;
  /**Moc broni.*/
  int sila;
  /**Ilosc mozliwych uzyc broni*/
  int trwalosc;

}

/**Podklasy klasy Bron okreslajaca typ broni.*/
class Kamien extends Bron {
  Kamien(){
    nazwa="Kamien";
    sila=15;
    trwalosc=2;
  }
}

class Drag extends Bron {
  Drag(){
    nazwa="Drag";
    sila=20;
    trwalosc=4;
  }
}

class Sztylet extends Bron {
  Sztylet(){
    nazwa="Sztylet";
    sila=30;
    trwalosc=6;
  }
}