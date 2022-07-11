//
/**
FashionHub
@Category Webkul
@author Webkul <support@webkul.com>
FileName: PricingTableViewCell.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/


import UIKit

class PricingTableViewCell: UITableViewCell {

    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var value : UILabel!
    
    static var identifier: String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var item : Totals?{
        didSet{
            title.text = item?.label
            value .text = item?.formattedValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
