//
//  PaymentMethodController.swift
//  Magento2V4Theme
//
//  Created by Webkul on 20/02/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

class PaymentMethodController: UIViewController{
    
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shipmentImageView: UIImageView!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var summaryImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var lblLineAdressRight: UILabel!
    @IBOutlet weak var lblLineShippingLeft: UILabel!
    @IBOutlet weak var lblLineShippingRight: UILabel!
    @IBOutlet weak var lblLinePaymentLeft: UILabel!
    @IBOutlet weak var lblLinePaymentRight: UILabel!
    @IBOutlet weak var lblLineSummaryLeft: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var shipmentPaymentMethodViewModel:ShipmentAndPaymentViewModel!
    var paymentId:String = ""
    var shippingId:String = ""
    var orderReviewModel: OrderReviewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "payment".localized
        
        paymentTableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        paymentTableView.rowHeight = UITableViewAutomaticDimension
        self.paymentTableView.estimatedRowHeight = 50
        paymentTableView.separatorColor = UIColor.clear
        
        
        addressImageView.backgroundColor = UIColor.DarkLavendar
        addressImageView.layer.cornerRadius = 4
        addressImageView.layer.masksToBounds = true
        
        shipmentImageView.backgroundColor = UIColor.DarkLavendar
        shipmentImageView.layer.cornerRadius = 4
        shipmentImageView.layer.masksToBounds = true
        
        paymentImageView.backgroundColor = UIColor.DarkLavendar
        paymentImageView.layer.cornerRadius = 4
        paymentImageView.layer.masksToBounds = true
        
        summaryImageView.layer.cornerRadius = 4
        summaryImageView.layer.masksToBounds = true
        
        self.lblLineAdressRight.backgroundColor = UIColor.DarkLavendar
        self.lblLineShippingLeft.backgroundColor = UIColor.DarkLavendar
        self.lblLineShippingRight.backgroundColor = UIColor.DarkLavendar
        self.lblLinePaymentLeft.backgroundColor = UIColor.DarkLavendar
        self.lblLinePaymentRight.backgroundColor = UIColor.Magnesium
        self.lblLineSummaryLeft.backgroundColor = UIColor.Magnesium

        
        addressLabel.text = "address".localized
        shippingLabel.text = "shipping".localized
        paymentLabel.text = "payment".localized
        summaryLabel.text = "summary".localized
        cancelButton.title = "cancel".localized
        
        //continueButton.backgroundColor = UIColor.button
        //continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.setTitle(GlobalData.sharedInstance.language(key: "continue"), for: .normal)
        continueButton.applyAfritiaTheme()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.applyAfritiaTheme()
        self.title =  "payment".localized
        
        let billingNavigationController = self.tabBarController?.viewControllers?[0]
        let nav = billingNavigationController as! UINavigationController
        let billingViewController = nav.viewControllers[0] as! ShippingAddressViewController
        self.shipmentPaymentMethodViewModel = billingViewController.shipmentPaymentMethodViewModel
        
        let shippingMethodNavigationController = self.tabBarController?.viewControllers?[1]
        let nav1 = shippingMethodNavigationController as! UINavigationController
        let shippingMethodViewController = nav1.viewControllers[0] as! ShippingMethodController
        shippingId = shippingMethodViewController.shippingId
        
        if GlobalVariables.CurrentIndex == 3{
            self.paymentTableView.dataSource = self
            self.paymentTableView.delegate = self
        }
    }
    
    @IBAction func cancelBarBtnClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func goToshippingAddress(_ sender: Any) {
        self.tabBarController!.selectedIndex = 0
    }
    
    @IBAction func goToShippingMethod(_ sender: UITapGestureRecognizer) {
        if DEFAULTS.object(forKey: "isVirtual") as! String == "false"{
            self.tabBarController!.selectedIndex = 1
        }
    }
    
    
    
    @IBAction func continueClick(_ sender: Any) {
        if paymentId == ""{
            AlertManager.shared.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "pleaseselectpaymentmethod"))
        }else {
            callingHttppApi()
        }
    }
    
    func callingHttppApi(){
        self.view.isUserInteractionEnabled = false
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]()
        let customerId = DEFAULTS.object(forKey: "customerId")
        let storeId = DEFAULTS.object(forKey: "storeId")
        let quoteId = DEFAULTS.object(forKey: "quoteId")
        if(customerId != nil){
            requstParams["customerToken"] = customerId
            requstParams["checkoutMethod"] = "customer"
            
        }
        if(quoteId != nil ){
            requstParams["quoteId"] = quoteId
            requstParams["checkoutMethod"] = "guest"
        }
        
        if DEFAULTS.object(forKey: "currency") != nil{ requstParams["currency"] = DEFAULTS.object(forKey: "currency") as! String }
        
        requstParams["method"] = paymentId
        requstParams["shippingMethod"] = shippingId
        requstParams["storeId"] = storeId
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.orderReviewInfo, currentView: self){success,responseObject in
            
            print(responseObject!)
            
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        DEFAULTS.set(storeId, forKey: "storeId")
                    }
                }
                
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                let dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.orderReviewModel =  OrderReviewViewModel(data: dict)
                    self.orderReviewModel.paymentCode = self.paymentId
                    GlobalVariables.CurrentIndex = 4
                    self.tabBarController!.selectedIndex = 3
                    print("sss", dict)
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

extension PaymentMethodController : UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return self.shipmentPaymentMethodViewModel.paymentData.count - 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
         return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as! PaymentTableViewCell
        cell.methodDescription.text = self.shipmentPaymentMethodViewModel.paymentData[indexPath.section].title
        print("Method :", cell.methodDescription.text!)
        
        if paymentId == self.shipmentPaymentMethodViewModel.paymentData[indexPath.section].code{
            cell.roundImageView.backgroundColor = UIColor.button
        }else{
            cell.roundImageView.backgroundColor = UIColor.white
        }
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if paymentId == self.shipmentPaymentMethodViewModel.paymentData[section].code{
           return  self.shipmentPaymentMethodViewModel.paymentData[section].extraInformation
        }else{
          return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paymentId = self.shipmentPaymentMethodViewModel.paymentData[indexPath.section].code
        self.paymentTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
