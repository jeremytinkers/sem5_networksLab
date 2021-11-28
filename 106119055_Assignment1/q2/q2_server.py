import socket		

# Defining BinarytoDecimal() function
def BinaryToDecimal(binary):
        
    binary1 = binary
    decimal, i, n = 0, 0, 0
    while(binary != 0):
        dec = binary % 10
        decimal = decimal + dec * pow(2, i)
        binary = binary//10
        i += 1
    return (decimal)   
 
def binaryToText(bin_data):
  
    print("The binary value is:", bin_data)
 
    str_data =' '
    
    for i in range(0, len(bin_data), 8):
        
        # slicing the bin_data from index range [0, 6]
        # and storing it as integer in temp_data
        temp_data = int(bin_data[i:i + 8])
        
        # passing temp_data in BinarytoDecimal() function
        # to get decimal value of corresponding temp_data
        decimal_data = BinaryToDecimal(temp_data)
        str_data = str_data + chr(decimal_data)
   
    print("The Binary value after string conversion is:",
        str_data)

    return (str_data)

try:
    serverSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # create a new socket object with the following parameters called serverSocket
except:
	print ("ERROR: Failed to create socket")
	exit()

port = 32000		

try:
	serverSocket.bind(('13.3.3.3', port)) #bind it to ethernet with a port of 32000
	
except socket.error as e:
	print ("ERROR: Failed to bind socket")
	exit()

print ("Waiting for client to send data ...")		
serverSocket.listen()	

clientConn,address = serverSocket.accept() # a new socket called clientConn is created and is used for 1-1 communciation bw this server and the client at the front of the queue

print ('Connection successful!')
dataFromClient = clientConn.recv(1024).decode()

print("From Client: {} ".format(dataFromClient))
modifiedData = binaryToText(dataFromClient)

print("Modified data: {} ".format(modifiedData))
clientConn.send(modifiedData.encode())

print ("Finished sending to client!")
clientConn.close()

