//
//  LocationManager.swift
//  LocMe
//
//  Created by Joshua Tabakhoff on 10/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI
import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate, BindableObject {
    private let locManager: CLLocationManager
    var didChange = PassthroughSubject<LocationManager, Never>()
    
    var lastKnownLocation: CLLocation? {
        didSet {
            didChange.send(self)
        }
    }
    
    override init() {
        self.locManager = CLLocationManager()
        super.init()
        self.startUpdating()
    }
    
    func startUpdating() {
        self.locManager.delegate = self
        self.locManager.requestWhenInUseAuthorization()
        self.locManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}
