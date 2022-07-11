//
//  OrderReviewController.swift
//  Magento2V4Theme
//
//  Created by Webkul on 21/02/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit
import Stripe

class OrderReviewController: UIViewController {
    
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
    
    @IBOutlet weak var orderReviewTableView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var orderReviewModel: OrderReviewViewModel!
    var incrementidValue:String = ""
    var stripeCardToken:String = ""
    
    var paymentContext :STPPaymentContext!
    var isSetShipping = true
    var paymentTextField = STPPaymentCardTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "orderreview".localized
        
        addressImageView.backgroundColor = UIColor.DarkLavendar
        addressImageView.layer.cornerRadius = 4
        addressImageView.layer.masksToBounds = true
        
        shipmentImageView.backgroundColor = UIColor.DarkLavendar
        shipmentImageView.layer.cornerRadius = 4
        shipmentImageView.layer.masksToBounds = true
        
        paymentImageView.backgroundColor = UIColor.DarkLavendar
        paymentImageView.layer.cornerRadius = 4
        paymentImageView.layer.masksToBounds = true
        
        summaryImageView.backgroundColor = UIColor.DarkLavendar
        summaryImageView.layer.cornerRadius = 4
        summaryImageView.layer.masksToBounds = true
        
        self.lblLineAdressRight.backgroundColor = UIColor.DarkLavendar
        self.lblLineShippingLeft.backgroundColor = UIColor.DarkLavendar
        self.lblLineShippingRight.backgroundColor = UIColor.DarkLavendar
        self.lblLinePaymentLeft.backgroundColor = UIColor.DarkLavendar
        self.lblLinePaymentRight.backgroundColor = UIColor.DarkLavendar
        self.lblLineSummaryLeft.backgroundColor = UIColor.DarkLavendar
        
        addressLabel.text = "address".localized
        shippingLabel.text = "shipping".localized
        paymentLabel.text = "payment".localized
        summaryLabel.text = "summary".localized
        cancelButton.title = "cancel".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.applyAfritiaTheme()
        self.title =  "orderreview".localized
        
        let paymentMethodNavigationController = self.tabBarController?.viewControllers?[2]
        let nav1 = paymentMethodNavigationController as! UINavigationController
        let paymentMethodViewController = nav1.viewControllers[0] as! PaymentMethodController
        self.orderReviewModel = paymentMethodViewController.orderReviewModel
        self.orderReviewTableView.register(UINib(nibName: "AddressUITableViewCell", bundle: nil), forCellReuseIdentifier: "address")
        self.orderReviewTableView.register(UINib(nibName: "OrderReviewProductCell", bundle: nil), forCellReuseIdentifier: "OrderReviewProductCell")
        self.orderReviewTableView.register(UINib(nibName: "ContinueToBillTableViewCell", bundle: nil), forCellReuseIdentifier: "continueCell")
        
        self.orderReviewTableView.estimatedRowHeight = 250.0
        self.orderReviewTableView.rowHeight = UITableViewAutomaticDimension
        self.orderReviewTableView.separatorColor = UIColor.clear
        
