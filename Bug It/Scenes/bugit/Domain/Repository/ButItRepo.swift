//
//  ButItRepo.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation

protocol BugItRepo {
    
  
    func updateSheet (description : String , priority : Fields.Values , labels : Fields.Values , assignee : Fields.Values , imageLinks : [String]) async throws -> SheetResponse?
    
}
