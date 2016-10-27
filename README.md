# WebSocketClient

## Origin

This Julia package is originally forked from https://github.com/dandeliondeathray/WebSocketClient.jl

## Purpose

The original WebSocketClient is a nice addition of a client side web socket library for Julia.

Julia is a great scientific programming tool. However, its networking functionality is very primitive.

We intend to extend WebSocketClient as a generic web socket client.

The typical use case is to attach one or more Julia applications to a "resource-tier" application server.
The resource-tier application server may be written in a general purpose programming language like Java.

## Refactoring

The package name "DandelionWebSockets" has been renamed to a more generic name "WebSocketClient". The package has been updated for Julia 0.5 with Unicode support.

## Usage

Please see the original README:

- [WebSocketClient](README-WebSocketClient.md)
