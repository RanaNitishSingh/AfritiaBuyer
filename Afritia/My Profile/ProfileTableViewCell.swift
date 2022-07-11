//
//  ProfileTableViewCell.swift
//  Magento2V4Theme
//
//  Created by Webkul on 10/02/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileBannerImage: UIImageView!
    @IBOutlet weak var visualView: UIVisualEffectView!
    @IBOutlet var editView: UIVisualEffectView!
    @IBOutlet weak var editLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        visualView.isHidden = true
//        profileEmail.isHidden = true
        
        profileImage.applyRoundCornerBorder(radius:10, width:2, color:UIColor.DarkLavendar)
        
        //profileImage.layer.cornerRadius = 10
        //profileImage.layer.masksToBounds = true
        
        editView.layer.cornerRadius = 4
        editView.layer.masksToBounds = true
        editLbl.text = "profileedit".localized
        
        //profileImage.applyRoundCornerShadow(radius: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
