//
//  MapView.swift
//  LocMe
//
//  Created by Joshua Tabakhoff on 10/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI
import Combine
import MapKit
import CoreLocation

struct Map: UIViewRepresentable {
    @ObservedObject var socketManager: SocketIOManager
    @ObservedObject var locationManager: LocationManager
    
    class MapDelegate: NSObject, MKMapViewDelegate {
        weak var socketManager: SocketIOManager?
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            for view in views {
                if view.annotation is MKUserLocation {
                    view.canShowCallout = false
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            socketManager?.updateLocation(userLocation.coordinate)
        }
    }
    
    let mapDelegate = MapDelegate()
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        
        view.delegate = mapDelegate
        mapDelegate.socketManager = socketManager
        view.tintColor = .purple
        
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true
        view.userTrackingMode = .followWithHeading
        
        let coordinate = CLLocationCoordinate2D(
            latitude: locationManager.lastKnownLocation?.coordinate.latitude ?? 0, longitude: locationManager.lastKnownLocation?.coordinate.longitude ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        view.setRegion(region, animated: true)
    }
}



// MARK - SwiftUI View

struct RoomView : View {
    @EnvironmentObject var socketManager: SocketIOManager
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationView{
            ZStack{
                Map(socketManager: socketManager, locationManager: locationManager)
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
            .navigationBarTitle(Text("Room #\(socketManager.room?.id ?? "")"), displayMode: .inline)
            .navigationBarItems(trailing: Button("OK"){
                self.socketManager.room = nil
            })
        }
    }
}
