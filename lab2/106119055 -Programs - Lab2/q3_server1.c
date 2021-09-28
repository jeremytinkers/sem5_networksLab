// Server side - JEREMIAH THOMAS
#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
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
	
	 int opt = 1;
	 
	if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
                                                  &opt, sizeof(opt)))
    {
        perror("setsockopt");
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
	
	//Server 1, whose function is to send 5 random chunks of data over to 
	//client on request
	
	
	char fileAddress[10][100] = {"1", "2","3","4","5","6","7","8","9","10"};
	int clientWantsFile=0;
	
		
	read(new_socket, &clientWantsFile, sizeof(int));
	
	int chosen[10]= {0}; // an array to tell us if current random no has been chosen or not
	
	if(clientWantsFile){		
	
	//choose 5 random files nad send it across
	
	srand(time(NULL));
	int rno;
	
	for(int i=0;i<5;i++){
	
	l1:
	rno=rand()%10;
	if(!chosen[rno]){
	printf("Sending chunk %d to client \n", rno+1);
	send(new_socket , &fileAddress[rno], sizeof(fileAddress[rno]) , 0 );
	chosen[rno]=1;
	}else{
	goto l1;
	}
		
	}
	
	}else{
	
	printf("CLosing connection... \n");
	
	}
	
	char msgClient[100];
	
	read(new_socket, &msgClient, sizeof(msgClient));
	
	if(strcmp(msgClient, "THANKS")==0) {
	
	printf("\n Closing connection...");
	close(new_socket);
	}
	
	return 0;
}

