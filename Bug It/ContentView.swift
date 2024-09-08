//
//  ContentView.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    
    @State var user : GIDGoogleUser?
    
    var body: some View {
        VStack {
            Button(action: signIn) {
                Text("Sign In with Google")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    func signIn() {
        guard  let root = UIApplication.shared.rootViewController else {
            return
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: root, hint: nil , additionalScopes: ["https://www.googleapis.com/auth/spreadsheets"] ) { result, error in
      //  GIDSignIn.sharedInstance.signIn(withPresenting: root) { result, error in
            // Handle sign-in result
            self.user = result?.user
            print(result?.user.accessToken.tokenString ?? "Error Access Token")
        }
        
    }
    
    
}

#Preview {
    ContentView()
}
