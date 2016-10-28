using DataStructures
q = Queue(Any)

import Requests: URI

using WebSocketClient
import WebSocketClient: on_text, on_binary,
                        state_connecting, state_open, state_closing, state_closed

type EchoHandler <: WebSocketHandler
    client::WSClient
    stop_channel::Queue{Any}
end

# These are called when you get text/binary frames, respectively.
on_text(::EchoHandler, s::String)         = println("Received text: $s")
on_binary(::EchoHandler, data::Vector{UInt8}) = println("Received data: $data")

# These are called when the WebSocket state changes.

state_closing(::EchoHandler)    = println("State: CLOSING")
state_connecting(::EchoHandler) = println("State: CONNECTING")

# Called when the connection is open, and ready to send/receive messages.
function state_open(handler::EchoHandler)
    println("State: OPEN")

    @async send_test_messages(q, handler)

    # Send some text frames, and a binary frame.
    @async begin

        for i in 1:10000
            println("Sending: ", i)
            enqueue!(q, "hello - " * string(i));
            yield()
        end

        send_binary(handler.client, b"Hello, binary!")

        # Signal that we're done sending all messages.
        stop(handler.client)
    end
end

function send_test_messages(q::Queue, handler::EchoHandler)
         println("STARTED")
         while true
           if !isempty(q)
             s = dequeue!(q);
             send_text(handler.client, s)
           end
           yield()
          end
       end

function state_closed(handler::EchoHandler)
    println("State: CLOSED")
    # Signal the script that the connection is closed.
    enqueue!(handler.stop_channel, "closed") #put
end

# Create a WSClient, which we can use to connect and send frames.
handler = EchoHandler(WSClient(), Queue(Any))

uri = URI("ws://127.0.0.1:8087/ws/hello")
println("Connecting to $uri... ")

try
  wsconnect(handler.client, uri, handler)
  println("Connected.")
catch ex
  enqueue!(handler.stop_channel, string(ex))
end

while true
  if !isempty(handler.stop_channel)
    println(dequeue!(handler.stop_channel))
    break
  end
  yield()
end
