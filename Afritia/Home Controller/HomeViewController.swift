//
//  ViewController.swift
//  Magento2V4Theme
//
//  Created by Webkul on 07/02/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit
import SwiftMessages
import EzPopup

class HomeViewController: AfritiaBaseViewController
{
    
    @IBOutlet weak var homeTableView: UITableView!
    //@IBOutlet weak var searchBar: UISearchBar!
    //@IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    //@IBOutlet weak var searchBarBgView: UIView!
    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    var homeViewModel : HomeViewModel!
    var selProductName:String = ""
    var selProductId:String = ""
    var selProductImage:String = ""
    var selCategoryId:String = ""
    var selCategoryName:String = ""
    var selCategoryType:String = ""
    var whichApiToProcess:String = ""
    
    var launchViewLoader:UIViewController!
    var refreshControl:UIRefreshControl!
    var responseObject : AnyObject!
    
    var searchViewOpenBy:String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setUpCustomNavigationBar()
        
        /*
        let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil)
        launchView = launchScreen.instantiateInitialViewController()
        self.view.addSubview(launchView!.view)
         */
        
        self.addAnimatedLauncherView()
        
        homeViewModel = HomeViewModel()
        homeTableView?.register(BannerTableViewCell.nib, forCellReuseIdentifier: BannerTableViewCell.identifier)
        homeTableView?.register(TopCategoryTableViewCell.nib, forCellReuseIdentifier: TopCategoryTableViewCell.identifier)
        homeTableView?.register(ProductTableViewCell.nib, forCellReuseIdentifier: ProductTableViewCell.identifier)
        homeTableView?.register(HotdealsTableViewCell.nib, forCellReuseIdentifier: HotdealsTableViewCell.identifier)
        homeTableView?.register(RecentViewTableViewCell.nib, forCellReuseIdentifier: RecentViewTableViewCell.identifier)
        homeTableView?.register(BigBannerTableViewCell.nib, forCellReuseIdentifier: BigBannerTableViewCell.identifier)
        
        self.homeTableView?.dataSource = homeViewModel
        self.homeTableView?.delegate = homeViewModel
        GlobalVariables.hometableView = homeTableView
        self.homeViewModel.homeViewController = self;
        self.homeTableView.separatorColor = UIColor.clear
        //searchBar.delegate = self
        callApiToLoadHomeData()
        //searchBar.placeholder = GlobalData.sharedInstance.language(key: "searchentirestore")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCategoryTap), name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedProductTap), name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCustomCollectionTap), name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPageRecentView), name: NSNotification.Name(rawValue: "refreshRecentView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedOtherTap), name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil)
        
