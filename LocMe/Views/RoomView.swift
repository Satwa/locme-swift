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
            print("location update")
            
//          mapView.removeAnnotations(mapView.annotations)
            
        }
    }
    
    let mapDelegate = MapDelegate()
    @ObservedObject var socketManager: SocketIOManager
    @ObservedObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> MKMapView {
        mapDelegate.socketManager = socketManager
        
        let view = MKMapView(frame: .zero)
        view.delegate = mapDelegate
        view.tintColor = .purple
        
        view.showsCompass = false
        view.userTrackingMode = .followWithHeading
        view.showsUserLocation = true
        
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let coords: CLLocationCoordinate2D? = locationManager.lastKnownLocation?.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coords ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), span: span)
        

        let user2 = MKPointAnnotation()
        user2.title = "User 2 (WIP)"
        user2.coordinate.latitude = socketManager.room?.users.last?.coordinates.latitude ?? 0
        user2.coordinate.longitude = socketManager.room?.users.last?.coordinates.longitude ?? 0
        view.addAnnotation(user2)
        print(user2.coordinate)
        
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
            .navigationBarTitle(Text("Room #\(socketManager.room?.id ?? "")"), displayMode: .inline) // TODO: This doesn't work if room = userRoom
            .navigationBarItems(trailing: Button("OK"){
                self.socketManager.room = nil
            })
        }
    }
}
