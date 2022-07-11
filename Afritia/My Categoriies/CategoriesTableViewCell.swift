//
//  CategoriesTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 24/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
        mainView.layer.borderColor = UIColor.LightLavendar.cgColor
        mainView.layer.borderWidth = 1
        mainView.clipsToBounds = true
        
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        //mainView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
