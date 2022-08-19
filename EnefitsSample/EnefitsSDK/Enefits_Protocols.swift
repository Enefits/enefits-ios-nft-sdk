//
//  Enefit_Protocols.swift
//  Enefit_SDK
//


import UIKit
import Foundation
import LocalAuthentication

public protocol EnefitsProtocols {
    
    /*Shared Instance for Client*/
    static var shared: EnefitsProtocols { get }
    
    /*Present detail View*/
    func present(from parentController: UIViewController, apiKeyString: String ,completionHandler handler: @escaping (Bool, String) -> Void)

    /*Dismiss the Presented Page from client App*/
    func dismiss()
    
    /*Tenant Name from client*/
    var apiKeyString: String? { get set }
    var appNameString: String? { get set }
    var isInitComplete: Bool? { get set }
    var isAccountConnected: Bool? { get set }
    var isToConnectWithWallet: Bool? { get set }
    
    var walletConnect : EnefitsWalletConnect? { get set }
    
    /*Get Offers*/
    func getOffers(apiKeyString: String?, completionHandler handler: @escaping (Bool,String) -> Void)
    
    /*Initialise SDK with API KEY*/
    func initializeSDK(name: String?, apiKey: String?, completionHandler handler: @escaping (Bool, String) -> Void)
    
    /*Get Connected Wallet*/
    func getConnectAccount(apiKeyString : String?, completionHandler handler: @escaping (String, [String:Any]) -> Void)
    
    /*Get chain Data*/
    func getChainData(apiKeyString : String?, completionHandler handler: @escaping(String) -> Void)
    
    /*Disconnect Wallet*/
    func disconnect(apiKeyString : String?, completionHandler handler: @escaping(Bool, String) -> Void)
    
    /*Get Connected closure*/
    var isConnectedWithWallet:((Bool?) -> ())? { get set }
    
}
