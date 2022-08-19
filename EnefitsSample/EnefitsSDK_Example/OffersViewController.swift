//
//  OffersViewController.swift
//  EnefitsSDK_Example
//
//  Created by SIDHUDEVARAYAN K C on 10/08/22.
//

import UIKit

class OffersViewController: UIViewController {
    
    @IBOutlet weak var offerTextView: UITextView!
    
    var jsonString : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.offerTextView.text = jsonString 
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
