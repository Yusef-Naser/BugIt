//
//  NetworkError.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

enum APIType : String {
    case upload
    case updateGoogleSheet
}

class NetworkError: NSError {
    
    init (code : Int , message : String) {
        super.init(domain: message , code: code , userInfo: [NSLocalizedDescriptionKey :  message ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
