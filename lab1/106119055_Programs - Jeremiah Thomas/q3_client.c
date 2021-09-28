// Q3 - Client - Jeremiah Thomas
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#define PORT 3000
#define MAXLINE 1024

// Driver code
int main() {


	float arr1[3];
	float arr2[3];
	
	printf("ENTER ARRAY 1 ELEMENTS TO BE PROCESSED BY THE SERVER.  \n");
	for(int i=0;i<3;i++){
	
	scanf("%f" , &arr1[i]);
	
	}
	
	printf("ENTER ARRAY 2 ELEMENTS TO BE PROCESSED BY THE SERVER.  \n");
	for(int i=0;i<3;i++){
	
	scanf("%f" , &arr2[i]);
	
	}
	
	int sockfd;

	struct sockaddr_in servaddr;

	// socket creation - UDP/IP 
	if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
		perror("socket creation failed");
		exit(EXIT_FAILURE);
	}

	memset(&servaddr, 0, sizeof(servaddr));
	
	// server information
	servaddr.sin_family = AF_INET;
	servaddr.sin_port = htons(PORT);
	servaddr.sin_addr.s_addr = INADDR_ANY;
	
	struct timeval timeout;
	timeout.tv_sec = 3;
	timeout.tv_usec =0;
	
	if(setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO,(char *)&timeout , sizeof(timeout))<0){
	perror( "SETSOCKOPT HAS FAILED!");
	}
	
	int lenServerAddr;
	int n=-1;
	
	while(n<0){
	
	sendto(sockfd, &arr1, sizeof(arr1), MSG_CONFIRM, (const struct sockaddr *) &servaddr,
			sizeof(servaddr));
			
	sendto(sockfd, &arr2, sizeof(arr2), MSG_CONFIRM, (const struct sockaddr *) &servaddr,
			sizeof(servaddr));
			
	printf("Arrays have been sent.\n");
	
	n= recvfrom(sockfd, &arr2, MAXLINE, MSG_WAITALL, (struct sockaddr *) &servaddr,
				&lenServerAddr);
	
	if(n<0){
	printf("\n RETRANSMITTING DATAGRAM TO SERVER \n");
	}
				
	}
	
	
	close(sockfd);
	
	printf("Datagram from Server :- : \n");
	
	for(int i=0;i<3;i++){
	
	printf("%f ", arr2[i]);
	
	}

	printf("\n");
	
	close(sockfd);
	
	return 0;
}

