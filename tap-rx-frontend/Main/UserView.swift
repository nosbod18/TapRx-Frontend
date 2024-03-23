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
    
    var icon: String{
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
    @State var selectedTab = ToolbarItems.home

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                MedicationView(with: SAMPLE_MEDICATIONS)
                    .tag(ToolbarItems.medications)
                
                HomeView(with: SAMPLE_MEDICATIONS)
                    .tag(ToolbarItems.home)
                
                ContentView(calendar: Calendar(identifier: .gregorian))
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
    }
}

#Preview {
    UserView()
}
