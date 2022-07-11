//
//  BigBannerTableViewCell.swift
//  Getkart
//
//  Created by Ranjit Mahto on 22/09/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit

@objc protocol BigBannerTableViewCellDelegate: class {

    func clickOnBanner(type:String)
}

class BigBannerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    var bannerType:String!
    var delegate:BigBannerTableViewCellDelegate!
    
        override func awakeFromNib() {
            super.awakeFromNib()
            bannerImageView.applyRoundCornerBorder(radius:10, width:1, color: UIColor.silver)
            bannerImageView.contentMode = .scaleAspectFill
            bannerImageView.addTapGestureRecognizer {
                self.delegate.clickOnBanner(type: self.bannerType)
            }
        }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
