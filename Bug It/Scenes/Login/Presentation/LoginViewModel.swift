//
//  LoginViewModel.swift
//  Bug It
//
//  Created by yusef naser on 08/09/2024.
//

import Foundation

class LoginViewModel : BaseViewModel {
    
    @Published var useCase : LoginUserCase
    
    init(useCase: LoginUserCase = LoginUserCase(repo: LoginRepository())) {
        self.useCase = useCase
    }
    
    @MainActor
    func googleLogin (successCompletion : @escaping (Bool)->Void ) {
        useCase.googleLogin { success , error in
            if let success = success {
                successCompletion(success)
            }
        }
    }
    
}
