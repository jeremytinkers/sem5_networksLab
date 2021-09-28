// Client1 side - Jeremiah Thomas
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h> // contains INADDR_ANY structure
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
	
	char c1;
	
	printf("ENTER <char>  : \n");
	scanf("%c", &c1);
	
	
	send(sock, &c1, sizeof(c1), 0);
	
	printf("The message has been sent! ");
		
	return 0;
}

