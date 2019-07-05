import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind(('localhost', 5000))
sock.listen()

while True:
    client, addr = sock.accept()
    print('Connection from', addr)

    while True:
        request = client.recv(4096)

        if not request:
            break
        else:
            response = 'Hello\n'.encode()
            client.send(response)


#nc localhost 5000