# -*- encoding : utf-8 -*-
def pierwsza (n) 
    if n < 2
        puts []
    end
    tab = [2]
    result = true
    for i in 3..n
        for j in 2..(Math.sqrt(i))
            if i%j == 0
                result = false
            end
        end
        if result == true
            tab = tab << i
        end
        result = true
    end
    puts tab
end

def doskonale(n)
    if n<=5
        puts []
    else
        tab = [6]
        for i in 7..n
            sum = 1
            k = 2
            while k * k <= i do
                if i % k == 0
                     sum = sum + k + i/k
                end
                k += 1
            end
            if sum == i
                tab = tab << i
            end
        end
        puts tab
    end
end


puts "Pierwsze: "
pierwsza(1000)
puts "\nDoskonałe: "
doskonale(10000)
  
