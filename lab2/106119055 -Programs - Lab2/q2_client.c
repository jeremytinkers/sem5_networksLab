// Client - Jeremiah Thomas
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

#define PORT 3000


int main()
{
	int sock = 0;
	struct sockaddr_in serv_addr;
	
	
	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
	{
		printf("\n Socket creation error \n");
		return -1;
	}

	serv_addr.sin_family = AF_INET;
	serv_addr.sin_port = htons(PORT);
	
	// Convert IPv4 and IPv6 addresses from text to binary form
	if(inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr)<=0)
	{
		printf("\nInvalid address/ Address not supported \n");
		return -1;
	}

	if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
	{
		printf("\nConnection Failed \n");
		return -1;
	}
	
	int n=3; // a random positive number
	char msg[1000];
	
	while(n>=0){
	
	printf("\n ENTER A NEW STRING TO BE PROCESSED BY THE SERVER:- ");
	scanf("%s", msg);
	
	send(sock, &msg, sizeof(msg), 0);
  	printf("The string has been sent to server.\n");
	
	n= read(sock, &msg, sizeof(msg));
	
	if(strcmp(msg, "terminate")!=0){
	printf("Message from the server : %s", msg);
	}else{
	break;
	}
		
	}
	
	
	close(sock);
	printf("\n Server has closed the socket of communication. Client socket has been closed. Thank you! \n");
	
	
	return 0;
}