        if GlobalVariables.CurrentIndex == 4{
            orderReviewTableView.dataSource = self
            orderReviewTableView.delegate = self
        }
    }


    //MARK:- Call API
    func callingHttppApi(){
        
        self.view.isUserInteractionEnabled = false
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        let customerId = DEFAULTS.object(forKey: "customerId")
        let quoteId = DEFAULTS.object(forKey: "quoteId")
        if(customerId != nil){
            requstParams["customerToken"] = customerId
        }
        if(quoteId != nil  ){
            requstParams["quoteId"] = quoteId
        }
        
        if DEFAULTS.object(forKey: "storeId") != nil{
            requstParams["storeId"] = DEFAULTS.object(forKey: "storeId") as! String
        }
        
        requstParams["stripe_id"] = stripeCardToken
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.saveOrder, currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        DEFAULTS .set(storeId, forKey: "storeId")
                    }
                }
                
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                self.doFurtherProcessingWithResult(data:responseObject! as! NSDictionary)
            }
            else if success == 2
            {
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(data :NSDictionary){
        DispatchQueue.main.async {
            let dict = JSON(data)
            if dict["success"].boolValue == true{
                self.incrementidValue = dict["incrementId"].stringValue
                self.performSegue(withIdentifier: "goToSuccessPage", sender: self)
            }
        }
    }
    
    //MARK:- IBAction
    @IBAction func goToShippingAddress(_ sender: UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 0
    }
    
    @IBAction func goToshippingMethod(_ sender: UITapGestureRecognizer) {
        if DEFAULTS.object(forKey: "isVirtual") as! String == "false"{
            self.tabBarController!.selectedIndex = 1
        }
    }
    
    @IBAction func goToPaymentMethod(_ sender: UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 2
    }
    
    @objc func handleRegister(){
        
        if orderReviewModel.paymentCode == "paypal_express"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentInWebViewController") as! PaymentInWebViewController
            vc.paymentURL = AfritiaAPI.payPalPaymentUrl
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if orderReviewModel.paymentCode == "pstk_paystack"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentInWebViewController") as! PaymentInWebViewController
            vc.paymentURL = AfritiaAPI.payStackPaymentUrl
            print("Payment URL ***** ", AfritiaAPI.payStackPaymentUrl)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if orderReviewModel.paymentCode == "stripe_payments"{
            let addCardViewController = STPAddCardViewController()
            addCardViewController.delegate = self
            paymentTextField.delegate = self
            navigationController?.pushViewController(addCardViewController, animated: true)
        }
        else{
            callingHttppApi()
        }
    }
    
    @IBAction func cancelBarBtnClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "goToSuccessPage") {
            let viewController:OrderPlaced = segue.destination as UIViewController as! OrderPlaced
            viewController.incrementId = incrementidValue
        }
    }
}

extension OrderReviewController : UITableViewDelegate , UITableViewDataSource {
    
