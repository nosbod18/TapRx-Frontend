//
//  SettingsUserView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/2/24.
//

import SwiftUI

struct SettingsUserView: View {
    var body: some View {
        VStack {
            Text("Authorized Users")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.medicalDarkBlue)
            
            Spacer()
        }
    }
}

#Preview {
    SettingsUserView()
}
