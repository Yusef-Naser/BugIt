//
//  UploadRepo.swift
//  Bug It
//
//  Created by yusef naser on 12/09/2024.
//

import Foundation

protocol UploadRepo {
    
    func uploadImage ( image : Data ) async throws -> ImageResponse?
    
}
