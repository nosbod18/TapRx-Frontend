//
//  FormFieldView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/1/24.
//

import SwiftUI

struct FormFieldView: View {
    let placeholder: String
    
    init(placeholder: String){
        self.placeholder = placeholder
    }
    
    var body: some View {
        /*
        TextField("", text: nil, prompt: Text("\(placeholder)")
            .foregroundColor(Color(red: 56/255, green: 83/255, blue: 153/255)))
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding([.leading,.trailing],15)
            .padding([.top,.bottom],8)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color(red: 35/255, green: 64/255, blue: 142/255), lineWidth: 2)
            )
         */
        Text("Form View").foregroundColor(Color.medicalRed)
    }
}

#Preview {
    FormFieldView(placeholder: "Password")
}
