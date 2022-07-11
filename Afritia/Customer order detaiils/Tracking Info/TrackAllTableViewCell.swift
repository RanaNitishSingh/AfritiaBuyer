//
/**
FashionHub
@Category Webkul
@author Webkul <support@webkul.com>
FileName: TrackAllTableViewCell.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/


import UIKit

class TrackAllTableViewCell: UITableViewCell {

    @IBOutlet weak var trackAllShipmentKLinkBtn : UIButton!
    
    var delegate : TrackingInfoProtocol?
    
    static var identifier: String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var item : String?{
        didSet{
            if item != ""{
                trackAllShipmentKLinkBtn.setTitle("trackallShipments".localized, for: .normal)
            }else{
                trackAllShipmentKLinkBtn.setTitle("", for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        trackAllShipmentKLinkBtn.setTitle("trackallShipments".localized, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func trackAllShipmentKLinkBtnClicked(_ sender: UIButton){
        
    }
}
