//
//  ContentView.swift
//  LocMe
//
//  Created by Joshua Tabakhoff on 10/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct LobbyView : View {
    
    @EnvironmentObject var socketManager: SocketIOManager
    @EnvironmentObject var locationManager: LocationManager
    
    @State var showRoom: Bool = false
    @State var roomId: String = ""
    @State var showAlert: Bool = false
    
    @State var alertInformation: AlertInformation?

    
    var body: some View {
        ZStack{
            Color.purple.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                Text(socketManager.userRoom.id).bold()
                Spacer()
                Text("Rejoindre une room")
                TextField($roomId, placeholder: Text("Entrez votre code room"))
                    .padding(.top)
                    .padding(.bottom)
                Button("Rejoindre"){
                    if(self.roomId.count == 6 && self.roomId != self.socketManager.userRoom.id){
                        self.socketManager.joinRoom(self.roomId)
                    }else{
                        if self.roomId == self.socketManager.userRoom.id {
                            self.alertInformation = AlertInformation(title: "Code room incorrect", message: "Vous ne pouvez pas rejoindre votre propre room", primaryButton: .default(Text("OK")), secondaryButton: nil)
                        }else{
                            self.alertInformation = AlertInformation(title: "Code room incorrect", message: "Le code d'une room est de 6 caractères", primaryButton: .default(Text("OK")), secondaryButton: nil)
                        }
                    }
                    
                    self.showAlert = true
                }
                .presentation($showAlert){
                    self.alertInformation != nil ? Alert(
                            title: Text(alertInformation!.title),
                            message: Text(alertInformation!.message),
                            dismissButton: alertInformation!.primaryButton
                        ) : ( self.socketManager.error != nil ? Alert(
                            title: Text("Erreur serveur"),
                            message: Text(self.socketManager.error?.message ?? "err"),
                            dismissButton: .default(Text("OK")){
                                self.socketManager.error = nil
                                self.showAlert = false
                            }) : Alert(title: Text("Information serveur"), message: Text(self.socketManager.error?.message ?? "ok"), dismissButton: .default(Text("OK")){
                                    self.showAlert = false
                                    self.showRoom = true
                                    MapView(roomId: self.roomId, showRoom: self.$showRoom).environmentObject(self.locationManager).environmentObject(self.socketManager)
                                })
                    )
                    // alertInformation ? alert : ( socketError ? alert : mapView )
                }
                
//                    Modal(MapView(roomId: self.roomId, showRoom: self.$showRoom).environmentObject(self.locationManager).environmentObject(self.socketManager))
//                    {
//                        print("dismissed")
//                        self.showRoom = !self.showRoom
//                    }
                
//                Alert(title: Text("Information serveur"), message: Text(self.socketManager.error?.message ?? "ok"), dismissButton: .default(Text("OK")))
                Spacer()
            }
            .padding()
        }
        .foregroundColor(.white)
        .accentColor(.white)
        .tapAction {
            UIApplication.shared.keyWindow?.endEditing(true)
        }
    }
}

#if DEBUG
struct LobbyView_Previews : PreviewProvider {
    static var previews: some View {
        LobbyView()
    }
}
#endif
