import socket

port_no = 32000
text = input("Enter the binary string:")

try:
	server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except:
	print ("ERROR: Failed to create socket")
	exit()

try:
	eth_ip = "13.3.3.3"
	print("Ethernet IP address: %s" %(eth_ip))
except:
	print ("ERROR: Failed to get Eth IP")
	exit()

server.connect((eth_ip, port_no))
print("Success connecting to the server!")

print("Sending text to the server ...")
server.send(text.encode())

print("Waiting for result from the server ...")
result = server.recv(1024).decode()

print("Result from the server is: {}".format(result))
server.close()
