//
//  APIClient.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation
import Combine

typealias CompletionSuccess<T : Codable> = (T?) -> Void

class ApiClient {
    
    private init() {
        
    }
    static let shared = ApiClient()
    
    func performRequest <T : Codable > (url : URLRequest ,  type : T.Type ,
                                        decoder: JSONDecoder = JSONDecoder() ) -> AnyPublisher< T , NetworkError> {
        print("Start Request url: \(url.url?.absoluteString ?? "")")
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> T in
    
                // Convert the data to a pretty-printed JSON string
                #if DEBUG
                print("ResponseString: (\(T.self)):\n\(String(decoding: output.data, as: UTF8.self))")
                #endif
                
                let jsonObject = try JSONSerialization.jsonObject(with: output.data, options: [])
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                guard let prettyString = String(data: prettyData, encoding: .utf8) else {
                    throw NetworkError(code: -1 , message: "invalidResponse")
                }
                print("Response (\(T.self)):\n\(prettyString)")
                
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: output.data)
                // Check if response is valid
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError(code: -1, message: "invalidResponse")
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    // create error object from statusCode and message
                    throw NetworkError(code: httpResponse.statusCode, message: "InvalidError")
                }

                
                return decodedData
            }
//            .map(\.data)
//            .decode(type: T.self, decoder: decoder )
            .mapError({ error in
                
                if let networkError = error as? NetworkError {
                    return networkError
                }
                
                return NetworkError(code: -1, message: error.localizedDescription )
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    
    func uploadRequest <T : Codable > (url : BaseRequest ,  type : T.Type ,
                                            decoder: JSONDecoder = JSONDecoder()  , completionSccess : @escaping (T?)->Void , completionError : @escaping (NetworkError)->Void ) {
        
        let request = url.BuildUploadRequest()
        #if DEBUG
            print("Start Request url: \(url.urlRequest?.url?.absoluteString ?? "")")
        #endif
        
        let urlSession = URLSession.shared.dataTask(with: request ) { data , urlResponse , error in
                     
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                completionError(NetworkError(code: -1 , message: "invalidResponse"))
                return
            }
            if let error = error {
                completionError(NetworkError(code: httpResponse.statusCode , message: error.localizedDescription ))
                return
            }
            guard let data = data else {
                completionError(NetworkError(code: -1 , message: "invalidResponse"))
                return
            }
            #if DEBUG
                print("ResponseString: (\(T.self)):\n\(String(decoding: data, as: UTF8.self))")
            #endif
            
            do {
                // Convert the data to a pretty-printed JSON string
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                guard let prettyString = String(data: prettyData, encoding: .utf8) else {
                    completionError(NetworkError(code: -1 , message: "invalidResponse"))
                    return
                }
                #if DEBUG
                    print("Response (\(T.self)):\n\(prettyString)")
                #endif
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                guard (200...299).contains(httpResponse.statusCode) else {
                    completionError(NetworkError(code: httpResponse.statusCode, message: "InvalidError"))
                    return
                }
                
                completionSccess(decodedData)
            }catch {
                completionError(NetworkError(code: -1 , message: error.localizedDescription))
            }
        }
        urlSession.resume()
        
        
    }
    
}
