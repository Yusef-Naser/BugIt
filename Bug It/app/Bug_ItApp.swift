//
//  Bug_ItApp.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import SwiftUI
import UIKit
import GoogleSignIn

class AppDelegate: NSObject , UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

extension UIApplication {
    var rootViewController: UIViewController? {
        guard let window = connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .filter({ $0.isKeyWindow }).first else {
            return nil
        }
        return window.rootViewController
    }
}


@main
struct Bug_ItApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            LoginView()
        }
    }
}
