using WebSocketClient
using FactCheck

include("mock.jl")
include("mock_test.jl")
include("utilities.jl")

include("core_test.jl")
include("ping_test.jl")
include("client_logic_test.jl")
include("taskproxy_test.jl")
include("glue_test.jl")
include("handshake_test.jl")
include("ws_client_test.jl")
include("integration_test.jl")
include("end_to_end_test.jl")
