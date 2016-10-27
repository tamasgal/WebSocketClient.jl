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

## Julia package manager

To install this package, just start "julia" at the command line and do 
```
Pkg.add("WebSocketClient")
```

To test, write a Java web socket echo server listening to "ws://127.0.0.1:8087/ws/hello".
"cd" to the example folder and enter "julia echo.jl"

## Package registration

This refactoring work is contributed by Eric Law, cloud platform architect, platform team, SRI International at https://www.sri.com

It has been registered with the Julia package system on 10/27/2016.

