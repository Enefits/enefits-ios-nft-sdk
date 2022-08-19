//
//  ExtensionClass.swift
//  EnefitsSDK_Example
//
//  Created by SIDHUDEVARAYAN K C on 04/08/22.
//

import Foundation
import UIKit


extension UIViewController{
    func showLoader(){
        let alert = UIAlertController(title: nil, message: "Loading ...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.color = .black
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissLoader(){
        self.dismiss(animated: false, completion: nil)
    }
}

extension UIButton {
    func primaryButtonUI(){
        self.backgroundColor = UIColor(red: 57/255, green: 83/255, blue: 148/255, alpha: 1)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 5.0
    }
}

