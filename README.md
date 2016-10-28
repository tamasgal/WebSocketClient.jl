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

The package name "DandelionWebSockets" has been renamed to a more generic name "WebSocketClient". The package has been updated for Julia 0.5 with Unicode support.

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
This will run the echo example script. You will see it sending 10,000 text messages and one binary message.
The web socket server will echo them back as text messages.
