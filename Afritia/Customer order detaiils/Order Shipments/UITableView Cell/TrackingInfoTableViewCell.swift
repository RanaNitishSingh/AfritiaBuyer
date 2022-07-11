//
/**
FashionHub
@Category Webkul
@author Webkul <support@webkul.com>
FileName: TrackingInfoTableViewCell.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/


import UIKit

protocol TrackingInfoProtocol {
    func trackingInfoClick(section : Int, index: Int)
}

class TrackingInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackingTitleLbl : UILabel!
    @IBOutlet weak var trackingTitleVal : UILabel!
    @IBOutlet weak var trackingIDLbl : UILabel!
    @IBOutlet weak var trackingIDValBtn : UIButton!
    @IBOutlet weak var carrierCodeLbl : UILabel!
    @IBOutlet weak var carrierCodeVal : UILabel!
    
    var delegate : TrackingInfoProtocol?
    static var identifier: String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var item : TrackingInfo?{
        didSet{
            trackingTitleVal.text = item?.title
            trackingIDValBtn.setTitle(item?.id, for: .normal)
            carrierCodeVal.text = item?.carrierCode
            
            if item?.url != ""  {
                trackingIDValBtn.setTitleColor(UIColor.blue, for: .normal)
            }else{
                trackingIDValBtn.setTitleColor(UIColor().HexToColor(hexString: "7b7b7b", alpha: 1.0), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        trackingTitleLbl.text = "trackingno".localized
        trackingIDLbl.text = "id".localized
        carrierCodeLbl.text = "carriercode".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func trackingIDValBtnClicked(_ sender: UIButton){
        delegate?.trackingInfoClick(section : (sender.superview?.tag)! ,index: sender.tag)
    }
}
