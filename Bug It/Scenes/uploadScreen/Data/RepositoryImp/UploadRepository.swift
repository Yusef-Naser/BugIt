//
//  UploadRepository.swift
//  Bug It
//
//  Created by yusef naser on 12/09/2024.
//

import Foundation

class UploadRepository : UploadRepo {
    
    func uploadImage( image: Data) async throws -> ImageResponse? {
        
        let request = BaseRequest(endPoint: EndPoints.uploadImage.path , httpMethod: .post , type: .upload)
        
      //  request.parameters =  [
          //  "title" : "" ,
           // "description" : description
      //  ]
        
        let imageData = ImageData(withImage: image , forKey: "image")
        
        request.parametersUploadImage = [imageData]
        
        
        return try await withCheckedThrowingContinuation { continuation in
            ApiClient.shared.uploadRequest(url: request , type: ImageResponse.self) { response in
                
                continuation.resume(returning: response)
                
            } completionError: { error in
                continuation.resume(throwing: error)
            }

        }
        
    }
    
}
