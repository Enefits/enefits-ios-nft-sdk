//
//  WalletListTableViewCell.swift
//  EnefitsSDK
//
//  Created by SIDHUDEVARAYAN K C on 09/08/22.
//

import UIKit

class WalletListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLable : UILabel!
    @IBOutlet weak var logoImageView : ImageLoader!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
