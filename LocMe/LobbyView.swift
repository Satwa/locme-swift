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
    
    var body: some View {
        ZStack{
            Color.orange.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(alignment: .center){
                    Text("Rejoindre une room")
                    TextField($roomId, placeholder: Text("Entrez votre code room"))
                    Button("Rejoindre"){
                        self.showRoom = !self.showRoom
                    }.accentColor(.white)
                }
                .presentation(showRoom ? Modal(MapView(roomId: roomId, showRoom: $showRoom)){
                    print("dismissed")
                    self.showRoom = !self.showRoom
                } : nil)
            }
            .padding()
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
