//
//  ProfileCell.swift
//  OpenCartMpV3
//
//  Created by Webkul on 11/01/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    //@IBOutlet var gradientImageView: UIImageView!
    @IBOutlet var arrowImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //profileImage.layer.cornerRadius = 20;
        //gradientImageView.layer.cornerRadius = 20;
        //profileImage.layer.masksToBounds = true
        //gradientImageView.layer.masksToBounds = true
        //gradientImageView.addBlackGradientLayer(frame: gradientImageView.bounds, colors:GRADIENTCOLOR)
        arrowImg.image =  #imageLiteral(resourceName: "ic_arrow").flipImage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
