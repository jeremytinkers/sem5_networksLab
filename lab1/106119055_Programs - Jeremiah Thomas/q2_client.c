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
	
	printf("ENTER ONE OF THE FOLLOWING COMMANDS TO FETCH INFORMATION FROM THE SERVER \n 1- SEARCH FOR A PART \n 2- FETCH PART NAME \n 3- FETCH QUANTITY OF PARTS AVAILABLE \n 4- RETRIEVE PART DECRIPTION \n 5- RETREIVE PART PRICE \n DO FOLLOW THIS PROTOCOL WHEN QUERYING : <COMMAND NO> <PART NO> \n");
	
	int cmd, partNo;
	scanf("%d %d", &cmd, &partNo);
	
	send(sock, &cmd, sizeof(cmd), 0);
        send(sock, &partNo, sizeof(partNo), 0);
	
	printf("The request has been sent! \n");
	char serverRes[1000];
	
	read(sock, &serverRes, sizeof(serverRes));
	
	printf("Response from server : %s", serverRes );
	
	return 0;
}

