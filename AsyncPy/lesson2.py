import socket
from select import select


monitor = []

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind(('localhost', 5000))
sock.listen()

def accept_connection(sock):
    client, addr = sock.accept()
    print('Connection from', addr)
    monitor.append(client)

def send_messages(client):
    request = client.recv(4096)

    if request:
        response = 'Hello\n'.encode()
        client.send(response)
    else:
        client.close()

def event_loop():
    while True:
        read_ready, _, _ = select(monitor, [], []) # read, write, errors
        print(read_ready)
        for ss in read_ready:
            if ss is sock:
                accept_connection(ss)
            else:
                send_messages(ss)

if __name__ == '__main__':
    monitor.append(sock)
    event_loop()
    #accept_connection(sock)

#nc localhost 5000