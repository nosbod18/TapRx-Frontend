//
//  SettingsHomeView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/2/24.
//

import SwiftUI

enum SettingsToolbarItems: Int, CaseIterable {
    case authorized_users = 0
    case home
    case history
    
    var icon: String{
        switch self {
            case .authorized_users:
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
                SettingsAuthorizedUserView(user: user)
                    .tag(SettingsToolbarItems.authorized_users)
                
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

//struct SettingsHomeView: View {
//    var body: some View {
//        VStack{
//            TabView{
//                Group {
//                    SettingsAccountView()
//                        .tabItem {
//                            Label("Account",systemImage: "person")
//                        }
//                    
//                    
//                    SettingsUserView()
//                        .tabItem {
//                            Label("Authorized Users",systemImage: "person.badge.plus")
//                        }
//                            
//                    
//                    SettingsHistoryView()
//                        .tabItem {
//                            Label("History",systemImage: "clock")
//                        }
//                }
//            }
//            Spacer()
//        }
//            .ignoresSafeArea()
//            .padding(.bottom,10)
//            .padding(.top,-100.0)
//    
//    }
//}

#Preview {
    SettingsHomeView(user: User())
}
