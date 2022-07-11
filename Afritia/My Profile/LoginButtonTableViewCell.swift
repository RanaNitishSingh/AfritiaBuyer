//
//  LoginButtonTableViewCell.swift
//  Afritia
//
//  Created by Ranjit Mahto on 29/09/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit


@objc protocol LoginButtonHandlerDelegate: class {
    func btnSignInClick()
    func btnRegisterClick()
    func btnDowloadMerchantAppClick()
    func btnSocialMediaClick(appType:String)
}

class LoginButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnSignIn:UIButton!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var btnDowloadMerchantApp:UIButton!
    var delegate:LoginButtonHandlerDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnSignIn.applyAfritiaTheme()
        btnRegister.applyAfritiaTheme()
        btnDowloadMerchantApp.applyAfritiaTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnSignInClick(_ sender:UIButton){
        self.delegate.btnSignInClick()
    }
    
    @IBAction func btnRegisterClick(_ sender:UIButton){
        self.delegate.btnRegisterClick()
    }
    
    @IBAction func btnSocialMediaClick(_ sender:UIButton){
        
        switch(sender.tag) {
            
        case 111:
            self.delegate.btnSocialMediaClick(appType:AppType.Facebook)
        case 112:
            self.delegate.btnSocialMediaClick(appType:AppType.Twitter)
        case 113:
            self.delegate.btnSocialMediaClick(appType:AppType.LinkedIn)
        case 114:
            self.delegate.btnSocialMediaClick(appType:AppType.Youtube)
        case 115:
            self.delegate.btnSocialMediaClick(appType:AppType.Pinterest)
        case 116:
            self.delegate.btnSocialMediaClick(appType:AppType.Instagram)
            
        default:
            print("no media type")
        }
    }
    
    @IBAction func btnDowloadMerchantAppClick(_ sender:UIButton){
        self.delegate.btnDowloadMerchantAppClick()
    }
    
}
