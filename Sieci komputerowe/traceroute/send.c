#include "receive.h"

#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <arpa/inet.h>
#include <sys/select.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <errno.h>

//funkcja z wykladu - oblicza sume kontrolna
static uint16_t compute_icmp_checksum(const void *buff, int length) {
    uint32_t sum;
    const uint16_t *ptr = buff;
    assert (length % 2 == 0);
    for (sum = 0; length > 0; length -= 2)
        sum += *ptr++;
    sum = (sum >> 16) + (sum & 0xffff);
    return (uint16_t)(~(sum + (sum >> 16)));
}

struct icmphdr create_icmp(uint16_t id, int ttl) {

    struct icmphdr icmp_header;
    icmp_header.type = ICMP_ECHO;
    icmp_header.code = 0;
    icmp_header.un.echo.id = id;
    icmp_header.un.echo.sequence = ttl;
    icmp_header.checksum = 0;
    icmp_header.checksum = compute_icmp_checksum((uint16_t *)&icmp_header, sizeof(icmp_header));
    return icmp_header;
}

struct sockaddr_in receipient_addr() {

    struct sockaddr_in recipient;
    bzero(&recipient, sizeof(recipient));
    recipient.sin_family = AF_INET;
    return recipient;
}

//funkcja wysyla pojedynczy pakiet - wiekszosc z wyklady
int send_one_packet(int sockfd, const char *ip, uint16_t id, int ttl) {

//tworzenie komunikatu ICMP do wysylania

    struct icmphdr icmp_header = create_icmp(id, ttl);


//wpisywanie adresu odbiorcy do struktury adresowej

    struct sockaddr_in recipient = receipient_addr();


    if(inet_pton(AF_INET, ip, &recipient.sin_addr)!=1) {
	fprintf(stderr, "IP error: %s \n", strerror(errno));
        return EXIT_FAILURE;
    }


//Pole TTL jest w nagłówku IP → brak bezpośredniego dostępu. Zmiana wywołaniem:
    int answer = setsockopt(sockfd, IPPROTO_IP, IP_TTL, &ttl, sizeof(int));
    if (answer != 0) {
        fprintf(stderr, "sendsockopt error: %s\n", strerror(errno)); 
        return EXIT_FAILURE;
    }

//wysylanie pakietu przez gniazdo
    ssize_t bytes_sent = sendto(sockfd, &icmp_header, sizeof(icmp_header), 0,
                               (struct sockaddr *)&recipient, sizeof(recipient));

    if (bytes_sent < 0) {
        fprintf(stderr, "sendto error: %s\n", strerror(errno)); 
        return EXIT_FAILURE;
    }
   return EXIT_SUCCESS;
}


