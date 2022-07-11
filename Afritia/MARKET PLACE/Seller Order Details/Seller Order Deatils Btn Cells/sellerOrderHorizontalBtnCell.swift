//
//  sellerOrderHorizontalBtnCell.swift
//  Getkart
//
//  Created by himanshu on 29/04/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class sellerOrderHorizontalBtnCell: UITableViewCell {
    
    @IBOutlet weak var viewInvoice: UIButton!
    @IBOutlet weak var viewshipment: UIButton!
    @IBOutlet weak var viewRefunds: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewInvoice.setTitle("invoice".localized, for: .normal)
        viewshipment.setTitle("shipment".localized, for: .normal)
        viewRefunds.setTitle("refund".localized, for: .normal)
        
        viewInvoice.backgroundColor = UIColor.button
        viewshipment.backgroundColor = UIColor.button
        viewRefunds.backgroundColor = UIColor.button
        
        viewInvoice.setTitleColor(UIColor.white, for: .normal)
        viewshipment.setTitleColor(UIColor.white, for: .normal)
        viewRefunds.setTitleColor(UIColor.white, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    static var identifier: String   {
        return String(describing: self)
    }
    
    static var nib: UINib   {
        return UINib(nibName: identifier, bundle: nil)
    }
}
