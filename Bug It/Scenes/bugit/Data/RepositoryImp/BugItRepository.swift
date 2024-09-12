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

    func updateSheet(description: String, priority: Fields.Values, labels: Fields.Values, assignee: Fields.Values, imageLinks: [String]) async throws -> SheetResponse? {
        
        var uploadedLinks : String = ""
        
        for link in imageLinks {
            if uploadedLinks.isEmpty{
                uploadedLinks = link
                continue
            }
            uploadedLinks += "\n\(link)"
        }
        
        //let tabName = "Sheet1"
        let tabName = "26-09-23"
        
        let request = BaseRequest(endPoint: EndPoints.updateSheet(sheetID: Constants.sheetId , tabName: tabName).path , httpMethod: .post , type: .updateGoogleSheet)
        
        request.parameters =  [
            "range" : tabName ,
            "majorDimension" : "ROWS" ,
            "values" : [
                [ description ,
                  uploadedLinks ,
                  (priority.enable) ? priority.value: "" ,
                  (labels.enable) ? labels.value : "" ,
                  (assignee.enable) ? assignee.value : ""
                ]
            ]
        ]
    
        
        
        return try await withCheckedThrowingContinuation { continuation in
            ApiClient.shared.performRequest(url: request.BuildRequest() , type: SheetResponse.self )
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
