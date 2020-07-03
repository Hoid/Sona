//
//  StreamsApi.swift
//  Sona
//
//  Created by Tyler Cheek on 6/27/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation
import Starscream

class StreamsManager : WebSocketDelegate {
    
    var socket: WebSocket
    var isConnected: Bool
    
    init() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let signedInUser = appDelegate.authorizationManager.signedInUser!
        
        isConnected = false
        let url = URL(string: "ws://sonastreaming.us-east-1.elasticbeanstalk.com:5001")!
        let request = URLRequest(url: url)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        isConnected = true
    }
    
    deinit {
      socket.disconnect()
      socket.delegate = nil
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("Websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("Websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
        
    }
    
    func handleError(_ error: Error?) {
        socket.disconnect()
    }
    
    func sendMessage(_ message: String) {
      socket.write(string: message)
    }
    
    public func websocketDidConnect(_ socket: Starscream.WebSocket) {
        print("Websocket connected.")
    }
    
    public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?) {
        print("Websocket disconnected. Error: \(String(describing: error))")
    }
    
    /**
    Example JSON structure:
     {
       "type": "message", // change this type to give a different structure
       "data": {
         "time": 1472513071731,
         "text": ":]",
         "author": "iPhone Simulator",
         "color": "orange"
       }
     }
     */
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
        guard let data = text.data(using: .utf16),
          let jsonData = try? JSONSerialization.jsonObject(with: data),
          let jsonDict = jsonData as? [String : Any],
          let messageType = jsonDict["type"] as? String else {
            return
        }

        if messageType == "message",
          let messageData = jsonDict["data"] as? [String: Any],
          let messageAuthor = messageData["author"] as? String,
          let messageText = messageData["text"] as? String {

          messageReceived(messageText, senderName: messageAuthor)
        }
    }
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
        guard let jsonData = try? JSONSerialization.jsonObject(with: data),
                let jsonDict = jsonData as? [String : Any],
                let messageType = jsonDict["type"] as? String else {
            print("Could not decode JSON data in websocketDidReceiveData(_:data:)")
            return
        }

        if messageType == "message",
                let messageData = jsonDict["data"] as? [String: Any],
                let messageAuthor = messageData["author"] as? String,
                let messageText = messageData["text"] as? String {
            messageReceived(messageText, senderName: messageAuthor)
        }
    }
    
    private func messageReceived(_ messageText: String, senderName: String) {
        print("Message received: \(messageText), from \(senderName)")
    }
    
}
