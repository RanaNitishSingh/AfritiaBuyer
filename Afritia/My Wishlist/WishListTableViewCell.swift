//
//  WishListTableViewCell.swift
//  MobikulRTL
//
//  Created by shobhit on 18/11/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit
import HCSStarRatingView

class WishListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var startRatings: HCSStarRatingView!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    //@IBOutlet weak var textView: UITextView!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var editBtnBgView: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMove: UIButton!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnAddToCart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        qtyTextField.layer.cornerRadius = 6
        qtyTextField.layer.borderColor = UIColor.DarkLavendar.cgColor
        qtyTextField.layer.borderWidth = 1
        
        editBtnBgView.layer.cornerRadius = 20
        editBtnBgView.layer.borderColor = UIColor.LightLavendar.cgColor
        editBtnBgView.layer.borderWidth = 1
        
        btnAddToCart.applyAfritiaTheme()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
