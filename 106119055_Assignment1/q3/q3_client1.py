import socket

client1 = socket.socket()
host = '127.0.0.1'
port = 2004 #play around with diff port nos?

print('Loading Client1 connection with server')
try:
    client1.connect((host, port))
    print("This is Client 1!")
except socket.error as e:
    print(str(e))

res = client1.recv(1024)
while True:
    dataUser = input('Do enter some data to send the server! ')
    client1.send(str.encode(dataUser))
    sendData = client1.recv(1024)
    print(sendData.decode('utf-8'))

client1.close()
