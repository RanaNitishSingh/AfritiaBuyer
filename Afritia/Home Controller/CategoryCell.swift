//
//  CategoryCell.swift
//  WooCommerce
//
//  Created by Webkul  on 01/11/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.layer.cornerRadius = 35
        imageView?.clipsToBounds = true
        labelName.textColor = UIColor().HexToColor(hexString: "000000")
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor().HexToColor(hexString: "EEEEEE").cgColor
    }
}
