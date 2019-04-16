import java.util.Random;
import java.lang.Thread;

class MergeTask extends Thread {

    private int[] tab;
    private int[] pomtab;
    private int len;

    private int pocz;
    private int kon;

    MergeTask(int tab[], int pomtab[], int pocz, int kon) {
        this.tab = tab;
        this.len = tab.length;

        this.pomtab = pomtab;

        this.pocz = pocz;
        this.kon = kon;
    }

    private void Merge(int pocz, int kon) {

        if (pocz < kon) {
            int srodek = pocz + (kon - pocz) / 2;
            Merge(pocz, srodek);
            Merge(srodek + 1, kon);
            Merge2(pocz, srodek, kon);
        }
    }

    private void Merge2(int pocz, int srodek, int kon) {
        for (int i = pocz; i <= kon; i++) {
            pomtab[i] = tab[i];
        }

        int i = pocz;
        int j = srodek + 1;
        int k = pocz;
        while (i <= srodek && j <= kon) {
            if (pomtab[i] <= pomtab[j]) {
                tab[k] = pomtab[i];
                i++;
            } else {
                tab[k] = pomtab[j];
                j++;
            }
            k++;
        }
        while (i <= srodek) {
            tab[k] = pomtab[i];
            k++;
            i++;
        }
    }

    public void run() {
        Merge(pocz, kon);
    }
}

class Merge2Task extends Thread {

    private int[] tab;
    private int[] pomtab;
    private int len;

    private int pocz;
    private int srodek;
    private int kon;

    Merge2Task(int tab[], int pomtab[], int pocz, int srodek, int kon) {
        this.tab = tab;
        this.len = tab.length;

        this.pomtab = pomtab;

        this.pocz = pocz;
        this.srodek = srodek;
        this.kon = kon;
    }

    private void Merge2(int pocz, int srodek, int kon) {
        for (int i = pocz; i <= kon; i++) {
            pomtab[i] = tab[i];
        }

        int i = pocz;
        int j = srodek + 1;
        int k = pocz;
        while (i <= srodek && j <= kon) {
            if (pomtab[i] <= pomtab[j]) {
                tab[k] = pomtab[i];
                i++;
            } else {
                tab[k] = pomtab[j];
                j++;
            }
            k++;
        }
        while (i <= srodek) {
            tab[k] = pomtab[i];
            k++;
            i++;
        }
    }

    public void run() {
        Merge2(pocz, srodek, kon);
    }
}

class MergeSort {
    private int[] tab;
    private int[] pomtab;
    private int len;

    public MergeSort() {
    }

    public void sort(int tab[]) {
        this.tab = tab;
        this.len = tab.length;
        this.pomtab = new int[len];
        Merge(0, len - 1);
    }

    private void Merge(int pocz, int kon) {

        if (pocz < kon) {
            int srodek = pocz + (kon - pocz) / 2;
            Merge(pocz, srodek);
            Merge(srodek + 1, kon);
            Merge2(pocz, srodek, kon);
        }
    }

    private void Merge2(int pocz, int srodek, int kon) {

        for (int i = pocz; i <= kon; i++) {
            pomtab[i] = tab[i];
        }
        int i = pocz;
        int j = srodek + 1;
        int k = pocz;
        while (i <= srodek && j <= kon) {
            if (pomtab[i] <= pomtab[j]) {
                tab[k] = pomtab[i];
                i++;
            } else {
                tab[k] = pomtab[j];
                j++;
            }
            k++;
        }
        while (i <= srodek) {
            tab[k] = pomtab[i];
            k++;
            i++;
        }
    }

    public void sortWithThreads(int tab[]) {
        this.tab = tab;
        this.len = tab.length;
        this.pomtab = new int[len];

        int pocz = 0;
        int kon = len-1;
        int sublen = (kon - pocz) / 2;
        int srodek = pocz + sublen;

        Thread t1 = new MergeTask(tab, pomtab, pocz, srodek);
        Thread t2 = new MergeTask(tab, pomtab, srodek + 1, kon);
        Merge2Task mt = new Merge2Task(tab, pomtab, pocz, srodek, kon);
        
        try 
        {
          t1.start();
          t2.start();
          
          t1.join();
          t2.join();
        
  
          mt.start();
          mt.join();
        } catch(Exception ex)
        {
          System.out.print(ex.getMessage());
        }
    }
}

class Main{
  public static void main(String a[]){
        int RANGE = 10000000;
        Random rand = new Random();
        int[] tab = new int[RANGE];
        
        for  (int i=0; i<RANGE; i++)
          tab[i] = rand.nextInt(RANGE);

        try {
        
        MergeSort posortowane = new MergeSort();

        long start = System.currentTimeMillis();        
          //posortowane.sort(tab);
          posortowane.sortWithThreads(tab);
        long stop = System.currentTimeMillis();        
        
        System.out.print("sortowanie trwalo " + (stop-start) + "ms\n");
        for(int i=0; i<10; i++){
            System.out.print(tab[i]);
            System.out.print(", ");
        }
        
        System.out.print("\n");

        } catch (Exception ex) { System.out.print(ex.getMessage()); }

}
}