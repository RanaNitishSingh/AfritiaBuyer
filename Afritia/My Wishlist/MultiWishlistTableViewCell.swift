//
//  MultiWishlistTableViewCell.swift
//  Afritia
//
//  Created by Ranjit Mahto on 24/11/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit
import SwipeCellKit

class MultiWishlistTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var logoImageView:UIImageView!
    @IBOutlet weak var lblWishListName:UILabel!
    @IBOutlet weak var btnMoreSwipe:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
