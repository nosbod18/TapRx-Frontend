//
//  SettingsHomeView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/2/24.
//

import SwiftUI

struct SettingsHomeView: View {
    var body: some View {
        VStack{
            TabView{
                Group {
                    SettingsAccountView()
                        .tabItem {
                            Label("Account",systemImage: "person")
                        }
                    
                    
                    SettingsUserView()
                        .tabItem {
                            Label("Authorized Users",systemImage: "person.badge.plus")
                        }
                            
                    
                    SettingsHistoryView()
                        .tabItem {
                            Label("History",systemImage: "clock")
                        }
                }
            }
            Spacer()
        }
            .ignoresSafeArea()
            .padding(.bottom,10)
            .padding(.top,-100.0)
    
    }
}

#Preview {
    SettingsHomeView()
}
