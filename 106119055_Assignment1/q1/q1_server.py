import socket			

def strToBinary(dataFromClient):
	binaryForm = ' '.join(format(ord(i),'08b') for i in dataFromClient)
	return binaryForm

try:
    serverSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # create a new socket object with the following parameters called serverSocket
except:
	print ("ERROR: Failed to create socket")
	exit()

port = 32000		

try:
	serverSocket.bind(('localhost', port)) #bind it to localhost with a port of 32000
	
except socket.error as e:
	print ("ERROR: Failed to bind socket")
	exit()

print ("Waiting for client to send data ...")		
serverSocket.listen()	

clientConn,address = serverSocket.accept() # a new socket called clientConn is created and is used for 1-1 communciation bw this server and the client at the front of the queue

print ('Connection successful!')
dataFromClient = clientConn.recv(1024).decode()

print("From Client: {} ".format(dataFromClient))
modifiedData = strToBinary(dataFromClient)

print("Modified data: {} ".format(modifiedData))
clientConn.send(modifiedData.encode())

print ("Finished sending to client!")
clientConn.close()

