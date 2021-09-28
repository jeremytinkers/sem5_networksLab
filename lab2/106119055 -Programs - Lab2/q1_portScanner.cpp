#include <stdio.h>
#include <string.h>
#include<unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include<cstring>
#include<iostream>

using namespace std;

int main(int argc, char *argv[])
{
    if(argc != 4)
    {
        cout<<"Invalid Entry. Do try again with this format : (PROGRAM EXE) (HOSTNAME/IP ADDRESS) (START PORT) (END PORT)"<<endl;
        exit(EXIT_FAILURE);
    }

    int status;
    addrinfo hints, *servinfo; 

    memset(&hints, 0, sizeof(hints)); // make sure the struct is empty
    hints.ai_family = AF_UNSPEC;     // serves both IPv4 or IPv6
    hints.ai_socktype = SOCK_STREAM; // TCP stream sockets

    int startP = atoi(argv[2]);
    int endP = atoi(argv[3]);

    for(int port = startP; port <= endP; port++)
    {
        
        char portstr[50];
        sprintf(portstr, "%d", port);

        if((status = getaddrinfo(argv[1], portstr, &hints, &servinfo)) != 0)
        {
            cout<<"Error with function -> getaddrinfo() "<<endl;
            exit(EXIT_FAILURE);
        }

        int sock = socket(servinfo->ai_family, servinfo->ai_socktype, servinfo->ai_protocol);
        
        if(sock < 0)
        {
            cout<<"Socket creation failed"<<endl;
            exit(EXIT_FAILURE);
        }

        struct timeval timeout;
        timeout.tv_sec  = 1;  
        timeout.tv_usec = 0;

        setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));
        int portIsOpen = connect(sock, servinfo->ai_addr, servinfo->ai_addrlen);
        
          if(portIsOpen == -1)
        {
            cout<<"Port is closed. Server is not listening here."<<port<<endl;
        }
        else if(portIsOpen == 0)
        {
            cout<<"Port "<<port<<" is open. Server is LISTENING here!"<<endl;
        }

     

        freeaddrinfo(servinfo);
        close(sock);
    }

    return 0;
}
