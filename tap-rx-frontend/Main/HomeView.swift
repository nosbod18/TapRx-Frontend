//
//  ContentView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 1/30/24.
//

import SwiftUI

struct Medicine: Identifiable {
    var id: UUID
    var name: String
    var dosage: Int
    var bottleDescription: String
    var time: Date
}

struct MedicinePreview: View {
    let item: Medicine
    let scale: Double

    let height = 75.0

    init(item: Medicine, scale: Double) {
        self.item = item
        self.scale = scale
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.medicalDarkBlue.opacity(scale))
                .frame(height: self.height)
            
            HStack {
                Text(item.time, style: .time)
                    .font(.title3)
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.medicalRed.opacity(scale))
                    .frame(width: 2, height: self.height * 0.90)
                
                VStack(alignment: .leading) {
                    Text(item.name)
                        .foregroundColor(.white.opacity(scale))
                        .font(.title2)
                    
                    Spacer()
                    
                    Text("\(item.dosage)mg | \(item.bottleDescription)")
                        .foregroundColor(.medicalGrey.opacity(scale))
                        .font(.footnote)
                }
                .padding(.vertical, 18)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        }
    }
}

enum TabbedItems: Int, CaseIterable {
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

struct DetailedMedicationsView: View {
    var body: some View {
        Text("This is the medications view")
    }
}

struct CalendarView: View {
    var body: some View {
        Text("This is the calendar view")
    }
}

struct HomeView: View {
    @State private var username = "<Test>"

    let medications = [
        Medicine(id: UUID(), name: "Medicine 1", dosage: 20, bottleDescription: "Orange Bottle", time: Date()),
        //Medicine(id: UUID(), name: "Medicine 2", dosage: 40, bottleDescription: "Orange Bottle", time: Date()),
        //Medicine(id: UUID(), name: "Medicine 3", dosage: 60, bottleDescription: "Orange Bottle", time: Date()),
        //Medicine(id: UUID(), name: "Medicine 4", dosage: 80, bottleDescription: "Orange Bottle", time: Date()),
    ]
    
    var body: some View {
        VStack {
            
            // Logo and menu icons
            HStack {
                LogoView()
                Spacer()
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .frame(width: 25, height: 20)
                    .foregroundColor(.medicalRed)
                    .padding(.top, 5)
            }
            
            // Welcome message
            Section {
                Text("Welcome, \(username)!")
                    .font(.largeTitle)
                    .foregroundColor(.medicalRed)
                    .fontWeight(.black)
            }
            .padding([.top, .bottom], 30)
            
            // Todays medications and date
            Section {
                Text("Today's Medications:")
                    .font(.title2)
                    .foregroundColor(.medicalDarkBlue)
                    .fontWeight(.black)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.medicalRed)
                    .frame(height: 5)
                
                Text(Date.now, style: .date)
                    .font(.title2)
                    .foregroundColor(.medicalLightBlue)
            }
            
            
            // Medication list and add medication button
            List {
                Section {
                    ForEach(0 ..< medications.count, id: \.self) { index in
                        MedicinePreview(item: medications[index], scale: 1.0 - 0.1 * Double(index))
                    }
                    
                    ZStack(alignment: .center) {
                        Capsule()
                            .stroke(Color.medicalRed)
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: 35)
                        
                        HStack {
                            Image(systemName: "plus")
                                .renderingMode(.template)
                                .foregroundColor(.medicalRed)
                            
                            Text("Add Medication")
                                .foregroundColor(.medicalRed)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                    
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .padding(.top, 10)

        }
        .padding(.horizontal, 25)
    }
}

struct TabItemView: View {
    let imageName: String
    let isActive: Bool
    
    init(imageName: String, isActive: Bool) {
        self.imageName = imageName
        self.isActive = isActive
    }
    
    var body: some View {
        Section {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 35, height: 35)
        }
        .frame(width: 60, height: 60)
        .padding(.horizontal, 15)
        .background(isActive ? Color.medicalGrey : .clear)
        .cornerRadius(20)
    }
}

struct MainView: View {
    @State var selectedTab = 1
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                DetailedMedicationsView()
                    .tag(0)

                HomeView()
                    .tag(1)

                CalendarView()
                    .tag(2)
            }

            HStack {
                ForEach(TabbedItems.allCases, id: \.self) { item in
                    Button {
                        selectedTab = item.rawValue
                    } label: {
                        TabItemView(imageName: item.icon, isActive: (selectedTab == item.rawValue))
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.85, height: 70)
            .background(Color.medicalGrey.opacity(0.5))
            .cornerRadius(25)
        }
    }
}

#Preview {
    MainView()
}