        self.tabBarController?.delegate = self
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: GlobalData.sharedInstance.language(key: "refreshing"), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        homeTableView.refreshControl = refreshControl
    }
    
    func setUpCustomNavigationBar(){
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.afritiaNavBarView.isHidden = true
        
        self.tabBarController!.tabBar.applyAfritiaTheme()
        
        self.changeStatusBarColor(color: UIColor.LightLavendar)
                
        afritiaNavBarView.configureLeftButton1(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        afritiaNavBarView.configureLeftButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        
        afritiaNavBarView.configureRightButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.cart) { (btnTitle) in
            self.showMyCart()
        }
        afritiaNavBarView.configureRightButton2(isVisible:false, btnType:.image, btnTitle:nil, btnImage:nil, actionHandler:nil)
        
        afritiaNavBarView.configure(isVisible:true, titleText:nil, titleType:.image, barStyle:.full) { (searchBy) in
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
    
    /*
    func setUpNavigationBarView()
    {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController!.navigationBar.applyAfritiaTheme()
        self.tabBarController!.tabBar.applyAfritiaTheme()
        self.searchBar.changeSearchBarColor(color:UIColor.white)
        
        self.searchBarBgView.applyRoundCornerBorder(radius:6, width: 0.5, color:UIColor.DarkLavendar)
        //self.searchBar.applyAfritiaTheme()
        navigationItem.setImageTitleView(titleImage: UIImage(named: "afritia_logo")!)
        self.navigationController!.navigationBar.removeHairLine()
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        
        //let searchBtn = UIBarButtonItem(image:UIImage(named: "nav_icon_search"), style: .plain, target: self, action:#selector(self.showSearchStore))
         let notifBtn = UIBarButtonItem(image:UIImage(named: "ic_notification"), style: .plain, target: self, action:#selector(self.showNotifications))
        self.navigationItem.rightBarButtonItems = [notifBtn]
    }
     */
    
    /*
    @objc func showSearchStoreBySearchBar() {
        self.searchViewOpenBy = SearchViewOpenBy.searchBar
        self.performSegue(withIdentifier: "search", sender: self)
    }
    
    @objc func showSearchStoreByCamera() {
        if AppFunction.isRealDevice(){
            view.endEditing(true)
            self.tabBarController?.tabBar.isHidden = true
            self.searchViewOpenBy = SearchViewOpenBy.CameraIcon
            self.performSegue(withIdentifier: "search", sender: self)
        }
        else{
            AlertManager.shared.showInfoSnackBar(msg:"Device not found.")
        }
    }
    
    @objc func showSearchStoreByMicrophone() {
        if AppFunction.isRealDevice(){
            view.endEditing(true)
            self.tabBarController?.tabBar.isHidden = true
            self.searchViewOpenBy = SearchViewOpenBy.MicIcon
            self.performSegue(withIdentifier: "search", sender: self)
        }
        else{
            AlertManager.shared.showInfoSnackBar(msg:"Device not found.")
        }
    }
    
    @objc func showNotifications(){
        self.performSegue(withIdentifier: "notification", sender: self)
    }*/
    /*
    @IBAction func SeachByCameraIconClick(_ sender:UIButton){
        self.showSearchStoreByCamera()
    }
    
    @IBAction func SeachByMicrophoneIconClick(_ sender:UIButton){
        self.showSearchStoreByMicrophone()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true
        self.navigationController?.isNavigationBarHidden = true
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //self.searchBarHeight.constant = 0
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidAppear(animated)
        print("Cart Item Count", GlobalData.sharedInstance.cartItemsCount)
        afritiaNavBarView.UpdateBadgesCount(itemCount: GlobalData.sharedInstance.cartItemsCount)
    }
    
    //Refresh page for Recent View
    @objc func refreshPageRecentView(){
        
        print(homeTableView.numberOfSections)
        let productModel = ProductViewModel()
        print(productModel.getProductDataFromDB())
        
        if responseObject != nil {
            self.homeViewModel.getHomeData(data: responseObject!, recentViewData : productModel.getProductDataFromDB()) {
                (data : Bool) in
                if data {
                    self.homeTableView.reloadData()
                }
            }
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        callApiToLoadHomeData()
    }
    
    @objc func pushNotificationReceivedCategoryTap(_ note: Notification) {
        let root  = note.userInfo
        //categoryId = root?["categoryId"] as! String
        //categoryName = root?["categoryName"] as! String
        //categoryType = ""
        //self.performSegue(withIdentifier: "productcategory", sender: self)
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
        vc.categoryId = (root?["categoryId"] as! String)
        vc.categoryName = (root?["categoryName"] as! String)
        vc.categoryType = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushNotificationReceivedProductTap(_ note: Notification) {
        let root = note.userInfo
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = root?["productName"] as! String
        vc.productId = root?["productId"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushNotificationReceivedCustomCollectionTap(_ note: Notification) {
        let root = note.userInfo;
        //categoryId = root?["id"] as! String
        //categoryName = root?["title"] as! String
        //categoryType = "custom"
        //self.performSegue(withIdentifier: "productcategory", sender: self)
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
        vc.categoryId = (root?["categoryId"] as! String)
        vc.categoryName = root?["categoryName"] as! String
        vc.categoryType = ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func pushNotificationReceivedOtherTap(_ note: Notification) {
        let root = note.userInfo;
        let title = root?["title"] as! String
        let content = root?["message"] as! String
        let AC = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.callApiToLoadHomeData()
        })
        AC.addAction(okBtn)
        self.parent!.present(AC, animated: true, completion: { })
    }
    
    @IBAction func showNotificationClick(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "notification", sender: self)
    }
    
    func addAnimatedLauncherView(){
        launchViewLoader = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "AnimatedLauncherVC") as! AnimatedLauncherVC
        self.view.addSubview(launchViewLoader!.view)
    }
    
    func removeAnimatedLauncherView(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
               // HERE
            self.launchViewLoader?.view.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2) // Scale your image
            self.launchViewLoader?.view.alpha = 0.0

         }) { (finished) in
             UIView.animate(withDuration: 1, animations: {
               
                self.launchViewLoader?.view.transform = CGAffineTransform.identity // undo in 1 seconds
                self.launchViewLoader!.view.removeFromSuperview()
           })
        }
    }
    
    func callApiToLoadHomeData(){
        
        //GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["websiteId"] = UserManager.getWebsiteId
        requstParams["currency"] = UserManager.getCurrencyType
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["width"] = UserManager.getDeviceWidth
            
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.homePageData, currentView: self){success,responseObject in
            
            GlobalData.sharedInstance.dismissLoader()
            
            if success == 1{
                
                
                print(responseObject as! NSDictionary)
                self.refreshControl.endRefreshing()
                
                /*
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                
                if responseObject?.object(forKey: "defaultCurrency") != nil{
                    if defaults.object(forKey: "currency") == nil{
                        defaults .set(responseObject!.object(forKey: "defaultCurrency") as! String, forKey: "currency")
                    }
                }*/
                
                UserManager.saveDefaultStoreData(responseObject: responseObject)
                
                let dict =  JSON(responseObject as! NSDictionary)
                self.view.isUserInteractionEnabled = true
                
                if dict["success"].boolValue == true{
                    
                    self.responseObject = responseObject!
                    
                    let productModel = ProductViewModel()
                    
                    self.homeViewModel.getHomeData(data: responseObject!, recentViewData : productModel.getProductDataFromDB()) {
                        (data : Bool) in
                        if data {
                            self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
                            //self.navigationController?.isNavigationBarHidden = false
                            self.afritiaNavBarView.isHidden = false
                            self.tabBarController?.tabBar.isHidden = false
                            self.removeAnimatedLauncherView()
                            
                            /*
                            UIView.animate(withDuration: 0.5, animations: {
                                self.launchViewLoader?.view.alpha = 0.0
                            }) { _ in
                                self.launchViewLoader!.view.removeFromSuperview()
                            }*/
                        }
                    }
                }
            }
            else if success == 2
            {
                self.refreshControl.endRefreshing()
                self.callApiToLoadHomeData()
            }
            else if success == 0
            {
                if let data = responseObject as? NSDictionary {
                    if let otherError = data.object(forKey: "otherError") as? String  , otherError == "customerNotExist"  {
                        print("customerNotExist call")
                        self.refreshControl.endRefreshing()
                        DEFAULTS.removeObject(forKey: "customerId")
                        self.callApiToLoadHomeData()
                    }
                }
            }
        }
    }
    
    func addProductToCompareList(productID:String){
        
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["quoteId"] = UserManager.getQuoteId
        
        requstParams["productId"] = productID
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToCompare, currentView: self){success,responseObject in
            
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        DEFAULTS.set(storeId, forKey: "storeId")
                    }
                }
                
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                let data = responseObject as! NSDictionary
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                
                if errorCode == true{
                    
                    AlertManager.shared.showSnackBarWithAction(onView:self, theme:.success, msg: data.object(forKey: "message") as! String, actionBtnTitle:"See List") { (btnTitle) in
                         self.performSegue(withIdentifier: "comparelist", sender: self)
                    }
                    
                    //self.showSuccessMessgae(data:data.object(forKey: "message") as! String)
                }else{
                    AlertManager.shared.showErrorSnackBar(msg:data.object(forKey: "message") as! String)
                }
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                //self.callingExtraHttpApi()
            }
        }
    }
    
    //MARK:-
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "productcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.selCategoryName
            viewController.categoryId = self.selCategoryId
            viewController.categoryType = self.selCategoryType
        }
        else if (segue.identifier! == "search"){
            let viewController:SearchSuggestion = segue.destination as UIViewController as! SearchSuggestion
            viewController.searchFrom =  self.searchViewOpenBy
        }
    }
}

