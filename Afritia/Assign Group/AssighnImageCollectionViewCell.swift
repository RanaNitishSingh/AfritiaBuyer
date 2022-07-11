//
//  AssighnImageCollectionViewCell.swift
//  Alnazi
//
//  Created by kunal on 15/05/18.
//  Copyright © 2018 himanshu. All rights reserved.
//

import UIKit

class AssighnImageCollectionViewCell: UICollectionViewCell {

    
@IBOutlet var productImage: UIImageView!
@IBOutlet var switchButton: UISwitch!
@IBOutlet var deleteButton: UIButton!
    
    @IBOutlet var baseImageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
