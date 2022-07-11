//
//  FlagViewCell.swift
//  AfritiaSeller
//
//  Created by Ranjit Mahto on 16/12/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit
import DropDown

class FlagViewCell: DropDownCell {
    
    @IBOutlet weak var flagImageView:UIImageView!
    @IBOutlet weak var lblCountryCode:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
