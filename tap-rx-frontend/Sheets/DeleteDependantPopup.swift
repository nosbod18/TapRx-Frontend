//
//  DeleteDependantPopup.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 4/16/24.
//

import SwiftUI
import FirebaseAuth

struct DeleteDependantPopup: View {
    @Binding var isActive: Bool
    @Binding var dependantID: String
    @ObservedObject var user: User
    
    func deleteDependant() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let url = URL(string: "https://taprx.xyz/users/\(user.uid)/dependants")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        user.getIDToken { idToken, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            
            guard let idToken = idToken else {
                return
            }
            
            request.setValue(idToken, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        print( "Network error: \(error.localizedDescription)")
                    }
                    return
                }
                
                if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response String: \(responseString ?? "Test")")

                    do {
                        let response = try JSONDecoder().decode(DeleteDependantById.self, from: data)
                        DispatchQueue.main.async {
                            if let success = response.success, success {
                                self.user.refresh()
                                isActive.toggle()
                            }
                        }
                    } catch {
                        print("Decoding error: \(error)")
                    }
                }
            }
            task.resume()
            self.user.refresh()
        }
    }
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button{
                    isActive.toggle()
                } label: {
                    Image(systemName:"xmark.square.fill")
                        .imageScale(.large)
                        .foregroundColor(Color.medicalGrey)
                }
            }.padding(0)

            Text("Delete Dependant")
                .font(.title2)
                .foregroundColor(.medicalDarkBlue)
                .fontWeight(.black)
            
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.medicalRed)
                .frame(height: 5)
            
            Text("Are you sure that you want to delete this dependant?")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.medicalDarkBlue)
        
            
            Button(action: deleteDependant) {
                Text("Confirm")
                    .fontWeight(.semibold)
                    .font(.subheadline)
            }
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 15)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.medicalRed)
            )
            .padding(.top,15)
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct DeleteDependantPopup_Previews: PreviewProvider {
    struct WrapperView: View {
        @State private var showSheet = true  // State to control the visibility
        @State private var dependantID = "-Nv5HRJXV9pDL1okR_oW"
        @ObservedObject var user = User()
        
        func login() {
            Auth.auth().signIn(withEmail: "drewclutes@gmail.com", password: "123456") { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                user.refresh()
            }
        }
        
        var body: some View {
            DeleteDependantPopup(isActive: $showSheet, dependantID: $dependantID, user: user)
                .onAppear{
                    login()
                }
        }
    }

    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
