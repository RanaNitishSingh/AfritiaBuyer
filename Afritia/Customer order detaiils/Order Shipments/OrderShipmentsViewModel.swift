//
/**
FashionHub
@Category Webkul
@author Webkul <support@webkul.com>
FileName: OrderShipmentsViewModel.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/


import Foundation
import UIKit

class OrderShipmentsViewModel : NSObject {
    var customerOrderDetailsModel:CustomerOrderDetailsViewModel!
    var delegate : TrackingInfoProtocol?
    
}

extension OrderShipmentsViewModel : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return customerOrderDetailsModel != nil ? customerOrderDetailsModel.shipmentData.count : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerOrderDetailsModel.shipmentData[section].items.count + customerOrderDetailsModel.shipmentData[section].trackingInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "shipment".localized + " #" + customerOrderDetailsModel.shipmentData[section].incrementId
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <= customerOrderDetailsModel.shipmentData[indexPath.section].items.count - 1{
            //invoice list data
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderShipmentsItemsTableViewCell.identifier, for: indexPath) as! OrderShipmentsItemsTableViewCell
            cell.pName.tag = indexPath.row
            cell.item = customerOrderDetailsModel.shipmentData[indexPath.section].items[indexPath.row]
            return cell
        }else{
            //trcking info list
            let cell:TrackingInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: TrackingInfoTableViewCell.identifier) as! TrackingInfoTableViewCell
            cell.delegate = self
            cell.trackingIDValBtn.superview?.tag = indexPath.section
            cell.trackingIDValBtn.tag = indexPath.row - customerOrderDetailsModel.shipmentData[indexPath.section].items.count
            cell.item = customerOrderDetailsModel.shipmentData[indexPath.section].trackingInfo[indexPath.row - 1]
            return cell
        }
    }
}

//MARK:- Custom delegates
extension OrderShipmentsViewModel : TrackingInfoProtocol{
    func trackingInfoClick(section : Int, index: Int) {
        delegate?.trackingInfoClick(section : section, index: index)
    }
}
