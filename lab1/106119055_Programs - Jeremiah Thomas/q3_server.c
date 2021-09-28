// Server Side - Jeremiah Thomas
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdbool.h>

#define PORT 3000
#define MAXLINE 1024

// Driver code
int main() {

	int sockfd;
	struct sockaddr_in servaddr, cliaddr;
	
	// socket creation
	if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
		perror("Socket creation has failed");
		exit(EXIT_FAILURE);
	}
	
	
	memset(&servaddr, 0, sizeof(servaddr));
	memset(&cliaddr, 0, sizeof(cliaddr));
	
	// server details
	servaddr.sin_family = AF_INET; // IPv4
	servaddr.sin_addr.s_addr = INADDR_ANY;
	servaddr.sin_port = htons(PORT);
	
	// Binding server
	if ( bind(sockfd, (const struct sockaddr *)&servaddr,
			sizeof(servaddr)) < 0 )
	{
		perror("Bind to server address has failed");
		exit(EXIT_FAILURE);
	}
	
	int lenClientAddress = sizeof(cliaddr); 
	
	float temp[3];
	float arr3[3] ={0};
	bool error= false;
	
	while(1){
	
 recvfrom(sockfd, &temp, MAXLINE, MSG_WAITALL, ( struct sockaddr *) &cliaddr,  &lenClientAddress);
	
	
	for(int i=0;i<3;i++){
	
	int t= temp[i];
	if(t%2!=0 || temp[i]!= t){
	
	printf("error");
	error= true;
	break;
	
	}else{	
	arr3[i]+=temp[i];
	}
	
	}
	
	
recvfrom(sockfd, &temp, MAXLINE, MSG_WAITALL, ( struct sockaddr *) &cliaddr,  &lenClientAddress);
	
	for(int i=0;i<3;i++){
	
	int t= temp[i];
	if( t%2!=0 || temp[i]!= t){
	
	printf("error");
	error= true;
	break;
	
	}else{	
	arr3[i]+=temp[i];
	}
	
	}
	
	if(!error)
	{
	sendto(sockfd, &arr3, sizeof(arr3), MSG_CONFIRM, (const struct sockaddr *) &cliaddr,
			lenClientAddress);
	printf("ARRAY 3 HAS BEEN SENT.\n");
	break;
	
	}
	}
	

	
	return 0;
}

