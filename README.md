# WebSocketClient

## Origin

This Julia package is originally forked from https://github.com/dandeliondeathray/WebSocketClient.jl

The original WebSocketClient is a nice addition of a client side web socket library for Julia.

## Purpose

Julia is a great scientific programming tool. However, its networking functionality is limited.

We intend to extend WebSocketClient as a generic web socket client.

The typical use case is to attach one or more Julia applications to a "resource-tier" application server.
The resource-tier application server may be written in a general purpose programming language like Java.

## Refactoring

1. The package name "DandelionWebSockets" has been renamed to a more generic name "WebSocketClient".
2. The package has been updated for Julia 0.5 with Unicode support - "utf8" is updated to "String".
3. The reconnect.jl has been removed. It is the responsibility of the user application to decide whether to reconnect.
4. A true end-to-end client-server test replaces the mock network_test.jl.
5. Minor bug fix for client.jl - makes input string and byte array immutable.

## Usage

Please see the original README:

- [WebSocketClient](README-DandelionWebSockets.md)

## Installation

To install this package, just start "julia" at the command line and do
```
Pkg.clone("https://github.com/ericcwlaw/WebSocketClient.jl")
```

## Running the web socket echo example

In the example folder, there are two files, echo.jl and simple_ws_server.jl.
You may try the example with the following:

Install "WebSockets" server package if you have not done so.
```
julia> Pkg.add("WebSockets")
```

Open a terminal and start the web socket server.
```
$ julia simple_ws_server.jl
```
The web socket server will run in the foreground. You can stop it using control-C.

To run the example echo.jl
```
$ julia echo.jl
```
This will run the echo example script. It will send 100 text messages and one binary message.
The web socket server will echo them back as text messages.

When echo.jl finishes, it will tell the web socket server to stop.
To rerun the example, start the server and then the client again.

## Pre-requisites for julia tests

Please install "DataStructures" and "FactCheck". The end_to_end_test.jl uses the Queue object (from DataStructures) to send control signals and messages because the WebSocketClient is event-driven. FactCheck is used as the test framework.
