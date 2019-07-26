//
//  ContentView.swift
//  LocMe
//
//  Created by Joshua Tabakhoff on 10/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct LobbyView : View {
    
    @State var roomId: String = ""
    @State var showRoom: Bool = false
    @EnvironmentObject var socketManager: SocketIOManager
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        ZStack{
            Color.purple.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                Spacer()
                Text("Rejoindre une room")
                TextField($roomId, placeholder: Text("Entrez votre code room"))
                    .padding(.top)
                    .padding(.bottom)
                Button("Rejoindre"){
                    self.showRoom = !self.showRoom
                }
                Spacer()
            }
            .presentation(showRoom ? Modal(MapView(roomId: roomId, showRoom: $showRoom).environmentObject(locationManager).environmentObject(socketManager)){
                print("dismissed")
                self.showRoom = !self.showRoom
            } : nil)
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
