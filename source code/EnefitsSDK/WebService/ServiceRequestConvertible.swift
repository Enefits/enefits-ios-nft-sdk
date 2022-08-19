//
//  ServiceRequestConvertible.swift
//  eKYC
//
//  Created by Maulik Bhuptani on 04/05/20.
//

import Foundation

typealias HTTPHeaders = Dictionary<String,String>
typealias Parameters = Dictionary<String,Any>

enum ContentType: String {
    case json = "application/json"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

protocol ServiceRequestConvertible {
    var baseURLString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    
    func asURLRequest() throws -> URLRequest
}
