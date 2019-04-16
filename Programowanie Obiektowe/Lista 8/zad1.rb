class Fixnum

  def czynniki?
    n = self
    tab = [1]
    i = 2
    while i <= n
      if n%i == 0 
        tab << i 
        i = i+1 
      else
        i = i + 1
      end
    end
    return tab
  end

  def ack(y)
    n = self
    if n == 0 
      return y + 1
    elsif y == 0 
      return (n - 1).ack(1)
    else 
      return (n-1).ack(n.ack(y-1))
    end
  end

  def doskonala?
    suma = 1 
    n = self
    i = 2
    while i < n
      if suma > n
        return false 
      else
        if n%i == 0 
          suma = suma + i
          i = i + 1 
        else
          i = i + 1
        end
      end
    end
    if suma == n
        return true
    else
      return false 
    end
  end
  
  def slownie?
    n = self 
    tab = ["zero ","jeden ","dwa ","trzy ","cztery ","pięć ","sześć ","siedem ","osiem ","dziewięć "]
    if n == 0 
      return tab[0]
    else
      s = ""
      while n != 0 
        c = n % 10 
        n = n / 10
        s =  tab[c] + s
      end
      return s
    end
  end 
end

puts 6.czynniki?
puts 2.ack(1)
puts 6.doskonala?
puts 123.slownie?
