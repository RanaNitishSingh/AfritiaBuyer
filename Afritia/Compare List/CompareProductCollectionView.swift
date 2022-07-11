//
//  CompareProductCollectionView.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 25/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit
import HCSStarRatingView

class CompareProductCollectionView: UICollectionViewCell {
    
    @IBOutlet weak var imageViewData: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var ratingValue: HCSStarRatingView!
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addToCartButton.applyAfritiaBorederTheme(cornerRadius:15)
        addToCartButton.setTitle("addtocart".localized, for: .normal)
        addToCartButton.setTitleColor(UIColor.black, for: .normal)
        
        deleteButton.layer.cornerRadius = 15
        ratingValue.tintColor = UIColor.appOrange
    }
}
