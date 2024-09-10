//
//  BugItUseCase.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation

class BugItUseCase {
    
    private var repo : BugItRepo
    
    init(repo: BugItRepo = BugItRepository()) {
        self.repo = repo
    }
    
    func uploadImage (description : String , image : Data ) async throws -> ImageResponse?{

        return  try await repo.uploadImage(description: description, image: image)
        
    }
    
    func updateSheet (description : String , imageLink : String) async throws -> EmptyResponse? {
        return  try await repo.updateSheet(description: description, imageLink: imageLink)
    }
    
}
