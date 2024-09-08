//
//  LoginView.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import Foundation
import SwiftUI
import GoogleSignIn

struct LoginView : View {
    
    @StateObject var loginViewodel = LoginViewModel()
    
    var body: some View {
        ZStack {
            Button(action: signIn) {
                Text("Sign In with Google")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
    }
    
    
    private func signIn() {
        
        loginViewodel.googleLogin { success in
            
        }
        
    }
    
}
