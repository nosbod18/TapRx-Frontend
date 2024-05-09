//
//  SettingsAccountView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/2/24.
//

import SwiftUI
import FirebaseAuth

struct SettingsAccountView: View {
    @ObservedObject var user: User
    @Binding var update: String
    @Binding var showModal: Bool
    @Binding var logOut: Bool
    
    init(user: User, update_property: Binding<String>,showSheet: Binding<Bool>,logout: Binding<Bool>) {
        self.user = user
        self._update = update_property
        self._showModal = showSheet
        self._logOut = logout
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            if let _ = Auth.auth().currentUser {
                logOut = false
            } else {
                user.clear()
                logOut = true
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func getEmail()->String {
        if let user = Auth.auth().currentUser {
            return user.email ?? ""
        } else {
            return ""
        }
    }
    
    var body: some View {
        VStack {
            Text("Account Settings")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.medicalDarkBlue)
            
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.medicalRed)
                .frame(height: 5)
                .padding(.top,-10)
                .padding(.bottom,5)

            HStack{
                Text("Name:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.medicalDarkBlue)
                
                Text("\(user.first_name) \(user.last_name)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.medicalLightBlue)
                Spacer()
                Button {
                    self.update = "name"
                    showModal.toggle()
                } label: {
                    HStack {
                        Image(systemName:"square.and.pencil")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.medicalLightBlue)
                    }
                }
                    
            
            }
            
            HStack{
                Text("Email:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.medicalDarkBlue)
                
                Text("\(getEmail())")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.medicalLightBlue)
                Spacer()
                Button {
                    self.update = "email"
                    showModal.toggle()
                } label: {
                    HStack {
                        Image(systemName:"square.and.pencil")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.medicalLightBlue)
                    }
                }
            }
            
            HStack{
                Text("Phone:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.medicalDarkBlue)
                
                Text("\(user.phone ?? "")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.medicalLightBlue)
                Spacer()
                Button {
                    self.update = "phone"
                    showModal.toggle()
                } label: {
                    HStack {
                        Image(systemName:"square.and.pencil")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.medicalLightBlue)
                    }
                }
            }
            
            HStack{
                Text("Password:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.medicalDarkBlue)
                
                Text("******")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.medicalLightBlue)
                Spacer()
                    Button {
                    self.update = "password"
                    showModal.toggle()
                } label: {
                    HStack {
                        Image(systemName:"square.and.pencil")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.medicalLightBlue)
                    }
                }
            
            }
            
            Spacer()
            ZStack{
                ZStack(alignment: .center) {
                    Capsule()
                        .stroke(Color.medicalRed)
                        .frame(width: 200, height: 35)
                    
                    Button {
                        signOut()
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.xmark")
                                .renderingMode(.template)
                                .foregroundColor(.medicalRed)
                            
                            Text("Sign Out")
                                .foregroundColor(.medicalRed)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.top,.bottom], 10)
            }
        }
        .frame(width: WIDTH)
        .padding(.top, 30)
    }
}

struct SettingsAccountView_Previews: PreviewProvider {
    struct WrapperView: View {
        @ObservedObject var user: User = User()
        @State private var logout = false
        @State private var sheet = false
        @State private var prop = ""

        func login() {
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
            NavigationStack{
                SettingsAccountView(user: user, update_property: $prop,showSheet: $sheet,logout: $logout)
                    .onAppear{ login() }
                
                
            }
            
            
        }
    }
    
    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
