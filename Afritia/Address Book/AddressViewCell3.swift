//
//  AddressViewCell3.swift
//  Magento2V4Theme
//
//  Created by Webkul on 13/02/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

class AddressViewCell3: UITableViewCell {

    @IBOutlet weak var addressValue: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var downloadButton: UIButton!
    
    var item : AddressBookViewModel?    {
        didSet  {
            if (item?.gdprEnable)! && (item?.gdprRequestAddressInfoBtn)!  {
                downloadButton.isHidden = false
            }else{
                downloadButton.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editButton.setTitle(appLanguage.localize(key: "editaddress"), for: .normal)
        deleteButton.setTitle(appLanguage.localize(key: "deleteaddress"), for: .normal)
        
        editButton.applyAfritiaTheme()
        deleteButton.applyAfritiaTheme()
        
        downloadButton.layer.cornerRadius = 20.0
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
