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
                
                if let user = result?.user {
                    self.userID = user.uid
                    let url = URL(string: "https://taprx.xyz/users/\(self.userID)")!
                    var request = URLRequest(url: url)
                    request.httpMethod="GET"
                    user.getIDToken { idToken, error in
                        if let error = error {
                            print("error: \(error.localizedDescription)")
                        } else if let idToken = idToken {
                            request.setValue(idToken, forHTTPHeaderField: "Authorization")
                            
                            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                                if let error = error {
                                    DispatchQueue.main.async {
                                        print( "Network error: \(error.localizedDescription)")
                                    }
                                } else if let data = data {
                                    let responseString = String(data: data, encoding: .utf8)
                                    print("Response String: \(responseString ?? "Test")")

                                    do {
                                        let response = try JSONDecoder().decode(APIResponse.self, from: data)
                                        DispatchQueue.main.async {
                                            if response.success == true{
                                                print("TEST")
                                                let user_data = response.data
                                                self.user.update(with: user_data)
                                            }
                                        }
                                    } catch {
                                        print("Decoding error: \(error)")
                                    }
                                }
                            }
                            task.resume()
                        }
                    }
                    
                }
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
