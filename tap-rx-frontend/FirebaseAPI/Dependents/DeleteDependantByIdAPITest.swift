//
//  DeleteDependantsByIdAPITest.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/9/24.
//

import SwiftUI
import FirebaseAuth

struct DeleteDependantsByIdAPITest: View {
    @State private var email: String = "drewclutes@gmail.com"
    @State private var password: String = "123456"
    @State private var userID: String = ""
    @State private var dependant_id: String = ""
    
    func delete_dependant(){
        Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            

            
            if let user = result?.user {
                self.userID = user.uid
                let url = URL(string: "https://taprx.xyz/dependants/\(self.dependant_id)")!
                var request = URLRequest(url: url)
                request.httpMethod="DELETE"
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
                                    let response = try JSONDecoder().decode(GetDependants.self, from: data)
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
            TextField("dependant id",text: $dependant_id).padding([.top,.bottom],20)
            Button(action: delete_dependant) {
                Label("Delete Dependant", systemImage: "folder.badge.plus")
            }
        }.background(.gray).padding(10)
    }
}

#Preview {
    DeleteDependantsByIdAPITest()
}
