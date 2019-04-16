#include "receive.h"
#include "print.h"



int received_packets(int sockfd, int pid, uint8_t ttl) {
    int packets_received = 0;
    int finished = 0;
    struct timeval start_time, end_time, current_time;
    gettimeofday(&start_time, NULL);
    end_time = start_time;
    end_time.tv_sec++;

    struct timeval packets_time[3];

    char ip_list[3][20];
    unsigned count_ip = 0;



    gettimeofday(&current_time, NULL);

    while (packets_received < 3 && !timercmp(&current_time, &end_time, >)) {

        struct sockaddr_in sender;
        socklen_t sender_len = sizeof(sender);
        uint8_t buffer[IP_MAXPACKET];



    	char sender_ip_str[20]; //sender IP
    	bool new = true;

//Czekanie maksymalnie x sekund na pakiet w gnieździe sockfd - wyklad
        fd_set descriptors;
        FD_ZERO(&descriptors);
        FD_SET(sockfd, &descriptors);
        struct timeval tv;
	tv.tv_sec = 1;
	tv.tv_usec = 0;
        timersub(&end_time, &current_time, &tv);
        int ready = select(sockfd + 1, &descriptors, NULL, NULL, &tv);
        if (ready < 0) {
            fprintf(stderr, "select error: %s\n", strerror(errno)); 
            return EXIT_FAILURE;
        } if (ready == 0) {
            break;
        }

// recvfrom odbiera kolejny pakiet z kolejki związanej z gniazdem - wyklad
        ssize_t packet_len = recvfrom(sockfd, buffer, IP_MAXPACKET, 0, (struct sockaddr *)&sender, &sender_len);
        if (packet_len < 0) {
            if(errno==EAGAIN)
		continue;
	    else
	    {
		fprintf(stderr, "recvfrom error: %s\n", strerror(errno)); 
          	return EXIT_FAILURE;
		}
        }

        gettimeofday(&current_time, NULL);

// zamienia strukturę adresową w sender na napis z adresem IP

        if(inet_ntop(AF_INET, &(sender.sin_addr), sender_ip_str, sizeof(sender_ip_str)) == NULL){
		fprintf(stderr, "sender error: %s\n", strerror(errno)); 
          	return EXIT_FAILURE;
	}		

// odczyt naglowka IP - wyklad
        struct iphdr* ip_header = (struct iphdr *) buffer;
	u_int8_t* icmp_packet = buffer + 4 * ip_header->ihl;
// odczyt naglowka ICMP - wyklad
        struct icmphdr *icmp_header = (struct icmphdr *) icmp_packet;

        uint8_t icmp_type = icmp_header->type;


        if (icmp_type == ICMP_TIME_EXCEEDED) {
            struct iphdr* inner_ip_header = (void *) icmp_header + 8;
            icmp_header = ((void *) icmp_header + 8) + 4 * inner_ip_header->ihl;
        }

        if ((icmp_type == ICMP_TIME_EXCEEDED || icmp_type == ICMP_ECHOREPLY) && icmp_header->un.echo.id == pid && icmp_header->un.echo.sequence == ttl) {
            timersub(&current_time, &start_time, &packets_time[packets_received]);


	    for (unsigned int i = 0; i < count_ip && new; i++){
            	if (!strcmp(ip_list[i], sender_ip_str))
		  { new = false; }
	    }
	    if (new) 
		{ strcpy(ip_list[count_ip++], sender_ip_str);}
	    
            packets_received++;

            if (icmp_type == ICMP_ECHOREPLY) {

                finished = 1;
            }
        }
    }

    print_all(packets_received, count_ip, ip_list, packets_time, ttl);


    printf("\n");

    return finished;
}


