//
//  SocketManager.swift
//  LocMe
//
//  Created by Joshua Tabakhoff on 21/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SocketIO

let manager = SocketManager(socketURL: URL(string: "http://localhost:3022/")!, config: [.log(false), .compress])
let socket = manager.defaultSocket

class SocketIOManager: BindableObject {
    let willChange = PassthroughSubject<SocketIOManager,Never>()
    
    var userRoom: Room = Room(id: "Connecting to server...", polyline: "", users: []) { // WIP
        willSet {
            print("new data incoming")
            self.willChange.send(self)
        }
    }
    var room: Room? { // WIP
        willSet {
            print("new data incoming")
            self.willChange.send(self)
        }
    }
    
    var error: SocketError? {
        didSet {
            print("error happened from incoming data")
            print(error)
            self.willChange.send(self)
        }
    }
    
    
    init() {
        // All socket listeners here
        
        socket.on(clientEvent: .connect) {data, ack in
            print("Connected to server")
            
            socket.emit("join", UIDevice.current.identifierForVendor!.uuidString)
//            socket.emit("join", [
//                "room": "roomId",
//                "uuid": UIDevice.current.identifierForVendor!.uuidString
//            ])
        }
        
        socket.on("naive_attach") {data, ack in
            let room = Room(dictionary: data[0] as! [String : Any])
            self.userRoom = room
        }
        
        socket.on("room_attach") { data, ack in
            let response = data[0] as! [String: Any]
            
            if (response["success"] as! Bool) == true {
                print(response["message"]!)
                print(response["room"]!)
                
                self.room = Room(dictionary: response["room"] as! [String : Any])
            } else {
                self.error = SocketError(success: false, message: response["message"] as! String)
            }
        }
    } // AYWCVX
    
    func joinRoom(_ roomId: String){
        socket.emit("room_attach", roomId)
    }
    
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
