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
                            self.$socketManager.error.value = SocketError(success: false, message: "Vous ne pouvez pas rejoindre votre propre room")
                        }else{
                            self.$socketManager.error.value = SocketError(success: false, message: "Le code d'une room est de 6 caractères")
                        }
                    }
                }
                .alert(item: $socketManager.error){ error in
                    Alert(
                        title: Text("Erreur serveur"),
                        message: Text(self.socketManager.error?.message ?? "err"),
                        dismissButton: .default(Text("OK")){
                            self.socketManager.error = nil
                            self.showAlert = false
                        })
                }
                .sheet(item: $socketManager.room){ room in
                    RoomView().environmentObject(self.locationManager).environmentObject(self.socketManager)
                }
                Spacer()
            }
            .padding()
        }
        .foregroundColor(.white)
        .accentColor(.white)
        .tapAction {
            UIApplication.shared.keyWindow?.endEditing(true)
        } // LEFDMZ
    }
}

#if DEBUG
struct LobbyView_Previews : PreviewProvider {
    static var previews: some View {
        LobbyView()
    }
}
#endif
