#include "traceroute.h"



int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Only 1 argument required\n");
        return EXIT_FAILURE;
    }

    int sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
    if (sockfd < 0) {
        fprintf(stderr, "socket error: %s\n", strerror(errno));
        return EXIT_FAILURE;
    }

    struct sockaddr_in addr;
    addr.sin_port = htons (7);
    addr.sin_family = AF_INET;
    if (inet_pton(AF_INET, argv[1], &(addr.sin_addr)) != 1) {
        printf("IP error - not IPv4 address\n");
        return EXIT_FAILURE;
    }


	
	return traceroute1(sockfd, argv[1]);
}
