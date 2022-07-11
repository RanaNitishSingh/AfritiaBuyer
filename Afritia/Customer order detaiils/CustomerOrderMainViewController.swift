//
/**
FashionHub
@Category Webkul
@author Webkul <support@webkul.com>
FileName: CustomerOrderMainViewController.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/

import UIKit

class CustomerOrderMainViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var orderScrollView: UIScrollView!
    @IBOutlet weak var orderContainerView: UIView!
    @IBOutlet weak var invoiceContainerView: UIView!
    @IBOutlet weak var shipmentsContainerView: UIView!
    @IBOutlet weak var orderBtn : UIButton!
    @IBOutlet weak var invoiceBtn : UIButton!
    @IBOutlet weak var shipmentsBtn : UIButton!
    var incrementId:String!
    var customerOrderDetailsModel:CustomerOrderDetailsViewModel!
    let defaults = UserDefaults.standard
    var customerOrderDetails : CustomerOrderDetails!
    var invoiceViewController : InvoiceViewController!
    var orderShipmentsViewController : OrderShipmentsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.applyAfritiaTheme()
        self.navigationItem.title = "orderdetails".localized
        
        setLayout()
        callingHttppApi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLayout(){
        orderBtn.setTitle("itemsordered".localized, for: .normal)
        invoiceBtn.setTitle("invoices".localized, for: .normal)
        shipmentsBtn.setTitle("ordershipments".localized, for: .normal)
        
        self.orderBtn.backgroundColor = UIColor.DimLavendar
        self.invoiceBtn.backgroundColor = UIColor.DimLavendar
        self.shipmentsBtn.backgroundColor = UIColor.DimLavendar
        
        orderBtn.setTitleColor(UIColor.DarkLavendar, for: .normal)
        invoiceBtn.setTitleColor( UIColor.appLightGrey, for: .normal)
        shipmentsBtn.setTitleColor( UIColor.appLightGrey, for: .normal)
    }
    
    //MARK:- Call API
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]()
        if self.defaults.object(forKey: "currency") != nil{
            requstParams["currency"] = self.defaults.object(forKey: "currency") as! String
        }
        requstParams["incrementId"] = incrementId
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.orderDetails, currentView: self){success,responseObject in
            if success == 1{
                
                print(responseObject)
                GlobalData.sharedInstance.dismissLoader()
                self.customerOrderDetailsModel =  CustomerOrderDetailsViewModel(data: JSON(responseObject as! NSDictionary))
                
                self.customerOrderDetails.customerOrderDetailsModel = self.customerOrderDetailsModel
                self.customerOrderDetails.tableView.reloadData()
                
                self.invoiceViewController.customerOrderDetailsModel = self.customerOrderDetailsModel
                self.orderShipmentsViewController.customerOrderDetailsModel = self.customerOrderDetailsModel
                
                self.apiResponse()
            }else if success == 2{
                self.callingHttppApi()
                GlobalData.sharedInstance.dismissLoader()
            }
        }
    }
    
    func apiResponse(){
        if self.customerOrderDetailsModel.customerOrderDetailsModel.hasInvoices {
            self.invoiceBtn.isHidden = false
        }else{
            self.invoiceBtn.isHidden = true
        }
        
        if self.customerOrderDetailsModel.customerOrderDetailsModel.hasShipments {
            self.shipmentsBtn.isHidden = false
        }else{
            self.shipmentsBtn.isHidden = true
        }
    }
    
    //MARK:- @IBAction
    @IBAction func orderBtnClicked(_ sender: UIButton){
        orderBtn.setTitleColor(UIColor.DarkLavendar, for: .normal)
        invoiceBtn.setTitleColor( UIColor.appLightGrey, for: .normal)
        shipmentsBtn.setTitleColor(UIColor.appLightGrey, for: .normal)
        orderScrollView.contentOffset.x = 0
    }
    
    @IBAction func invoiceBtnClicked(_ sender: UIButton){
        orderBtn.setTitleColor( UIColor.appLightGrey, for: .normal)
        invoiceBtn.setTitleColor( UIColor.DarkLavendar, for: .normal)
        shipmentsBtn.setTitleColor( UIColor.appLightGrey, for: .normal)
        orderScrollView.contentOffset.x = SCREEN_WIDTH
        self.childViewControllers[1].viewWillAppear(true)
    }
    
    @IBAction func orderShipmentBtnClicked(_ sender: UIButton){
        orderBtn.setTitleColor( UIColor.appLightGrey, for: .normal)
        invoiceBtn.setTitleColor(UIColor.appLightGrey, for: .normal)
        shipmentsBtn.setTitleColor(UIColor.DarkLavendar, for: .normal)
        orderScrollView.contentOffset.x = SCREEN_WIDTH * 2
        self.childViewControllers[2].viewWillAppear(true)
    }
    
    /*
    MARK:- UIScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)

        switch index {
        case 1:
            if self.customerOrderDetailsModel.customerOrderDetailsModel.hasInvoices {
                orderBtn.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY, alpha: 1.0), for: .normal)
                invoiceBtn.setTitleColor(UIColor().HexToColor(hexString: "000000", alpha: 1.0), for: .normal)
                shipmentsBtn.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY, alpha: 1.0), for: .normal)
                orderScrollView.contentOffset.x = SCREEN_WIDTH
                self.childViewControllers[1].viewWillAppear(true)
            }else if self.customerOrderDetailsModel.customerOrderDetailsModel.hasShipments{
                orderBtn.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY, alpha: 1.0), for: .normal)
                invoiceBtn.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY, alpha: 1.0), for: .normal)
                shipmentsBtn.setTitleColor(UIColor().HexToColor(hexString: "000000", alpha: 1.0), for: .normal)
                orderScrollView.contentOffset.x = SCREEN_WIDTH * 2
                self.childViewControllers[2].viewWillAppear(true)
            }else{
                orderScrollView.contentOffset.x = 0
            }

        case 2:
            if self.customerOrderDetailsModel.customerOrderDetailsModel.hasShipments{
                orderBtn.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY, alpha: 1.0), for: .normal)
                invoiceBtn.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY, alpha: 1.0), for: .normal)
                shipmentsBtn.setTitleColor(UIColor().HexToColor(hexString: "000000", alpha: 1.0), for: .normal)
                orderScrollView.contentOffset.x = SCREEN_WIDTH * 2
                self.childViewControllers[2].viewWillAppear(true)
            }else{
                orderScrollView.contentOffset.x = SCREEN_WIDTH
            }
        default:
            orderBtn.setTitleColor(UIColor().HexToColor(hexString: "000000", alpha: 1.0), for: .normal)
            invoiceBtn.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY, alpha: 1.0), for: .normal)
            shipmentsBtn.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY, alpha: 1.0), for: .normal)
            orderScrollView.contentOffset.x = 0
        }
    }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openOrderDetails") {
            customerOrderDetails = segue.destination as! CustomerOrderDetails
            customerOrderDetails.incrementId = self.incrementId
            customerOrderDetails.customerOrderDetailsModel = customerOrderDetailsModel
        }else if (segue.identifier == "openInvoiceDetails") {
            invoiceViewController = segue.destination as! InvoiceViewController
            self.invoiceViewController.customerOrderDetailsModel = self.customerOrderDetailsModel
        }else if (segue.identifier == "openShipmentOrderDetails") {
            orderShipmentsViewController = segue.destination as! OrderShipmentsViewController
            self.orderShipmentsViewController.customerOrderDetailsModel = self.customerOrderDetailsModel
        }
    }
}