extension HomeViewController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabitem: Int = tabBarController.selectedIndex
        let navigation:UINavigationController = tabBarController.viewControllers?[tabitem] as! UINavigationController
        navigation.popToRootViewController(animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        //let tabitem: Int = tabBarController.selectedIndex
        APIServiceManager.shared.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
        self.refreshControl.endRefreshing()
        self.navigationController?.isNavigationBarHidden = false
        return true
    }
}

extension HomeViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = true
        self.searchViewOpenBy = SearchViewOpenBy.searchBar
        self.performSegue(withIdentifier: "search", sender: self)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = true
        self.searchViewOpenBy = "home_controller_searchbar_camera_icon"
        self.performSegue(withIdentifier: "search", sender: self)
    }
}

extension HomeViewController : productViewControllerHandlerDelegate {
    
    func productClick(name:String,image:String,id:String){
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productImageUrl = image
        vc.productName = name
        vc.productId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func productQuickView(productInfo: Products) {
        //AlertManager.shared.showWarningSnackBar(msg: "Show Quick View")
        
        let quickVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "QuickViewController") as! QuickViewController
        quickVC.productInfo = productInfo
        quickVC.callBackAction = {(action) in
            
            if action == QuickViewAction.compare {
                self.performSegue(withIdentifier: "comparelist", sender: self)
            }else if action == QuickViewAction.goToCart {
                self.showMyCart()
               // self.tabBarController?.selectedIndex = 3
            }
        }
        /*
        vc.myWishlistGroupData = availWishList
        
        vc.callBackOnSubmitClick = {(groupId, groupName) in
            print(groupId, groupName)
            
        }*/
        
        let titleHeight = AppFunction.getTextHeight(text:productInfo.name, textWidth: SCREEN_WIDTH-100)
        var detailHeight = AppFunction.getTextHeight(text:productInfo.shortDescription, textWidth: SCREEN_WIDTH-100)
        
        if detailHeight > 65 {
            detailHeight = 65
        }
        
        let popViewHeight = 350 + titleHeight + detailHeight
        // Init popup view controller with content is your content view controller
        let popupVC = PopupViewController(contentController: quickVC, popupWidth:SCREEN_WIDTH-60, popupHeight: CGFloat(popViewHeight))
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.canTapOutsideToDismiss = true
        popupVC.cornerRadius = 10
        popupVC.shadowEnabled = false
        self.present(popupVC, animated: true)
        
    }
    
    
    func productAddToCompare(productID: String)
    {
        self.selProductId = productID;
        self.addProductToCompareList(productID: productID)
    }
    
    
    func viewAllClick(type:String){
        
        var categoryType = ""
        var categoryName = ""
        var categoryId = ""
        
        if type == "feature"{
            categoryType = "featureproduct"
            categoryName = "featuredproducts".localized
            categoryId = ""
        }else if type == "new" {
            
            categoryType = "newproduct"
            categoryName = "newproducts".localized
            categoryId = ""
            
        }else {
            categoryType = "hotdeal"
            categoryName = "hotdealproduct".localized
            categoryId = ""
        }
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
        vc.categoryId = categoryId
        vc.categoryName = categoryName
        vc.categoryType = categoryType
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        //self.performSegue(withIdentifier: "productcategory", sender: self)
    }
    
}

