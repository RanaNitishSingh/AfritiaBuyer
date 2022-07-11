//
//  SellerShipmentTableViewCell.swift
//  Getkart
//
//  Created by kunal on 06/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerShipmentTableViewCell: UITableViewCell {
    @IBOutlet weak var shipmentValue: UILabel!
    @IBOutlet weak var carriertextField: UITextField!
    @IBOutlet weak var trackingtextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        carriertextField.placeholder = "carrier".localized
        trackingtextField.placeholder = "trackingnumber".localized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
