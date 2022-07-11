//
//  AddressViewCell.swift
//  OpenCartMpV3
//
//  Created by Webkul on 15/12/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class AddressViewCell: UITableViewCell {
    
    @IBOutlet weak var addressValue: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var downloadBtn: UIButton!
    
    var item : AddressBookViewModel?    {
        didSet  {
            if (item?.gdprEnable)! && (item?.gdprRequestAddressInfoBtn)!  {
                downloadBtn.isHidden = false
            }else{
                downloadBtn.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editButton.setTitle( appLanguage.localize(key: "editaddress"), for: .normal)
        deleteButton.setTitle(" "+appLanguage.localize(key: "deleteaddress"), for: .normal)
        
        editButton.applyAfritiaTheme()
        deleteButton.applyAfritiaTheme()
        downloadBtn.layer.cornerRadius = 20.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
