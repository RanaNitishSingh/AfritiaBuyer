//
//  SellerOrderFilterController.swift
//  Getkart
//
//  Created by kunal on 27/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import DropDown

@objc protocol OrderFilterDelegate: class {
    func orderFilterData(data:Bool,orderid:String,fromDate:String,toDate:String,status:String)
}

class OrderFilterController: UIViewController {
    
    //@IBOutlet weak var filterLabel: UILabel!
    //@IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var orderIdTextField: UITextField!
    @IBOutlet weak var selectDateLabel: UILabel!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var orderStatusTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var ApplyButton: UIButton!
    
    var sellerOrderViewModel:SellerOrderViewModel!
    var status:String = ""
    var delegate: OrderFilterDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.applyAfritiaBorederTheme(cornerRadius:20)
        resetButton.setTitle("reset".localized, for: .normal)

        ApplyButton.applyAfritiaBorederTheme(cornerRadius:20)
        ApplyButton.setTitle("apply".localized, for: .normal)

        
        //filterLabel.text = "filter".localized
        selectDateLabel.text = "selectdate".localized
        orderIdTextField.placeholder = "enterorderid".localized
        fromDateTextField.placeholder = "fromdate".localized
        toDateTextField.placeholder = "todate".localized
        
        fromDateTextField.delegate = self
        toDateTextField.delegate = self
        
        orderStatusTextField.placeholder = "orderstatus".localized
        
        /*
        if sellerOrderViewModel.orderStatus.count > 0{
            orderStatusTextField.text = sellerOrderViewModel.orderStatus[0].label
            status = sellerOrderViewModel.orderStatus[0].status
        }*/
    }
    
    @IBAction func dismissController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func selectFromDate(){
        
        RPicker.selectDate {(selectedDate) in
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            self.fromDateTextField.text = formatter.string(from:selectedDate)
            }
    }
    
    func selectToDate(){
        
        RPicker.selectDate {(selectedDate) in
                // TODO: Your implementation for date
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            self.toDateTextField.text = formatter.string(from:selectedDate)
                //self.fromDateTextField.text = selectedDate.dateString("MMM-dd-YYYY")
            }
    }
    
    func showStatusPicker() {
        
        let dropDown = DropDown()
        dropDown.anchorView = self.orderStatusTextField // UIView or UIBarButtonItem

        let dataSource = ["Processing", "Closed", "Pending", "Complete"]
        /*for i in 0..<self.sellerOrderViewModel.orderStatus.count {
            dataSource.append(sellerOrderViewModel.orderStatus[i].label)
        }*/
        
        dropDown.dataSource = dataSource
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            //self.selectedStatus = "\(index)"
            self.orderStatusTextField.text = item
            self.status = item
        }
        
        dropDown.direction = .any
        dropDown.width = self.orderStatusTextField.frame.size.width
        
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .automatic
        
        dropDown.show()
    }
    
    @IBAction func orderStatusClick(_ sender: UITextField) {
        self.showStatusPicker()
        /*
        let thePicker = UIPickerView()
        thePicker.tag = 1000;
        orderStatusTextField.inputView = thePicker
        thePicker.delegate = self
         */
    }
    
    @IBAction func applyClick(_ sender: UIButton) {
        delegate.orderFilterData(data: true, orderid: orderIdTextField.text!, fromDate: fromDateTextField.text!, toDate: toDateTextField.text!, status: status)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClick(_ sender: UIButton) {
        orderIdTextField.text = ""
        fromDateTextField.text = ""
        toDateTextField.text = ""
        orderStatusTextField.text = sellerOrderViewModel.orderStatus[0].label
        status = sellerOrderViewModel.orderStatus[0].status
    }
    
    /*
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sellerOrderViewModel.orderStatus.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sellerOrderViewModel.orderStatus[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.orderStatusTextField.text =  self.sellerOrderViewModel.orderStatus[row].label
    }*/
}


extension OrderFilterController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        if textField == self.fromDateTextField{
            self.selectFromDate()
            return false
        }
        else if textField == self.toDateTextField{
            self.selectToDate()
            return false
        }
        return true
    }
}
