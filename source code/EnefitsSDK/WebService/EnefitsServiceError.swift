//
//  EnefitsServiceError.swift
//  Enefits
//
//  Created by Maulik Bhuptani on 11/05/20.
//

import Foundation

enum EnefitsServiceError: Int, Error{
    case BadRequest = 400
    case Unauthorized = 401
    case NotFound = 404
    case Unknown = 999
    case GenerateTokenService = 5000
    case eKYCTriggerCreateRequestService = 5001
    case eKYCTriggerGetNextStepService = 5002
    case UnhandledSuccessFromService = 5003
    case InvalidServiceParameters = 5005
    case InvalidConfigurationValues = 5010
    case WebViewURLFailedToLoad = 6001
}

extension EnefitsServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .BadRequest:
                return "Invalid or unknown user."
            case .Unauthorized:
                return "Client authentication failed due to unknown or invalid client."
            case .NotFound:
                return "Not Found."
            case .Unknown:
                return "Unknown Error Type."
            case .GenerateTokenService:
                return "GenerateTokenService failed."
            case .eKYCTriggerCreateRequestService:
                return "eKYCTrigger Create Request Service failed."
            case .eKYCTriggerGetNextStepService:
                return "eKYCTrigger Get Next Step Service failed."
            case .UnhandledSuccessFromService:
                return "HTTPURLResponse statuscode is 200, but JSON response is unknown."
            case .InvalidServiceParameters:
                return "One or more service parameters or HTTP headers are nil."
            case .InvalidConfigurationValues:
                return "One or more properties are nil, while initializing eKYC Configuration."
            case .WebViewURLFailedToLoad:
                return "One of the urls in webview failed to load."
        }
    }
}
