//
/**
 FashionHub
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: InvoiceViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import Foundation
import UIKit

class InvoiceViewModel: NSObject{
    
    var customerOrderDetailsModel:CustomerOrderDetailsViewModel!
}

extension InvoiceViewModel : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return customerOrderDetailsModel != nil ? customerOrderDetailsModel.invoiceData.count : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerOrderDetailsModel.invoiceData[section].items.count + customerOrderDetailsModel.invoiceData[section].totals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "invoice".localized + " #" + customerOrderDetailsModel.invoiceData[section].incrementId
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <= customerOrderDetailsModel.invoiceData[indexPath.section].items.count - 1{
            //invoice list data
            let cell = tableView.dequeueReusableCell(withIdentifier: InvoiceItemsTableViewCell.identifier, for: indexPath) as! InvoiceItemsTableViewCell
            cell.pName.tag = indexPath.row
            cell.item = customerOrderDetailsModel.invoiceData[indexPath.section].items[indexPath.row]
            return cell
        }else{
            //pricing data
            let cell = tableView.dequeueReusableCell(withIdentifier: PricingTableViewCell.identifier, for: indexPath) as! PricingTableViewCell
            let itemsTotal = customerOrderDetailsModel.invoiceData[indexPath.section].items.count
            cell.title.tag = indexPath.row
            cell.item = customerOrderDetailsModel.invoiceData[indexPath.section].totals[indexPath.row - itemsTotal]
            return cell
        }
    }
}
