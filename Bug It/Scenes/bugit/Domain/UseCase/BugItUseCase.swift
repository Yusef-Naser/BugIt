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
    
    func uploadImage ( image : Data ) async throws -> ImageResponse?{

        return  try await repo.uploadImage( image: image)
        
    }
    
    func updateSheet (description : String , priority : Fields.Values , labels : Fields.Values , assignee : Fields.Values , imageLink : String) async throws -> EmptyResponse? {
        return  try await repo.updateSheet(description: description, priority: priority, labels: labels, assignee: assignee, imageLink: imageLink)
    }
    
}
