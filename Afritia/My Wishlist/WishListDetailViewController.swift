//
//  WishListDetailViewController.swift
//  Afritia
//
//  Created by Ranjit Mahto on 25/11/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit
import EzPopup

struct WishListItemApiType {
    //static var delete = "DeleteWishlistItem"
    static var move = "MoveWishlistItem"
    static var copy = "CopyWishlistItem"
    //static var share = "ShareWishlistItem"
    //static var addToCart = "AddSelWishlistItemToCart"
}

class WishListDetailViewController: AfritiaBaseViewController {
    
    @IBOutlet weak var myWishLIstTableView: UITableView!
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    var imageCache = NSCache<AnyObject, AnyObject>()
    var totalCount : Int = 0
    var whichApiDataToprocess: String = ""
    var pageNumber:Int = 0
    var keyBoardFlag:Int = 1
    var refreshControl:UIRefreshControl!
    fileprivate var wishlistItems:[WishListItem]!
    var wishListGroupInfo : MyWishlistGroupModel!
    var isListEdited:Bool = false
    
    var callBackForUpdateWishList : ((Bool) -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.title = appLanguage.localize(key: "mywishlist")
        
        self.setUpCustomNavigationBar()
        
        wishlistItems = wishListGroupInfo.items
        
        if wishlistItems.count > 0 {
            
            myWishLIstTableView.rowHeight = UITableViewAutomaticDimension
            myWishLIstTableView.estimatedRowHeight = 200
            myWishLIstTableView.addTapGestureRecognizer {
                self.view.endEditing(true)
            }
            myWishLIstTableView.dataSource = self
            myWishLIstTableView.delegate = self
            myWishLIstTableView.reloadData()
        }
        
        GlobalData.sharedInstance.dismissLoader()
        APIServiceManager.shared.removePreviousNetworkCall()
        whichApiDataToprocess = " "
        pageNumber = 1
        //callingHttppApi()
        //callApiForMultiWishlist(apiType:MultiWishlistAPIType.allWishlist)
        
        /*
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "refreshing".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        myWishLIstTableView.refreshControl = refreshControl
         */

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        
        let backButton = UIBarButtonItem(image:UIImage(named: "nav_icon_back"), style: .plain, target: self, action:#selector(self.btnBackTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func btnBackTapped() {
        if isListEdited {
            self.navigationController?.popViewController(animated: true)
            self.callBackForUpdateWishList(true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func showNotifications(){
        //self.performSegue(withIdentifier: "notification", sender: self)
    }

    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
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
        afritiaNavBarView.configureRightButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)

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
    
    func getWishListGroupsDataForMoveAndCopyItem(selItem:WishListItem,selItemIndexPath:IndexPath, operationType:String){
        
        let customerId = UserManager.getCustomerId
        if customerId == ""
        {
            AlertManager.shared.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "loginrequired"))
            return
        }
        
        if operationType == WishListItemApiType.copy {
            
            WishListServiceHelper.getWishListGroups { (result, wishlistGroups) in
                
                WishListServiceHelper.showWishListGroupsPopUp(onVC: self, availWishList: wishlistGroups) { (selGroupId, selGroupName) in
                    
                    WishListServiceHelper.copyItemToWishList(wishListGroupInfo: self.wishListGroupInfo, selItem: selItem, destGroupId: selGroupId, destGroupName: selGroupName) { (result, message) in
                        
                        if result {
                            AlertManager.shared.showSuccessSnackBar(msg:message)
                            self.isListEdited = true
                        }else{
                            AlertManager.shared.showErrorSnackBar(msg:message)
                        }
                    }
                }
            }
        }
        else if operationType == WishListItemApiType.move {
           
            WishListServiceHelper.getWishListGroups { (result, wishlistGroups) in
                
                WishListServiceHelper.showWishListGroupsPopUp(onVC: self, availWishList: wishlistGroups) { (selGroupId, selGroupName) in
                    
                    WishListServiceHelper.moveItemFromWishList(wishListGroupInfo: self.wishListGroupInfo, selItem: selItem, destGroupId: selGroupId, destGroupName: selGroupName) { (result, message) in
                        
                        if result {
                            AlertManager.shared.showSuccessSnackBar(msg:message)
                            self.wishlistItems.remove(at:selItemIndexPath.row)
                            self.myWishLIstTableView.reloadData()
                            self.isListEdited = true
                        }else{
                            AlertManager.shared.showErrorSnackBar(msg:message)
                        }
                    }
                }
            }
        }
        
        /*
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            
            self.getAllAvailableWishlistGroups { (allWishListGroups) in
                
                if operationType == WishListItemApiType.copy {
                    self.openWishlistPopUp(availWishList: allWishListGroups,
                                           selProdInfo: selItem,
                                           selIndexPath: selItemIndexPath,
                                           apiType: WishListItemApiType.copy)
                }
                else if operationType == WishListItemApiType.move {
                    self.openWishlistPopUp(availWishList: allWishListGroups,
                                           selProdInfo: selItem,
                                           selIndexPath: selItemIndexPath,
                                           apiType: WishListItemApiType.move)
                }
            }
        }
        else
        {
            AlertManager.shared.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "loginrequired"))
        }*/
        
    }

    
    func callHttppApiForDeleteItem(selItem:WishListItem,selItemIndexPath:IndexPath){
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["wishlistId"] = wishListGroupInfo.id
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["itemId"] = selItem.product_id
        
        print("Request Params: \(requstParams)")
        
        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.removeItemFromWishListGroup ){success,responseObject in
            
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                print(responseObject!)
                let apiResponse = responseObject as? NSDictionary
                AlertManager.shared.showSuccessSnackBar(msg:apiResponse!["message"] as! String)
                self.wishlistItems.remove(at:selItemIndexPath.row)
                self.myWishLIstTableView.reloadData()
                self.isListEdited = true
            }else if success == 2 {
                //self.callApiForMultiWishlist(apiType:MultiWishlistAPIType.addNewWishListGroup)
                //GlobalData.sharedInstance.dismissLoader()
            }
        }
    }
    
    /*
    func callHttppApiForMoveItem(selItem:WishListItem,selItemIndexPath:IndexPath, destGroupId:String, destGroupName:String){
        
        if destGroupName == "Main" || destGroupId == wishListGroupInfo.id {
            AlertManager.shared.showInfoSnackBar(msg:"You have already item in this group")
            return
        }
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        
        if destGroupName == "Main" {
            requstParams["wishlist"] = "main"
        }else{
            requstParams["wishlist"] = destGroupId
        }
        
        if wishListGroupInfo.name == "Main"{
            requstParams["itemId"] = "main" + "-" + selItem.product_id
        }else{
            requstParams["itemId"] = selItem.product_id
        }
        
        // no need source group id to send
        if destGroupId == "new"{
            requstParams["newWishlistName"] = destGroupName
        }else{
            requstParams["newWishlistName"] = ""
        }
        
        // name of group where to move / or new group name
        print("Request Params: \(requstParams)")
        
        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.moveItemFromWishListGroup ){success,responseObject in
            
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                print(responseObject!)
                let apiResponse = responseObject as? NSDictionary
                AlertManager.shared.showSuccessSnackBar(msg:apiResponse!["message"] as! String)
                self.wishlistItems.remove(at:selItemIndexPath.row)
                self.myWishLIstTableView.reloadData()
                self.isListEdited = true
            }else if success == 2 {
                //self.callApiForMultiWishlist(apiType:MultiWishlistAPIType.addNewWishListGroup)
                //GlobalData.sharedInstance.dismissLoader()
            }
        }
    }
    
    func callHttppApiForCopyItem(selItem:WishListItem,selItemIndexPath:IndexPath, destGroupId:String, destGroupName:String){
        if destGroupName == "Main" || destGroupId == wishListGroupInfo.id {
            AlertManager.shared.showInfoSnackBar(msg:"You have already item in this group")
            return
        }
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        
        if destGroupName == "Main" {
            requstParams["wishlist"] = "main"
        }else{
            requstParams["wishlist"] = destGroupId
        }
        
        if wishListGroupInfo.name == "Main"{
            requstParams["itemId"] = "main" + "-" + selItem.product_id
        }else{
            requstParams["itemId"] = selItem.product_id
        }
        
        // no need source group id to send
        if destGroupId == "new"{
            requstParams["newWishlistName"] = destGroupName
        }else{
            requstParams["newWishlistName"] = ""
        }
        
        // name of group where to move / or new group name
        print("Request Params: \(requstParams)")
        
        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.copyItemFromWishListGroup ){success,responseObject in
            
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                print(responseObject!)
                let apiResponse = responseObject as? NSDictionary
                AlertManager.shared.showSuccessSnackBar(msg:apiResponse!["message"] as! String)
                self.isListEdited = true
            }else if success == 2 {
                //self.callApiForMultiWishlist(apiType:MultiWishlistAPIType.addNewWishListGroup)
                //GlobalData.sharedInstance.dismissLoader()
            }
        }
        
    }

    func openWishlistPopUp(availWishList:[MyWishlistGroupModel], selProdInfo:WishListItem, selIndexPath:IndexPath, apiType:String){
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "WishListGroupPopUpVC") as! WishListGroupPopUpVC
        vc.myWishlistGroupData = availWishList
        
        vc.callBackOnSubmitClick = {(groupId, groupName) in
            print(groupId, groupName)
            
            if apiType == WishListItemApiType.copy {
                self.callHttppApiForCopyItem(selItem: selProdInfo ,
                                             selItemIndexPath: selIndexPath,
                                             destGroupId: groupId,
                                             destGroupName:groupName)
            }
            else if apiType == WishListItemApiType.move {
                self.callHttppApiForMoveItem(selItem: selProdInfo ,
                                             selItemIndexPath: selIndexPath,
                                             destGroupId: groupId,
                                             destGroupName:groupName)
            }
            
        }
        
        let popViewHeight = 44 + 120 + (40 * (availWishList.count+1))
        // Init popup view controller with content is your content view controller
        let popupVC = PopupViewController(contentController: vc, popupWidth:SCREEN_WIDTH-100, popupHeight: CGFloat(popViewHeight))
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.canTapOutsideToDismiss = false
        popupVC.cornerRadius = 10
        popupVC.shadowEnabled = false
        self.present(popupVC, animated: true)
    }
    */
    
    
    func callHttppApiForShareItem(selItem:WishListItem,selItemIndexPath:IndexPath){
        print ("Share Seleccted")
        let items = [URL(string:selItem.product_url)!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }
    
    func callApiForAddItemToCart(selItem:WishListItem,selItemIndexPath:IndexPath){
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["qty"] = selItem.qty
        requstParams["productId"] = selItem.product_id
        requstParams["itemId"] = selItem.id
        requstParams["storeId"] = DEFAULTS.object(forKey:"storeId") as! String
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.wishListToCart, currentView: self){success,responseObject in
            if success == 1{
                
                self.view.isUserInteractionEnabled = true
                //self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
                let data = responseObject as! NSDictionary
                let jsonData = JSON(data)
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                if errorCode == true{
                    AlertManager.Show(onController:self, btnTitles: ["OK"], alertTitle: "Cart", alertMessage: (data.object(forKey: "message") as! String), alertStyle: .alert) { (btnIndex, btnTitle) in
                        
                        if btnTitle == "OK"{
                            // do nothing
                        }
                    }
                    //self.tabBarController!.tabBar.items?[3].badgeValue = "\(jsonData["cartCount"])"
                    GlobalData.sharedInstance.cartItemsCount = Int("\(jsonData["cartCount"])")!
                    self.wishlistItems.remove(at:selItemIndexPath.row)
                    self.myWishLIstTableView.reloadData()
                    self.isListEdited = true
                    
                }else{
                    AlertManager.shared.showErrorSnackBar(msg:data .object(forKey:"message") as! String)
                }
                
            }
            else if success == 2{
                //self.callingHttppApi()
                GlobalData.sharedInstance.dismissLoader()
            }
        }
    }
    
    /*
    func getAllAvailableWishlistGroups(completionBlock:@escaping completionHandler){
        
        //self.mutliWishlistApiType = Mu
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["pageNumber"] =  "1"
        requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
        
        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.allAvailableWishlist){success,responseObject in
            if success == 1{
                
                DispatchQueue.main.async {
                    
                    let data = responseObject as! NSDictionary
                    
                    GlobalData.sharedInstance.dismissLoader()

                    var wishlistData = [MyWishlistGroupModel]()
                    
                    if data.object(forKey: "multipleWishlist") != nil   {
                        if let dictData = JSON(data.object(forKey: "multipleWishlist")!).arrayObject {
                            wishlistData = dictData.map({(val) -> MyWishlistGroupModel in
                                return MyWishlistGroupModel(data: JSON(val))
                            })
                        }
                    }
                    completionBlock(wishlistData)
                }
            }
            else if success == 2{
                //self.getAllAvailableWishlistGroups()
                GlobalData.sharedInstance.dismissLoader()
            }
        }
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension WishListDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- UITableViewDataSource and UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.white
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        myWishLIstTableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "wishListCell")
        let cell:WishListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wishListCell") as! WishListTableViewCell
        
        let wishlistItem = wishlistItems[indexPath.row]
        
        cell.productImageView.image = UIImage(named: "ic_placeholder.png")
        cell.productImageView.tag = indexPath.row
        cell.productImageView.isUserInteractionEnabled = true
        
        cell.productImageView.getImageFromUrl(imageUrl: wishlistItem.img_link)

        cell.productImageView.addTapGestureRecognizer {
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
            vc.productName = wishlistItem.product_name
            vc.productId = wishlistItem.product_id
            vc.productImageUrl = wishlistItem.img_link
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.productName.text = wishlistItem.product_name
        cell.productName.textColor = UIColor.textHeading
        cell.productName.font = UIFont.systemFont(ofSize:15 , weight: .semibold)
        
        let dateData =  wishlistItem.sku
        cell.skuLabel.text = GlobalData.sharedInstance.language(key: "sku")+" "+dateData
        
        cell.quantityLabel.text = GlobalData.sharedInstance.language(key: "qty")
        let quantity = wishlistItem.qty.split(separator:".")
        //print("@@@ QUANTITY :\(quantity[0])")
        cell.qtyTextField.text = String(quantity[0])
        cell.qtyTextField.tag = 2000 + indexPath.row
        cell.qtyTextField.textAlignment = .center
        cell.qtyTextField.isEnabled = false
        
        cell.btnDelete.addTargetClosure { (btn) in
            self.callHttppApiForDeleteItem(selItem:wishlistItem, selItemIndexPath:indexPath)
        }
        
        cell.btnMove.addTargetClosure { (btn) in
            self.getWishListGroupsDataForMoveAndCopyItem(selItem: wishlistItem,
                                                   selItemIndexPath: indexPath,
                                                   operationType:WishListItemApiType.move)
        }
        
        cell.btnCopy.addTargetClosure { (btn) in
            self.getWishListGroupsDataForMoveAndCopyItem(selItem:wishlistItem,
                                                   selItemIndexPath:indexPath,
                                                   operationType:WishListItemApiType.copy)
        }
        
        cell.btnShare.addTargetClosure { (btn) in
            self.callHttppApiForShareItem(selItem:wishlistItem, selItemIndexPath: indexPath)
        }
        
        cell.btnAddToCart.addTargetClosure { (btn) in
            
        }
        
        /*
        cell.startRatings.value = CGFloat(wishlistItem.rating)
        cell.startRatings.tintColor = UIColor.button
        cell.startRatings.allowsHalfStars = true*/
        
        let priceValue : String = wishlistItem.price
        cell.priceLabel.text = GlobalData.sharedInstance.language(key: "price")+" "+priceValue
        
        if indexPath.row == wishlistItems.count - 1  && totalCount > wishlistItems.count {
            self.pagination()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
            
            self.myWishLIstTableView.tableFooterView = spinner
            self.myWishLIstTableView.tableFooterView?.isHidden = false
            
            if self.wishlistItems != nil    {
                if self.totalCount == self.wishlistItems.count  {
                    spinner.stopAnimating()
                    self.myWishLIstTableView.tableFooterView = nil
                    self.myWishLIstTableView.tableFooterView?.isHidden = true
                }
            }
        }
    }
    
    //MARK:- Pagination
    func pagination()   {
        //whichApiDataToprocess = ""
        //pageNumber += 1
        //callingHttppApi()
    }
}
