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
        let view = MKMapView(frame: .zero)
        view.tintColor = .purple
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true
        
        let coordinate = CLLocationCoordinate2D(
            latitude: coords?.latitude ?? 0, longitude: coords?.longitude ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }
}


struct MapView : View {
    var roomId: String
    @Binding var showRoom: Bool
    
    @EnvironmentObject var socketManager: SocketIOManager
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationView{
            ZStack{
                Map(coords: locationManager.lastKnownLocation?.coordinate)
                HStack{
                    VStack(alignment: .leading){
                        Spacer()
                        Text("Latitude: " + (locationManager.lastKnownLocation?.coordinate.latitude.description ?? "nil"))
                        Text("Longitude: " + (locationManager.lastKnownLocation?.coordinate.longitude.description ?? "nil"))
                    }
                    Spacer()
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
