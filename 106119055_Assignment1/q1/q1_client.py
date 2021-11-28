import socket

port_no = 32000
text = input("Enter the text:")

try:
	server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except:
	print ("ERROR: Failed to create socket")
	exit()

try:
	host_ip = socket.gethostbyname('localhost')
	print("Host IP address: %s" %(host_ip))
except:
	print ("ERROR: Failed to get host IP")
	exit()

server.connect((host_ip, port_no))
print("Success connecting to the server!")

print("Sending text to the server ...")
server.send(text.encode())

print("Waiting for result from the server ...")
result = server.recv(1024).decode()

print("Result from the server is: {}".format(result))
server.close()