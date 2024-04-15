//
//  sheetTester.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/15/24.
//

import SwiftUI

struct sheetTester: View {
    @State private var showSheet: Bool = false
    
    var body: some View {
        Button("click me"){
            showSheet.toggle()
        }
        .fullScreenCover(isPresented: $showSheet){
            AboutMedicationPopup(isActive:$showSheet)
        }.transition(.identity)
    }
}

#Preview {
    sheetTester()
}
