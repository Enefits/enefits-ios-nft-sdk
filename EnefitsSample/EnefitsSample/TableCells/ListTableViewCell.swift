//
//  ListTableViewCell.swift
//  EnefitsSDK_Example
//
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLable : UILabel!
    @IBOutlet weak var actionButton : UIButton!
    @IBOutlet weak var inputTextfield : UITextField!
    @IBOutlet weak var inputTextfieldTopConstrain : NSLayoutConstraint!
    @IBOutlet weak var inputTextfieldBottomConstrain : NSLayoutConstraint!
    @IBOutlet weak var inputTextfieldHeightConstrain : NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.actionButton.primaryButtonUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
