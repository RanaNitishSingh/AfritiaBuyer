//
//  AddTrackingInfoCell.swift
//  Getkart
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class AddTrackingInfoCell: UITableViewCell,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var carrierLabel: UILabel!
    @IBOutlet weak var carrierField: UITextField!
    @IBOutlet weak var titleLabekl: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var sellerShipmentDetailsViewModel:SellerShipmentDetailsViewModel!
    var currentCarrierNumber:Int = 0
    var delegate:ShippingTrackingDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        carrierLabel.text = "carrier".localized
        titleLabekl.text = "title".localized
        numberLabel.text = "number".localized
        addButton.setTitle("add".localized, for: .normal)
        addButton.setTitleColor(UIColor.button, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func addClick(_ sender: UIButton) {
        var isValid:Int = 1
        var errorMessage:String = "pleasefill".localized
        if carrierField.text == "" {
            isValid = 0
            errorMessage = errorMessage + "carrier".localized
        } else if numberField.text == "" {
            isValid = 0
            errorMessage = errorMessage + "number".localized
        } else if titleField.text == "" {
            isValid = 0
            errorMessage = errorMessage + "title".localized
        }
        
        if isValid == 0 {
            AlertManager.shared.showWarningSnackBar(msg: errorMessage)
        } else {
            delegate.getShippingTrackingInfo(pos: currentCarrierNumber, title: titleField.text!, numberValue: numberField.text!)
        }
    }
    
    @IBAction func carrierClick(_ sender: UITextField) {
        if self.sellerShipmentDetailsViewModel.trackingCarrier.count > 0 {
            let thePicker = UIPickerView()
            thePicker.tag = 1000;
            carrierField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sellerShipmentDetailsViewModel.trackingCarrier.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sellerShipmentDetailsViewModel.trackingCarrier[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        carrierField.text =  self.sellerShipmentDetailsViewModel.trackingCarrier[row].label
        currentCarrierNumber = row
    }
}
