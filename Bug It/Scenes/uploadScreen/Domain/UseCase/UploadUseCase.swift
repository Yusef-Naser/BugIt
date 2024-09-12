//
//  UploadUseCase.swift
//  Bug It
//
//  Created by yusef naser on 12/09/2024.
//

import Foundation

class UploadUseCase {
    
    private var repo : UploadRepo
    
    init(repo: UploadRepo = UploadRepository()) {
        self.repo = repo
    }
    
    func uploadImage ( image : Data ) async throws -> ImageResponse?{

        return  try await repo.uploadImage( image: image)
        
    }
    
}
