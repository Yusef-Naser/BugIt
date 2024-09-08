//
//  LoginUserCase.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import GoogleSignIn

class LoginUserCase {
    
    private var repo : LoginRepo
    
    init(repo: LoginRepo) {
        self.repo = repo
    }
    
    func googleLogin (success : @escaping (Bool? , Error? )->Void ) {
        repo.googleLogin { result , error in
            // save User Object here
            guard let user = result?.user else {
                success(nil , error )
                return
            }
            guard let data = self.archiveGoogleUser(user: user) else {
                success(nil , error )
                return
            }
            let b = KeychainManger.shared.saveItem(item: data , key: KeychainManger.GOOGLE_USER)
            success(b , nil )
        }
    }
    
    func getUserObject () -> GoogleUserWrapper? {
        guard let data = repo.getUserObject() else {
            return nil
        }
        guard let user = self.unarchiveGoogleUser(data: data) else {
            return nil
        }
        return user
    }
    
    private func archiveGoogleUser(user: GIDGoogleUser) -> Data? {
        let wrapper = GoogleUserWrapper(user: user)
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: wrapper, requiringSecureCoding: false)
            return data
        } catch {
            print("Failed to archive GIDGoogleUser: \(error)")
            return nil
        }
    }
    
    private func unarchiveGoogleUser(data: Data) -> GoogleUserWrapper? {
        do {
            if let wrapper = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? GoogleUserWrapper {
                return wrapper
            }
        } catch {
            print("Failed to unarchive GIDGoogleUser: \(error)")
        }
        return nil
    }
    
}
