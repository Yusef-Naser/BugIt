//
//  BugItRepository.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation
import Combine

class BugItRepository : BugItRepo {
    
    var cancellables = Set<AnyCancellable>()
    
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
    
    func updateSheet(description: String, priority: Fields.Values, labels: Fields.Values, assignee: Fields.Values, imageLink: String) async throws -> EmptyResponse? {
        
        //let tabName = "Sheet1"
        let tabName = "26-09-23"
        
        let request = BaseRequest(endPoint: EndPoints.updateSheet(sheetID: Constants.sheetId , tabName: tabName).path , httpMethod: .post , type: .updateGoogleSheet)
        
        request.parameters =  [
            "range" : tabName ,
            "majorDimension" : "ROWS" ,
            "values" : [
                [ description ,
                  imageLink ,
                  (priority.enable) ? priority.value: "" ,
                  (labels.enable) ? labels.value : "" ,
                  (assignee.enable) ? assignee.value : ""
                ]
            ]
        ]
    
        
        
        return try await withCheckedThrowingContinuation { continuation in
            ApiClient.shared.performRequest(url: request.BuildRequest() , type: EmptyResponse.self )
                .sink { completion in
                    switch completion {
                    case .finished :
                        return
                    case .failure(let error) :
                        continuation.resume(throwing: error)
                        return
                    }
                } receiveValue: { response  in
                    continuation.resume(returning: response)
                }
                .store(in: &cancellables)

        }
        
    }
 
    
    
}