extension HomeViewController : bannerViewControllerHandlerDelegate {
    
    func bannerProductClick(type:String,image:String,id:String,title:String){
        
        if type == "category"{
            
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
            vc.categoryId = self.selCategoryId
            vc.categoryName = self.selCategoryName
            vc.categoryType = self.selCategoryType
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
            vc.productImageUrl = image
            vc.productName = title
            vc.productId = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController : CategoryViewControllerHandlerDelegate {
    
    func categoryProductClick(name:String,ID:String){
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
        vc.categoryId = ID
        vc.categoryName = name
        vc.categoryType = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/*
extension ViewController : hotDealProductViewControllerHandlerDelegate {
    
    func hotDealProductClick(name:String,image:String,id:String){
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productImageUrl = image
        vc.productName = name
        vc.productId = id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func hotDealAddToWishList(productID:String){
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            self.productId = productID;
            whichApiToProcess = "addtowishlist"
            callingExtraHttpApi()
        }else{
            AlertManager.shared.showWarningSnackBar(msg: "Login Required")
        }
    }
    
    func hotDealAddToCompare(productID:String){
        self.productId = productID;
        whichApiToProcess = "addtocompare"
        callingExtraHttpApi()
    }
    
    func hotDealViewAllClick(){
        categoryType = "hotdeal"
        categoryName = "hotdealproduct".localized
        categoryId = ""
        self.performSegue(withIdentifier: "productcategory", sender: self)
    }
}
*/

//MARK:- Recent Views Delegate func
extension HomeViewController : RecentProductViewControllerHandlerDelegate{
    
    func recentProductClick(name: String, image: String, id: String) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productImageUrl = image
        vc.productName = name
        vc.productId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func recentAddToCompare(productID: String) {
        self.self.selProductId = productID
        self.addProductToCompareList(productID: productID)
        //whichApiToProcess = "addtocompare"
        //callingExtraHttpApi()
    }
    
    func recentViewAllClick() {
        //do nothing
    }
}

extension HomeViewController : BigBannerTableViewCellDelegate {
    
    func clickOnBanner(type: String) {
        
        var categoryType = ""
        var categoryName = ""
        var categoryId = ""
        
        if type == "featurebanner"{
            categoryType = "featureproduct"
            categoryName = "featuredproducts".localized
            categoryId = ""
        }else if type == "newbanner" {
            
            categoryType = "newproduct"
            categoryName = "newproducts".localized
            categoryId = ""
            
        }else {
            categoryType = "hotdealbanner"
            categoryName = "hotdealproduct".localized
            categoryId = ""
        }
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
        vc.categoryId = categoryId
        vc.categoryName = categoryName
        vc.categoryType = categoryType
        self.navigationController?.pushViewController(vc, animated: true)
        
        //self.performSegue(withIdentifier: "productcategory", sender: self)
    }
}

extension HomeViewController : UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if ((self.presentedViewController?.isKind(of: PreviewViewController.self)) != nil) {
            return nil
        }
        
        var productDescription:String = ""
        self.selProductImage = ""
        var requiredOption:Int = 0
        
        
        if let currentRow =  (previewingContext.sourceView as? UICollectionView)?.indexPathForItem(at: location)?.row{
            if GlobalVariables.showFeature{
                if currentRow < self.homeViewModel.featuredProductsInfo.count{
                    let featProductInfo = self.homeViewModel.featuredProductsInfo[currentRow]
                    productDescription = featProductInfo.shortDescription
                    self.selProductImage = featProductInfo.image
                    self.selProductId = featProductInfo.productID
                    requiredOption = featProductInfo.requiredOptions
                    self.selProductName = featProductInfo.name
                }else{
                    return nil
                }
            }
            else{
                if currentRow < self.homeViewModel.latestProductsInfo.count{
                    let latestProductInfo = self.homeViewModel.latestProductsInfo[currentRow]
                    productDescription = latestProductInfo.shortDescription
                    self.selProductImage = latestProductInfo.image
                    self.selProductId = latestProductInfo.productID
                    requiredOption = latestProductInfo.requiredOptions
                    self.selProductName = latestProductInfo.name
                }else{
                    return nil
                }
            }
        }
 
        // PEEK (shallow press): return the preview view controller here
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let previewView = storyboard.instantiateViewController(withIdentifier: "PreviewView") as? PreviewViewController
        previewView?.productDescription = productDescription
        previewView?.imageUrl = self.selProductImage
        //previewView?.delegate = self ranjit
        previewView?.requiredOptions = requiredOption
        
        return previewView
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        let catalogProduct = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        catalogProduct.productName = self.selProductName
        catalogProduct.productImageUrl = self.selProductImage
        catalogProduct.productId = self.selProductId
        self.navigationController?.pushViewController(catalogProduct, animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        // called when the interface environment changes
        // one of those occasions would be if the user enables/disables 3D Touch
        // so we'll simply check again at this point
    }
    
}

/*
extension ViewController : PreviewControllerDelegate {
    
    func previewAddToCart(){
        
        // ranjit
        whichApiToProcess = "addtocart";
        self.callingExtraHttpApi()
        
    }
    
    func previewShare(){
        
        // ranjit
        let productUrl = productImage
        let activityItems = [productUrl]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.present(activityController, animated: true, completion: {  })
        }else {
            let popup = UIPopoverController(contentViewController: activityController)
            popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
        }
    }
}
*/
