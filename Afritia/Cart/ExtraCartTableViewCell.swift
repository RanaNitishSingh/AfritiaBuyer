//
//  ExtraCartTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 29/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class ExtraCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emptyCartButton: UIButton!
    @IBOutlet weak var updateCartButton: UIButton!
    @IBOutlet weak var applyCouponCodeLabel: UILabel!
    @IBOutlet weak var couponCodeTextFeild: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var subTotalLabelValue: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxLabelValue: UILabel!
    @IBOutlet weak var shippingHandlingLabel: UILabel!
    @IBOutlet weak var shippingHandlingLabelValue: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var grandTotalLabelValue: UILabel!
    @IBOutlet weak var proceedToCheckOutButton: UIButton!
    @IBOutlet weak var discountLabe: UILabel!
    @IBOutlet weak var discountLabelValue: UILabel!
    @IBOutlet weak var shareCartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        emptyCartButton.applyAfritiaTheme()
        updateCartButton.applyAfritiaTheme()
        applyButton.applyAfritiaTheme()
        cancelButton.applyAfritiaTheme()
        proceedToCheckOutButton.applyAfritiaTheme()
        shareCartButton.applyAfritiaTheme()
        
        couponCodeTextFeild.layer.cornerRadius = 6
        couponCodeTextFeild.layer.borderColor = UIColor.DarkLavendar.cgColor
        couponCodeTextFeild.layer.borderWidth = 1
        
        /*
        emptyCartButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        updateCartButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        cancelButton.backgroundColor = UIColor.red
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        proceedToCheckOutButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        emptyCartButton.layer.cornerRadius = 5
        emptyCartButton.clipsToBounds = true
        updateCartButton.layer.cornerRadius = 5
        updateCartButton.clipsToBounds = true
        proceedToCheckOutButton.layer.cornerRadius = 5
        proceedToCheckOutButton.clipsToBounds = true
        applyButton.layer.cornerRadius = 5
        applyButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 5
        cancelButton.clipsToBounds = true
        */
        
        setLangStyleData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        emptyCartButton.setTitle(appLanguage.localize(key: "emptycart"), for: .normal)
        updateCartButton.setTitle(appLanguage.localize(key: "updatecart"), for: .normal)
        applyButton.setTitle(appLanguage.localize(key: "apply"), for: .normal)
        cancelButton.setTitle(appLanguage.localize(key: "cancel"), for: .normal)
        proceedToCheckOutButton.setTitle(appLanguage.localize(key: "checkout"), for: .normal)
        applyCouponCodeLabel.text = appLanguage.localize(key: "applycouponcode")
    }
    
    func setLangStyleData() {
        let languageCode = UserDefaults.standard
        if languageCode.string(forKey: "language") == "ar" {
            subTotalLabelValue.textAlignment = .left
            taxLabelValue.textAlignment = .left
            shippingHandlingLabelValue.textAlignment = .left
            grandTotalLabelValue.textAlignment = .left
            discountLabelValue.textAlignment = .left
        }else{
            subTotalLabelValue.textAlignment = .right
            taxLabelValue.textAlignment = .right
            shippingHandlingLabelValue.textAlignment = .right
            grandTotalLabelValue.textAlignment = .right
            discountLabelValue.textAlignment = .right
        }
    }
}
