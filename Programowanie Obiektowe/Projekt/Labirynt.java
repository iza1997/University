import javax.swing.JFrame;

class Labirynt extends JFrame {
	
	private static final long serialVersionUID = 1L;
	/** Labirynt zlozony jest z 2500 komnat, pomiedzy ktorymi nie ma dzwi. */
	Komnata[][] komnata = new Komnata[50][50];
	/** Mowi czy trwa gra */
	boolean gra;
	/** Bohater gry. */
	Bohater bohater;

	Labirynt() {
		super("Labirynt");
		setResizable(false);
		setSize(150, 0);
		setVisible(true);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		gra = false;
		this.addKeyListener(new Klawisze(this));
		inicjuj_komnaty(); // tworzy tablice komnat
		generuj(20); // generuje labirynt. 20 - ilosc dodatkowych korytarzy
		start();
	}

	void inicjuj_komnaty() {
		for (int i = 0; i < 50; i++)
			for (int k = 0; k < 50; k++)
				komnata[i][k] = new Komnata(this);
	}

	/**
	 * Metoda generuje drogi wewnatrz labiryntu. Najpierw generowana jest droga
	 * od wejscia do wyjscia, a nastepnie drogi dodatkowe. Parametr okresla
	 * ilosc dodatkowych drog.
	 */
	void generuj(int ilosc) {
		int px = (int) (Math.random() * 49);
		int py = 0;

		bohater = new Bohater(this, px, py + 2);
		komnata[0][px].jest_bohater = true;
		komnata[0][px].dostepna = true;

		int kierunek;
		System.out.print("Generowanie labiryntu... ");
		do { /* generuje prawidlowa droge do wyjscia */
			if (px == 0)
				px++;
			if (px == 49)
				px--;
			komnata[py][px].sciana = false;
			kierunek = (int) (Math.random() * 100);
			if (kierunek > 75)
				px++;
			else if (kierunek > 50)
				px--;
			else
				py++;
		} while (py < 50);

		/* generowanie dodatkowych drog */
		for (int i = 1; i < ilosc; i++) {
			/* poczatkowe wspolrzedne */
			px = (int) (Math.random() * 47) + 1;
			py = (int) (Math.random() * 47) + 1;
			/* docelowe wspolrzedne */
			int kx, ky;
			do {
				kx = (int) (Math.random() * 47) + 1;
				ky = (int) (Math.random() * 47) + 1;
			} while (ky == py && kx == px);
			/* rysowanie korytarza  do dotarcia do punktu decelowego */
			do {
				int dx = Math.abs(px - kx); // odleglosc x
				int dy = Math.abs(py - ky); // odleglosc y
				if (dx > dy) {
					if (kx > px)
						px++;
					if (kx < px)
						px--;
				} else {
					if (ky > py)
						py++;
					if (ky < py)
						py--;
				}
				komnata[py][px].sciana = false;

				/* przydzielenie zlota komnacie */
				int tmp = (int) (Math.random() * 100);
				if (tmp > 90) {
					tmp = (int) (Math.random() * 100);
					if (tmp > 90)
						komnata[py][px].zloto = 100;
					else if (tmp > 70)
						komnata[py][px].zloto = 75;
					else if (tmp > 40)
						komnata[py][px].zloto = 50;
					else
						komnata[py][px].zloto = 25;
				}

				/* przydzielenie lekarstwa komnacie */
				tmp = (int) (Math.random() * 100);
				if (tmp > 94) {
					tmp = (int) (Math.random() * 100);
					if (tmp > 90)
						komnata[py][px].lekarstwo = 100;
					else if (tmp > 70)
						komnata[py][px].lekarstwo = 75;
					else if (tmp > 40)
						komnata[py][px].lekarstwo = 50;
					else
						komnata[py][px].lekarstwo = 25;
				}

				/* przydzielenie broni komnacie */
				tmp = (int) (Math.random() * 100);
				if (tmp > 94) {
					tmp = (int) (Math.random() * 100);
					if (tmp > 90)
						komnata[py][px].bron = new Sztylet();
					else if (tmp > 60)
						komnata[py][px].bron = new Drag();
					else
						komnata[py][px].bron = new Kamien();
				}

				/* przydzielenie zlodzieja komnacie */
				tmp = (int) (Math.random() * 100);
				if (tmp > 94) {
					tmp = (int) (Math.random() * 100);
					if (tmp > 50) {
						komnata[py][px].zbir = new Bandyta(this, px, py);
						komnata[py][px].zbir.start(); }
					else 
					{	komnata[py][px].zbir = new Zlodziej(this, px, py);
						komnata[py][px].zbir.start(); }
			}
			} while (px != kx && py != ky);

		px = bohater.x;
		if (px < 49 && px > 0) {
			if (!komnata[1][px].sciana)
				komnata[1][px].dostepna = true;
			if (!komnata[0][px + 1].sciana)
				komnata[0][px + 1].dostepna = true;
			if (!komnata[0][px - 1].sciana)
				komnata[0][px - 1].dostepna = true;
			}
		}
		System.out.println("Zakonczone");

	}

	/**
	 * Wyswietla mape. Pokazywane sa tylko odwiedzone komnaty i te w najblizszym
	 * otoczeniu.
	 */
	void wydrukuj(int kres) {
		int s = 0;
		/* zakres map, ktory zostanie wydrukowany */
		if (bohater.y - 5 > 0)
			s = bohater.y - 5;
		if (bohater.y + 20 < kres)
			kres = bohater.y + 5;
		System.out.println("Mapa: X - bohater   P - przedmiot   Z - zbir");
		for (int i = s; i < kres; i++) {
			for (int k = 0; k < 50; k++)
				if (komnata[i][k].sciana)
					System.out.print("#"); // jesli sciana
				else if (komnata[i][k].jest_bohater)
					System.out.print("X"); // bohater
				else if (komnata[i][k].dostepna) { // jesli odwiedzona
					if (komnata[i][k].zbir != null)
						System.out.print("Z"); // zbir
					else if (komnata[i][k].przejrzana) { // jesli bohater sie
															// rozgladnal w niej
						if (komnata[i][k].zloto > 0
								|| komnata[i][k].lekarstwo > 0)
							System.out.print("P"); // to pokaz przedmioty
						else
							System.out.print(" "); // pusta komnata
					} else
						System.out.print(" "); // pusta/nie przegladnieta
												// komnata
				} else
					System.out.print("#"); // nie sciana, ale niedostepna
			System.out.println();
		}
	}

	/** Rozpoczecie gry. */
	void start() {
		System.out.println("Gra rozpoczeta.");
		System.out
				.println("Nacisnij 'K', by wyswietlic liste dostepnych w grze klawiszy.");
		System.out.println("Znajdz wyjscie i nazbieraj jak najwiecej zlota.");
		gra = true;
	}

	/** Zakonczenie gry, gdy bohater znalazl wyjscie. */
	void koniec() {
		gra = false;
		System.out.println("Gratulacje!\nZnalazles wyjscie z labiryntu!");
		System.out.println("Zebrane zloto: " + bohater.zloto);
		this.dispose();
		System.exit(0);
	}

	/** Koniec gry, jesli bohater zginal. */
	void zgon() {
		gra = false;
		System.out.println("Zginales!");
		System.out.println("Zebrane zloto: " + bohater.zloto);
		this.dispose();
		System.exit(0);
	}

}