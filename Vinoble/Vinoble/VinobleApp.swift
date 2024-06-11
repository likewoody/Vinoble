//
//  VinobleApp.swift
//  Vinoble
//
//  Created by Woody on 6/4/24.
//

import SwiftUI
import ComposableArchitecture
//import FirebaseCore

// Init Setting for using Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
    return true
  }
}

@main
struct VinobleApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
