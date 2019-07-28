# -*- encoding : utf-8 -*-
require 'test/unit'

def isprime(n)
  if n < 2
    return false
  end
  k = 2
  while k * k <= n do
    if n % k == 0
      return false
    end
    k += 1
  end
  return true
end

def podzielniki(n)
  div_array = []
  k = 2
  if n <= 1
    return div_array
  end
  while k * k <= n do
    if n % k == 0
      div_array << k
      div_array << n / k
    end
    k += 1
  end
  print "Podzielniki #{n}: "
  print div_array.uniq.sort.select {|e| isprime(e)}
  print "\n"
end

podzielniki(14)
podzielniki(33)
podzielniki(1025)
podzielniki(1547)
