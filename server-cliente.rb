require 'socket'

socket = UDPSocket.new
socket.connect('localhost', 2100) 
while line=gets
    socket.puts line
    response,address = socket.recvfrom(1024)
    puts response
end

socket.close