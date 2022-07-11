//
//  WishListPopUpViewCell.swift
//  Afritia
//
//  Created by Ranjit Mahto on 25/11/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit

class WishListPopUpViewCell: UITableViewCell {

    @IBOutlet weak var imgRadio:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