    //MARK:- UITablewView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 4{
            return orderReviewModel.orderReviewProduct.count
        }else if section == 1{
            if orderReviewModel.orderReviewExtraData.shippingAddress != ""{
                return 1
            }else{
                return 0
            }
        }else if section == 3{
            if orderReviewModel.orderReviewExtraData.shippingMethod != ""{
                return 1
            }else{
                return 0
            }
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = orderReviewModel.orderReviewExtraData.billingAddress
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = orderReviewModel.orderReviewExtraData.shippingAddress
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 2{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = orderReviewModel.orderReviewExtraData.paymentMethod
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 3{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = orderReviewModel.orderReviewExtraData.shippingMethod
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 4
        {
            let cell:OrderReviewProductCell = tableView.dequeueReusableCell(withIdentifier: "OrderReviewProductCell") as! OrderReviewProductCell
            cell.productName.text = orderReviewModel.orderReviewProduct[indexPath.row].productName
            cell.productName.font = UIFont.boldSystemFont(ofSize:15)
            cell.priceValue.text = orderReviewModel.orderReviewProduct[indexPath.row].price
            cell.qtyValue.text = orderReviewModel.orderReviewProduct[indexPath.row].qty
            cell.subtotalValue.text = orderReviewModel.orderReviewProduct[indexPath.row].subtotal
            
            var tempString = ""
            
            for  i in (0..<orderReviewModel.orderReviewProduct[indexPath.row].options.count){
                tempString = tempString+orderReviewModel.orderReviewProduct[indexPath.row].options[i]["label"].stringValue+": "+orderReviewModel.orderReviewProduct[indexPath.row].options[i]["value"].stringValue+"\n"
            }
            cell.optionValue.text = tempString
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:orderReviewModel.orderReviewProduct[indexPath.row].imageUrl , imageView: cell.imageUrl)
            
            cell.selectionStyle = .none
            return cell
            
        }else{
            
            let cell:ContinueToBillTableViewCell = tableView.dequeueReusableCell(withIdentifier: "continueCell") as! ContinueToBillTableViewCell
            cell.subtotalTitleLabel.text = orderReviewModel.orderReviewExtraData.subtotalLabel
            cell.subTotalValue.text = orderReviewModel.orderReviewExtraData.subtotalValue
            cell.shippingTitleLabel.text = orderReviewModel.orderReviewExtraData.shippingChargeLabel
            cell.shippingValue.text = orderReviewModel.orderReviewExtraData.shippingChargeValue
            cell.grandTotalTitleLabel.text = orderReviewModel.orderReviewExtraData.grandTotalLabel
            cell.grandTotalValue.text = orderReviewModel.orderReviewExtraData.grandTotalValue
            cell.taxtitle.text = orderReviewModel.orderReviewExtraData.taxLabel
            cell.taxValue.text = orderReviewModel.orderReviewExtraData.taxValue
            
            
            if orderReviewModel.orderReviewExtraData.discountTitle != ""{
                cell.discountTitle.text = orderReviewModel.orderReviewExtraData.discountTitle
                cell.discountValue.text = orderReviewModel.orderReviewExtraData.discountValue
            }else{
                cell.discountTitle.text = "Discount"
                cell.discountValue.text = "0.00"
            }

            cell.continueBtn.applyAfritiaTheme()
            //cell.continueBtn.addTarget(self, action:#selector(handleRegister), for: .touchUpInside)
            cell.continueBtn.addTargetClosure { (button) in
                self.handleRegister()
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(section == 0){
            if orderReviewModel.orderReviewExtraData.billingAddress != ""{
                return GlobalData.sharedInstance.language(key:"billingaddress").uppercased()
            }else{
                return ""
            }
        }else if(section == 1){
            if orderReviewModel.orderReviewExtraData.shippingAddress != ""{
                return GlobalData.sharedInstance.language(key:"shippingaddress").uppercased()
            }else{
                return ""
            }
        }else if(section == 2){
            return GlobalData.sharedInstance.language(key:"billingmethod").uppercased()
        }else if(section == 3){
            if orderReviewModel.orderReviewExtraData.shippingMethod != ""{
                return GlobalData.sharedInstance.language(key:"shipmentmethod").uppercased()
            }else{
                return  ""
            }
        }else if section == 4 {
            return GlobalData.sharedInstance.language(key:"products").uppercased()
        }else{
            return " "
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 5{
            return 190
        }
        return UITableViewAutomaticDimension
    }
}

extension OrderReviewController:STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        print(textField.cardNumber!)
    }
}

extension OrderReviewController: STPAddCardViewControllerDelegate {

  func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
    self.navigationController?.popViewController(animated: true)
  }

    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreatePaymentMethod paymentMethod: STPPaymentMethod,
                               completion: @escaping STPErrorBlock) {
        self.navigationController?.popViewController(animated: true)
        
        if let strpCardInfo = paymentMethod.card {
            print(strpCardInfo.allResponseFields)
            
            let cardParams: STPCardParams = STPCardParams()
            cardParams.number = "4111111111111111"
            cardParams.expMonth = UInt(strpCardInfo.expMonth)
            cardParams.expYear = UInt(strpCardInfo.expYear)
            cardParams.cvc = "123"
            STPAPIClient.shared.createToken(withCard: cardParams, completion: { (token, error) -> Void in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                if let stpToken = token {
                    print("STRIPE_ID", stpToken.stripeID)
                    print("TOKEN_ID", stpToken.tokenId)
                    
                    self.stripeCardToken = stpToken.tokenId
                    self.callingHttppApi()
                }
            })
        }
    }
  
    /*
  func addCardViewController(_ addCardViewController: STPAddCardViewController,
                             didCreateToken token: STPToken,
                             completion: @escaping STPErrorBlock) {
    self.navigationController?.popViewController(animated: true)
    print(token.tokenId)
    self.stripeCardToken = token.tokenId
    callingHttppApi()
  }*/
    
}
