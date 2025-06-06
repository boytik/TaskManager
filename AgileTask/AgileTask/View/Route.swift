//
//  AgileTaskApp.swift
//  AgileTask
//
//  Created by Евгений on 28.05.2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Route: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("Auth") private var isLoggedIn: Bool = false
    var body: some Scene {
        WindowGroup {
            if isLoggedIn == true {
                MainView()
            } else {
                AuthView()
            }
//            AuthView()
        }
    }
}
