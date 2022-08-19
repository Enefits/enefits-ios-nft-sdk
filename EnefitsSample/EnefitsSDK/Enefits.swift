//
//  Enefit.swift
//  Enefit_SDK
//

import UIKit
import Foundation
import CryptoKit

/*Shared Protocal*/

public class Enefits: EnefitsProtocols {
    
    /*SharedInstance*/
    public static var shared: EnefitsProtocols = Enefits()
    
    /*Internal Shared Instance*/
    internal static var sharedInternal: Enefits = {
        return shared as! Enefits }()
    
    public init() { }
    
    public var walletConnect: EnefitsWalletConnect?
    
    /*Tenant Name from client*/
    public var apiKeyString: String? = ""
    public var appNameString: String? = ""
    
    public var isInitComplete: Bool? = false
    public var isAccountConnected: Bool? = false
    
    /*Hanlde parent and present viewcontrollers*/
    private var presentedViewController: UIViewController? = nil
    private var parentController: UIViewController? = nil
    public var isConnectedWithWallet: ((Bool?) -> ())?
    
    public var isToConnectWithWallet : Bool? = false
    
    /*Initialize SDK*/
    public func initializeSDK(name: String?, apiKey: String?, completionHandler handler: @escaping (Bool, String) -> Void) {
        if Enefits.shared.isInitComplete == true, let storedAPIKey = UserDefaults.standard.value(forKey: "api_key") as? String, storedAPIKey == apiKey{
            handler(true, "SDK Already initialized")
        }else{
            var alert : UIAlertController?
            DispatchQueue.main.async {
                if let topVC = UIApplication.getTopViewController() {
                    alert = topVC.showLoader()
                }
            }
            let parameters = ["api_key": apiKey ?? ""]
            EnefitsServiceClient.getInitializeSDK(parameters: parameters, completion: { (response, errorString, statusCode) in
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    alert?.dismiss(animated: true)
                })
                Enefits.shared.apiKeyString = apiKey
                Enefits.shared.appNameString = name
                UserDefaults.standard.set(Enefits.shared.apiKeyString ?? "", forKey: "api_key")
                if let _ = errorString{
                    Enefits.shared.isInitComplete = false
                    Enefits.shared.isAccountConnected = false
                    handler(false, "Failed to initialize SDK")
                    return
                }
                guard let statusCode = statusCode , statusCode == 200 else{
                    Enefits.shared.isInitComplete = false
                    Enefits.shared.isAccountConnected = false
                    handler(false, "Failed to initialize SDK")
                    return
                }
                self.walletConnect = EnefitsWalletConnect(delegate: self)
                Enefits.shared.isInitComplete = true
                Enefits.shared.isAccountConnected = false
                self.walletConnect?.reconnectIfNeeded()
                handler(true, "SDK initialized Successfully")
            })
        }
    }
    
    /*Present detail View*/
    public func present(from parentController: UIViewController,apiKeyString: String, completionHandler handler: @escaping (Bool, String) -> Void) {
        if Enefits.shared.isInitComplete == false {
            if let apiValue = UserDefaults.standard.value(forKey: "api_key") as? String, apiValue == apiKeyString {
                var alert : UIAlertController?
                DispatchQueue.main.async {
                    if let topVC = UIApplication.getTopViewController() {
                        alert = topVC.showLoader()
                    }
                }
                let parameters = ["api_key": apiValue]
                EnefitsServiceClient.getInitializeSDK(parameters: parameters, completion: { (response, errorString, statusCode) in
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        alert?.dismiss(animated: true)
                    })
                    Enefits.shared.apiKeyString = apiValue
                    UserDefaults.standard.set(Enefits.shared.apiKeyString ?? "", forKey: "api_key")
                    if statusCode != 200 {
                        handler(false,"Please initialize SDK")
                    }else{
                        self.walletConnect = EnefitsWalletConnect(delegate: self)
                        self.walletConnect?.reconnectIfNeeded()
                        Enefits.shared.isInitComplete = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if Enefits.shared.isAccountConnected == true {
                                Enefits.shared.getConnectAccount(apiKeyString: apiKeyString, completionHandler: { acc, walletDict in
                                    if acc != ""{
                                        handler(false,"Already connected with: \(acc)")
                                    }else{
                                        handler(true,"connecting with SDK")
                                        self.callParentViewToPresent(parentController: parentController)
                                    }
                                })
                                
                            }else{
                                handler(true,"connecting with SDK")
                                self.callParentViewToPresent(parentController: parentController)
                            }
                        }
                    }
                })
            }else{
                handler(false,"Please initialize SDK")
            }
        }else if Enefits.shared.isAccountConnected == true {
            Enefits.shared.getConnectAccount(apiKeyString: apiKeyString, completionHandler: { acc, walletDict in
                if acc != ""{
                    handler(false,"Already connected with: \(acc)")
                }else{
                    handler(true,"connecting with SDK")
                    self.callParentViewToPresent(parentController: parentController)
                }
            })
        }else{
            handler(true,"connecting with SDK")
            callParentViewToPresent(parentController: parentController)
        }
    }
    
    func callParentViewToPresent(parentController: UIViewController){
        self.parentController = parentController
        parentController.modalPresentationStyle = .overFullScreen
        if (self.presentedViewController != nil) {
            self.presentedViewController?.dismiss(animated: true, completion: {
                DispatchQueue.main.async {
                    self.presentCurrentViewController(parentController: parentController)
                }
            })
        } else {
            self.presentCurrentViewController(parentController: parentController)
        }
    }
    
    public func getOffers(apiKeyString: String?, completionHandler handler: @escaping (Bool,String) -> Void) {
        if Enefits.shared.isInitComplete == false {
            if let apiValue = UserDefaults.standard.value(forKey: "api_key") as? String, apiValue == apiKeyString {
                var alert : UIAlertController?
                DispatchQueue.main.async {
                    if let topVC = UIApplication.getTopViewController() {
                        alert = topVC.showLoader()
                    }
                }
                let parameters = ["api_key": apiValue]
                EnefitsServiceClient.getInitializeSDK(parameters: parameters, completion: { (response, errorString, statusCode) in
                    Enefits.shared.apiKeyString = apiValue
                    UserDefaults.standard.set(Enefits.shared.apiKeyString ?? "", forKey: "api_key")
                    if statusCode != 200 {
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                            alert?.dismiss(animated: true)
                        })
                        handler(false,"Please initialize SDK")
                    }else{
                        self.walletConnect = EnefitsWalletConnect(delegate: self)
                        DispatchQueue.main.async{
                            self.walletConnect?.reconnectIfNeeded()
                        }
                        Enefits.shared.isInitComplete = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                alert?.dismiss(animated: true)
                            })
                            if Enefits.shared.isAccountConnected == true {
                                self.callOffers(handler: handler)
                            }else{
                                handler(false,"Connect with Enefits SDK to check offers")
                            }
                        }
                    }
                })
            }else{
                handler(false,"Please initialize SDK")
            }
        }else if Enefits.shared.isAccountConnected == false {
            handler(false,"Connect with Enefits SDK to check offers")
        }else{
            callOffers(handler: handler)
        }
    }
    
    func callOffers(handler: @escaping (Bool,String) -> Void){
        var alert : UIAlertController?
        DispatchQueue.main.async {
            if let topVC = UIApplication.getTopViewController() {
                alert = topVC.showLoader()
            }
        }
        let parameters = ["api_key": Enefits.shared.apiKeyString ?? "", "address": walletConnect?.session.walletInfo?.accounts.first ?? ""]
        EnefitsServiceClient.getOfferList(parameters: parameters, completion: { (response, errorString, statusCode) in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                alert?.dismiss(animated: true)
            })
            if let errorString = errorString{
                print(errorString)
                handler(false,"failed to get offers")
                return
            }
            
            guard let responseDictionary = response as? Dictionary<String,Any> else{
                handler(false,"failed to get offers")
                return
            }
            
            guard (responseDictionary["status"] as? String)?.lowercased() == SUCCESS else{
                handler(false,"failed to get offers")
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                handler(true,"\(responseDictionary)")
            })
        })
    }
    
    public func disconnect(apiKeyString : String?, completionHandler handler: @escaping(Bool, String) -> Void){
        if Enefits.shared.isInitComplete == false {
            handler(false,"Please initialize SDK")
        }else if Enefits.shared.isAccountConnected == false {
            handler(false,"No Active session found")
        }else{
            // Disconnect
            guard let session = walletConnect?.session else {
                return handler(false,"Wallet Disconnect failed")
            }
            try? walletConnect?.client.disconnect(from: session)
            handler(true,"Wallet Disconnected")
        }
    }
    
    public func getConnectAccount(apiKeyString : String?,completionHandler handler: @escaping (String, [String:Any]) -> Void){
        if Enefits.shared.isInitComplete == false {
            if let apiValue = UserDefaults.standard.value(forKey: "api_key") as? String, apiValue == apiKeyString {
                var alert : UIAlertController?
                DispatchQueue.main.async {
                    if let topVC = UIApplication.getTopViewController() {
                        alert = topVC.showLoader()
                    }
                }
                let parameters = ["api_key": apiValue]
                EnefitsServiceClient.getInitializeSDK(parameters: parameters, completion: { (response, errorString, statusCode) in
                    Enefits.shared.apiKeyString = apiValue
                    UserDefaults.standard.set(Enefits.shared.apiKeyString ?? "", forKey: "api_key")
                    if statusCode != 200 {
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                            alert?.dismiss(animated: true)
                        })
                        handler("Please initialize SDK", [:])
                    }else{
                        self.walletConnect = EnefitsWalletConnect(delegate: self)
                        DispatchQueue.main.async{
                            self.walletConnect?.reconnectIfNeeded()
                        }
                        Enefits.shared.isInitComplete = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                alert?.dismiss(animated: true)
                            })
                            self.getConnectAccount(handler: handler)
                        }
                    }
                })
            }else{
                handler("Please initialize SDK", [:])
            }
        }else {
            getConnectAccount(handler: handler)
        }
    }
    
    func getConnectAccount(handler: @escaping (String, [String:Any]) -> Void){
        if let session =  walletConnect?.session, Enefits.shared.isAccountConnected == true{
            guard let walletString = session.walletInfo?.accounts.first else { return handler("Connect with Enefits SDK to check account", [:]) }
            handler(walletString, session.walletInfo?.dictionary ?? [:])
        }else{
            handler("Connect with Enefits SDK to check account", [:])
        }
    }

    public func getChainData(apiKeyString : String?, completionHandler handler: @escaping (String) -> Void){
        if Enefits.shared.isInitComplete == false {
            if let apiValue = UserDefaults.standard.value(forKey: "api_key") as? String, apiValue == apiKeyString {
                var alert : UIAlertController?
                DispatchQueue.main.async {
                    if let topVC = UIApplication.getTopViewController() {
                        alert = topVC.showLoader()
                    }
                }
                let parameters = ["api_key": apiValue]
                EnefitsServiceClient.getInitializeSDK(parameters: parameters, completion: { (response, errorString, statusCode) in
                    Enefits.shared.apiKeyString = apiValue
                    UserDefaults.standard.set(Enefits.shared.apiKeyString ?? "", forKey: "api_key")
                    if statusCode != 200 {
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                            alert?.dismiss(animated: true)
                        })
                        handler("Please initialize SDK")
                    }else{
                        self.walletConnect = EnefitsWalletConnect(delegate: self)
                        DispatchQueue.main.async{
                            self.walletConnect?.reconnectIfNeeded()
                        }
                        Enefits.shared.isInitComplete = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                alert?.dismiss(animated: true)
                            })
                            self.getChainValue(handler: handler)
                        }
                    }
                })
            }else{
                handler("Please initialize SDK")
            }
        }else {
            getChainValue(handler: handler)
        }
    }
    
    func getChainValue(handler: @escaping (String) -> Void){
        if let session =  walletConnect?.session, Enefits.shared.isAccountConnected == true{
            guard let walletInfo = session.walletInfo else { return handler("Connect with Enefits SDK to check data") }
            handler("\(walletInfo)")
        }else{
            handler("Connect with Enefits SDK to check data")
        }
    }
    
    func presentCurrentViewController(parentController: UIViewController) {
        if UIDevice.current.isJailBroken{
            print("Detected Jailbroken device")
        }else{
            /*Present View Controller*/
            let viewController = self.viewControllerToPresent()
            viewController.modalPresentationStyle = .overFullScreen
            self.presentedViewController = viewController
            parentController.present(viewController, animated: true, completion: nil)
        }
    }
    
    /*Dismiss the Presented Page from client App*/
    public func dismiss() {
        DispatchQueue.main.async {
            self.presentedViewController?.dismiss(animated: true, completion: {
                DispatchQueue.main.async {
                    self.presentedViewController = nil
                    self.parentController = nil
                }
            })
        }
    }
    
    /*View Controller to Present*/
    func viewControllerToPresent() -> UIViewController {
        return EnefitsConnectViewController.controller()
    }
}


extension Enefits: EnefitsWalletConnectDelegate {
    internal func failedToConnect() {
        onMainThread { [] in
            Enefits.shared.isAccountConnected = false
        }
    }
    
    internal func didConnect() {
        onMainThread { [] in
            Enefits.shared.isAccountConnected = true
            if self.isToConnectWithWallet ?? false {
                Enefits.shared.isConnectedWithWallet?(true)
            }
            Enefits.shared.dismiss()
        }
    }
    
    internal func didDisconnect() {
        onMainThread { [] in
            Enefits.shared.isAccountConnected = false
            Enefits.shared.walletConnect = EnefitsWalletConnect(delegate: self)
        }
    }
    
    private func onMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
}



extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
