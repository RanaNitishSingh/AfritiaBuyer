//
/**
FashionHub
@Category Webkul
@author Webkul <support@webkul.com>
FileName: InvoiceItemsTableViewCell.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/


import UIKit

class InvoiceItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var pName : UILabel!
    @IBOutlet weak var skuTitle : UILabel!
    @IBOutlet weak var skuVal : UILabel!
    @IBOutlet weak var priceTitle : UILabel!
    @IBOutlet weak var priceVal : UILabel!
    @IBOutlet weak var qtyTitle : UILabel!
    @IBOutlet weak var qtyVal : UILabel!
    @IBOutlet weak var subTotalTitle : UILabel!
    @IBOutlet weak var subTotalVal : UILabel!
    @IBOutlet weak var optionsVal : UILabel!
    
    static var identifier: String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var item : ItemsData?{
        didSet{
            pName.text = item?.name
            skuVal .text = item?.sku
            priceVal .text = item?.price
            qtyVal .text = item?.qty
            subTotalVal .text = item?.subTotal
            
            var optionVal = ""
            for val in (item?.option)!{
                optionVal += val.label + " : " + val.value + "\n"
            }
            optionsVal.text = optionVal
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        skuTitle.text = "skuinvoice".localized
        priceTitle.text = "priceinvoice".localized
        qtyTitle.text = "qtyinvoiced".localized
        subTotalTitle.text = "subtotalinvoice".localized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
