# -*- encoding : utf-8 -*-
def rozklad (n) 
    liczba = n
    i = 2
    result = []
    l = 0
    is = false
    while i * i <= n do
        while n%i == 0 do
            is = true
            n = n/i
            l = l + 1
        end
        if is == true
            result = result << [i, l]
            is = false
        end
    l = 0
    i = i + 1
    end
    if n > 1
        result = result << [n, 1]
    end
    puts result
end

def suma (n)
    sum = 1
    for i in 2..(n-1)
        if n%i == 0
            sum = sum + i
        end
    end
    return sum
end

def zaprzyjaznione?(a, b)
    x = (a == suma(b)) && (b == suma(a)) && (a != b)
    return x
end

def podajzaprzyjazniona(a)
    b = suma(a)
    return (a == suma(b) && (b != a)) ? b : 0
end

def zaprzyjaznione(n)
    if n < 220
        puts []
    end
    i = 220
    tab = []
    while ((t = podajzaprzyjazniona(i)) <= n)
        if (( t != 0) && (i < t))
            tab = tab << [i, t]
        end
        i = i + 1
    end
    puts tab
end
 
puts "Zaprzyjaźnione: "
zaprzyjaznione(1300)
puts "\nRozkład: "
rozklad(180)
