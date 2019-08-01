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
import CoreLocation

let manager = SocketManager(socketURL: URL(string: "http://localhost:3022/")!, config: [.log(false), .compress])
let socket = manager.defaultSocket

class SocketIOManager: ObservableObject {
    @Published var userRoom: Room = Room(id: "Connecting to server...", polyline: "", users: [])
    @Published var room: Room? = nil
    @Published var error: SocketError? = nil
    
    
    init() {
        // All socket listeners here
        
        socket.on(clientEvent: .connect) {data, ack in
            print("Connected to server")
            
            socket.emit("join", UIDevice.current.identifierForVendor!.uuidString)
        }
        
        socket.on("naive_attach") {data, ack in
            let room = Room(dictionary: data[0] as! [String : Any])
            self.userRoom = room
        }
        
        socket.on("room_attach") { data, ack in
            let response = data[0] as! [String: Any]
            
            if (response["success"] as! Bool) == true {
                self.room = Room(dictionary: response["room"] as! [String : Any])
            } else {
                self.error = SocketError(success: false, message: response["message"] as! String)
            }
        }
        
        socket.on("room_userjoin") { data, ack in
            let response = data[0] as! [String: Any]
            
            if (response["roomId"] as! String) == self.userRoom.id {
                self.userRoom.users.append(User(dictionary: response["user"] as! [String : Any]))
                print("user room")
            } else {
                self.room?.users.append(User(dictionary: response["user"] as! [String : Any]))
                print("guest room")
            }
        }
    }
    
    func joinRoom(_ roomId: String){
        socket.emit("room_attach", roomId)
    }
    
    func updateLocation(_ location: CLLocationCoordinate2D){
        socket.emit("update_location", [
            "latitude": location.latitude,
            "longitude": location.longitude
        ]) // Server will update socket_uuid position in all rooms
    }
    
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
