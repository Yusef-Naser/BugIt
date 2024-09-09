//
//  BugItUseCase.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

class BugItUseCase {
    
    private var repo : BugItRepo
    
    init(repo: BugItRepo = BugItRepository()) {
        self.repo = repo
    }
    
    func uploadImage () {
        repo.uploadImage()
    }
    
    func updateSheet () {
        repo.updateSheet()
    }
    
}
