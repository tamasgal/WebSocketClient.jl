using HttpServer
import WebSockets

wsh = WebSockets.WebSocketHandler() do req,client
    println("Connected to: " * req.resource);

    while isopen(client)
        msg = read(client)
        s = String(msg)
        if (s == "bye")
          break
        end
        println(String(msg))
        write(client, s)
    end
    println("Disconnected");
  end

server = Server(wsh)

try
  run(server,8087)
catch e
  println(e)
end
