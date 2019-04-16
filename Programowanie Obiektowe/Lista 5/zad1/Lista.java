class Lista<T extends Comparable<T>>
{
  Lista<T> next;
  protected T val;
  
   public Lista()
   {
   }
  
   public Lista(T value)
   {
     this.val = value;
   }
    
   public void add(T val)
        {
            if (this.next != null)
            {
                // jesli nastepny jest wiekszy, to wstawiamy val tutaj
                if (this.next.val.compareTo(val) > 0)
                {
                    Lista<T> newElem = new Lista<T>(val);
                    newElem.next = this.next;
                  
                    this.next = newElem;
                }
                else
                {
                    this.next.add(val);
                }
            }
            else
            {
                this.next = new Lista<T>(val);
            }
        }
        public void write()
        {
            if (this.next != null)
            {
                System.out.println( " Val: " + next.val.toString());
                this.next.write();
            }
        }
        
      public T get()
       {
            if (this.next!= null)
            {
              Lista<T> el = this.next;
              
              this.next = this.next.next;

              return el.val;              
            }
            
          return val;        
      }
}