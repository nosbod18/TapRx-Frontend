//
//  tap_rx_frontendApp.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 1/30/24.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
}

@main
struct TapRxApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
          FirebaseApp.configure()
      }
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
