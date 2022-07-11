//
//  NotificationController.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 04/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit
import Alamofire

//
//  Notification.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 04/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class NotificationController: AfritiaBaseViewController {
    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    @IBOutlet weak var notificationTableView: UITableView!
    
    let defaults = UserDefaults.standard
    var notificationViewModel:NotificationViewModel!
    var productId:String!
    var productName:String!
    var imageUrl:String!
    var emptyView:EmptyPlaceHolderView!
    var categoryType:String!
    
    var viewBy:navBarViewMode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.addHiddenEmptyView()
        callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.setUpCustomNavigationBar()
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.navigationItem.title = GlobalData.sharedInstance.language(key: "notification")
    }
    
    func DisplayEmptyDataView(isVisible:Bool){
        
        if isVisible {
            emptyView = EmptyPlaceHolderView(frame: self.view.frame)
            emptyView.emptyImages.image = UIImage(named: "empty_notification")!
            emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "tryagain"), for: .normal)
            emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptyNotif")
            //emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
            
            emptyView.callBackBtnAction = {(action) in
                self.tabBarController!.selectedIndex = 0
                self.navigationController?.popViewController(animated: true)
            }
            
            self.notificationTableView.backgroundView = emptyView
            self.notificationTableView.separatorStyle = .none
            
        }else{
            self.notificationTableView.backgroundView = nil
            self.notificationTableView.separatorStyle = .singleLine
        }
    }
    
    fileprivate func setUpCustomNavigationBar(){
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController!.tabBar.applyAfritiaTheme()
        
        self.changeStatusBarColor(color: UIColor.LightLavendar)
        
        var barViewStyle:NavBarStyle!
        
        if viewBy == navBarViewMode.profile {
            barViewStyle = .compact
            afritiaNavBarView.configureLeftButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.back){ (btn) in
                self.navigationController?.popViewController(animated:true)
            }
            
        }else{
            barViewStyle = .full
            afritiaNavBarView.configureLeftButton1(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        }
        
        afritiaNavBarView.configureLeftButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        
        afritiaNavBarView.configureRightButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.cart) { (btnTitle) in
            self.showMyCart()
        }
        afritiaNavBarView.configureRightButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)

        afritiaNavBarView.configure(isVisible:true, titleText:nil, titleType:.image, barStyle:barViewStyle) { (searchBy) in
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
    
    
    @objc func browseCategory(sender: UIButton) {
        self.tabBarController!.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    func callingHttppApi(){
        
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId // defaults.object(forKey:"storeId") as! String
        let width = UserManager.getDeviceWidth // String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.notificationList, currentView: self){success,responseObject in
            if success == 1{
                print(responseObject!)
                self.notificationViewModel = NotificationViewModel(data:JSON(responseObject as! NSDictionary))
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            GlobalData.sharedInstance.dismissLoader()
            if self.notificationViewModel.notificationModel.count > 0{
                self.DisplayEmptyDataView(isVisible: false)
                
                //self.emptyView.isHidden = true
                //self.notificationTableView.isHidden = false
                self.notificationTableView.delegate = self
                self.notificationTableView.dataSource = self
                self.notificationTableView.reloadData()
            }else{
                self.DisplayEmptyDataView(isVisible: true)
                //self.notificationTableView.isHidden = true
                //self.emptyView.isHidden = false
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "productcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.productName
            viewController.categoryId = self.productId
            viewController.categoryType = categoryType
        }
    }
}

extension NotificationController : UITableViewDelegate, UITableViewDataSource  {
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return notificationViewModel.notificationModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "notificationCell"
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! NotificationTableViewCell
        cell.titleText.text = notificationViewModel.notificationModel[indexPath.row].title
        cell.contentsText.text = notificationViewModel.notificationModel[indexPath.row].contet
        cell.bannerIMage.image = UIImage(named: "ic_placeholder.png")
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:notificationViewModel.notificationModel[indexPath.row].bannerImage , imageView: cell.bannerIMage)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH / 2 + 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productType = notificationViewModel.notificationModel[indexPath.row].notificationType
        if productType == "product"{
            
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
            vc.productName = notificationViewModel.notificationModel[indexPath.row].productName
            vc.productId = notificationViewModel.notificationModel[indexPath.row].id
            vc.productImageUrl = notificationViewModel.notificationModel[indexPath.row].bannerImage
            self.navigationController?.pushViewController(vc, animated: true)
        }else if productType == "category"{
            /*
            productId = notificationViewModel.notificationModel[indexPath.row].categoryId
            productName = notificationViewModel.notificationModel[indexPath.row].title
            categoryType = ""
            self.performSegue(withIdentifier: "productcategory", sender: self)
            */
            
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
            vc.categoryId = notificationViewModel.notificationModel[indexPath.row].categoryId
            vc.categoryName = notificationViewModel.notificationModel[indexPath.row].title
            vc.categoryType = ""
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if productType == "other"{
            
            let otherTitle = notificationViewModel.notificationModel[indexPath.row].title
            let otherMessage = notificationViewModel.notificationModel[indexPath.row].contet
            let AC = UIAlertController(title:otherTitle ,message: otherMessage , preferredStyle: .alert)
            let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key:"ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            AC.addAction(okBtn)
            self.parent!.present(AC, animated: true, completion: {  })
            
        }else if productType == "custom"{
            /*
            productId = notificationViewModel.notificationModel[indexPath.row].categoryId
            productName = notificationViewModel.notificationModel[indexPath.row].title
            categoryType = "custom"
            self.performSegue(withIdentifier: "productcategory", sender: self)
            */
            
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
            vc.categoryId = notificationViewModel.notificationModel[indexPath.row].categoryId
            vc.categoryName = notificationViewModel.notificationModel[indexPath.row].title
            vc.categoryType = "custom"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//class Triangle:NSObject{
//    var sideLength: Int = 0
//
//    init(sideLength: Int) { //initializer method
//        self.sideLength = sideLength
//    }
//
//    var perimeter: Int {
//        get { // getter
//            return sideLength
//        }
//        set { //setter
//            sideLength = newValue*5
//        }
//    }
//}

