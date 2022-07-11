//
//  TrackingInformationCell.swift
//  Getkart
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class TrackingInformationCell: UITableViewCell {
    
    @IBOutlet weak var carrierLabel: UILabel!
    @IBOutlet weak var carrierLabelValue: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelValue: UILabel!
    @IBOutlet weak var numberLAbel: UILabel!
    @IBOutlet weak var numberValue: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        carrierLabel.text = "carrier".localized
        titleLabel.text = "title".localized
        numberLAbel.text = "number".localized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
