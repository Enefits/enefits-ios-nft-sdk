//
//  EnefitsServiceClient.swift
//  Enefits
//
//  Created by Maulik Bhuptani on 04/05/20.
//

import Foundation

final class EnefitsServiceClient: ServiceClient {

    private static let sharedClient = EnefitsServiceClient()
    
    private func performRequest(route: EnefitsServiceRequestConvertible, completion: @escaping (_ response: Any?, _ errorString: String?, _ statusCode: Int?)->()){
        ServiceClient.shared.request(route) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else{
                completion(nil, error?.localizedDescription, (error as NSError?)?.code)
                return
            }
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let data = data else{
                    completion(nil, ServiceError.NoDataError.localizedDescription, response.statusCode)
                    return
                }
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print(jsonResponse)
                    completion(jsonResponse, nil, response.statusCode)
                }catch {
                    completion(nil, ServiceError.UnableToDecodeError.localizedDescription, response.statusCode)
                }
            case .failure(let failureErrorString):
                if failureErrorString == EnefitsServiceError.Unknown.localizedDescription{
                    completion(nil, error?.localizedDescription, response.statusCode)
                }else{
                    completion(nil, failureErrorString, response.statusCode)
                }
            }
        }
    }

    static func getWalletList(parameters: Parameters?, completion: @escaping (_ response: Any?, _ errorString: String?, _ statusCode: Int?)->()){
        EnefitsServiceClient.sharedClient.performRequest(route: (EnefitsServiceRequestConvertible.getWalletList(parameters: parameters))) { (response, errorString, statusCode) in
            completion(response, errorString, statusCode)
        }
    }
    
    static func getOfferList(parameters: Parameters?, completion: @escaping (_ response: Any?, _ errorString: String?, _ statusCode: Int?)->()){
        EnefitsServiceClient.sharedClient.performRequest(route: (EnefitsServiceRequestConvertible.getOfferList(parameters: parameters))) { (response, errorString, statusCode) in
            completion(response, errorString, statusCode)
        }
    }
    
    static func getInitializeSDK(parameters: Parameters?, completion: @escaping (_ response: Any?, _ errorString: String?, _ statusCode: Int?)->()){
        EnefitsServiceClient.sharedClient.performRequest(route: (EnefitsServiceRequestConvertible.getInitializeSDK(parameters: parameters))) { (response, errorString, statusCode) in
            completion(response, errorString, statusCode)
        }
    }
    
    override func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299:
            return .success
        case EnefitsServiceError.BadRequest.rawValue:
            return .failure(EnefitsServiceError.BadRequest.localizedDescription)
        case EnefitsServiceError.Unauthorized.rawValue:
            return .failure(EnefitsServiceError.Unauthorized.localizedDescription)
        case EnefitsServiceError.NotFound.rawValue:
            return .failure(EnefitsServiceError.NotFound.localizedDescription)
        default:
            return .failure(EnefitsServiceError.Unknown.localizedDescription)
        }
    }
    
}

