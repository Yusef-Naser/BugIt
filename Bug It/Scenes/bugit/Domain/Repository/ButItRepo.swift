//
//  ButItRepo.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation

protocol BugItRepo {
    
    func uploadImage (description : String , image : Data ) async throws -> ImageResponse?
    func updateSheet (description : String , imageLink : String) async throws -> EmptyResponse?
    
}
