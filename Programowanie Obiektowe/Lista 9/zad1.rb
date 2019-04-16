class Funkcja < Proc 
  
  def value(x)
    self.call(x)
  end
  
  def zerowe(a,b,e)
    if value(a)==0 
      return a 
    elsif value(b)==0 
      return b 
    else 
      srodek = (a+b)/2.0
      if b-a <= e
        return srodek 
      elsif value(a)*value(srodek)<0 
        return zerowe(a,srodek,e) 
      else 
        return zerowe(srodek,b,e)
      end
    end
  end
  
  def pole(a,b)
    s = 0
    n = 10000
    dx = (b-a)/n
    i = 1 
    while i <=n
      s = s + value(a+i*dx)
      i = i + 1
    end
    s = s + (value(a)+value(b))/2
    s = s*dx
    return s
  end
  
  def poch(x)
    h = 0.00000000001
  	return (value(x+h)-value(x))/h
  end
end

fun = Funkcja.new { |x| x*x}
puts "Wartosæ w punkcie 8 :"
puts fun.value(8)
puts "Miejsce zerowe w przedziale <-4,6>:"
puts fun.zerowe(-4, 6, 0.000000001)
puts "Pole pod wylkresem w przedziale <-4,6>:"
puts fun.pole(-4.0,6.0)
puts "Pochodna w punkcie 2:"
puts fun.poch(2)