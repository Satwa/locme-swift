//
//  RoomModel.swift
//  LocMe
//
//  Created by Joshua Tabakhoff on 21/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

struct Room: Hashable, Codable, Identifiable {
    var id: String
    var polyline: String
//    var directions: [Any] // Directions are stored locally
    
    var users: [User] // max. 2 for now
}
extension Room {
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? "defaultString"
        self.polyline = dictionary["polyline"] as? String ?? ""
        var decoding_users: [User] = []
        for i in 0..<(dictionary["users"] as! NSArray).count {
            let nontyped = (dictionary["users"] as! NSArray)[i] as! NSDictionary
            var user = User(
                id: nontyped["id"] as! String,
                name: nontyped["name"] as! String,
                color: nontyped["color"] as! String,
                lastUpdated: (nontyped["lastUpdated"] as! NSNumber).stringValue,
                joinedAt: (nontyped["joinedAt"] as! NSNumber).stringValue,
                coordinates: Coordinates(dictionary: (nontyped["coordinates"] as! [String : Any])),
                transportation: Transportation(rawValue: nontyped["transportation"] as! String) ?? Transportation.walking,
                isOwner: nontyped["isOwner"] as! Bool
            )
            decoding_users.append(user)
//            decoding_users.append(User(dictionary: (((dictionary["users"] as! NSArray)[i] as! NSArray))))
        }
        self.users = decoding_users
    }
}


struct User: Hashable, Codable, Identifiable {
    var id: String // uuid
    var name: String
    var color: String
    var lastUpdated: String
    var joinedAt: String
    
    var coordinates: Coordinates
    var transportation: Transportation
    
    var isOwner: Bool
}
extension User{
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? "defaultString"
        self.name = dictionary["name"] as? String ?? "defaultString"
        self.color = dictionary["color"] as? String ?? "defaultString"
        
        self.lastUpdated = dictionary["lastUpdated"] as? String ?? "0"
        self.joinedAt = dictionary["joinedAt"] as? String ?? "0"
        
        self.coordinates = Coordinates(dictionary: dictionary["coordinates"] as! [String : Any])
        self.transportation = Transportation(rawValue: dictionary["transportation"] as! String) ?? .walking
        
        self.isOwner = dictionary["isOwner"] as? Bool ?? true
    }
}

struct Message: Hashable, Codable {
    var success: Bool
    var data: String? // JSON room || roomCode => empty room
    var message: String? // if !success
}

enum Transportation: String, Codable{
    case walking
    case driving
    case cycling
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}
extension Coordinates{
    init(dictionary: [String: Any]) {
        self.latitude = dictionary["latitude"] as? Double ?? 0
        self.longitude = dictionary["longitude"] as? Double ?? 0
    }
}


struct SocketError: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    
    var success: Bool
    var message: String
}
extension SocketError{
    init(dictionary: [String: Any]) {
        self.success = dictionary["success"] as! Bool
        self.message = dictionary["message"] as! String
    }
}


struct AlertInformation {
    var title: String
    var message: String
    var primaryButton: Alert.Button
    var secondaryButton: Alert.Button?
}
