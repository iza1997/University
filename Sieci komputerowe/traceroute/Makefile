
CC = gcc
CFLAGS = -std=c99 -Wall -Wextra

all: traceroute

main.o: main.c
send.o: send.h send.c
print.o: print.h print.c
receive.o: receive.h receive.c
traceroute.o: traceroute.c traceroute.h
traceroute: receive.o traceroute.o send.o main.o print.o

clean:
	rm -f *.o

distclean: clean
	rm -f traceroute
