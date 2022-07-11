//
//  ShowPreviewCell.swift
//  Getkart
//
//  Created by Webkul on 23/07/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

class ShowPreviewCell: UITableViewCell {

    
@IBOutlet var productImage: UIImageView!
@IBOutlet var productDescription: UILabel!
@IBOutlet var productBackgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.layer.cornerRadius = 40
        productImage.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
