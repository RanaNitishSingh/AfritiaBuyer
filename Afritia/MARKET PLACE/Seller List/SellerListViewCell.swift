//
//  SellerListViewCell.swift
//  Getkart
//
//  Created by kunal on 01/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerListViewCell: UITableViewCell {
    
    @IBOutlet weak var sellerImage: UIImageView!
    @IBOutlet weak var sellerName: UIButton!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var noOfProducts: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sellerName.setTitleColor(UIColor.button, for: .normal)
        noOfProducts.textColor = UIColor.appLightGrey
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
