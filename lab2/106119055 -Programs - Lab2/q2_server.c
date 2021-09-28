// Server - Jeremiah Thomas
#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>
#include <string.h>
#include <ctype.h>
#define PORT 3000



int main()
{

	int server_fd, new_socket;
	struct sockaddr_in address;
	int addrlen = sizeof(address);

	// Creating socket - TCP/IP
	if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
	{
		perror("socket failed");
		exit(EXIT_FAILURE);
	}
	
	//server address details
	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons( PORT );
	
	// Binding socket to address specified
	if (bind(server_fd, (struct sockaddr *)&address,sizeof(address))<0)
	{
		perror("bind failed");
		exit(EXIT_FAILURE);
	}
	if (listen(server_fd, 5) < 0)
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
	
	

	
	char msg[1000];//response to client's request
	
	
	while(1){
	
	read(new_socket, &msg, sizeof(msg));
	
	printf("String from client is : %s \n", msg);
	
	if(strcmp(msg, "BYEBYE")==0){
	
	printf("Closing Server Connection due to client's request.");
	strcpy(msg, "terminate");
	send(new_socket, &msg, sizeof(msg), 0);
	break;
	
	}
	else{
	
	//processing the string from server:-
	for(int i=0;i<strlen(msg);i++){
	
	if(isalpha(msg[i])){
	
	if(isalpha(msg[i]+1)){
	msg[i]= msg[i] +1;
	}else{
	
	msg[i]= msg[i] -25;
	
	}
	}
	
	else if(isdigit(msg[i])){
	
	if(isdigit(msg[i]+1)){
	msg[i]= msg[i] +1;
	}else{
	
	msg[i]= msg[i] -9;
	
	}
	}
	
	else{
	
	msg[i] ='.';
	}
	
	
	
	
				 }//close of loop
	
	
				}//close of processing
	send(new_socket, &msg, sizeof(msg), 0);
	printf("The message has been sent to client \n");	
	
	}
	
	close(new_socket);
	
	
	return 0;
}

