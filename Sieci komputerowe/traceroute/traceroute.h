#ifndef TRACEROUTE_H_INCLUDED
#define TRACEROUTE_H_INCLUDED

#include <netinet/ip.h>
#include <linux/icmp.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>
#include <time.h>
#include <math.h>
#include <unistd.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>
#include <errno.h>

#include "receive.h"
#include "send.h"

int traceroute1(int sockfd, char *ip); // wyświetla trasę do poprawnego adresu ip

#endif
