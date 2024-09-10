//
//  BaseRequest.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation
import UIKit

struct ImageData {

    func mimeType() -> String {

        var b: UInt8 = 0
        data.copyBytes(to: &b, count: 1)

        switch b {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        default:
            return "application/octet-stream"
        }
    }
    
    let key: String
    var fileName: String
    let data: Data
    //let mimeType: String

    init(withImage image: Data, forKey key: String) {
        self.key = key
        self.data = image
        //self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpeg"

        
    }
    
}

class BaseRequest : BaseRequestProtocol {
    
    var urlRequest: URLRequest?
    
    var endPoint: String
    
    var httpMethod: HTTPMethod
    
    var httpHeaders: [String : String] = [:]
    
    var parameters: [String : Any] = [:]
    
    var parametersUploadImage: [ImageData] = []
        
    var queryItems : [URLQueryItem] = []
    
    let boundary = UUID().uuidString
    
    let type : APIType
    
    required init(endPoint : String , httpMethod : HTTPMethod , type : APIType ) {
        self.endPoint = endPoint
        self.httpMethod = httpMethod
        self.type = type
        self.addHeaders()
    }
    
    private func addHeaders () {
        httpHeaders["Content-Type"] = "application/json"
        httpHeaders["Accept"] = "application/json"
        switch type {
        case .upload:
            httpHeaders["Authorization"] = "Client-ID \(Constants.clientID)"
        case .updateGoogleSheet:
            httpHeaders["Authorization"] = "Bearer \(LoginUserCase().getUserObject()?.accessToken ?? "" )"
        }
    }
    
    func BuildRequest() -> URLRequest{
        guard  let safeUrl = (endPoint).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ,
               var url =  URL(string: safeUrl ) else {
            fatalError("Failed to build request url with url: \(endPoint)")
        }
        if queryItems.count > 0 {
            url.append(queryItems: queryItems )
        }
        

        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.rawValue
        request.allHTTPHeaderFields = httpHeaders
        
        guard httpMethod != .get else {
            self.urlRequest = request
            return request
        }
                
        if parameters.count > 0 {
            
            guard
                let data =  parameters.toJSONString()?.data(using: .utf8)  else {
                fatalError("Faild to serialize http body")
            }
            
            request.httpBody = data
        }
        request.timeoutInterval = 180
        self.urlRequest = request
        return request
    }
    
    func BuildUploadRequest () -> URLRequest {
        guard  let safeUrl = (endPoint).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ,
               let url =  URL(string: safeUrl ) else {
            fatalError("Failed to build request url with url: \(endPoint)")
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.rawValue
        httpHeaders ["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        request.allHTTPHeaderFields = httpHeaders
        
        if parameters.count > 0  || parametersUploadImage .count > 0 {
            
            request.httpBody = createHttpBody()
          //  request.httpBody = createHttpBody(boundary: boundary)
        }
        request.timeoutInterval = 180
        self.urlRequest = request
        return request
        
    }
    
    
    func createHttpBody () -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        for item in parametersUploadImage {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(item.key)\"; filename=\"\(item.fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(item.mimeType())\r\n\r\n".data(using: .utf8)!)
            body.append(item.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
}
