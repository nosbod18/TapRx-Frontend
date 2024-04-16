//
//  sheetTester.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/15/24.
//

import SwiftUI

struct sheetTester: View {
    @State private var showSheet: Bool = false
    @State private var med = "-Nv4zIQD4996vlxbeq25"
    var body: some View {
        ZStack{
            Color.gray.edgesIgnoringSafeArea(.all)
            Button("click me"){
                showSheet.toggle()
            }
            .sheet(isPresented: $showSheet) {
                AboutMedicationPopup(isActive: $showSheet,medication_id: $med)
            }
        }
        
    }
}

#Preview {
    sheetTester()
}
