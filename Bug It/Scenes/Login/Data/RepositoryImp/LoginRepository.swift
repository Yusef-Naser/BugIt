//
//  LoginRepository.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import Foundation
import GoogleSignIn

class LoginRepository : LoginRepo {
    
    func googleLogin(completion : @escaping (GIDSignInResult? , Error?)->Void ) {
        guard  let root = UIApplication.shared.rootViewController else {
            return
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: root, hint: nil , additionalScopes: ["https://www.googleapis.com/auth/spreadsheets"] ) { result, error in
            
            completion(result , error )
            // Handle sign-in result
//            self.user = result?.user
//            globalUser = self.user
//            print(result?.user.accessToken.tokenString ?? "Error Access Token")
        }
    }
    
    func getUserObject () -> Data? {
        KeychainManger.shared.getItem(key: KeychainManger.GOOGLE_USER)
    }
    

}
