//
//  EnefitBundle.swift
//

import UIKit
import Foundation

/*To Get bundle Name*/
class EnefitsBundle {
    static var shared = EnefitsBundle()
    private init() { }
    
    /*Access from Resource Bundle*/
    var currentBundle: Bundle  {
        let frameworkBundle = Bundle(identifier: "iOS.EnefitsSDK.framework")!
        return frameworkBundle
    }
    
    /*To get BundleId*/
    var bundleId: String? { return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String }
}


