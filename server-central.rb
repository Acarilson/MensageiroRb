require 'socket'
require 'rdbi-driver-sqlite3'

dbh = RDBI.connect(:SQLite3, :database => "bd.db")
socket = UDPSocket.new
socket.bind("",2100)
loop{
        data, sender = socket.recvfrom(1024)
        sender_ip = sender[3]
        sender_port = sender[1]
        puts "Dados recebidos do cliente #{sender_ip}:#{sender_port}: #{data}"

        #Verificar comando
        data = data.split
        if (data[0] == "REG")
        	dbh.execute('insert into pclocal (dominio, ip) values ("' + data[1] + '", "' + data[2] + '")')
        	socket.send("REGOK", 0, sender_ip, sender_port)
        elsif (data[0] == "IP")
        	socket.send("IP", 0, sender_ip, sender_port)
        else
        	socket.send("FALHA", 0, sender_ip, sender_port)
        end
}

socket.close
dbh.disconnect