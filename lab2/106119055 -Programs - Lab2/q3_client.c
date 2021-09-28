// Client1 side - Jeremiah Thomas
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <ctype.h>
#define PORT 3000
#define PORT2 3001

int findChunkNo(char msg[100]){ //built with knowledge of file format


char idx[3];
int c=0;

for(int i=0;i<strlen(msg);i++){

if(isdigit(msg[i])){
//printf("we hit a digit! \n");
idx[c++]=msg[i];
}

}

return atoi(idx);


}

int main()
{
	int sock = 0, sock2 =0;
	struct sockaddr_in serv_addr;
	
	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
	{
		printf("\n Socket creation error \n");
		return -1;
	}

	serv_addr.sin_family = AF_INET;
	serv_addr.sin_port = htons(PORT);
	
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
	
int flag=0;
	
	int chunks[10]= {0}; //an array to keep track of the chunks it has received
       
       printf("Enter \n 1 - If you wish to receive files 5 random files from server 1 \n 0 - If you do not \n");
       
       //client - server1 interaction:-
	scanf("%d", &flag);
	
	send(sock, &flag, sizeof(int), 0);
	
	printf("The message has been sent! \n \n ");
	
	for(int i=0;i<5;i++){
	
	char msg[100];
	
	read(sock, &msg, sizeof(msg));
	
	int x= findChunkNo(msg) - 1; 
	chunks[x]= 1; //mark as received

	

	
	}
	
	//create sock2 for communication bw client and server2
	
	if ((sock2 = socket(AF_INET, SOCK_STREAM, 0)) < 0)
	{
		printf("\n Socket creation error \n");
		return -1;
	}

	serv_addr.sin_family = AF_INET;
	serv_addr.sin_port = htons(PORT2);
	
	if(inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr)<=0)
	{
		printf("\nInvalid address/ Address not supported \n");
		return -1;
	}

	if (connect(sock2, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
	{
		printf("\nConnection Failed \n");
		return -1;
	}
	
	printf("\n \n ");
	
	//client - server2 interaction:-
	for(int i=0;i<10;i++){
	
	
	if(!chunks[i]){

	send(sock2, &i, sizeof(i), 0);
	
	char msg[100];
	read(sock2, &msg, sizeof(msg));
	
	
	
	}
	
	
	}
	

	
	printf("\n CLosing client socket..... ");
	
		
	return 0;
}

