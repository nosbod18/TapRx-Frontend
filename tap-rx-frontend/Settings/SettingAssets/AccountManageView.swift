//
//  AccountManageView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/2/24.
//

import SwiftUI

struct AccountManageView: View {
    private var label: String
    private var value: String
    private var type: String
    
    @State private var toggle = true
    init(label: String,value: String,type: String){
        self.label = label
        self.value = value
        self.type = type
    }
    
    var body: some View {
        HStack{
            Text("\(self.label):")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.medicalDarkBlue)
            
            Text("\(self.value)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.medicalLightBlue)
            Spacer()
            if(self.type == "edit"){
                Image(systemName:"square.and.pencil")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.medicalLightBlue)
            }
            if(self.type == "toggle"){
                Toggle(isOn: $toggle){
                    Text("")
                }
                    .tint(.red)
                    .toggleStyle(SwitchToggleStyle(tint: .medicalLightBlue))
            }
        }
    }
}

#Preview {
    AccountManageView(label: "Name",value: "Drew Clutes",type: "toggle")
}
