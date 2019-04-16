#include <stdio.h>
#include <stdlib.h>

typedef struct {
unsigned long lcm, gcd;
} result_t;

extern result_t lcm_gcd(unsigned long a, unsigned long b);

int main(int argc, char* argv[]) {


	if (argc == 3) { 

		unsigned long a = atol(argv[1]); 
		unsigned long b = atol(argv[2]);


		result_t result = lcm_gcd(a,b);


		printf("Wynik: %ld \n %ld \n", result.lcm, result.gcd);
	}

	return 0;
}


