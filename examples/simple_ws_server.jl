using HttpServer
import WebSockets

wsh = WebSockets.WebSocketHandler() do req,client
    println("Connected to: " * req.resource);

    while isopen(client)
        msg = read(client)
        # all messages are read as byte array here
        s = String(msg)
        if (s == "bye")
          break
        end
        println(String(msg))
        # However, the write method can send string or byte array
        write(client, s)
    end
    println("Disconnected");
    # this will close the web socket server
    close(server.http.sock)
  end

server = Server(wsh)

try
  run(server,8087)
catch e
  println(e)
end
