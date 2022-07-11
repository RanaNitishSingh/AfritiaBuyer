//
//  CustomerOrderDetails.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 23/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class CustomerOrderDetails: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    var incrementId:String!
    var customerOrderDetailsModel:CustomerOrderDetailsViewModel!
    var dynamicSummaryHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.applyAfritiaTheme()
        self.navigationItem.title =  appLanguage.localize(key: "orderdetails")
    
        
        tableView.register(UINib(nibName: "AddressUITableViewCell", bundle: nil), forCellReuseIdentifier: "address")
        tableView.register(UINib(nibName: "OrderInfoItemList", bundle: nil), forCellReuseIdentifier: "OrderInfoItemList")
        tableView.register(UINib(nibName: "OrderSummaryCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryCell")
        tableView.register(UINib(nibName: "StatusOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "StatusOrderTableViewCell")
        
        tableView.register(TrackingInfoTableViewCell.nib, forCellReuseIdentifier: TrackingInfoTableViewCell.identifier)
        tableView.register(TrackAllTableViewCell.nib, forCellReuseIdentifier: TrackAllTableViewCell.identifier)
        
        self.tableView.estimatedRowHeight = 250.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.clear
        
        tableView.backgroundColor = UIColor.PureWhite

    }
    
    func getHeaderText(section:Int) -> String {
        if section == 0{
            return "#"+self.incrementId
        }else if(section == 1){
            if customerOrderDetailsModel.customerOrderDetailsModel.billingAddress != ""{
                return "  "+"billingaddress".localized
            }else{
                return ""
            }
        }else if(section == 2){
            if customerOrderDetailsModel.customerOrderDetailsModel.paymentMethod != ""{
                return "  "+"billingmethod".localized
            }else{
                return ""
            }
        }else if(section == 3){
            return "  "+"shippingaddress".localized
        }else if(section == 4){
            return "  "+"shipmentmethod".localized
        }else if(section == 5){
            return "  "+"itemlist".localized
        }else if(section == 6){
            return "  "+"ordersummary".localized
        }else{
            return ""
        }
    }
    
    func getStatusColor(status:String) -> UIColor {
        
        if status == "pending"{
            return UIColor.appOrange
        }else if status == "complete"{
            return UIColor.appGreen
        }else if status == "processing"{
            return  UIColor.appGreen
        }else if status == "cancel"{
            return UIColor.appRed
        }
        return UIColor.clear
    }

}


extension CustomerOrderDetails: UITableViewDelegate,UITableViewDataSource  {
    
    func  numberOfSections(in tableView: UITableView) -> Int {
        return customerOrderDetailsModel != nil ? 7 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1{
            if customerOrderDetailsModel.customerOrderDetailsModel.billingAddress != ""{
                return 1
            }else{
                return 0
            }
        }
        else if section == 2{
            if customerOrderDetailsModel.customerOrderDetailsModel.paymentMethod != ""{
                return 1
            }else{
                return 0
            }
        }
        else if section == 3{
            if customerOrderDetailsModel.customerOrderDetailsModel.shippingAddress != ""{
                return 1
            }else{
                return 0
            }
        }
        else if section == 4{
            if customerOrderDetailsModel.customerOrderDetailsModel.shippingMethod != ""{
                return 1
            }else{
                return 0
            }
        }
        else if section == 5{
            return customerOrderDetailsModel.customerOrderList.count
        }
        else if section == 6{
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 6{
            return dynamicSummaryHeight + 50
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell:StatusOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StatusOrderTableViewCell") as! StatusOrderTableViewCell
            
            cell.placeOnDateValue.text = customerOrderDetailsModel.customerOrderDetailsModel.orderDate
            cell.statusMessage.text = " "+customerOrderDetailsModel.customerOrderDetailsModel.status+" "
            cell.statusMessage.backgroundColor = self.getStatusColor(status: customerOrderDetailsModel.customerOrderDetailsModel.status.lowercased())
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = customerOrderDetailsModel.customerOrderDetailsModel.billingAddress
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 2{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = customerOrderDetailsModel.customerOrderDetailsModel.paymentMethod
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 3{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = customerOrderDetailsModel.customerOrderDetailsModel.shippingAddress
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 4{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = customerOrderDetailsModel.customerOrderDetailsModel.shippingMethod
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 5{
            
            let cell:OrderInfoItemList = tableView.dequeueReusableCell(withIdentifier: "OrderInfoItemList") as! OrderInfoItemList
            
            let orderItemInfo = customerOrderDetailsModel.customerOrderList[indexPath.row]
            
            cell.productName.text = orderItemInfo.productName
            //cell.skuCode.text = orderItemInfo.sku
            
            cell.priceLabel.text = "Price:"
            cell.priceValue.text = orderItemInfo.price
            
            cell.qtyLabel.text = "Quantity:"
            cell.qtyValue.text = "Ordered:" + orderItemInfo.qty_Ordered
            
            cell.subtaotalLabel.text = "Subtotal:"
            cell.subtotalValue.text = orderItemInfo.SubTotal
            
            cell.ShippedLabel.text = "Shipped"
            cell.ShippedValue.text = orderItemInfo.qty_Shipped
            
            cell.CanceledLabel.text = "Canceled:"
            cell.CanceledValue.text = orderItemInfo.qty_Canceled
            
            cell.RefundedLabel.text = "Refunded:"
            cell.RefundedValue.text = orderItemInfo.qty_Refunded
            
            /*
            var qtyValue = ""
            if customerOrderDetailsModel.customerOrderList[indexPath.row].qty_CanceledValue != 0{
                qtyValue = qtyValue+GlobalData.sharedInstance.language(key: "canceled")+" :"+customerOrderDetailsModel.customerOrderList[indexPath.row].qty_Canceled+"\n"
            }
            if customerOrderDetailsModel.customerOrderList[indexPath.row].qty_OrderedValue != 0{
                qtyValue = qtyValue+GlobalData.sharedInstance.language(key: "ordered")+" :"+customerOrderDetailsModel.customerOrderList[indexPath.row].qty_Ordered+"\n"
            }
            if customerOrderDetailsModel.customerOrderList[indexPath.row].qty_RefundedValue != 0{
                qtyValue = qtyValue+GlobalData.sharedInstance.language(key: "refunded")+" :"+customerOrderDetailsModel.customerOrderList[indexPath.row].qty_Refunded+"\n"
            }
            if customerOrderDetailsModel.customerOrderList[indexPath.row].qty_ShippedValue != 0{
                qtyValue = qtyValue+GlobalData.sharedInstance.language(key: "shipped")+" :"+customerOrderDetailsModel.customerOrderList[indexPath.row].qty_Shipped+"\n"
            }
            cell.qtyValue.text = qtyValue
            
            let optionDict = customerOrderDetailsModel.customerOrderList[indexPath.row].options
            var stringData = ""
            var finalData = ""
            
            if (optionDict.count) > 0 {
                
                for j in 0..<(optionDict.count){
                    let dict = optionDict[j]
                    stringData  = stringData+(dict["label"].stringValue)+": "+(dict["value"].stringValue)+"\n"
                }
                finalData = GlobalData.sharedInstance.language(key: "options")+"\n"+stringData
            }
            
            cell.skuCode.text = finalData
            */
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 6 {
            let cell:OrderSummaryCell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryCell") as! OrderSummaryCell
            
            var labelYPos:CGFloat = 0
            
            for subViews: UIView in cell.dynamicView.subviews {
                subViews.removeFromSuperview()
            }
            
            for i in 0..<customerOrderDetailsModel.customerTotalData.count{
                let leadPadding:CGFloat = 5
                let tailPadding:CGFloat = 5
                let valueLabelWidth:CGFloat = 120
                let fullLabelWidth = cell.dynamicView.frame.size.width - (leadPadding + tailPadding)
                let titleLabelWidth = fullLabelWidth - (valueLabelWidth + ((leadPadding + tailPadding) * 2))
                
                let gridSpace:CGFloat = 3
                let labelHeight:CGFloat = 24
                let totalInfo = customerOrderDetailsModel.customerTotalData[i]
                
                let titleLabelXPos:CGFloat = leadPadding
                let valueLabelXPos = leadPadding + titleLabelWidth + gridSpace
                
                let optionLabel = UILabel(frame: CGRect(x: titleLabelXPos, y: labelYPos, width: titleLabelWidth, height: labelHeight))
                optionLabel.font = UIFont(name: BOLDFONT, size: CGFloat(16))!
                optionLabel.textAlignment = .left
                optionLabel.text =  totalInfo.label //customerOrderDetailsModel.customerTotalData[i].label
                optionLabel.backgroundColor = UIColor.Mercury
                optionLabel.textColor = UIColor.darkGray
                cell.dynamicView.addSubview(optionLabel)
                
                //Y += 20
                
                let optionValue = UILabel(frame: CGRect(x: valueLabelXPos , y: labelYPos, width: valueLabelWidth, height: labelHeight))
                optionValue.font = UIFont(name: REGULARFONT, size: CGFloat(16))!
                optionValue.textAlignment = .right
                //optionValue.text = customerOrderDetailsModel.customerTotalData[i].code == "discount" ? "-"+customerOrderDetailsModel.customerTotalData[i].value : customerOrderDetailsModel.customerTotalData[i].value
                optionValue.text = totalInfo.code == "discount" ? "-"+totalInfo.value : totalInfo.value
                optionValue.backgroundColor = UIColor.silver
                optionValue.textColor = UIColor.black
                cell.dynamicView.addSubview(optionValue)
                
                labelYPos += (labelHeight + gridSpace)
            }
            cell.dynamicViewHeightConstarints.constant = labelYPos
            dynamicSummaryHeight = labelYPos
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
        
    }

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.backgroundColor = UIColor.DimLavendar
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = self.getHeaderText(section:section)
            label.font = UIFont.systemFont(ofSize:16)// my custom font
            label.textColor = UIColor.black // my custom colour
            label.backgroundColor = UIColor.clear
            headerView.addSubview(label)
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 40
        }
        else if(section == 1){
            if customerOrderDetailsModel.customerOrderDetailsModel.billingAddress != "" {
                return 40
            }else{
                return 0
            }
        }
        else if(section == 2){
            if customerOrderDetailsModel.customerOrderDetailsModel.paymentMethod != ""{
                return 40
            }else{
                return 0
            }
        }
        else if(section == 3){
            if customerOrderDetailsModel.customerOrderDetailsModel.shippingAddress != ""{
                return 40
            }else{
                return 0
            }
        }
        else if(section == 4){
            if customerOrderDetailsModel.customerOrderDetailsModel.shippingMethod != ""{
                return 40
            }else{
                return 0
            }
        }
        else if section == 5{
            return 40
        }
        else if section == 6{
            return 40
        }
        else{
            return 0
        }
    }
}
