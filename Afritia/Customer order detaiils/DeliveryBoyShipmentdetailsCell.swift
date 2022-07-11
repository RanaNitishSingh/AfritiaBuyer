//
//  DeliveryBoyShipmentdetailsCell.swift
//  Getkart
//
//  Created by Webkul on 10/04/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

class DeliveryBoyShipmentdetailsCell: UITableViewCell {

    
@IBOutlet weak var profileImage: UIImageView!
@IBOutlet weak var name: UILabel!
@IBOutlet weak var otpLabel: UILabel!
@IBOutlet weak var otpValue: UILabel!
@IBOutlet weak var mobileNumber: UILabel!
@IBOutlet weak var vehicleNumber: UILabel!
    
@IBOutlet weak var trackButton: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        otpLabel.text = GlobalData.sharedInstance.language(key: "otp")
        trackButton.setTitle(GlobalData.sharedInstance.language(key: "track"), for: .normal)
        trackButton.setTitleColor(UIColor.button, for: .normal)
        otpValue.textColor = UIColor.appRed
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
