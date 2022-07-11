//
/**
 FashionHub
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderShipmentsViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import UIKit

class OrderShipmentsViewController: UIViewController {
    
    @IBOutlet weak var shipmentTblView: UITableView!
    @IBOutlet weak var trackAllShipmentKLinkBtn : UIButton!
    var orderShipmentsViewModel = OrderShipmentsViewModel()
    var customerOrderDetailsModel:CustomerOrderDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        shipmentTblView.register(OrderShipmentsItemsTableViewCell.nib, forCellReuseIdentifier: OrderShipmentsItemsTableViewCell.identifier)
        shipmentTblView.register(TrackingInfoTableViewCell.nib, forCellReuseIdentifier: TrackingInfoTableViewCell.identifier)
        
        shipmentTblView.rowHeight = UITableViewAutomaticDimension
        shipmentTblView.estimatedRowHeight = 200
        
        shipmentTblView.delegate = orderShipmentsViewModel
        shipmentTblView.dataSource = orderShipmentsViewModel
        orderShipmentsViewModel.delegate = self
        orderShipmentsViewModel.customerOrderDetailsModel = customerOrderDetailsModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if customerOrderDetailsModel != nil {
            if customerOrderDetailsModel.trackingInfoURL != ""{
                trackAllShipmentKLinkBtn.setTitle("trackallShipments".localized, for: .normal)
            }else{
                trackAllShipmentKLinkBtn.setTitle("", for: .normal)
            }
        }
        
        shipmentTblView.delegate = orderShipmentsViewModel
        shipmentTblView.dataSource = orderShipmentsViewModel
        orderShipmentsViewModel.customerOrderDetailsModel = customerOrderDetailsModel
        self.shipmentTblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func trackAllShipmentKLinkBtnClicked(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrackingWebInfoViewController") as! TrackingWebInfoViewController
        vc.trackingUrl = customerOrderDetailsModel.trackingInfoURL
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Custom delegates
extension OrderShipmentsViewController : TrackingInfoProtocol{
    func trackingInfoClick(section : Int, index: Int) {
        if customerOrderDetailsModel.shipmentData[section].trackingInfo[index].url != ""{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrackingWebInfoViewController") as! TrackingWebInfoViewController
            vc.trackingUrl = customerOrderDetailsModel.shipmentData[section].trackingInfo[index].url
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
