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

let manager = SocketManager(socketURL: URL(string: "http://localhost:3022/")!, config: [.log(true), .compress])
let socket = manager.defaultSocket


class SocketIOManager: BindableObject {
    let didChange = PassthroughSubject<SocketIOManager,Never>()
    static let sharedInstance = SocketIOManager()
    
    
    var room: Room = Room(id: "randomString", polyline: "", users: []) { // WIP
        didSet {
            print("new data incoming")
            self.didChange.send(self)
        }
    }
    
    
    init() {
        // All sockets here
        
        socket.on(clientEvent: .connect) {data, ack in
            print("Connected to server")
            
            socket.emit("join", UIDevice.current.identifierForVendor!.uuidString)
//            socket.emit("join", [
//                "room": "roomId",
//                "uuid": UIDevice.current.identifierForVendor!.uuidString
//            ])
//            self.messagePublisher.send(data[0] as! Message)
        }
        
        socket.on("naive_attach") {data, ack in
            let room = Room(dictionary: data[0] as! [String : Any])
            
            self.room = room
//            print(room)
            
//            room.id = room.id as! String
//            room.users = [ User(id: room.users[0].id, name: room.users[0].name, color: room.users[0].color, lastUpdated: room.users[0].lastUpdated, joinedAt: room.users[0].joinedAt, coordinates: Coordinates(latitude: room.users[0].coordinates.latitude, longitude: room.users[0].coordinates.longitude), transportation: room.users[0].transportation, isOwner: room.users[0].coordinates.isOwner) ]
//            print(ack)
//            self.messagePublisher.send(data[0] as! Message)
        }
    }
    
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
