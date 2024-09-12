//
//  ButItRepo.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation

protocol BugItRepo {
    
    func uploadImage ( image : Data ) async throws -> ImageResponse?
    func updateSheet (description : String , priority : Fields.Values , labels : Fields.Values , assignee : Fields.Values , imageLink : String) async throws -> EmptyResponse?
    
}
