//
//  MyOrders.swift
//  DummySwift
//
//  Created by Webkul on 22/11/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class MyOrders: AfritiaBaseViewController {
    
    @IBOutlet weak var myOrderTableView: UITableView!
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    //var whichApiDataToprocess: String = ""
    var reloadPageData:Bool = false
    var pageNumber:Int = 0
    var loadPageRequestFlag: Bool = false
    var indexPathValue:IndexPath!
    var loaderFlag:Bool = false
    //var incrementId:String = ""
    var emptyOrderView:UIView!
    let defaults = UserDefaults.standard;
    var myOrderCollectionData:MyOrdersCollectionViewModel!
    var orderId:String = ""
    var emptyView:EmptyPlaceHolderView!
    let globalObjectMyOrders = GlobalData()
    var refreshControl:UIRefreshControl!
    
    var incrementID:String = ""
    var fromDate:String = ""
    var toDate:String = ""
    var status:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.navigationItem.title =  appLanguage.localize(key: "myorder")
        
        self.setUpCustomNavigationBar()
        
        self.myOrderTableView.reloadData()
        myOrderTableView.isHidden = true
        pageNumber = 1
        loadPageRequestFlag = true
        //callingHttppApi()
        self.myOrderTableView.separatorColor = UIColor.clear
        //whichApiDataToprocess = ""
        
        myOrderTableView.register(UINib(nibName: "MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrderTableViewCell")
        myOrderTableView.rowHeight = UITableViewAutomaticDimension
        self.myOrderTableView.estimatedRowHeight = 50
        
        self.myOrderTableView.separatorStyle = .singleLine
        self.myOrderTableView.separatorColor = UIColor.DarkLavendar
        
        self.callApiToGetOrderList()
        
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "refreshing".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            myOrderTableView.refreshControl = refreshControl
        } else {
            myOrderTableView.backgroundView = refreshControl
        }
    }
    
    
    fileprivate func setUpCustomNavigationBar(){
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController!.tabBar.applyAfritiaTheme()
        
        self.changeStatusBarColor(color: UIColor.LightLavendar)
    
        afritiaNavBarView.configureLeftButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.back) { (btnTitle) in
            self.navigationController?.popViewController(animated:true)
        }
        afritiaNavBarView.configureLeftButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        
        afritiaNavBarView.configureRightButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.cart) { (btnTitle) in
            self.showMyCart()
        }
        afritiaNavBarView.configureRightButton2(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.filter){ (btnTitle) in
            self.showFilter()
        }
        
        afritiaNavBarView.configure(isVisible:true, titleText:nil, titleType:.image, barStyle:.compact) { (searchBy) in
            if searchBy == SearchOpenBy.bar || searchBy == SearchOpenBy.searchBtn {
                self.showSearchStoreBySearchBar()
            }else if searchBy == SearchOpenBy.camera{
                self.showSearchStoreByCamera()
            }else if searchBy == SearchOpenBy.mic{
                self.showSearchStoreByMicrophone()
            }
        } styleHandler: { (style) in
            if style == .full{
                self.afritiaNavBarViewHeight.constant = NavBarHeight.full.rawValue
            }else if style == .compact{
                self.afritiaNavBarViewHeight.constant = NavBarHeight.compact.rawValue
            }
        }
    }
    
    func DisplayEmptyDataView(isVisible:Bool){
        
        if isVisible {
            emptyView = EmptyPlaceHolderView(frame: self.view.frame)
            emptyView.emptyImages.image = UIImage(named: "empty_order")!
            emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "browsecategory"), for: .normal)
            emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptyorder")
            emptyView.callBackBtnAction = {(btnTitle) in
                self.tabBarController!.selectedIndex = 2
            }
            
            myOrderTableView.backgroundView = emptyView
            myOrderTableView.separatorStyle = .none
            
        }else{
            
            myOrderTableView.backgroundView = nil
            myOrderTableView.separatorStyle = .singleLine
        }
    }
    
    /*
    @objc func browseCategory(sender: UIButton){
        self.tabBarController!.selectedIndex = 2
    }*/
    
    /*override func viewDidAppear(_ animated: Bool) {
        //whichApiDataToprocess = ""
        callApiToGetOrderList()
    }*/
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //navigationItem.backBarButtonItem?.isHideBackBtnTitle = true
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showFilter(){
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "OrderFilterController") as! OrderFilterController
        vc.modalPresentationStyle = .fullScreen
        //vc.sellerOrderViewModel = self.sellerOrderViewModel
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func filterClick(_ sender: UIBarButtonItem) {
        ///
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.incrementID = ""
        self.fromDate  = ""
        self.toDate = ""
        self.status = ""
        pageNumber = 1
        loadPageRequestFlag = true
        callApiToGetOrderList()
        refreshControl.endRefreshing()
    }
    
    /*
    func callingHttppApi(){
        
        if whichApiDataToprocess == "reorder"{
            
        }else{
            self.callApiToGetOrderList()
        }
    }*/
    
    func callApiToReorder(){
        
        GlobalData.sharedInstance.showLoader()

        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
        requstParams["incrementId"] = orderId
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname: AfritiaAPI.reOrder, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                
                let data = JSON(responseObject as! NSDictionary)
                let errorCode: Bool = data["success"].boolValue
                if errorCode == true{
                    GlobalData.sharedInstance.cartItemsCount = Int(data["cartCount"].stringValue)!
                    //self.tabBarController!.tabBar.items?[3].badgeValue = data["cartCount"].stringValue
                    
                    let AC = UIAlertController(title:self.orderId , message: data["message"].stringValue, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        self.tabBarController?.selectedIndex =  3
                    })
                    
                    AC.addAction(okBtn)
                    self.present(AC, animated: true, completion: {})
                }else{
                    AlertManager.shared.showErrorSnackBar(msg: data["message"].stringValue)
                }
            }else if success == 2{
                self.callApiToReorder()
                GlobalData.sharedInstance.dismissLoader()
            }
        }
    }
    
    
    func callApiToGetOrderList() {
        
        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        var requstParams = [String:Any]();
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        requstParams["pageNumber"] = "1"
        requstParams["status"] = status
        requstParams["dateTo"] =  toDate
        requstParams["dateFrom"] = fromDate
        requstParams["incrementId"] = incrementID
        
        if self.defaults.object(forKey: "currency") != nil{
            requstParams["currency"] = self.defaults.object(forKey: "currency") as! String
        }
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.orderList, currentView: self){success,responseObject in
            if success == 1{
                
                print("result",responseObject!)
                
                if self.pageNumber == 1{
                    self.myOrderCollectionData = MyOrdersCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                }else{
                    self.myOrderCollectionData.setMyOrderCollectionData(data:JSON(responseObject as! NSDictionary))
                }
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                self.callApiToGetOrderList()
                GlobalData.sharedInstance.dismissLoader()
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            if self.pageNumber == 1{
                GlobalData.sharedInstance.dismissLoader()
            }
            self.loadPageRequestFlag = true;
            self.view.isUserInteractionEnabled = true;
            self.myOrderTableView.isHidden = false
            self.myOrderTableView.delegate = self
            self.myOrderTableView.dataSource = self
            self.myOrderTableView.reloadData()
            
            if self.myOrderCollectionData.getMyOrdersCollectionData.count > 0{
                self.DisplayEmptyDataView(isVisible: false)
                //self.myOrderTableView.isHidden = false
                //self.emptyView.isHidden  = true
            }else{
                self.DisplayEmptyDataView(isVisible: true)
                //self.myOrderTableView.isHidden = true
                //self.emptyView.isHidden  = false
            }
        }
    }
    
    @objc func reorderClick(sender: UIButton){
        
        //whichApiDataToprocess = "reorder"
        orderId = self.myOrderCollectionData.getMyOrdersCollectionData[sender.tag].orderId
        self.callApiToReorder()
        //callingHttppApi()
    }
    
    @objc func viewOrderClick(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerOrderMainViewController") as! CustomerOrderMainViewController
        vc.incrementId = self.myOrderCollectionData.getMyOrdersCollectionData[sender.tag].orderId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.myOrderTableView.numberOfRows(inSection: 0)
        for cell: UITableViewCell in self.myOrderTableView.visibleCells {
            indexPathValue = self.myOrderTableView.indexPath(for: cell)!
            if indexPathValue.row == self.myOrderTableView.numberOfRows(inSection: 0) - 1 {
                if (myOrderCollectionData.totalCount > currentCellCount) && loadPageRequestFlag{
                    //whichApiDataToprocess = ""
                    pageNumber += 1
                    loadPageRequestFlag = false
                    callApiToGetOrderList()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "customerorderdetails") {
            let viewController:CustomerOrderDetails = segue.destination as UIViewController as! CustomerOrderDetails
            viewController.incrementId = self.orderId;
        }
    }
}

extension MyOrders : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myOrderCollectionData.getMyOrdersCollectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell") as! MyOrderTableViewCell
        
        let orderInfo = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row]
        cell.orderId.text = orderInfo.orderId
        cell.placedOnDate.text = orderInfo.order_Date
        cell.orderDetails.text = orderInfo.order_total
        
        cell.statusMessage.text = " " + orderInfo.status + " "
        cell.statusMessage.textColor = UIColor.white
        
        cell.productImgView.getImageFromUrl(imageUrl:orderInfo.orderImage)
        
        if orderInfo.status.lowercased() == "pending"{
            cell.statusMessage.backgroundColor = UIColor.appOrange
            
        }else if orderInfo.status.lowercased() == "complete"{
            cell.statusMessage.backgroundColor =  UIColor.appGreen
            
        }else if orderInfo.status.lowercased() == "processing"{
            cell.statusMessage.backgroundColor =  UIColor.appGreen.withAlphaComponent(0.5)
        }else if orderInfo.status.lowercased() == "cancel"{
            cell.statusMessage.backgroundColor = UIColor.appRed
        }else if orderInfo.status.lowercased() == "closed"{
            cell.statusMessage.backgroundColor = UIColor.appRed
        }
        
        /*
        if self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].canReorder  == true {
            cell.reorderButton.tag = indexPath.row
            cell.reorderButton.addTarget(self, action: #selector(reorderClick(sender:)), for: .touchUpInside)
            cell.reorderButton.isUserInteractionEnabled = true;
            cell.reorderButton.isHidden = false;
        }else{
            cell.reorderButton.isHidden = true;
        }*/
        
        cell.viewOrderButton.tag = indexPath.row
        cell.viewOrderButton.addTarget(self, action: #selector(viewOrderClick(sender:)), for: .touchUpInside)
        cell.viewOrderButton.isUserInteractionEnabled = true
       
        let shipValue: String = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].ship_To
        if shipValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""{
            cell.shipToValue.text = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].ship_To
        }
        else{
            cell.shipToLabel.text = ""
            cell.shipToValue.text = ""
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    //for showing the activity loader
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.myOrderTableView.tableFooterView = spinner
            self.myOrderTableView.tableFooterView?.isHidden = false
            
            if self.myOrderCollectionData != nil    {
                if self.myOrderCollectionData.totalCount == self.myOrderCollectionData.getMyOrdersCollectionData.count  {
                    spinner.stopAnimating()
                    self.myOrderTableView.tableFooterView = nil
                    self.myOrderTableView.tableFooterView?.isHidden = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
}

extension MyOrders: OrderFilterDelegate {
    
    func orderFilterData(data: Bool, orderid: String, fromDate: String, toDate: String, status: String) {
        
        self.incrementID = orderid
        self.fromDate  = fromDate
        self.toDate = toDate
        self.status = status
        pageNumber = 1
        loadPageRequestFlag = true
        callApiToGetOrderList()
    }
}
