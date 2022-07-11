//
//  SellerItemsTableViewCell.swift
//  Getkart
//
//  Created by kunal on 06/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerItemsTableViewCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabelValue: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var qtyLabelValue: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalLabelValue: UILabel!
    @IBOutlet weak var admincommissionLabel: UILabel!
    @IBOutlet weak var admincommissionLabelValue: UILabel!
    @IBOutlet weak var vendorTotalLabel: UILabel!
    @IBOutlet weak var vendorTotalLabelValue: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var subtotalLabelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        priceLabel.text = "price".localized
        qtyLabel.text = "qty".localized
        totalLabel.text = "totals".localized
        admincommissionLabel.text = "admincommission".localized
        vendorTotalLabel.text = "vendortotal".localized
        subtotalLabel.text = "subtotal".localized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
