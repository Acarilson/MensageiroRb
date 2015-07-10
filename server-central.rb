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
        if (data[0] == "REG" and data.count == 3)
            rs_dom_ip = dbh.execute("select * from pclocal where dominio = '" + data[1] + "' or ip = '" + data[2] + "'")
            if (rs_dom_ip.count != 0)
                socket.send("REGFALHA", 0, sender_ip, sender_port)
            else
                dbh.execute('insert into pclocal (dominio, ip) values ("' + data[1] + '", "' + data[2] + '")')
                socket.send("REGOK", 0, sender_ip, sender_port)
            end
        elsif (data[0] == "IP" and data.count == 2)
            rs_dom = dbh.execute("select * from pclocal where dominio = '" + data[1] + "'")
            if (rs_dom.count != 0)
                    rs_dom.fetch(:all, :Struct).each do |row|
                    socket.send("IPOK " + row.ip, 0, sender_ip, sender_port)
                end
            else
                socket.send("IPFALHA", 0, sender_ip, sender_port)
            end
        else
            socket.send("FALHA", 0, sender_ip, sender_port)
        end
}

socket.close
dbh.disconnect