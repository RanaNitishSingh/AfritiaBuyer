//
//  ProductImageCell.swift
//  WooCommerce
//
//  Created by Webkul  on 04/11/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class CategoryTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryName.font = UIFont.systemFont(ofSize:16, weight:.semibold)
    }
}
