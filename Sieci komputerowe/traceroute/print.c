#include "print.h"

int print_all(int packets_received, int count_ip, char ip_list[][20], struct timeval packets_time[], int ttl){

    printf("%d. ", ttl);
    if (packets_received == 0) {
        printf("*");
    } 
    else { 

	for (int i = 0; i < count_ip; i++) {
	
      		printf("%s ", ip_list[i]); }
		if(packets_received ==3) {
			
	   	float average =  ((packets_time[0].tv_usec+packets_time[1].tv_usec+packets_time[2].tv_usec)/3)/1000.0;
            		printf(" %.1f ms ", average);
        
    		}
   		 else { 

			printf("???");
	 	} 

	}
return 0;
}



