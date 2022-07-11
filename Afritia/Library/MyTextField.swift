 //
//  MyTextField.swift
//  Alnazi
//
//  Created by rakesh on 18/05/18.
//  Copyright © 2018 himanshu. All rights reserved.
//

import UIKit
import UIFloatLabelTextField

class MyTextField: UIFloatLabelTextField {
    public var row: Int?
    public var section: Int?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if self.textAlignment != .center{
            let languageCode = UserDefaults.standard
            if languageCode.string(forKey: "language") == "ar" {
                self.textAlignment = .right
            } else {
                self.textAlignment = .left
            }
        }
        
        
    }

}


class MySkyTextField: SkyFloatingLabelTextField {
    public var row: Int?
    public var section: Int?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if self.textAlignment != .center{
            let languageCode = UserDefaults.standard
            if languageCode.string(forKey: "language") == "ar" {
                self.textAlignment = .right
            } else {
                self.textAlignment = .left
            }
        }
    }
    
}
