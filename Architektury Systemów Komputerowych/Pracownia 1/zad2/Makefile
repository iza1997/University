all: zad2.o lcm_gcd.o
	gcc -o zad2 zad2.o lcm_gcd.o -Wall -Wextra 

src.o: zad2.c
	gcc -Og -c -g zad2.c -Wall -Wextra

asm.o: lcm_gcd.s
	gcc -c -g lcm_gcd.s -Wall -Wextra

clean:
	rm -f zad2.o lcm_gcd.o zad2

dis:
	objdump -d zad2
	
