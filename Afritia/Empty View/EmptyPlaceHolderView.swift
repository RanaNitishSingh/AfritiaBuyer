//
//  EmptyNewAddressView.swift
//  WooCommerce
//
//  Created by Webkul  on 09/11/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class EmptyPlaceHolderView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var emptyImages: UIImageView!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    
    var callBackBtnAction : ((String) -> ())!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("EmptyPlaceHolderView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        addressButton.applyAfritiaTheme()
//        addressButton.layer.cornerRadius = 5;
//        addressButton.layer.masksToBounds = true
//        addressButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
    }
    
    @IBAction func btnAddressClick(_ sender:UIButton){
        self.callBackBtnAction(sender.titleLabel?.text ?? "No title found")
    }
    
}
