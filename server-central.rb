require 'socket'

socket = UDPSocket.new
socket.bind("",2100)
loop{
        data, sender = socket.recvfrom(1024)
        sender_ip = sender[3]
        sender_port = sender[1]
        puts "Dados recebidos do cliente #{sender_ip}:#{sender_port}: #{data}"
        socket.send("Mensagem de resposta", 0, sender_ip, sender_port)
}
socket.close