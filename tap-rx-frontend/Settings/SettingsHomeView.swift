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
            HStack{
                LogoView()
                Spacer()
            }
                .padding([.leading,.trailing],25)
                .padding(.bottom,10)
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
                .toolbarBackground(Color.medicalGrey, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
                
            }
            
        }
        .padding(.bottom,10)
            
        Spacer()
    }
}

#Preview {
    SettingsHomeView()
}
