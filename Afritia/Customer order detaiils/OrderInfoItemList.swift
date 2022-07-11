//
//  OrderInfoItemList.swift
//  OpenCartMpV3
//
//  Created by Webkul on 05/01/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

class OrderInfoItemList: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var skuCode: UILabel!
    //@IBOutlet weak var dynamicView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var qtyValue: UILabel!
    @IBOutlet weak var subtaotalLabel: UILabel!
    @IBOutlet weak var subtotalValue: UILabel!
    //@IBOutlet weak var dynamicViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var ShippedLabel: UILabel!
    @IBOutlet weak var ShippedValue: UILabel!
    @IBOutlet weak var CanceledLabel: UILabel!
    @IBOutlet weak var CanceledValue: UILabel!
    @IBOutlet weak var RefundedLabel: UILabel!
    @IBOutlet weak var RefundedValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        priceLabel.text = GlobalData.sharedInstance.language(key: "price")+":"
        qtyLabel.text = GlobalData.sharedInstance.language(key: "qty")
        subtaotalLabel.text = GlobalData.sharedInstance.language(key: "subtotal")+" :"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
