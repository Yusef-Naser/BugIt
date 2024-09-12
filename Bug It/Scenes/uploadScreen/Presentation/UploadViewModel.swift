//
//  UploadViewModel.swift
//  Bug It
//
//  Created by yusef naser on 12/09/2024.
//

import Foundation

class UploadViewModel : BaseViewModel {
    
    @Published var useCase = UploadUseCase()
    
    @Published private var linksArray : [String] = []
    
    @MainActor
    func uploadImage (images : [Data]  , success : @escaping ([String])->Void) {
        
        linksArray = []
        guard images.count > 0 else {
            self.showAlert(message: "Please Select Images")
            return
        }
        self.uploadSingleImage(images: images , index: 0) {
            // success
            print(self.linksArray)
            success(self.linksArray)
        }
    }
    
    @MainActor
    private func uploadSingleImage (images : [Data] , index : Int , success : (()->Void)? = nil ) {
        guard images.count > index else {
            success?()
            return
        }
        loading = true
        Task {
            do {
                let data = try await useCase.uploadImage( image: images[index])
        
                loading = false
                guard let link = data?.data?.link else {
                    self.uploadSingleImage(images: images, index: index + 1 , success: success)
                    return
                }
                linksArray.append(link)
                self.uploadSingleImage(images: images, index: index + 1, success: success)
            }catch {
                loading = false
                self.uploadSingleImage(images: images, index: index + 1 , success: success)
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
}
