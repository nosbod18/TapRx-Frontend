//
//  LogoView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/1/24.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        // TapRx Logo
        HStack{
            Image(systemName: "pencil.and.list.clipboard").foregroundColor(Color.medicalRed)
            Text("TapRx").foregroundColor(Color.medicalDarkBlue)
        }
            .font(.title2)
            .bold()
    }
}

#Preview {
    LogoView()
}
