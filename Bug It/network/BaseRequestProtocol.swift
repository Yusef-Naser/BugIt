//
//  BaseRequestProtocol.swift
//  Bug It
//
//  Created by yusef naser on 09/09/2024.
//

import Foundation

protocol BaseRequestProtocol {
    var urlRequest : URLRequest? { get }
    var endPoint : String { get set }
    var httpMethod : HTTPMethod {get set}
    var httpHeaders : [String : String] { get set }
    var parameters : [String : Any] { get set }
    init(endPoint : String , httpMethod: HTTPMethod , type : APIType )
}
