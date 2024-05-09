//
//  UpdateUserPopup.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 5/8/24.
//

import SwiftUI
import FirebaseAuth


struct UpdateUserPopup: View {
    @State private var text: String = ""
    @State private var text2: String = ""
    @State private var isName: Bool = false

    @ObservedObject var user = User()
    
    @Binding var isActive: Bool
    @Binding var property: String
    
    init(user: User,property: Binding<String>,showSheet: Binding<Bool>){
        self.user = user
        self._property = property
        self._isActive = showSheet
    }
    
    func updateName(){
        self.isName = self.property == "name"
    }
    
    func update(){
        switch(property){
            case "name":
                user.first_name = text
                user.last_name = text2
                user.populate_user()
            case "email":
                guard let user = Auth.auth().currentUser else {
                    return
                }

                // Update the password
                user.updateEmail(to: text) { error in
                    if let _ = error {
                        return
                    } else {
                        text = ""
                        text2 = ""
                        isActive = false
                        return
                    }
                }            
            case "phone":
                user.phone = text
                user.populate_user()
            case "password":
                guard let user = Auth.auth().currentUser else {
                    return
                }

                // Update the password
                user.updatePassword(to: text) { error in
                    if let _ = error {
                        return
                    } else {
                        text = ""
                        text2 = ""
                        isActive = false
                        return
                    }
                }
            default:
                return
        }
        
        text = ""
        text2 = ""
        isActive = false
    }
    
    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            VStack {
                    HStack{
                        Spacer()
                        Button{
                            isActive.toggle()
                        } label: {
                            Image(systemName:"xmark.square.fill")
                                .resizable()
                                .frame(width:20,height:20)
                                .foregroundColor(Color.medicalGrey)
                        }
                    }.padding(0)
                    Text("Update \(property)")
                        .font(.title2)
                        .foregroundColor(.medicalDarkBlue)
                        .fontWeight(.black)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.medicalRed)
                        .frame(height: 5)
                        .padding(.bottom,10)
                    
                    
                TextField("", text: $text, prompt: Text(isName ? "first name" : property)
                        .foregroundColor(Color.medicalLightBlue) + Text(" *").foregroundColor(Color.medicalRed))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.medicalDarkBlue, lineWidth: 2)
                    ).padding(.bottom,5)
                    
                    if isName{
                        TextField("", text: $text2, prompt: Text("last name")
                            .foregroundColor(Color.medicalLightBlue) + Text(" *").foregroundColor(Color.medicalRed))
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding([.leading,.trailing],15)
                        .padding([.top,.bottom],8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.medicalDarkBlue, lineWidth: 2)
                        )
                    }
                    Button(action: update){
                        Text("Update Account")
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
                .onAppear {
                    updateName()
                }
                
        }
    }
}

struct UpdateUserPopup_Previews: PreviewProvider {
    struct WrapperView: View {
        @State private var showSheet = true  // State to control the visibility
        @State private var prop = "name"
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
            UpdateUserPopup(user: user, property: $prop, showSheet: $showSheet)
                .onAppear() {
                    login()
                }
        }
    }

    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
