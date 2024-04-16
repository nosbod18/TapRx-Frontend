//
//  chatgbtExample.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/15/24.
//

import SwiftUI

struct chatgbtExample: View {
    @State private var showingPopup = false

        var body: some View {
            ZStack {
                // Main content
                Button("Show Popup") {
                    withAnimation {
                        showingPopup.toggle()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                
                // Popup window
                if showingPopup {
                    // Background dimming
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showingPopup = false
                            }
                        }
                    
                    // Popup content
                    VStack {
                        Text("This is a popup")
                        Button("Close") {
                            withAnimation {
                                showingPopup = false
                            }
                        }
                    }
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                }
            }
        }
}

#Preview {
    chatgbtExample()
}
