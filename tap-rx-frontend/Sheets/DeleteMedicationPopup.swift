//
//  DeleteMedicationPopup.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/15/24.
//

import SwiftUI
import FirebaseAuth

struct DeleteMedicationPopup: View {
    @Binding var isActive: Bool
    @Binding var medication_id: String
    @ObservedObject var user: User
    
    @State private var userID = ""
    
    func delete_medication(){
        if let user = Auth.auth().currentUser {
            self.userID = user.uid
            let url = URL(string: "https://taprx.xyz/medications/\(self.medication_id)")!
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
                                let response = try JSONDecoder().decode(DeleteMedById.self, from: data)
                                DispatchQueue.main.async {
                                    if(response.success == true){
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
        Text("Delete Medication")
            .font(.title2)
            .foregroundColor(.medicalDarkBlue)
            .fontWeight(.black)
        
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.medicalRed)
            .frame(height: 5)
        
        Text("Are you sure that you want to delete this medication?")
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundColor(Color.medicalDarkBlue)
    
        
        Button(action: delete_medication){
            Text("Confirm")
                .fontWeight(.semibold)
                .font(.subheadline)
        }
            .padding([.top,.bottom],10)
            .padding([.leading,.trailing],15)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.medicalRed)
            )
            .padding(.top,15)
        
    }
    .frame(width: UIScreen.main.bounds.width*0.8)
    .padding(20)
    .background(Color.white)
    .cornerRadius(20)
    .shadow(radius: 20)
}
    

}

struct DeleteMedicationPopup_Previews: PreviewProvider {
    struct WrapperView: View {
        @State private var showSheet = true  // State to control the visibility
        @State private var medication_id = "-Nv4zIQD4996vlxbeq25"
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
            DeleteMedicationPopup(isActive: $showSheet,medication_id: $medication_id, user: user).onAppear{
                login()
            }
        }
    }

    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
