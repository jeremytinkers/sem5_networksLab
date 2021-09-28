// Client1 side - Jeremiah Thomas
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
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
	int sock = 0;
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
	
	struct msgStruct s1;
	
	printf("ENTER THE STRUCTURE DETAILS : <char> <integer> <float> \n");
	scanf("%c %d %f", &s1.c, &s1.i, &s1.f);
	
	
	send(sock, &s1, sizeof(s1), 0);
	
	printf("The message has been sent! ");
		
	return 0;
}

