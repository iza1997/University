# -*- encoding : utf-8 -*-
class Notatnik

    def initialize
        @book = {}
        @groups = {}
    end

    def add_person(name, number, list)
        if @book[name] != nil
            puts "Istnieje już kontakt o tej nazwie"
        else 
            @book[name] =  [number, list]
            list.each do |i|
                if @groups[i] != nil
                    @groups[i] = @groups[i] + [name]
                else
                    @groups[i] = [name] 
                end
            end
            print "Dodano do kontaktów #{name}"
        end
    end 

    def data(name)
        if @book[name] == nil
            print "Nie istnieje kontakt o nazwie #{name}"
        else
            puts name + "\nNumer telefonu: " + @book[name][0] + "\nGrupy: " + @book[name][1].join(", ")
        end
    end

    def group_names(group)
        if @groups[group] == nil
            puts "Nie ma nikogo w tej grupie"
        else
            puts "Osoby należące do grupy #{group}: " + @groups[group].join(", ")
        end
    end

    def groups
        puts "Istniejące grupy: " 
        puts @groups.keys
    end

end
    notatnik = Notatnik.new
    answer = 0
    while answer != "exit"
        print "Co chcesz zrobić? Dodać kontakt - wpisz dodaj, wyszukać kontakt po imieniu - wyszukaj, zobaczyć listę grup - lista, znaleźć wszystkie osoby nalezace do konkretnej grupy - grupa, wyjść - exit "
        answer = gets.chomp 
        case answer
        when "dodaj"
            print "Imię: "
            name = gets.chomp
            print "Numer telefonu: "
            number = gets.chomp
            list = []
            print "Wpisz nazwę grupy lub zapisz : "
            answer2 = gets.chomp
            while answer2 != "zapisz" 
                list = list + [answer2]
                print "Wpisz nazwę grupy lub zapisz : "
                answer2 = gets.chomp
            end
            notatnik.add_person(name, number, list)
        when "wyszukaj"
            print "Imię: "
            name = gets.chomp
            notatnik.data(name)
        when "lista"
            notatnik.groups
        when "grupa"
            print "Nazwa grupy: "
            group = gets.chomp
            notatnik.group_names(group)
        end 
    end
  
