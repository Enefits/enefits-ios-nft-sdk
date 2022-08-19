//
//  ServiceClient.swift
//  eKYC
//
//  Created by Maulik Bhuptani on 04/05/20.
//

import Foundation

typealias ServiceRequestCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

enum Result<String>{
    case success
    case failure(String)
}

class ServiceClient {
    
    static let shared = ServiceClient()
    
    private var task: URLSessionTask?
    private let BackgroundQueue = DispatchQueue.global(qos: .userInitiated)
    private let MainQueue = DispatchQueue.main

    func request(_ route: ServiceRequestConvertible, completion: @escaping ServiceRequestCompletion){
        self.BackgroundQueue.async {
            do {
                let request = try route.asURLRequest()
                self.task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                    self.MainQueue.async {
                        completion(data, response, error)
                    }
                })
            } catch {
                self.MainQueue.async {
                      completion(nil, nil, error)
                }
            }
            self.task?.resume()
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(ServiceError.BadRequestError.localizedDescription)
        case 501...599:
            return .failure(ServiceError.InternalServerError.localizedDescription)
        case 600:
            return .failure(ServiceError.OutdatedError.localizedDescription)
        default:
            return .failure(ServiceError.FailedError.localizedDescription)
        }
    }
}

