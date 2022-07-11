//
//  SearchSuggestionCell.swift
//  Gmart
//
//  Created by Webkul on 19/07/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

class SearchSuggestionCell: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    static var identifier: String   {
        return String(describing: self)
    }
    
    static var nib: UINib   {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImg.layer.cornerRadius = 4
        productImg.layer.borderColor = UIColor.silver.cgColor
        productImg.layer.borderWidth = 0.5
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
