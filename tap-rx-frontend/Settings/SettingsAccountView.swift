//
//  SettingsAccountView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/2/24.
//

import SwiftUI

struct SettingsAccountView: View {
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
            AccountManageView(label: "Name",value: "Drew Clutes",type: "edit")
            AccountManageView(label: "Email",value: "drewclutes@gmail.com",type: "edit")
            AccountManageView(label: "Phone",value: "314-960-8228",type: "edit")
            AccountManageView(label: "Password",value: "****************",type: "edit")
            AccountManageView(label: "Doctor",value: "Dr. John Adams",type: "edit")
            AccountManageView(label: "Auto-Refill Prescription",value: "",type: "toggle")
            AccountManageView(label: "Allow Anonymous Data Usage",value: "",type: "toggle")
            Spacer()
        }
            .padding([.leading,.trailing],25)
        
        
        
    }
}

#Preview {
    SettingsAccountView()
}
