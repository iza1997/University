#include "traceroute.h"


int traceroute1(int sockfd, char *ip) {

    int pid = getpid(); 


    for (int ttl = 1; ttl <= 30; ttl++) {

        for (int i = 0; i < 3; i++) {
            send_one_packet(sockfd, ip, pid, ttl);
        }


	int finished = received_packets(sockfd, pid, ttl);
        if (finished) {
            break;
        }
    }

    return EXIT_SUCCESS;
}
