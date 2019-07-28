# -*- encoding : utf-8 -*-
class Kalendarz
    
    def initialize
        @tab = []
    end

    def events
        puts "\n" + "Kalendarz" + "\n\n"
        sort_tab = @tab.sort_by {|e| e[3].to_f}
        sort_tab = sort_tab.sort_by {|e| e[2]}
        sort_tab = sort_tab.sort_by {|e| e[1]}
        sort_tab = sort_tab.sort_by {|e| e[0]}
        sort_tab.each do |i|
            puts "Data: " + i[2].to_s + "." + i[1].to_s + "." + i[0].to_s + "      Godzina: " + i[3] + "\nWydarzenie: " + i[4].to_s + "\n\n"
        end
    end

    def add_event(year,month, day, time, title)
        control = true
        @tab.each do |i|
            if i[0] == year
                if i[1] == month
                    if i[2] == day
                        if ((i[3].to_f - 1) <= time.to_f)  and (time.to_f < (i[3].to_f + 1))
                            control = false
                            puts "W tym czasie jesteś zajęty!"
                            break
                        end
                    end
                end
            end 
        end
        if control == true
            @tab = @tab + [[year, month, day, time, title]]
            puts "Dodano do kalendarza!"
        end 
    end
end

kalendarz = Kalendarz.new
answer = 0
while answer != "exit"
    print "Chcesz dodać wydarzenie do kalendarza czy wyświetlić wszystkie? Wpisz: dodaj, kalendarz lub exit "
    answer = gets.chomp
    if answer == "kalendarz"
            kalendarz.events
    end
    if answer == "dodaj"
        print "Rok(YYYY): "
        year = gets.to_i
        while year < 2018
            puts "Rok 2018+!"
            print "Rok(YYYY): "
            year = gets.to_i
        end
        print "Miesiąc(M): "
        month = gets.to_i
        while month > 12
            puts "Mamy 12 miesięcy!"
            print "Miesiąc(M): " 
            month = gets.to_i
        end
        print "Dzień(D): "
        day = gets.to_i
        case month
        when 1,3,5,7,8,10,12
            while day > 31 
                puts "W tym miesiący jest 31 dni!"
                print "Dzień(D): "
                day = gets.to_i
            end
        when 4,6,9,11
            while day > 30
                puts "W tym miesiący jest 30 dni!"
                print "Dzień(D): "
                day = gets.to_i
            end
        else
            while day > 29
                puts "W tym miesiący jest 29 dni!"
                print "Dzień(D): "
                day = gets.to_i
            end
        end
        print "Godzina(H.MM): "
        time = gets.chomp
        temp = time.to_f
        while (temp - temp.to_i) > 0.59
            puts "Godzina ma 60 minut!"
            print "Godzina(H.MM): "
            time = gets.chomp
            temp = time.to_f
        end
        while temp > 23.59
            puts "Dobba ma 24 h!"
            print "Godzina(H.MM): "
            time = gets.chomp
            temp = tme.to_f
        end
        print "Wydarzenie: "
        title = gets.to_s
        kalendarz.add_event(year, month, day, time, title)
    end
end
