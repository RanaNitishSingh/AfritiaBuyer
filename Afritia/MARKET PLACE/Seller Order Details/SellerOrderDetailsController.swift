//
//  SellerOrderDetailsController.swift
//  Getkart
//
//  Created by kunal on 05/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerOrderDetailsController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sellerTableView: UITableView!
    
    var incrementId:String = ""
    var sellerOrderDetailsViewModelData:SellerOrderDetailsViewModelData!
    var carrierTextField = UITextField()
    var trackingTextField = UITextField()
    var whichApiToProcess:String!
    var btnCellTotalHeight = 0
    var cellIndexes = [String:Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyAfritiaTheme()
        self.navigationItem.title = "orderdetails".localized
        
        sellerTableView.register(UINib(nibName: "SellerItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "SellerItemsTableViewCell")
        sellerTableView.register(UINib(nibName: "AddressUITableViewCell", bundle: nil), forCellReuseIdentifier: "address")
        sellerTableView.register(UINib(nibName: "SellerShipmentTableViewCell", bundle: nil), forCellReuseIdentifier: "SellerShipmentTableViewCell")
        sellerTableView.register(UINib(nibName: "CustomerInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomerInfoTableViewCell")
        sellerTableView.register(UINib(nibName: "SellerOrderDetailsTotalCell", bundle: nil), forCellReuseIdentifier: "SellerOrderDetailsTotalCell")
        sellerTableView.register(sellerOrderVerticalBtnCell.nib, forCellReuseIdentifier: sellerOrderVerticalBtnCell.identifier)
        sellerTableView.register(sellerOrderHorizontalBtnCell.nib, forCellReuseIdentifier: sellerOrderHorizontalBtnCell.identifier)
        
        sellerTableView.rowHeight = UITableViewAutomaticDimension
        self.sellerTableView.estimatedRowHeight = 100
        self.sellerTableView.separatorColor = UIColor.clear
        
        whichApiToProcess = ""
        callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()
        requstParams["incrementId"] = incrementId
        
        let storeId = DEFAULTS.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = DEFAULTS.object(forKey:"customerId")
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        
        if whichApiToProcess == "shipment"{
            requstParams["carrier"] = carrierTextField.text
            requstParams["trackingId"] = trackingTextField.text
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname: AfritiaSellerAPI.createShipment, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            DEFAULTS.set(storeId, forKey: "storeId")
                        }
                    }
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        AlertManager.shared.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    print("sss", responseObject)
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else if whichApiToProcess == "mail"{
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname: AfritiaSellerAPI.sendOrdereMail, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            DEFAULTS.set(storeId, forKey: "storeId")
                        }
                    }
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        AlertManager.shared.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.whichApiToProcess = ""
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    print("sss", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else if whichApiToProcess == "cancel"{
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname: AfritiaSellerAPI.cancelOrder, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            DEFAULTS.set(storeId, forKey: "storeId")
                        }
                    }
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        AlertManager.shared.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    print("sss", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else if whichApiToProcess == "invoice"{
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaSellerAPI.createInvoice, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            DEFAULTS.set(storeId, forKey: "storeId")
                        }
                    }
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        AlertManager.shared.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    print("sss", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaSellerAPI.viewOrder , currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            DEFAULTS.set(storeId, forKey: "storeId")
                        }
                    }
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        self.sellerOrderDetailsViewModelData = SellerOrderDetailsViewModelData(data:dict)
                        self.sellerTableView.delegate = self
                        self.sellerTableView.dataSource = self
                        self.sellerTableView.reloadData()
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    print("sss", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if section == 0{
            return self.sellerOrderDetailsViewModelData.sellerOrderItemList.count
        }else if section == 2{
            if self.sellerOrderDetailsViewModelData.billingAddress == "" {
                return 0
            }else{
                return 1
            }
        }else if section == 3{
            if self.sellerOrderDetailsViewModelData.shippingAddress == ""{
                return 0
            }else{
                return 1
            }
        }else if section == 5{
            if self.sellerOrderDetailsViewModelData.shippingMethod == ""{
                return 0
            }else{
                return 1
            }
        }else if section == 7    {
            if self.sellerOrderDetailsViewModelData.buyerName != "" || self.sellerOrderDetailsViewModelData.buyerEmail != ""    {
                return 1
            }else{
                return 0
            }
        }else if section == 6{
            
            var returnCellCount = 0
            cellIndexes.removeAll()
            
            if self.sellerOrderDetailsViewModelData.creditMemoButton == 1{
                cellIndexes["creditMemo"] = returnCellCount
                returnCellCount += 1
            }
            
            if self.sellerOrderDetailsViewModelData.sendEmailButton == 1{
                cellIndexes["sendMail"] = returnCellCount
                returnCellCount += 1
            }
            
            if self.sellerOrderDetailsViewModelData.invoiceButton == 1{
                cellIndexes["invoice"] = returnCellCount
                returnCellCount += 1
            }
            
            if self.sellerOrderDetailsViewModelData.shipmentButton == 1{
                cellIndexes["shipment"] = returnCellCount
                returnCellCount += 1
            }
            
            if self.sellerOrderDetailsViewModelData.cancelButton == 1{
                cellIndexes["cancel"] = returnCellCount
                returnCellCount += 1
            }
            
            var f = 0
            
            if self.sellerOrderDetailsViewModelData.invoiceId != "0"{
                f = 1
            }
            
            if self.sellerOrderDetailsViewModelData.shipmentId != "0"{
                f = 1
            }
            
            if self.sellerOrderDetailsViewModelData.creditMemoTab != 0{
                f = 1
            }
            
            if f == 1{
                cellIndexes["bottom"] = returnCellCount
                returnCellCount += 1
            }
            
            return returnCellCount
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 3{
            if sellerOrderDetailsViewModelData.shippingAddress == ""{
                return 0
            }
        }else if indexPath.section == 5{
            if sellerOrderDetailsViewModelData.shipmentId != "0"{
                return 0
            }
        }else if indexPath.section == 6{
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5{
            let cell:SellerShipmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SellerShipmentTableViewCell") as! SellerShipmentTableViewCell
            cell.shipmentValue.text = sellerOrderDetailsViewModelData.shippingMethod
            if sellerOrderDetailsViewModelData.shipmentId != "0"{
                cell.carriertextField.isHidden = true
                cell.trackingtextField.isHidden = true
            }
            self.carrierTextField = cell.carriertextField
            self.trackingTextField = cell.trackingtextField
            
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerItemsTableViewCell", for: indexPath) as! SellerItemsTableViewCell
            cell.productName.text = self.sellerOrderDetailsViewModelData.sellerOrderItemList[indexPath.row].productName
            cell.priceLabelValue.text = self.sellerOrderDetailsViewModelData.sellerOrderItemList[indexPath.row].price
            cell.totalLabelValue.text = self.sellerOrderDetailsViewModelData.sellerOrderItemList[indexPath.row].totalPrice
            cell.admincommissionLabelValue.text = self.sellerOrderDetailsViewModelData.sellerOrderItemList[indexPath.row].adminCommission
            cell.vendorTotalLabelValue.text = self.sellerOrderDetailsViewModelData.sellerOrderItemList[indexPath.row].vendorTotal
            cell.subtotalLabelValue.text = self.sellerOrderDetailsViewModelData.sellerOrderItemList[indexPath.row].subtotal
            
            
            var optionData:String = ""
            for i in 0..<self.sellerOrderDetailsViewModelData.sellerOrderItemList[indexPath.row].sellerQty.count{
                let first = self.sellerOrderDetailsViewModelData.sellerOrderItemList[indexPath.row].sellerQty[i].label
                let second = self.sellerOrderDetailsViewModelData.sellerOrderItemList[indexPath.row].sellerQty[i].value
                optionData = optionData+first!+":"+second!+"\n"
            }
            
            cell.qtyLabelValue.text = optionData
            
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerOrderDetailsTotalCell", for: indexPath) as! SellerOrderDetailsTotalCell
            cell.subtaotalLabelValue.text = self.sellerOrderDetailsViewModelData.subTotal
            cell.shipping_handlingLabelValue.text = self.sellerOrderDetailsViewModelData.shipping
            cell.discountLabelValue.text = self.sellerOrderDetailsViewModelData.discount
            cell.totalTaxValue.text = self.sellerOrderDetailsViewModelData.tax
            cell.totalOrderAmountLabelValue.text = self.sellerOrderDetailsViewModelData.orderTotal
            cell.totalVendorAmountLabelValue.text = self.sellerOrderDetailsViewModelData.vendorTotal
            cell.totalAdminCommissionLabelValue.text = self.sellerOrderDetailsViewModelData.adminCommission
            
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerOrderDetailsViewModelData.billingAddress
            
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 3{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerOrderDetailsViewModelData.shippingAddress
            
            
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 4{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = sellerOrderDetailsViewModelData.paymentMethod
            
            
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 6{
            
            if indexPath.row == cellIndexes["creditMemo"]   {
                if self.sellerOrderDetailsViewModelData.creditMemoButton == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: sellerOrderVerticalBtnCell.identifier, for: indexPath) as! sellerOrderVerticalBtnCell
                    
                    cell.verticalBtn.setTitle("creditmemo".localized, for: .normal)
                    cell.verticalBtn.backgroundColor = UIColor.button
                    cell.verticalBtn.setTitleColor(UIColor.white, for: .normal)
                    cell.verticalBtn.addTarget(self, action: #selector(createCreditMemo(sender:)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }
            }else if indexPath.row == cellIndexes["sendMail"]   {
                if self.sellerOrderDetailsViewModelData.sendEmailButton == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: sellerOrderVerticalBtnCell.identifier, for: indexPath) as! sellerOrderVerticalBtnCell
                    
                    cell.verticalBtn.setTitle("sendmail".localized, for: .normal)
                    cell.verticalBtn.backgroundColor = UIColor.button
                    cell.verticalBtn.setTitleColor(UIColor.white, for: .normal)
                    cell.verticalBtn.addTarget(self, action: #selector(sendMail(sender:)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }
            }else if indexPath.row == cellIndexes["invoice"]   {
                if self.sellerOrderDetailsViewModelData.invoiceButton == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: sellerOrderVerticalBtnCell.identifier, for: indexPath) as! sellerOrderVerticalBtnCell
                    
                    cell.verticalBtn.setTitle("createinvoice".localized, for: .normal)
                    cell.verticalBtn.backgroundColor = UIColor.button
                    cell.verticalBtn.setTitleColor(UIColor.white, for: .normal)
                    cell.verticalBtn.addTarget(self, action: #selector(createInvoice(sender:)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }
            }else if indexPath.row == cellIndexes["shipment"]   {
                if self.sellerOrderDetailsViewModelData.shipmentButton == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: sellerOrderVerticalBtnCell.identifier, for: indexPath) as! sellerOrderVerticalBtnCell
                    
                    cell.verticalBtn.setTitle("createshipment".localized, for: .normal)
                    cell.verticalBtn.backgroundColor = UIColor.button
                    cell.verticalBtn.setTitleColor(UIColor.white, for: .normal)
                    cell.verticalBtn.addTarget(self, action: #selector(createShipment(sender:)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }
            }else if indexPath.row == cellIndexes["cancel"]   {
                if self.sellerOrderDetailsViewModelData.cancelButton == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: sellerOrderVerticalBtnCell.identifier, for: indexPath) as! sellerOrderVerticalBtnCell
                    
                    cell.verticalBtn.setTitle("cancel".localized, for: .normal)
                    cell.verticalBtn.backgroundColor = UIColor.button
                    cell.verticalBtn.setTitleColor(UIColor.white, for: .normal)
                    cell.verticalBtn.addTarget(self, action: #selector(cancelOrder(sender:)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }
            }else if indexPath.row == cellIndexes["bottom"]   {
                let cell = tableView.dequeueReusableCell(withIdentifier: sellerOrderHorizontalBtnCell.identifier, for: indexPath) as! sellerOrderHorizontalBtnCell
                
                if self.sellerOrderDetailsViewModelData.invoiceId != "0"{
                    cell.viewInvoice.isHidden = false
                }else{
                    cell.viewInvoice.isHidden = true
                }
                
                if self.sellerOrderDetailsViewModelData.shipmentId != "0"{
                    cell.viewshipment.isHidden = false
                }else{
                    cell.viewshipment.isHidden = true
                }
                
                if self.sellerOrderDetailsViewModelData.creditMemoTab != 0{
                    cell.viewRefunds.isHidden = false
                }else{
                    cell.viewRefunds.isHidden = true
                }
                
                cell.viewInvoice.addTarget(self, action: #selector(viewInvoicedetails(sender:)), for: .touchUpInside)
                cell.viewshipment.addTarget(self, action: #selector(viewShipmentdetails(sender:)), for: .touchUpInside)
                cell.viewRefunds.addTarget(self, action: #selector(viewRefundList(sender:)), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
            
            //            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerOrderDetailsTopCell", for: indexPath) as! SellerOrderDetailsTopCell
            //            if self.sellerOrderDetailsViewModelData.cancelButton == 1{
            //                cell.cancelHeight.constant = 40
            //                cell.cancelItem.isHidden = false
            //
            //                btnCellTotalHeight = 40 + 8
            //            }else{
            //                cell.cancelHeight.constant = -8
            //                cell.cancelItem.isHidden = true
            //            }
            //
            //            if self.sellerOrderDetailsViewModelData.invoiceButton == 1{
            //                cell.invoiceHeight.constant = 40
            //                cell.createInvoiceButton.isHidden = false
            //
            //                btnCellTotalHeight += 40 + 5
            //            }else{
            //                cell.invoiceHeight.constant = -5
            //                cell.createInvoiceButton.isHidden = true
            //            }
            //
            //            if self.sellerOrderDetailsViewModelData.shipmentButton == 1{
            //                cell.shipmentHeight.constant = 40
            //                cell.createShipmenntButton.isHidden = false
            //
            //                btnCellTotalHeight += 40 + 5
            //            }else{
            //                cell.shipmentHeight.constant = -5
            //                cell.createShipmenntButton.isHidden = true
            //            }
            //
            //            if self.sellerOrderDetailsViewModelData.creditMemoButton == 1{
            //                cell.refundHeight.constant = 40
            //                cell.creditMemoButton.isHidden = false
            //
            //                btnCellTotalHeight += 40 + 5
            //            }else{
            //                cell.refundHeight.constant = -5
            //                cell.creditMemoButton.isHidden = true
            //            }
            //
            //            if self.sellerOrderDetailsViewModelData.sendEmailButton == 1{
            //                cell.mailHeight.constant = 40
            //                cell.sendMailButton.isHidden = false
            //
            //                btnCellTotalHeight += 40
            //            }else{
            //                cell.mailHeight.constant = 0
            //                cell.sendMailButton.isHidden = true
            //            }
            //
            //            var f = 0
            //
            //            if self.sellerOrderDetailsViewModelData.invoiceId == "0"{
            //                cell.viewInvoiceHeight.constant = 0
            //                cell.viewInvoice.isHidden = true
            //            }else{
            //                cell.viewInvoiceHeight.constant = 30
            //                cell.viewInvoice.isHidden = false
            //                f = 1
            //            }
            //
            //            if self.sellerOrderDetailsViewModelData.shipmentId == "0"{
            //                cell.viewshipmentHeight.constant = 0
            //                cell.viewshipment.isHidden = true
            //            }else{
            //                cell.viewshipmentHeight.constant = 30
            //                cell.viewshipment.isHidden = false
            //                f = 1
            //            }
            //
            //            if self.sellerOrderDetailsViewModelData.creditMemoTab == 0{
            //                cell.viewRefundsHeight.constant = 0
            //                cell.viewRefunds.isHidden = true
            //            }else{
            //                cell.viewRefundsHeight.constant = 30
            //                cell.viewRefunds.isHidden = false
            //                f = 1
            //            }
            //
            //            if f == 1{
            //                btnCellTotalHeight += 20 + 40 + 16
            //            }else{
            //                btnCellTotalHeight += 20
            //            }
            //
            //            cell.createShipmenntButton.addTarget(self, action: #selector(createShipment(sender:)), for: .touchUpInside)
            //            cell.createShipmenntButton.isUserInteractionEnabled = true
            //
            //            cell.createInvoiceButton.addTarget(self, action: #selector(createInvoice(sender:)), for: .touchUpInside)
            //            cell.createInvoiceButton.isUserInteractionEnabled = true
            //
            //            cell.sendMailButton.addTarget(self, action: #selector(sendMail(sender:)), for: .touchUpInside)
            //            cell.sendMailButton.isUserInteractionEnabled = true
            //
            //            cell.cancelItem.addTarget(self, action: #selector(cancelOrder(sender:)), for: .touchUpInside)
            //            cell.cancelItem.isUserInteractionEnabled = true
            //
            //            cell.creditMemoButton.addTarget(self, action: #selector(createCreditMemo(sender:)), for: .touchUpInside)
            //            cell.creditMemoButton.isUserInteractionEnabled = true
            //
            //            cell.viewInvoice.addTarget(self, action: #selector(viewInvoicedetails(sender:)), for: .touchUpInside)
            //            cell.viewInvoice.isUserInteractionEnabled = true
            //
            //            cell.viewshipment.addTarget(self, action: #selector(viewShipmentdetails(sender:)), for: .touchUpInside)
            //            cell.viewshipment.isUserInteractionEnabled = true
            //
            //            cell.viewRefunds.addTarget(self, action: #selector(viewRefundList(sender:)), for: .touchUpInside)
            //            cell.viewRefunds.isUserInteractionEnabled = true
            //
            //            cell.setNeedsDisplay()
            //            cell.setNeedsLayout()
            //            cell.layoutIfNeeded()
            
            return UITableViewCell()
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerInfoTableViewCell", for: indexPath) as! CustomerInfoTableViewCell
            cell.customerNameValue.text = self.sellerOrderDetailsViewModelData.buyerName
            cell.emailValue.text = self.sellerOrderDetailsViewModelData.buyerEmail
            
            cell.setNeedsDisplay()
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "itemlist".localized
        }else if section == 3{
            if self.sellerOrderDetailsViewModelData.shippingAddress == ""{
                return ""
            }else{
                return "shippingaddress".localized
            }
        }else if section == 2{
            if self.sellerOrderDetailsViewModelData.billingAddress == ""{
                return ""
            }else{
                return "billingaddress".localized
            }
        }else if section == 4{
            return "billingmethod".localized
        }else if section == 5{
            if self.sellerOrderDetailsViewModelData.shippingMethod == ""{
                return ""
            }else{
                return "shipmentmethod".localized
            }
        }else if section == 7{
            if self.sellerOrderDetailsViewModelData.buyerName != "" || self.sellerOrderDetailsViewModelData.buyerEmail != ""    {
                return "buyerinformation".localized
            }else{
                return ""
            }
        }else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else if section == 2 {
            if sellerOrderDetailsViewModelData.billingAddress != ""{
                return 30
            }else{
                return 0
            }
        }else if section == 3    {
            if sellerOrderDetailsViewModelData.shippingAddress != ""{
                return 30
            }else{
                return 0
            }
        }else if section == 4 {
            if sellerOrderDetailsViewModelData.paymentMethod != ""{
                return 30
            }else{
                return 0
            }
        }else if section == 5{
            if sellerOrderDetailsViewModelData.shipmentId != "0"{
                return 0
            }else{
                return 30
            }
        }else if section == 6 {
            return 0
        }else{
            return 30
        }
    }
    
    @objc func createShipment(sender: UIButton){
        var isValid:Int = 1
        var errorMessage:String = "pleaseselect".localized + " "
        
        if carrierTextField.text! == ""{
            isValid = 0
            errorMessage = errorMessage + "carrier".localized
        }else if trackingTextField.text == ""{
            isValid = 0
            errorMessage = errorMessage + "trackingnumber".localized
        }
        
        if isValid == 0{
            AlertManager.shared.showWarningSnackBar(msg: errorMessage)
        }else{
            whichApiToProcess = "shipment"
            callingHttppApi()
        }
    }
    
    @objc func createInvoice(sender: UIButton){
        whichApiToProcess = "invoice"
        self.callingHttppApi()
    }
    
    @objc func sendMail(sender: UIButton){
        whichApiToProcess = "mail"
        callingHttppApi()
    }
    
    @objc func cancelOrder(sender: UIButton){
        let AC = UIAlertController(title: "pleaseconfirm".localized, message: "cancelorder".localized, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "cancel"
            self.callingHttppApi()
        })
        let noBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
    }
    
    @objc func createCreditMemo(sender: UIButton){
        /*
        let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "CreateCreditMemoViewController") as! CreateCreditMemoViewController
        vc.incrementId = self.incrementId
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    @objc func viewShipmentdetails(sender: UIButton){
        let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ShipmentDetailsController") as! ShipmentDetailsController
        vc.shipmentid = self.sellerOrderDetailsViewModelData.shipmentId
        vc.incrementId = self.incrementId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewRefundList(sender: UIButton){
        
        /*
        let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "CreditMemoListViewController") as! CreditMemoListViewController
        vc.incrementId = self.incrementId
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    @objc func viewInvoicedetails(sender: UIButton) {
        /*
        let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "SellerInvoiceDetailsController") as! SellerInvoiceDetailsController
        vc.invoiceId = self.sellerOrderDetailsViewModelData.invoiceId
        vc.incrementId = self.incrementId
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
}
