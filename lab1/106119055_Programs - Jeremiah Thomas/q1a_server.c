// Server side - JEREMIAH THOMAS
#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <math.h>
#define PORT 3000

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
	
	
	
	char c1;
	read(new_socket, &c1, sizeof(c1));
	

	printf("Data from client1 : %c \n ", c1 );
	
	//MODIFYING DATA
	c1--;
	
	
	//get socket descriptor for the 2nd client
	if ((new_socket = accept(server_fd, (struct sockaddr *)&address,
					(socklen_t*)&addrlen))<0)
	{
		perror("accept");
		exit(EXIT_FAILURE);
	}
	
	send(new_socket , &c1, sizeof(c1) , 0 );
	
	
	return 0;
}

