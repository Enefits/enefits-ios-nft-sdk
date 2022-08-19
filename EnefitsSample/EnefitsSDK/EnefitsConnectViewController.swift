//
//  EnefitConnectViewController.swift
//  EnefitsSDK
//
//

import UIKit

class EnefitsConnectViewController: UIViewController {
    
    @IBOutlet weak var walletListTableView : UITableView!
    @IBOutlet weak var backButton : UIButton!
    var walletConnectListArray: [Dictionary<String,Any>]?
    var universalLinkString : String?
    var deepLinkString : String?

    /*Present Controller*/
    internal class func controller() -> EnefitsConnectViewController {
        return UIStoryboard(name: "Main", bundle: EnefitsBundle.shared.currentBundle).instantiateViewController(withIdentifier: "EnefitsConnectViewController") as! EnefitsConnectViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.backButton.setImage(UIImage(named: "close.png", in: EnefitsBundle.shared.currentBundle, compatibleWith: .current), for: .normal)
        self.walletListTableView.isHidden = true
        self.walletListAPICall()
    }
    
    func walletListAPICall(){
        var alert : UIAlertController?
        DispatchQueue.main.async {
            alert = self.showLoader()
        }
        let parameters = ["api_key": Enefits.shared.apiKeyString ?? ""]
        EnefitsServiceClient.getWalletList(parameters: parameters, completion: { (response, errorString, statusCode) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                alert?.dismiss(animated: true)
            })
            
            if let errorString = errorString{
                print(errorString)
                return
            }
            
            guard let responseDictionary = response as? Dictionary<String,Any> else{
                return
            }
            
            guard (responseDictionary["status"] as? String)?.lowercased() == SUCCESS, let dataDictionary = responseDictionary["data"] as? Dictionary<String,Any> else{
                return
            }
            self.walletConnectListArray = dataDictionary["registry"] as? [Dictionary<String,Any>]
            self.walletConnectListArray = self.walletConnectListArray?.filter({$0["universalLink"] as? String != ""})
            self.registerNib()
            self.walletListTableView.reloadData()
            self.walletListTableView.isHidden = false
        })
    }
    
    func registerNib(){
        walletListTableView.register(UINib(nibName: "WalletListTableViewCell", bundle: EnefitsBundle.shared.currentBundle), forCellReuseIdentifier: "WalletListTableViewCell")
    }
    
    @IBAction func closeAction(_ sender: UIButton){
        Enefits.shared.dismiss()
    }
   
    func connect() {
        let connectionUrl = Enefits.shared.walletConnect?.connect()
        //let deepLinkUrl = "\(deepLinkString)://wc?uri=\(connectionUrl)"
        let universalLink = "\(universalLinkString ?? "")/wc?uri=\(connectionUrl?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let url = URL(string: universalLink), UIApplication.shared.canOpenURL(url) {
                Enefits.shared.isToConnectWithWallet = true
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                
            }
        }
    }
    
    func onMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}

extension EnefitsConnectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletConnectListArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "WalletListTableViewCell", for: indexPath) as! WalletListTableViewCell
        aCell.selectionStyle = .default
        aCell.titleLable.text = self.walletConnectListArray?[indexPath.row]["name"] as? String ?? ""
        DispatchQueue.main.async {
            if let url = URL(string: self.walletConnectListArray?[indexPath.row]["logo"] as? String ?? ""){
                aCell.logoImageView.loadImageWithUrl(url)
            }
        }
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexValue = indexPath.row
        universalLinkString = self.walletConnectListArray?[indexValue]["universalLink"] as? String ?? ""
        self.connect()
    }
}

