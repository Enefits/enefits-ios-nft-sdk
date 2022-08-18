//
//  ViewController.swift
//  EnefitsSDK_Example
//

import UIKit
import EnefitsSDK

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    var listDataArray = [ListDataModel]()
    var apiKeyValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.overrideUserInterfaceStyle = .light
        self.registerNib()
        listDataArray = getListModel()
        self.tableView.reloadData()
        
        /*Get callback after wallet connected*/
        Enefits.shared.isConnectedWithWallet = { flag in
            if flag == true { /*Conected with wallet success*/
                if let session =  Enefits.shared.walletConnect?.session{
                    guard let walletString = session.walletInfo?.accounts.first else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.view.makeToast("Connected with : \(walletString)")
                    })
                }
            }else{
                /*Failed to connect with wallets*/
            }
        }
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func registerNib(){
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        tableView.register(UINib(nibName: "HelperTableViewCell", bundle: nil), forCellReuseIdentifier: "HelperTableViewCell")
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == listDataArray.count - 1 {
            let helperCell = tableView.dequeueReusableCell(withIdentifier: "HelperTableViewCell", for: indexPath) as! HelperTableViewCell
            helperCell.titleLable.text = listDataArray[indexPath.row].titleLabel ?? ""
            helperCell.selectionStyle = .none
            helperCell.initButton.setTitle("  \(listDataArray[indexPath.row].helperTitleString?.first ?? "")  ", for: .normal)
            helperCell.isAccConnectedButton.setTitle("  \(listDataArray[indexPath.row].helperTitleString?[1] ?? "")  ", for: .normal)
            helperCell.accConnectedButton.setTitle("  \(listDataArray[indexPath.row].helperTitleString?[2] ?? "")  ", for: .normal)
            helperCell.chainDataButton.setTitle("  \(listDataArray[indexPath.row].helperTitleString?.last ?? "")  ", for: .normal)
            
            [helperCell.initButton,helperCell.isAccConnectedButton,helperCell.accConnectedButton,helperCell.chainDataButton].forEach { button in
                button?.addTarget(self, action: #selector(helperButtonTapped(_:)), for: .touchUpInside)
            }
        
            helperCell.initButton.tag = 101
            helperCell.isAccConnectedButton.tag = 102
            helperCell.accConnectedButton.tag = 103
            helperCell.chainDataButton.tag = 104
            
            return helperCell
        }else{
            let listCell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            listCell.selectionStyle = .none
            self.apiKeyValue = UserDefaults.standard.value(forKey: "api_key") as? String ?? ""
            if listCell.inputTextfield.text == "" {
                listCell.inputTextfield.text = self.apiKeyValue
            }
            listCell.titleLable.text = listDataArray[indexPath.row].titleLabel ?? ""
            listCell.actionButton.setTitle("  \(listDataArray[indexPath.row].buttonTitle ?? "")  ", for: .normal)
            listCell.inputTextfield.isHidden = listDataArray[indexPath.row].textInputFlag ?? false
            listCell.inputTextfieldTopConstrain.constant = (listDataArray[indexPath.row].textInputFlag ?? false) ? 0 : 12
            listCell.inputTextfieldHeightConstrain.constant = (listDataArray[indexPath.row].textInputFlag ?? false) ? 0 : 35
            listCell.actionButton.tag = indexPath.row
            listCell.actionButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            return listCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func helperButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        switch sender.tag {
        case 101:
            if Enefits.shared.isInitComplete == true {
                self.view.makeToast("Yes")
            }else{
                self.view.makeToast("No")
            }
        case 102:
            if Enefits.shared.isAccountConnected == true {
                self.view.makeToast("Yes")
            }else{
                self.view.makeToast("No")
            }
        case 103:
            Enefits.shared.getConnectAccount(apiKeyString :apiKeyValue, completionHandler: { account, blockchainInfo in
                self.view.makeToast(account)
                print("Wallet Addresses....\((blockchainInfo["accounts"] as? [String])?.first ?? "")")
            })
        case 104:
            Enefits.shared.getChainData(apiKeyString :apiKeyValue, completionHandler: { blockchainInfo in
                self.view.makeToast("\(blockchainInfo)")
            })
        default:
            break
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        switch sender.tag {
        case 0:
            /* Check the API key changes from the userdefaults to newly entired key to initialize the SDK */
            var apikey = ""
            let indexPath = IndexPath(row: sender.tag, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell{
                apikey = cell.inputTextfield.text ?? ""
            }
            if apikey == "" {
                self.view.makeToast("Please enter api key")
            }else{
                apiKeyValue = apikey
                Enefits.shared.initializeSDK(name: "EnefitsSample", apiKey: apikey) { flag, message in
                    self.view.makeToast(message)
                }
            }
        case 1:
            Enefits.shared.present(from: self, apiKeyString: apiKeyValue, completionHandler:{ flag, message in
                if flag == false{ /* Already connected or not initialized */
                    self.view.makeToast(message)
                }else{
                    /* Connecting with wallet */
                }
            })
        case 2:
            Enefits.shared.getOffers(apiKeyString :apiKeyValue, completionHandler: { flag, message in
                if flag == false {
                    self.view.makeToast(message)
                }else{
                    let offersVC = self.storyboard?.instantiateViewController(withIdentifier: "OffersViewController") as! OffersViewController
                    offersVC.jsonString = message
                    self.navigationController?.pushViewController(offersVC, animated: true)
                }
            })
        case 3:
            Enefits.shared.disconnect(apiKeyString :apiKeyValue, completionHandler: { flag, message in
                if flag == true {
                    /* Disconnected */
                }else{
                    /* No session found show the error message from SDK */
                }
                self.view.makeToast(message)
            })
        default:
            self.view.makeToast("Please try again")
        }
    }
}


