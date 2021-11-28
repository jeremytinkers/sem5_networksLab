import socket
import os
from _thread import *

serverSocket = socket.socket()
host = '127.0.0.1'
port = 2004
noThreads = 0
clientCount =1
try:
    serverSocket.bind((host, port))
except socket.error as e:
    print(str(e))

print('Server Socket is listening..')
serverSocket.listen(5)

def multiThreaded(connection):
    connection.send(str.encode('Server is working!'))
    while True:
        data = connection.recv(2048)
        response = 'Server message: ' + data.decode('utf-8')
        if not data:
            break
        connection.sendall(str.encode(response))
    connection.close()

while True:
    Client, address = serverSocket.accept()
    print("Connected to Client {}".format(clientCount))
    clientCount+=1
    print('Address: ' + address[0] + ':' + str(address[1]))
    start_new_thread(multiThreaded, (Client, ))
    noThreads += 1
    print('Thread Number handling this client: ' + str(noThreads))
serverSocket.close()