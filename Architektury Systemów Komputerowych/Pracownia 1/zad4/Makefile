all: zad4.o fibonacci.o
	gcc -o zad4 zad4.o fibonacci.o -Wall -Wextra 

src.o: zad4.c
	gcc -Og -c -g zad4.c -Wall -Wextra

asm.o: asm.s
	gcc -c -g fibonacci.s -Wall -Wextra

clean:
	rm -f zad4.o fibonacci.o zad4

	
