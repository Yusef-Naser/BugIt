//
//  BugItViewModel.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation

class BugItViewModel : BaseViewModel {
    
    @Published var useCase = BugItUseCase()
    
    
    func uploadImage (description : String , image : Data , success : @escaping (String?)->Void) {
        loading = true
        Task {
            do {
                let data = try await useCase.uploadImage(description: description, image: image)
                
                loading = false
                success(data?.data?.link)
                self.showAlert(message: "Success" )
            }catch {
                loading = false
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func updateSheet (description : String , imageLink : String , success : @escaping ()->Void) {
        loading = true
        Task {
            do {
                let data = try await useCase.updateSheet(description: description, imageLink: imageLink)
                
                loading = false
                success()
                self.showAlert(message: "Success Sheet Update" )
            }catch {
                loading = false
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
}
