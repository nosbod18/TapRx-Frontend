//
//  SettingsHomeView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/2/24.
//

import SwiftUI

enum SettingsToolbarItems: Int, CaseIterable {
    case dependants = 0
    case home
    case history
    
    var icon: String{
        switch self {
            case .dependants:
                return "person.badge.plus.fill"
            case .home:
                return "person.fill"
            case .history:
                return "clock.fill"
        }
    }
}

struct SettingsHomeView: View {
    @ObservedObject var user: User
    @State var selectedTab = SettingsToolbarItems.home

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                SettingsDependantsView(user: user)
                    .tag(SettingsToolbarItems.dependants)
                
                SettingsAccountView(user: user)
                    .tag(SettingsToolbarItems.home)
                
                SettingsHistoryView()
                    .tag(SettingsToolbarItems.history)
            }
            HStack {
                ForEach(SettingsToolbarItems.allCases, id: \.self) { item in
                    Button {
                        selectedTab = item
                    } label: {
                        ToolbarItemView(systemImageName: item.icon, isActive: (selectedTab == item))
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                LogoView()
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: UserView(user: user)) {
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 25, height: 20)
                        .foregroundColor(.medicalRed)
                        .padding(.top, 5)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SettingsHomeView(user: User())
}
