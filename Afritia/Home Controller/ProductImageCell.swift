//
//  ProductImageCell.swift
//  WooCommerce
//
//  Created by Webkul  on 04/11/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class ProductImageCell: UICollectionViewCell {
    
    @IBOutlet var lblShipping: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var specialPrice: UILabel!
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var addToCompareButton: UIButton!
    @IBOutlet weak var btnQuickView: UIButton!
    @IBOutlet weak var btnQuickViewHeight: NSLayoutConstraint!
    
    //var isShowBtnQuickView:Bool = true
    var showFeature:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productName.font = UIFont.systemFont(ofSize:14, weight:.semibold)
        specialPrice.isHidden = true
        btnQuickView.applyAfritiaBorederTheme(cornerRadius:15)
        
        /*
        if isShowBtnQuickView {
            self.btnQuickViewHeight.constant = 30
            self.btnQuickView.isHidden = false
        }
        else{
            self.btnQuickViewHeight.constant = 00
            self.btnQuickView.isHidden = true
        }*/
    }
}
