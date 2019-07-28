# -*- encoding : utf-8 -*-
class Wyrazenia

    def oblicz
    end

    def to_s
    end

    def uproszczenie
    end

end

class Stala < Wyrazenia

    def initialize(stala)
        @stala = stala
    end

    def oblicz
        @stala.to_i
    end

    def to_s
        @stala
    end

    def uproszczenie
        @stala
    end

end

class Zmienna < Wyrazenia

    def initialize(zmienna)
        @zmienna = zmienna

        $zmienne[@zmienna] = 0
    end

    def oblicz
        if $zmienne[@zmienna] != nil
            $zmienne[@zmienna]
        else
            raise "zmienna #{@zmienna} niezainicjowana!"
        end
    end

    def to_s
        @zmienna
    end

    def uproszczenie
        @zmienna
    end
end
    
class Dodawanie < Wyrazenia

    def initialize(wyr1, wyr2)
        @wyr1 = wyr1
        @wyr2 = wyr2
    end

    def oblicz

            @wyr1.oblicz + @wyr2.oblicz
        
    end

    def to_s
         "(#{@wyr1.to_s})" + " + " + "(#{@wyr2.to_s})"
    end

    def uproszczenie
        if @wyr1.uproszczenie == 0 
            @wyr2  
        elsif @wyr2.uproszczenie == 0 
            @wyr1
        elsif @wyr1.uproszczenie == -@wyr2.uproszczenie
            0
        elsif @wyr2.uproszczenie < 0 
            Odejmowanie.new(@wyr1.uproszczenie, -@wyr2.uproszczenie)
        end
    end
   
        
end

class Odejmowanie < Wyrazenia

    def initialize(wyr1, wyr2)
        @wyr1 = wyr1
        @wyr2 = wyr2
    end

    def oblicz
 
            @wyr1.oblicz - @wyr2.oblicz
     
    end

    def to_s
        "(#{@wyr1.to_s})" + " - " + "(#{@wyr2.to_s})"   
    end

    def uproszczenie
        if @wyr1.uproszczenie == 0 
            @wyr2
        end
        if @wyr2.uproszczenie == 0 
            @wyr1
        end
        if @wyr1.uproszczenie == @wyr2.uproszczenie
            0
        elsif @wyr2.uproszczenie < 0 
            Dodawanie.new(@wyr1.uproszczenie, -@wyr2.uproszczenie)
        end
    end

end

class Mnozenie < Wyrazenia

    def initialize(wyr1, wyr2)
        @wyr1 = wyr1
        @wyr2 = wyr2
    end

    def oblicz
  
            @wyr1.oblicz * @wyr2.oblicz

    end

    def to_s
        "(#{@wyr1.to_s})" + " * " + "(#{@wyr2.to_s})"
    end

    def uproszczenie
        if @wyr1.uproszczenie == 0 
            0
        end
        if @wyr2.uproszczenie == 0 
            0
        elsif @wyr1.uproszczenie == 1
            @wyr2
        elsif @wyr2.uproszczenie == 1
            @wyr1
        elsif @wyr1.uproszczenie == 1/@wyr2.uproszczenie
            1
        end
    end

end

class Dzielenie < Wyrazenia

    def initialize(wyr1, wyr2)
        @wyr1 = wyr1
        @wyr2 = wyr2
    end

    def oblicz

        if @wyr2.oblicz == 0
            "Nie dzielimy przez 0!"
        else
            @wyr1.oblicz / @wyr2.oblicz
        end
    end

    def to_s
        "(#{@wyr1.to_s})" + " / " + "(#{@wyr2.to_s})"
    end

    def uproszczenie
        if @wyr1.uproszczenie == 0 
            0
        elsif @wyr2.uproszczenie == 1 
            @wyr1
        elsif @wyr2.uproszczenie == -1 
            -@wyr1
        elsif @wyr1.uproszczenie == @wyr2.uproszczenie
            1
        elsif @wyr1.uproszczenie == -@wyr2.uproszczenie
            -1
        end
    end
end


class Instrukcje

    def wykonaj
    end

    def to_s
    end

end

class ListaInstrukcji < Instrukcje
    $zmienne = {}
    def initialize(lista)
        @lista = lista
    end

    def wykonaj
        for i in @lista
            i.wykonaj
        end
        puts i.wykonaj
    end

    def to_s 
        str = ""
        for i in @lista
            
            str = str + i.to_s
            str = str + "\n" 
        end        
        str
    end

end

class ListaInstrukcjiPetla < Instrukcje

    def initialize(lista)
        @lista = lista
    end

    def wykonaj
        for i in @lista
            i.wykonaj
        end
    end

    def to_s 
        str = ""
        for i in @lista
            
            str = str + i.to_s
            str = str + "\n" + "    "
        end        
        str
    end

end

class Podstawienie < Instrukcje
     
    def initialize(zmienna, wartosc)
        @zmienna = zmienna
        @wartosc = wartosc
    end

    def wykonaj
        $zmienne[@zmienna.to_s] = @wartosc.oblicz
    end

    def to_s
        z = @zmienna.to_s
        w = @wartosc.to_s
        "#{z} = #{w}"
    end
end



class Warunek < Instrukcje

    def initialize(warunek, odp1, odp2)
        @warunek = warunek
        @odp1 = odp1
        @odp2 = odp2
    end

    def wykonaj
        if @warunek.oblicz != 0
            @odp1.wykonaj 
        else
            @odp2.wykonaj
        end
    end

    def to_s
        "if #{@warunek.to_s}\n  #{@odp1.to_s}\nelse\n   #{@odp2.to_s}"
    end
end

class Petla < Instrukcje

    def initialize(warunek, lista)
        @warunek = warunek
        @lista = lista
    end

    def wykonaj
    
        while @warunek.oblicz != 0 do 
            #puts sprintf("warunek %d", @warunek.oblicz)
            @lista.wykonaj
        end

    end

    def to_s
        "while #{@warunek.to_s} do\n    #{(@lista.to_s )}"
    end
end


l = ListaInstrukcji.new([Podstawienie.new(Zmienna.new("n"),Stala.new(10)),
                         Podstawienie.new(Zmienna.new("a"),Stala.new(0)), 
                         Podstawienie.new(Zmienna.new("b"),Stala.new(1)), 
                         Petla.new(Zmienna.new("n"), ListaInstrukcjiPetla.new([Podstawienie.new(Zmienna.new("b"), Dodawanie.new(Zmienna.new("b"),Zmienna.new("a"))), Podstawienie.new(Zmienna.new("a"), Odejmowanie.new(Zmienna.new("b"),Zmienna.new("a"))), Podstawienie.new(Zmienna.new("n"), Odejmowanie.new(Zmienna.new("n"),Stala.new("1")))])),
                         Podstawienie.new(Zmienna.new("wynik"),Zmienna.new("a"))])


puts l.to_s
l.wykonaj
