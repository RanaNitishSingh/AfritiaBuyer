//
/**
Getkart
@Category Webkul
@author Webkul <support@webkul.com>
FileName: SubCategoryTableViewCell.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license   https://store.webkul.com/license.html
*/

import UIKit

class SubCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subCategoryName : UILabel!
    @IBOutlet weak var arrowImg : UIImageView!
    
    static var identifier: String   {
        return String(describing: self)
    }
    
    static var nib : UINib  {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var item : String? {
        didSet{
            subCategoryName.text = item
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        arrowImg.image =  #imageLiteral(resourceName: "ic_arrow").flipImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
