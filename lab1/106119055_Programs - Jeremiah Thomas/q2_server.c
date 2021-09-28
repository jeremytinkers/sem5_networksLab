// Server - Jeremiah Thomas
#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>
#define PORT 3000


//database schema
struct autoData {

int partNo;
char partName[100];
int partPrice;
int partQuantity;
int accountNo;
char partDescp[200];

};


//1- Search Procedure
bool searchPart(struct autoData db[], int x){


for(int i=0;i<3;i++){

if(db[i].partNo==x){
return true;
}
}

return false;

}

int main()
{

//database details:-
struct autoData db[3];

db[0].partNo =1;
strcpy(db[0].partName, " V8 engine");
db[0].partPrice=200;
db[0].partQuantity=4;
db[0].accountNo= 12345321;
strcpy(db[0].partDescp, "A fully customized V8 engine built by Chrysler" );

db[1].partNo =2;
strcpy(db[1].partName, "bumper");
db[1].partPrice=400;
db[1].partQuantity=4;
db[1].accountNo= 43345321;
strcpy(db[1].partDescp, "Bumpers of the finest quality, built by Maruti " );

db[2].partNo =3;
strcpy(db[2].partName, "Tyre");
db[2].partPrice=100;
db[2].partQuantity=23;
db[2].accountNo= 5445321;
strcpy(db[2].partDescp, "Michelin Tyres, made to last." );

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
	
	

	char res[1000]; //response to client's request
	
	int cmd, partNo;
	
	
	
	read(new_socket, &cmd, sizeof(cmd));
	
	printf("The cmd is : %d \n", cmd);
		
	read(new_socket, &partNo, sizeof(partNo));
		
	printf("The partNo is : %d \n", partNo);
	
	
	if(cmd<1 || cmd>5){
	
	strcpy(res, "Invalid Command!");
	
	}else if(partNo >3 || partNo <1){
	
	
	strcpy(res, "Part does not exist");
	
	
	}else if(cmd==1){
	
	//Search Procedure
	
	if(searchPart(db,partNo)){
	
	strcpy(res, "The part does exist");
		
	}else{
	
	strcpy(res, "The part does not exist");
	
	}
	
	}
	else if(cmd==2){
	//2- fetch partName

	strcpy(res, db[partNo-1].partName);	
	
	
	}else if(cmd==3){
	
	//3 - fetch quantity of parts available
	
	res[0]=db[partNo -1].partQuantity; //function to vonert to string in c
	
	
	}else if(cmd==4){
	
	//4 - fetch part description
	
	strcpy(res, db[partNo-1].partDescp);
	
	}else{
	
	//5 - fetch price of part
	
	res[0]=db[partNo -1].partPrice;
	
	}
	
	
	
	send(new_socket, &res, sizeof(res), 0);
	
	
	
	return 0;
}

