//
//  MyproductreviewTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 23/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit
import HCSStarRatingView

class MyproductreviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageData: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {

        viewButton.setTitle(appLanguage.localize(key: "view"), for: .normal)
        viewButton.applyAfritiaBorederTheme(cornerRadius: 18)
        viewButton.setTitleColor(UIColor.black, for:.normal)
        
    
        ratingView.tintColor = UIColor.DarkLavendar
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
