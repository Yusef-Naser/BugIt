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
    
    @EnvironmentObject var appRouter : AppRouter
    
    var body: some View {
        ZStack {
            
            VStack {
                
                Text("Please Login With Google")
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding([.top] , 16)
                    .padding()
                
                Text("Login wuth google to get access to update google sheet")
                    .font(.caption2)
                    .foregroundColor(.black)
                
                Button(action: signIn) {
                    Text("Sign In with Google")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding([.top] , 32)
                .padding()
                
                Spacer()
            }
            
        }
    }
    
    
    private func signIn() {
        
        loginViewodel.googleLogin { success in
            appRouter.pushTo(.uploadScreen)
        }
        
    }
    
}

#Preview {
    LoginView()
}
