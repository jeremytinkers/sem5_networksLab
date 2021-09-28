// Server side - JEREMIAH THOMAS
#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <math.h>
#define PORT 3001

int main()
{
	int server_fd, new_socket;
	struct sockaddr_in address;
	int addrlen = sizeof(address);
	
	// socket creation
	if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
	{
		perror("socket failed");
		exit(EXIT_FAILURE);
	}
	

	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons( PORT );
	
	// Binding socket to server address
	if (bind(server_fd, (struct sockaddr *)&address,
								sizeof(address))<0)
	{
		perror("bind failed");
		exit(EXIT_FAILURE);
	}
	
	if (listen(server_fd, 3) < 0)
	{
		perror("listen");
		exit(EXIT_FAILURE);
	}
	
	if ((new_socket = accept(server_fd, (struct sockaddr *)&address,
					(socklen_t*)&addrlen))<0)
	{
		perror("accept");
		exit(EXIT_FAILURE);
	}
	
	char fileAddress[10][100] = {"1", "2","3","4","5","6","7","8","9","10"};
	
	for(int i=0;i<5;i++){
	int chunkNo;
	read(new_socket, &chunkNo, sizeof(int));
	printf("Client has requested for chunk -> %d . Sending Chunk.... \n", chunkNo +1);
	send(new_socket , &fileAddress[chunkNo], sizeof(fileAddress[chunkNo]) , 0 );
	
	}
	
	char msgClient[100];
	
	read(new_socket, &msgClient, sizeof(msgClient));
	
	if(strcmp(msgClient, "THANKS")==0) {
	
	printf("\n Closing connection...");
	close(new_socket);
	}
	
	return 0;
}

