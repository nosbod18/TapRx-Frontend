//
//  ToolbarView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 2/2/24.
//

import SwiftUI

enum ToolbarItems: Int, CaseIterable {
    case medications = 0
    case home
    case calendar
    
    var icon: String {
        switch self {
            case .medications:
                return "pill.fill"
            case .home:
                return "house"
            case .calendar:
                return "calendar"
        }
    }
}

struct ToolbarItemView: View {
    let systemImageName: String
    let isActive: Bool
    
    init(systemImageName: String, isActive: Bool) {
        self.systemImageName = systemImageName
        self.isActive = isActive
    }
    
    var body: some View {
        Section {
            Image(systemName: systemImageName)
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundStyle(isActive ? Color.medicalRed : Color.medicalLightBlue)
        }
        .frame(width: 60, height: 60)
        .padding(.horizontal, 20)
        .padding(.bottom, -10)
    }
}

struct UserView: View {
    @ObservedObject var user: User
    @State var selectedTab = ToolbarItems.home

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                MedicationView(user: user)
                    .tag(ToolbarItems.medications)
                
                HomeView(user: user)
                    .tag(ToolbarItems.home)
                
                MonthlyCalendarView(calendar: Calendar(identifier: .gregorian))
                    .tag(ToolbarItems.calendar)
            }
            HStack {
                ForEach(ToolbarItems.allCases, id: \.self) { item in
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
                NavigationLink(destination: SettingsHomeView(user: user)) {
                    Image(systemName: "line.3.horizontal")
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
    UserView(user: User())
}
