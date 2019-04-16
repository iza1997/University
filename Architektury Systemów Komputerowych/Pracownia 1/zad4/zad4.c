#include <stdio.h>
#include <stdlib.h>


extern long fibonacci(unsigned long n);


int main(int argc, char* argv[]) {


	if (argc == 2) { 

		unsigned long n = atol(argv[1]); 

		long result = fibonacci(n);


		printf("Wynik: %ld \n ", result);
	}

	return 0;
}


