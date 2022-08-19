//
//  ListModel.swift
//  EnefitsSDK_Example
//
//

import Foundation
import UIKit

struct ListDataModel {
    var titleLabel: String?
    var textInputFlag : Bool?
    var buttonTitle: String?
    var helperTitleString : [String]? = []
}

func getListModel() -> [ListDataModel]{
    let listData1 = ListDataModel(titleLabel: "Step 1. Initialize SDK", textInputFlag: false, buttonTitle: "Initialize SDK")
    let listData2 = ListDataModel(titleLabel: "Step 2. Connect to User Wallet", textInputFlag: true, buttonTitle: "Connect with Enefits")
    let listData3 = ListDataModel(titleLabel: "Step 3. Get Offers for User", textInputFlag: true, buttonTitle: "Get Offers for User")
    let listData4 = ListDataModel(titleLabel: "Step 4. Disconnect from Wallet (Optional)", textInputFlag: true, buttonTitle: "Disconnect")
    let listData5 = ListDataModel(titleLabel: "Helper functions", textInputFlag: true, buttonTitle: "", helperTitleString : ["Is Init Complete?","Is Account Connected?","Get Connected Account", "Get Chain Data"])
    var listArray = [ListDataModel]()
    listArray.append(listData1)
    listArray.append(listData2)
    listArray.append(listData3)
    listArray.append(listData4)
    listArray.append(listData5)
    return listArray
}

