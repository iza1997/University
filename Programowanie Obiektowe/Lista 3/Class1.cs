using System;

namespace dll
{
    public class Slownik<K, V>
    {
        Slownik<K, V> next;
        protected K key;
        protected V val;


        public void add(K key, V val)
        {
            if (this.next != null)
            {
                if (this.next.key.Equals(key))
                {
                    this.next.val = val;
                }
                else
                {
                    this.next.add(key, val);
                }
            }
            else
            {
                this.next = new Slownik<K, V>();
                this.next.key = key;
                this.next.val = val;

            }
        }

        public void write()
        {
            if (this.next != null)
            {
                Console.WriteLine("Key: {0} Value: {1}.", next.key, next.val);
                this.next.write();
            }
        }

        public void search(K keys)
        {
            if (this.next != null)
            {
                if (next.key.Equals(keys)) { Console.WriteLine("Key: {0} Value: {1}.", next.key, next.val); }
                this.next.search(keys);
            }
        }
        public void delete(K key)
       {
            if (this.next!= null)
            {
                if (next.key.Equals(key))
                {
                    if (next.next != null)
                    {
                        next = next.next;
                    }
                    else
                    {
                        next = null;
                    }
                }
                this.next.delete(key);

            }
        }

       
    }


}
