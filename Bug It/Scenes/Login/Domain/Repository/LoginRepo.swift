//
//  LoginRepo.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import GoogleSignIn

protocol LoginRepo {
    
    func googleLogin(completion : @escaping (GIDSignInResult? , Error?)->Void )
    func getUserObject () -> Data?
}
