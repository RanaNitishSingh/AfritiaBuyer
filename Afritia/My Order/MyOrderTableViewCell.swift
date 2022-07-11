//
//  MyOrderTableViewCell.swift
//  WooCommerce
//
//  Created by Webkul  on 18/11/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {
@IBOutlet weak var orderLabel: UILabel!
@IBOutlet weak var orderId: UILabel!
@IBOutlet weak var productImgView: UIImageView!
@IBOutlet weak var statusMessage: UILabel!
@IBOutlet weak var placedonLabel: UILabel!
@IBOutlet weak var placedOnDate: UILabel!
@IBOutlet weak var orderDetails: UILabel!
@IBOutlet weak var viewOrderButton: UIButton!
@IBOutlet weak var shipToLabel: UILabel!
@IBOutlet weak var shipToValue: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //orderLabel.textColor = UIColor.appLightGrey
        orderLabel.text = appLanguage.localize(key: "orderid")
        placedonLabel.text = appLanguage.localize(key: "placeon")
        shipToLabel.text = appLanguage.localize(key: "shipto")
        
        placedonLabel.textColor = UIColor.appLightGrey
    
        shipToLabel.textColor = UIColor.appLightGrey
        
        viewOrderButton.applyAfritiaBorederTheme(cornerRadius:4)
        statusMessage.layer.cornerRadius = 4;
        statusMessage.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
