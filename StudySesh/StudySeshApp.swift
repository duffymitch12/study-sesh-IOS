//
//  StudySeshApp.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/26/24.
//

import SwiftUI
import Firebase
class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct StudySeshApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authenticationManager = AuthenticationManager()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authenticationManager.isLoadingUser {
                    ProgressView("Loading...")
                } else if authenticationManager.isAuthenticated {
                    HomeView().environmentObject(authenticationManager)

                } else {
                    SignUpView().environmentObject(authenticationManager)

                }
            }
        }
    }
}
