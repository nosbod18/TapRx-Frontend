//
//  SettingsUserView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/2/24.
//

import SwiftUI

struct SettingsUserView: View {
    
    func addUser(){
        
    }
    
    var body: some View {
        VStack {
            Text("Authorized Users")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.medicalDarkBlue)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.medicalRed)
                .frame(height: 5)
                .padding(.top,-10)
                .padding(.bottom,5)

            
            AccountUserView(name: "Drew",relationship: "Guardian",date:"02/08/2002",color: 1.0)
            AccountUserView(name: "Ryan",relationship: "Sibling",date: "05/05/2004",color: 0.9)
            AccountUserView(name: "Jake",relationship: "Sibling",date:"10/02/2006",color: 0.8)
            AccountUserView(name: "Chad",relationship: "Parent",date: "04/14/1971",color: 0.7)
            Spacer()
            HStack{
                Spacer()
                Button(action: addUser){
                    HStack{
                        Image(systemName: "person.crop.circle.badge.plus")
                        Text("Add User")
                    }
                        .padding([.top,.bottom],4)
                        .padding([.leading,.trailing],7)
                }
                    .foregroundColor(.medicalRed)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color.medicalRed)
                    ).padding()
                Spacer()
            }
        }
            .padding([.leading,.trailing],25)
    }
}

#Preview {
    SettingsUserView()
}
