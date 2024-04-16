//
//  GetMedEventByIdAPITest.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/12/24.
//

import SwiftUI
import FirebaseAuth

struct GetMedEventByIdAPITest: View {
    @State private var email: String = "drewclutes@gmail.com"
    @State private var password: String = "123456"
    @State private var userID: String = ""
    
    @State private var med_id: String = ""
    @State private var event_id: String = ""
    
    func get_med_event_by_id(){
        Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            

            
            if let user = result?.user {
                self.userID = user.uid
                let url = URL(string: "https://taprx.xyz/medications/\(self.med_id)/events/\(self.event_id)")!
                var request = URLRequest(url: url)
                print(url)
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
                                    let response = try JSONDecoder().decode(GetMedEventById.self, from: data)
                                    DispatchQueue.main.async {
                                        print(response)
                                        
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
        VStack {
            TextField("Medication Id",text: $med_id).padding([.top,.bottom],20)
            TextField("Event Id",text: $event_id).padding([.top,.bottom],20)
        
            Button(action: get_med_event_by_id) {
                Label("Get Med Event", systemImage: "folder.badge.plus")
            }
        }.padding(10).background(.gray)
    }
}

#Preview {
    GetMedEventByIdAPITest()
}
