//
//  MainView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 2/2/24.
//

import SwiftUI
import FirebaseAuth

let WIDTH = UIScreen.main.bounds.width * 0.90

struct MainView: View {
    @ObservedObject var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        UserView(user: user)
    }
}

struct MainView_Previews: PreviewProvider {
    struct WrapperView: View {
        @ObservedObject var user: User = User()
        @State private var userID: String = ""
        
        func login(){
            Auth.auth().signIn(withEmail: "drewclutes@gmail.com", password: "123456") { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                //test
                
                user.refresh()
            }
        }
        var body: some View {
            MainView(user: user)
                .onAppear{ login() }
            
        }
    }
    
    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
