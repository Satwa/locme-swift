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
    var coords: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: coords?.latitude ?? 0, longitude: coords?.longitude ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }
}


struct MapView : View {
    var roomId: String
    @Binding var showRoom: Bool
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationView{
            ZStack{
                Map(coords: locationManager.lastKnownLocation?.coordinate)
                HStack{
                    Text("Latitude: " + (locationManager.lastKnownLocation?.coordinate.latitude.description ?? "nil"))
                    Spacer()
                    Text("Longitude: " + (locationManager.lastKnownLocation?.coordinate.longitude.description ?? "nil"))
                }
                .padding()
                
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle(Text("Room #" + roomId), displayMode: .inline)
                .navigationBarItems(trailing: Button("OK"){
                    self.showRoom = !self.showRoom
                })
        }
    }
}
