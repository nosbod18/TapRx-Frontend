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
            Image(systemName: "pencil.and.list.clipboard").foregroundColor(Color(red: 237/255, green: 27/255, blue:36/255))
            Text("TapRx")
        }
            .font(.title2)
            .foregroundStyle(Color(red: 35/255, green: 64/255, blue: 142/255))
            .bold()
    }
}

#Preview {
    LogoView()
}
