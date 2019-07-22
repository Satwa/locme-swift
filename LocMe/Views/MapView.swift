//
//  MapView.swift
//  LocMe
//
//  Created by Joshua Tabakhoff on 10/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct Map: UIViewRepresentable {
    
//    var lastPosition: CLLocation?
    var locationManager: CLLocationManager = CLLocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        

        
        if let location = locationManager.location {
            view.showsUserLocation = true
        }else{
            print("no location")
            // Ask for Authorisation from the User.
            locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            locationManager.requestWhenInUseAuthorization()
            
        }
        
        if CLLocationManager.locationServicesEnabled() {
            //        self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            
            //Temporary fix: App crashes as it may execute before getting users current location
            //Try to run on device without DispatchQueue
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                let locValue:CLLocationCoordinate2D = self.locationManager.location!.coordinate
                print("CURRENT LOCATION = \(locValue.latitude) \(locValue.longitude)")
                
                let coordinate = CLLocationCoordinate2D(
                    latitude: locValue.latitude, longitude: locValue.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                view.setRegion(region, animated: true)
                
            })
        }
    }
    
}


struct MapView : View {
    var roomId: String
    @Binding var showRoom: Bool
    
    var body: some View {
        NavigationView{
            ZStack{
                Map()
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle(Text("Room #" + roomId), displayMode: .inline)
                .navigationBarItems(trailing: Button("OK"){
                    self.showRoom = !self.showRoom
                })
        }
    }
}
