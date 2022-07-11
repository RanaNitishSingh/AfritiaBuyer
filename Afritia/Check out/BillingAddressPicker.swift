//
//  BillingAddressPicker.swift
//  OpenCartMpV3
//
//  Created by Webkul on 21/12/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class BillingAddressPicker: UIViewController,UITableViewDelegate, UITableViewDataSource,NewAddressAddHandlerDelegate {
    
    @IBOutlet weak var addNewAddressButton: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    
    var addressID:String = ""
    var billingViewModel:BillingAndShipingViewModel!
    var delegate:BillingAddressPickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNewAddressButton.backgroundColor = UIColor.DimLavendar
        addNewAddressButton.setTitleColor(UIColor.DarkLavendar, for: .normal)
        addNewAddressButton.setTitle("addnewaddress".localized, for: .normal)
        addNewAddressButton.layer.borderColor = UIColor.DarkLavendar.cgColor
        addNewAddressButton.layer.borderWidth = 0.5
        addNewAddressButton.layer.cornerRadius = 15
        addNewAddressButton.layer.masksToBounds = true
        
        addressTableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        addressTableView.rowHeight = UITableViewAutomaticDimension
        self.addressTableView.estimatedRowHeight = 50
        addressTableView.separatorColor = UIColor.clear
        addressTableView.dataSource = self
        addressTableView.delegate = self
    }
    
    func callingHttppApi(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            GlobalData.sharedInstance.showLoader()
            var requstParams = [String:Any]();
            let customerId = DEFAULTS.object(forKey: "customerId")
            let storeId = DEFAULTS.object(forKey: "storeId")
            let quoteId = DEFAULTS.object(forKey: "quoteId")
            let currency =  DEFAULTS.object(forKey: "currency")
            if currency != nil{
                requstParams["currency"] = DEFAULTS.object(forKey: "currency") as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId
                requstParams["checkoutMethod"] = "customer"
                requstParams["quoteId"] = ""
            }
            if(quoteId != nil ){
                requstParams["quoteId"] = quoteId
                requstParams["checkoutMethod"] = "guest"
                requstParams["customerToken"] = ""
            }
            
            requstParams["storeId"] = storeId
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.billingShippingInfo, currentView: self){success,responseObject in
                if success == 1{
                    GlobalData.sharedInstance.dismissLoader()
                    print(responseObject as! NSDictionary)
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            DEFAULTS.set(storeId, forKey: "storeId")
                        }
                    }
                    
                    let dict =  JSON(responseObject as! NSDictionary)
                    self.view.isUserInteractionEnabled = true
                    if dict["success"].boolValue == true{
                        self.billingViewModel = BillingAndShipingViewModel(data: dict)
                        GlobalVariables.shippingAndBillingViewModel = self.billingViewModel;
                        self.addressTableView.reloadData()
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return billingViewModel.addressData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as! PaymentTableViewCell
        cell.methodDescription.text = billingViewModel.addressData[indexPath.row].value
        
        if addressID == billingViewModel.addressData[indexPath.row].id{
            cell.roundImageView.backgroundColor = UIColor.button
        }else{
            cell.roundImageView.backgroundColor = UIColor.white
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return GlobalData.sharedInstance.language(key: "ShippingAddress")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addressID = billingViewModel.addressData[indexPath.row].id
        let address = billingViewModel.addressData[indexPath.row].value
        delegate.selectBillingAddress(data: true, addressId:addressID , address: address!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func newAddAddreressSuccess(data:Bool){
        callingHttppApi()
    }
    
    @IBAction func addNewAddressButtonClick(_ sender: UIButton) {
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier:"AddEditAddress") as! AddEditAddress
        vc.addressEdiitByView = .billingAddress
        vc.addOrEdit = "0"
        vc.addressId = "0"
        self.navigationController?.pushViewController(vc, animated:true)
        
        
        //self.performSegue(withIdentifier: "newaddress", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if (segue.identifier! == "newaddress") {
            let viewController:AddEditAddress = segue.destination as UIViewController as! AddEditAddress
            viewController.addOrEdit = "0"
            viewController.addressId = "0"
            viewController.currentClass = "shipping"
            viewController.delegate = self
        }*/
    }
}
