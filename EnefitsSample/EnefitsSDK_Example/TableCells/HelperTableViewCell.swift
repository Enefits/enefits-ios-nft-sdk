//
//  HelperTableViewCell.swift
//  EnefitsSDK_Example
//
//  Created by SIDHUDEVARAYAN K C on 10/08/22.
//

import UIKit

class HelperTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLable : UILabel!
    @IBOutlet weak var initButton : UIButton!
    @IBOutlet weak var isAccConnectedButton : UIButton!
    @IBOutlet weak var accConnectedButton : UIButton!
    @IBOutlet weak var chainDataButton : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initButton.primaryButtonUI()
        self.isAccConnectedButton.primaryButtonUI()
        self.accConnectedButton.primaryButtonUI()
        self.chainDataButton.primaryButtonUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
