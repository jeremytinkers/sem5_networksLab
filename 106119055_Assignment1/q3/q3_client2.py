import socket

client2 = socket.socket()
host = '127.0.0.1'
port = 2004 
print('Loading Client2 connection with server')
try:
    client2.connect((host, port))
    print("This is Client 2!")
except socket.error as e:
    print(str(e))

res = client2.recv(1024)
while True:
    dataUser = input('Do enter some data to send the server! ')
    client2.send(str.encode(dataUser))
    sendData = client2.recv(1024)
    print(sendData.decode('utf-8'))

client2.close()
