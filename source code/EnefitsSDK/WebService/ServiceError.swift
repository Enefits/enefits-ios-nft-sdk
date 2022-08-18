//
//  ServiceError.swift
//  eKYC
//
//  Created by Maulik Bhuptani on 04/05/20.
//

import Foundation

enum ServiceError: Error {
    case EncodingFailedError
    case InvalidURLError
    case FailedError
    case NoDataError
    case UnableToDecodeError
    case BadRequestError
    case OutdatedError
    case InternalServerError
    case EmptyHTTPURLResponseError
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .InvalidURLError:
                return "URL is not valid."
            case .EncodingFailedError:
                return "Parameter encoding failed."
            case .EmptyHTTPURLResponseError:
                return "HTTP URLResponse is nil."
            case .NoDataError:
                return "Response returned with no data to decode."
            case .UnableToDecodeError:
                return "Could not decode the response."
            case .BadRequestError:
                return "You need to be authenticated first."
            case .OutdatedError:
                return "The url you requested is outdated."
            case .InternalServerError:
                return "The server has encountered a situation it doesn't know how to handle."
            case .FailedError:
                return "Network request failed."
        }
    }
}

