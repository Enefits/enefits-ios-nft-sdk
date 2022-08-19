//
//  EnefitsServiceRequestConvertible.swift
//  Enefits
//
//  Created by Maulik Bhuptani on 11/05/20.
//

import Foundation

enum EnefitsServiceRequestConvertible: ServiceRequestConvertible {
    
    case getWalletList(parameters: Parameters?)
    case getOfferList(parameters: Parameters?)
    case getInitializeSDK(parameters: Parameters?)
    
    var baseURLString: String{
        switch self {
        case .getWalletList(let params):
            if params != nil {
                var postString = ""
                for (key,value) in params ?? [:] {
                    postString += key + "=" + "\(value)" + "&"
                }
                if postString.hasSuffix("&") {
                    postString.removeLast()
                }
                return BASEURLSTRING + "wallet-providers.json" + "?" + postString
            }
            return BASEURLSTRING
        case .getOfferList(let params):
            if params != nil {
                var postString = ""
                for (key,value) in params ?? [:] {
                    postString += key + "=" + "\(value)" + "&"
                }
                if postString.hasSuffix("&") {
                    postString.removeLast()
                }
                return BASEURLSTRING + "offers.json" + "?" + postString
            }
            return BASEURLSTRING
        case .getInitializeSDK(let params):
            if params != nil {
                var postString = ""
                for (key,value) in params ?? [:] {
                    postString += key + "=" + "\(value)" + "&"
                }
                if postString.hasSuffix("&") {
                    postString.removeLast()
                }
                return BASEURLSTRING + "account.json" + "?" + postString
            }
            return BASEURLSTRING
        }
    }
    
    var path: String{
        switch self {
        case .getWalletList:
            return ""
        case .getOfferList:
            return ""
        case .getInitializeSDK:
            return ""
        }
    }
    
    var method: HTTPMethod{
        switch self {
        case .getWalletList:
            return .get
        case .getOfferList:
            return .get
        case .getInitializeSDK:
            return .get
        }
    }
    
    var headers: HTTPHeaders?{
        let customHeaders: HTTPHeaders = [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
        switch self {
        case .getWalletList(_):
            return customHeaders
        case .getOfferList(_):
            return customHeaders
        case .getInitializeSDK(_):
            return customHeaders
        }
    }
    
    var parameters: Parameters?{
        switch self {
        case .getWalletList(_):
            return nil
        case .getOfferList(_):
            return nil
        case .getInitializeSDK(_):
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw ServiceError.EncodingFailedError
            }
        }
        return urlRequest
    }
}

extension String{
    func asURL() throws -> URL {
        guard let url = URL(string: self), let _ = url.scheme, let _ = url.host else {
            throw ServiceError.InvalidURLError
        }
        return url
    }
}

extension Dictionary {
    var convertedData: Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return data
    }
}
