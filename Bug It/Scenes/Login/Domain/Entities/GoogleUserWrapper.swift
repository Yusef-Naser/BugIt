//
//  GoogleUserWrapper.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import Foundation
import GoogleSignIn

class GoogleUserWrapper: NSObject, NSCoding {
    var userID: String
    var idToken: String
    var accessToken: String
    var refreshToken: String?
    var fullName: String
    var givenName: String
    var familyName: String
    var email: String

    init(user: GIDGoogleUser) {
        self.userID = user.userID ?? ""
        self.idToken = user.idToken?.tokenString ?? ""
        self.accessToken = user.accessToken.tokenString
        self.refreshToken = user.refreshToken.tokenString
        self.fullName = user.profile?.name ?? ""
        self.givenName = user.profile?.givenName ?? ""
        self.familyName = user.profile?.familyName ?? ""
        self.email = user.profile?.email ?? ""
    }

    // MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(userID, forKey: "userID")
        coder.encode(idToken, forKey: "idToken")
        coder.encode(accessToken, forKey: "accessToken")
        coder.encode(refreshToken, forKey: "refreshToken")
        coder.encode(fullName, forKey: "fullName")
        coder.encode(givenName, forKey: "givenName")
        coder.encode(familyName, forKey: "familyName")
        coder.encode(email, forKey: "email")
    }

    required init?(coder: NSCoder) {
        self.userID = coder.decodeObject(forKey: "userID") as? String ?? ""
        self.idToken = coder.decodeObject(forKey: "idToken") as? String ?? ""
        self.accessToken = coder.decodeObject(forKey: "accessToken") as? String ?? ""
        self.refreshToken = coder.decodeObject(forKey: "refreshToken") as? String
        self.fullName = coder.decodeObject(forKey: "fullName") as? String ?? ""
        self.givenName = coder.decodeObject(forKey: "givenName") as? String ?? ""
        self.familyName = coder.decodeObject(forKey: "familyName") as? String ?? ""
        self.email = coder.decodeObject(forKey: "email") as? String ?? ""
    }
    
}
