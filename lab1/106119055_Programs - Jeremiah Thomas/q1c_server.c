// Server side - JEREMIAH THOMAS
#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <math.h>
#define PORT 3000

struct msgStruct {

char c;
int i;
float f;

};



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
	
	
	
	struct msgStruct s2;
	read(new_socket, &s2, sizeof(struct msgStruct));
	

	printf("Structure data from client1 :  %c %d %f \n ", s2.c, s2.i, s2.f );
	
	//MODIFYING STRUCTURE DATA
	s2.i*=2;
	s2.c--;
	s2.f--;
	
	
	//get socket descriptor for the 2nd client
	if ((new_socket = accept(server_fd, (struct sockaddr *)&address,
					(socklen_t*)&addrlen))<0)
	{
		perror("accept");
		exit(EXIT_FAILURE);
	}
	
	send(new_socket , &s2, sizeof(s2) , 0 );
	
	
	return 0;
}

