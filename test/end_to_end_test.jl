using FactCheck

using DataStructures
using HttpServer
import WebSockets
import Requests: URI
using WebSocketClient
import WebSocketClient: on_text, on_binary,
                        state_connecting, state_open, state_closing, state_closed

type TestWsHandler <: WebSocketHandler
    client::WSClient
    signal::Queue{Any}
end

on_text(handler::TestWsHandler, s::String) = enqueue!(handler.signal, s)
on_binary(handler::TestWsHandler, data::Vector{UInt8}) = enqueue!(handler.signal, data)
state_connecting(handler::TestWsHandler) = enqueue!(handler.signal, "connecting")
state_open(handler::TestWsHandler) =  enqueue!(handler.signal, "opened")
state_closing(handler::TestWsHandler) = enqueue!(handler.signal, "closing")
state_closed(handler::TestWsHandler) = enqueue!(handler.signal, "closed")

wsh = WebSockets.WebSocketHandler() do req,client
    println("Begin end-to-end web socket test at " * req.resource);

    while isopen(client)
        msg = read(client)
        s = String(msg)
        if (s == "bye") break end
        # It seems to be a limitation of the WebSocket server library that turns all input into bytes.
        # Therefore, echo text message by detecting a prefix that is added by the client.
        if contains(s, "binary")
          write(client, msg)
        else
          write(client, s)
        end
    end
    println("End-to-end web socket test finishes");
  end

# run web socket server in the background
server = Server(wsh)
@async run(server,8087)

facts("End-to-end web socket tests") do
  handler = TestWsHandler(WSClient(), Queue(Any))
  uri = URI("ws://127.0.0.1:8087/ws/hello")

    context("Start") do
      wsconnect(handler.client, uri, handler)
      sleep(0.5)
      @fact isempty(handler.signal) --> false
      @fact dequeue!(handler.signal) --> "connecting"
      @fact isempty(handler.signal) --> false
      @fact dequeue!(handler.signal) --> "opened"
    end

    context("Send text") do
      text = "Hello world"
      send_text(handler.client, text)
      sleep(0.1)
      @fact isempty(handler.signal) --> false
      data = dequeue!(handler.signal)
      @fact data --> text
    end

    context("Send binary") do
      msg = b"Hello binary!"
      send_binary(handler.client, msg)
      sleep(0.1)
      @fact isempty(handler.signal) --> false
      data = dequeue!(handler.signal)
      @fact data --> msg
    end

    context("Stop") do
      # stop server
      send_text(handler.client, "bye")
      sleep(0.1)
      @fact isempty(handler.signal) --> false
      @fact dequeue!(handler.signal) --> "closing"
      @fact isempty(handler.signal) --> false
      @fact dequeue!(handler.signal) --> "closed"
    end

end
