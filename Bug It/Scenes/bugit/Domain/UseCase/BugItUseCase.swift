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

    func updateSheet (description : String , priority : Fields.Values , labels : Fields.Values , assignee : Fields.Values , imageLinks : [String]) async throws -> SheetResponse? {
        return  try await repo.updateSheet(description: description, priority: priority, labels: labels, assignee: assignee, imageLinks: imageLinks)
    }
    
}
