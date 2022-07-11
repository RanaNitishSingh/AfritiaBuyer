//
//  MyWishList.swift
//  DummySwift
//
//  Created by Webkul on 23/11/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit
import SwipeCellKit

class MyWishList: AfritiaBaseViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var myWishLIstTableView: UITableView!
    //@IBOutlet weak var massUpdate: UIButton! //this button is hidden behind table
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    var myWishlistModelData = [MyWishlistModel]()
    var totalCount : Int = 0
    var whichApiDataToprocess: String = ""
    var pageNumber:Int = 0
    var indexPathValue:IndexPath!
    var itemId:String!
    var imageCache = NSCache<AnyObject, AnyObject>()
    let defaults = UserDefaults.standard
    var massUpdateWhishList = [Any]()
    var qtyValue:String!
    var productId:String!
    var productImageUrl:String = ""
    var productName:String = ""
    var refreshControl:UIRefreshControl!
    var emptyView:EmptyPlaceHolderView!
    
    var isSwipeRightEnabled:Bool = true
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    
    var myWishlistGroupData = [MyWishlistGroupModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.title = appLanguage.localize(key: "mywishlist")
        
        self.setUpCustomNavigationBar()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyWishList.dismissKeyboard))
        myWishLIstTableView.addGestureRecognizer(tap)
        
        myWishLIstTableView.rowHeight = UITableViewAutomaticDimension
        myWishLIstTableView.estimatedRowHeight = 200
        
        GlobalData.sharedInstance.dismissLoader()
        APIServiceManager.shared.removePreviousNetworkCall()
        whichApiDataToprocess = " "
        
        pageNumber = 1
        //callingHttppApi()
        //callApiForMultiWishlist(apiType:GroupedWishlistAPIType.getAll)
        self.getAllWishListGroups()
        //massUpdate.applyAfritiaTheme()
        //massUpdate.setTitle(GlobalData.sharedInstance.language(key: "massupdate"), for: .normal)
        //massUpdate.isHidden = true

        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "refreshing".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        myWishLIstTableView.refreshControl = refreshControl
        
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
    
    func DisplayEmptyDataView(isVisible:Bool){
        
        if isVisible {
            emptyView = EmptyPlaceHolderView(frame: self.view.frame)
            emptyView.emptyImages.image = UIImage(named: "empty_cart")!
            emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "browsecategory"), for: .normal)
            emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptycartmessage")
            emptyView.callBackBtnAction = {(action) in
                self.tabBarController!.selectedIndex = 2
            }
            
            myWishLIstTableView.backgroundView = emptyView
            myWishLIstTableView.separatorStyle = .none
            
        }else{
            
            myWishLIstTableView.backgroundView = nil
            myWishLIstTableView.separatorStyle = .singleLine
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //let addBtn = UIBarButtonItem(image:UIImage(named: "nav_icon_add"), style: .plain, target: self, action:#selector(self.callApiForAddNewWishListGroup))
       //self.navigationItem.rightBarButtonItem =  addBtn
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    @objc func callApiForAddNewWishListGroup()
    {
        var textFieldNewGrouptName: UITextField!
        
        let alert = UIAlertController(title: "Add New Group", message: "Enter your new WishList name ", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (rename) in
            
            if textFieldNewGrouptName.isEmpty(){
                AlertManager.shared.showInfoSnackBar(msg:"Please enter new group name")
            }
            else{
               
                GlobalData.sharedInstance.showLoader()
                self.view.isUserInteractionEnabled = false
                
                var requstParams = [String:Any]()
                requstParams["storeId"] = UserManager.getStoreId
                requstParams["wishlist"] = "new"
                requstParams["newWishlistName"] = textFieldNewGrouptName.text ?? ""
                requstParams["customerToken"] = UserManager.getCustomerId
                
                APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addNewWishListGroup, currentView: self){success,responseObject in
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    if success == 1{
                        //print(responseObject)
                        self.getAllWishListGroups()
                    }else if success == 2 {
                        self.callApiForAddNewWishListGroup()
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (cancel) in
            print("cancel renaming now")
        }
        
        alert.addTextField { (groupNameTextField) in
            textFieldNewGrouptName = groupNameTextField
            textFieldNewGrouptName?.placeholder = "Enter New WishList Name"
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK:- Pull to refresh
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        whichApiDataToprocess = " "
        pageNumber = 1
        callingHttppApi()
        refreshControl.endRefreshing()
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    /*
    @objc func openProduct(_ sender:UITapGestureRecognizer){
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = myWishlistModelData[(sender.view?.tag)!].name
        vc.productId = myWishlistModelData[(sender.view?.tag)!].productId
        vc.productImageUrl = myWishlistModelData[(sender.view?.tag)!].thumbNail
        self.navigationController?.pushViewController(vc, animated: true)
    }*/
    
    func getAllWishListGroups(){
        
        /*
        self.view.isUserInteractionEnabled = false
        
        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["pageNumber"] =  "\(pageNumber)"
        requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
    
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.allAvailableWishlist, currentView: self){success,responseObject in
            if success == 1{
               
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                
                let data = responseObject as! NSDictionary
                
                if self.pageNumber == 1{
                    self.myWishlistGroupData = [MyWishlistGroupModel]()
                }
                
                var wishlistData = [MyWishlistGroupModel]()
                
                if data.object(forKey: "multipleWishlist") != nil   {
                    if let dictData = JSON(data.object(forKey: "multipleWishlist")!).arrayObject {
                        wishlistData = dictData.map({(val) -> MyWishlistGroupModel in
                            return MyWishlistGroupModel(data: JSON(val))
                        })
                    }
                }
                
                for i in 0..<wishlistData.count {
                    print(wishlistData[i].name)
                    self.myWishlistGroupData.append(wishlistData[i])
                }
                
                /*
                if data .object(forKey: "totalCount") != nil    {
                    self.totalCount = (data .object(forKey: "totalCount") as? Int)!
                }*/
                
                if self.myWishlistGroupData.count == 0{
                    self.DisplayEmptyDataView(isVisible:true)
                    //self.emptyWishListView.isHidden = false
                }else{
                    self.DisplayEmptyDataView(isVisible:false)
                }
                
                self.myWishLIstTableView.reloadData()
                self.view.isUserInteractionEnabled = true
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                //self.getAllAvailableWishListGroups()
            }
        }
        */
        
        WishListServiceHelper.getWishListGroups { (result, wishlistGroups) in
            
            if result {
                
                self.myWishlistGroupData = [MyWishlistGroupModel]()
                
                for i in 0..<wishlistGroups.count {
                    //print(wishlistData[i].name)
                    self.myWishlistGroupData.append(wishlistGroups[i])
                }
                
                if self.myWishlistGroupData.count == 0{
                    self.DisplayEmptyDataView(isVisible:true)
                    //self.emptyWishListView.isHidden = false
                }else{
                    self.DisplayEmptyDataView(isVisible:false)
                }
                
                self.myWishLIstTableView.reloadData()
            }
        }
    }
    
    func callApiForRenameWishListGroup(selItem:MyWishlistGroupModel) {
        
        var textFieldNewListName: UITextField?
        //var txtPassword: UITextField?
        
        let alert = UIAlertController(title: "Rename", message: "\(selItem.name) To", preferredStyle: .alert)
        
        let renameAction = UIAlertAction(title: "Rename", style: .default) { (rename) in
            if let newName = textFieldNewListName?.text {
                print("List New Name is: \(newName)")
                //self.wishListNewName = newName
                //self.selWishListId = selItem.id
                //self.callApiForMultiWishlist(apiType:GroupedWishlistAPIType.rename)
                
                GlobalData.sharedInstance.showLoader()
                self.view.isUserInteractionEnabled = false
                
                var requstParams = [String:Any]()
                requstParams["storeId"] = UserManager.getStoreId
                requstParams["wishlistId"] = selItem.id
                requstParams["name"] = newName
                requstParams["customerToken"] = UserManager.getCustomerId
            
                APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.renameWishlistGroup, currentView: self){success,responseObject in
                    if success == 1{
                        //print(responseObject)
                        self.view.isUserInteractionEnabled = true
                        GlobalData.sharedInstance.dismissLoader()
                        self.getAllWishListGroups()
                        //self.callApiForMultiWishlist(apiType: GroupedWishlistAPIType.getAll)
                        //self.doFurtherProcessingWithMultiWishlistResult(data: (responseObject as! NSDictionary))
                    }else if success == 2 {
                        //self.callApiForMultiWishlist(apiType:GroupedWishlistAPIType.rename)
                        self.callApiForRenameWishListGroup(selItem: selItem)
                        GlobalData.sharedInstance.dismissLoader()
                    }
                }
                
            } else {
                print("No username")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (cancel) in
            print("cancel renaming now")
        }
        
        alert.addTextField { (usernameTextField) in
            textFieldNewListName = usernameTextField
            textFieldNewListName?.placeholder = "Enter New WishList Name"
        }
        
        alert.addAction(renameAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func callApiForDeleteWishListGroup(selItem:MyWishlistGroupModel){
        AlertManager.Show(onController: self, btnTitles:["Delete", "Cancel"], alertTitle: "Delete List", alertMessage:"Are your sure? to delete this item", alertStyle: .alert) { (btnIndex, btnTitle) in
            if btnIndex == 0 {
                //self.selWishListId = selItem.id
                //self.callApiForMultiWishlist(apiType:GroupedWishlistAPIType.delete)
                GlobalData.sharedInstance.showLoader()
                self.view.isUserInteractionEnabled = false
                
                var requstParams = [String:Any]()
                requstParams["storeId"] = UserManager.getStoreId
                requstParams["wishlistId"] = selItem.id
                requstParams["customerToken"] = UserManager.getCustomerId
            
                APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.deleteWishListGroup, currentView: self){success,responseObject in
                    if success == 1{
                        //print(responseObject)
                        self.view.isUserInteractionEnabled = true
                        GlobalData.sharedInstance.dismissLoader()
                        self.getAllWishListGroups()
                        //self.callApiForMultiWishlist(apiType: GroupedWishlistAPIType.getAll)
                        //self.doFurtherProcessingWithMultiWishlistResult(data: (responseObject as! NSDictionary))
                    }else if success == 2 {
                        //self.callApiForMultiWishlist(apiType:GroupedWishlistAPIType.delete)
                        self.callApiForDeleteWishListGroup(selItem: selItem)
                        GlobalData.sharedInstance.dismissLoader()
                    }
                }
            }
        }
    }
    
    //MARK:- Call API
    
    func callingHttppApi(){
        if whichApiDataToprocess == "massUpdateWishList"{
            self.view.isUserInteractionEnabled = false
            GlobalData.sharedInstance.showLoader()
            var requstParams = [String:Any]()
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject:massUpdateWhishList , options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["itemData"] = jsonSortString
            }catch {
                print(error.localizedDescription)
            }
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.updateWishList, currentView: self){success,responseObject in
                if success == 1{
                    
                    self.view.isUserInteractionEnabled = true
                    self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
        else if whichApiDataToprocess == "myWhishListAddToCart"{
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]()
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["qty"] = qtyValue
            requstParams["productId"] = productId
            requstParams["itemId"] = itemId
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.wishListToCart, currentView: self){success,responseObject in
                if success == 1{
                    
                    self.view.isUserInteractionEnabled = true
                    self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
                }
                else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
        else if whichApiDataToprocess == "removeDataWishList"{
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]()
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["itemId"] = itemId
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.removeFromWishList, currentView: self){success,responseObject in
                if success == 1{
                    print(responseObject!)
                    self.view.isUserInteractionEnabled = true
                    self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
        else{
            self.view.isUserInteractionEnabled = false
            
            if pageNumber == 1{
                GlobalData.sharedInstance.showLoader()
            }
            
            var requstParams = [String:Any]()
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["pageNumber"] =  "\(pageNumber)"
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.wishList, currentView: self){success,responseObject in
                if success == 1{
                    print(responseObject!)
                    self.view.isUserInteractionEnabled = true
                    self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data :NSDictionary){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            GlobalData.sharedInstance.dismissLoader()
            if (self.whichApiDataToprocess == "massUpdateWishList"){
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                if errorCode == true{
                    AlertManager.shared.showSuccessSnackBar(msg:"wishlistupdatedsuccessfully".localized)
                    self.pageNumber = 1
                    self.whichApiDataToprocess = ""
                    self.callingHttppApi()
                }else{
                    AlertManager.shared.showErrorSnackBar(msg:data .object(forKey:"message") as! String)
                }
            }
            else if(self.whichApiDataToprocess == "myWhishListAddToCart"){
                let jsonData = JSON(data)
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                if errorCode == true{
                    let AC = UIAlertController(title: nil, message: (data.object(forKey: "message") as! String), preferredStyle: .alert)
                    let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(noBtn)
                    self.present(AC, animated: true, completion: { })
                    
                    GlobalData.sharedInstance.cartItemsCount = Int("\(jsonData["cartCount"])")!
                    //self.tabBarController!.tabBar.items?[3].badgeValue = "\(jsonData["cartCount"])"
                    
                    self.pageNumber = 1
                    self.whichApiDataToprocess = ""
                    self.callingHttppApi()
                }else{
                    AlertManager.shared.showErrorSnackBar(msg:data .object(forKey:"message") as! String)
                }
            }
            else if(self.whichApiDataToprocess == "removeDataWishList"){
                let errorCode = data .object(forKey:"success") as! Bool
                if errorCode == true{
                    let AC = UIAlertController(title: nil, message: (data.object(forKey: "message") as! String), preferredStyle: .alert)
                    let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(noBtn)
                    self.present(AC, animated: true, completion: { })
                    self.pageNumber = 1
                    self.whichApiDataToprocess = ""
                    self.callingHttppApi()
                }else{
                    AlertManager.shared.showErrorSnackBar(msg:data .object(forKey:"message") as! String)
                }
            }else{
                self.view.isUserInteractionEnabled = false
                if self.pageNumber == 1{
                    self.myWishlistModelData = [MyWishlistModel]()
                }
                
                var wishlistData = [MyWishlistModel]()
                
                if data.object(forKey: "wishList") != nil   {
                    if let data1 = JSON(data.object(forKey: "wishList")!).arrayObject {
                        wishlistData = data1.map({(val) -> MyWishlistModel in
                            return MyWishlistModel(data: JSON(val))
                        })
                    }
                }
                
                for i in 0..<wishlistData.count {
                    self.myWishlistModelData.append(wishlistData[i])
                }
                
                if data .object(forKey: "totalCount") != nil    {
                    self.totalCount = (data .object(forKey: "totalCount") as? Int)!
                }
                
                if self.myWishlistModelData.count == 0{
                    self.DisplayEmptyDataView(isVisible:true)
                    //self.emptyWishListView.isHidden = false
                }else{
                    self.DisplayEmptyDataView(isVisible:false)
                }
                
                self.myWishLIstTableView.reloadData()
                
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func massUpdate(_ sender: UIButton) {
        
        massUpdateWhishList = [Any]()
        
        for i in 0..<myWishlistModelData.count {
            
            var massUpdate = [String: AnyObject]()
            
            if let qty = self.view.viewWithTag(2000 + i) as? UITextField    {
                massUpdate["qty"] = qty.text as AnyObject?
            }else{
                massUpdate["qty"] = "1" as AnyObject
            }
            
            if let des = self.view .viewWithTag(1000 + i) as? UITextView    {
                if des.text == ""{
                    massUpdate["description"] = " " as AnyObject?
                }else{
                    massUpdate["description"] = des.text as AnyObject?
                }
            }else{
                massUpdate["description"] = " " as AnyObject
            }
            
            massUpdate["id"] = myWishlistModelData[i].id as AnyObject
            massUpdateWhishList.append(massUpdate)
        }
        
        whichApiDataToprocess = "massUpdateWishList"
        callingHttppApi()
    }
    
}

extension MyWishList: SwipeTableViewCellDelegate
{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]?
    {
        let listItemInfo = myWishlistGroupData[indexPath.row]
        
        if orientation == .left
        {
            guard isSwipeRightEnabled else { return nil }
            
            let rename = SwipeAction(style: .default, title: nil) { action, indexPath in
                print("Rename Selected")
                self.callApiForRenameWishListGroup(selItem:listItemInfo)
            }
            rename.hidesWhenSelected = true
            configure(action: rename, with: .rename)
            
            let share = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                print ("Share Seleccted")
                let items = [URL(string:listItemInfo.wishListShareLink)!]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
                
            }
            share.hidesWhenSelected = true
            configure(action: share, with: .share)
            
            return [rename, share]
        }
        else // if orientation == .right
        {
            let delete = SwipeAction(style: .default, title: nil) { action, indexPath in
                print ("Delete Seleccted")
                self.callApiForDeleteWishListGroup(selItem:listItemInfo)
            }
            delete.hidesWhenSelected = true
            configure(action: delete, with: .delete)
            
            return [delete]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle =  .selection //orientation == .left ? .selection : .destructive
        options.transitionStyle = .border
        
        options.buttonSpacing = 5
        options.backgroundColor = UIColor.LightLavendar
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor)
    {
        action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
        action.image = descriptor.image(forStyle: buttonStyle, displayMode:
            buttonDisplayMode)
        
        action.backgroundColor = descriptor.color
        action.textColor = UIColor.white
        action.font = .systemFont(ofSize: 13)
        action.transitionDelegate = ScaleTransition.default

    }
}

extension MyWishList : UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- UITableViewDataSource and UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return myWishlistGroupData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.yellow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        myWishLIstTableView.register(UINib(nibName: "MultiWishlistTableViewCell", bundle: nil), forCellReuseIdentifier: "MultiWishlistTableCell")
        let cell:MultiWishlistTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MultiWishlistTableCell") as! MultiWishlistTableViewCell
        
        let listInfo = myWishlistGroupData[indexPath.row]
        
        cell.logoImageView.image = UIImage(named: "afritia_spaced_logo_512.png")
        cell.lblWishListName.text = listInfo.name
        
        cell.lblWishListName.addTapGestureRecognizer {
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "WishListDetailViewController") as! WishListDetailViewController
            vc.wishListGroupInfo = listInfo
            vc.callBackForUpdateWishList = {(isRequire) in
                if isRequire {
                    self.getAllWishListGroups()
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row > 0 {
            cell.delegate = self
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK:- Pagination
    func pagination()   {
        whichApiDataToprocess = ""
        pageNumber += 1
        callingHttppApi()
    }
}

/*
extension MyWishList : UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- UITableViewDataSource and UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myWishlistModelData.count > 0 {
            massUpdate.isHidden = false
        }else{
            massUpdate.isHidden = true
        }
        
        return myWishlistModelData.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let addToCart = UITableViewRowAction(style: .normal, title: GlobalData.sharedInstance.language(key: "addtocart")) { action, index in
            self.itemId = self.myWishlistModelData[indexPath.row].id
            let qty:UITextField = self.view .viewWithTag(2000 + indexPath.row) as! UITextField
            self.qtyValue = qty.text
            self.productId = self.myWishlistModelData[indexPath.row].productId
            
            if self.myWishlistModelData[indexPath.row].typeId == "configurable" || self.myWishlistModelData[indexPath.row].typeId == "bundle" || self.myWishlistModelData[indexPath.row].typeId == "grouped" {
                //contains options
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
                vc.productImageUrl = self.myWishlistModelData[indexPath.row].thumbNail
                vc.productId = self.myWishlistModelData[indexPath.row].productId
                vc.productName = self.myWishlistModelData[indexPath.row].name
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.whichApiDataToprocess = "myWhishListAddToCart"
                self.callingHttppApi()
            }
        }
        addToCart.backgroundColor = UIColor.button
        
        let delete = UITableViewRowAction(style: .normal, title: GlobalData.sharedInstance.language(key: "delete")) { action, index in
            
            self.itemId = self.myWishlistModelData[indexPath.row].id
            self.whichApiDataToprocess = "removeDataWishList"
            self.callingHttppApi()
        }
        delete.backgroundColor = UIColor.red
        
        return [delete, addToCart]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        myWishLIstTableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "wishListCell")
        let cell:WishListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wishListCell") as! WishListTableViewCell
        
        cell.productImageView.image = UIImage(named: "ic_placeholder.png")
        cell.productImageView.tag = indexPath.row
        cell.productImageView.isUserInteractionEnabled = true
        let image = (imageCache.object(forKey: NSURL(string:self.myWishlistModelData[indexPath.row].thumbNail)! as URL as AnyObject))
        if (image != nil) {
            cell.productImageView.image = image as! UIImage?
        }else{
            let url = NSURL(string:self.myWishlistModelData[indexPath.row].thumbNail)! as URL
            self.getDataFromUrl(url: url) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { () -> Void in
                    cell.productImageView.image = UIImage(data: data)
                    self.imageCache.setObject(UIImage(data: data)!, forKey: NSURL(string:self.myWishlistModelData[indexPath.row].thumbNail)! as URL as AnyObject)
                }
            }
        }
        
        let viewProductGesture = UITapGestureRecognizer(target: self, action: #selector(self.openProduct))
        viewProductGesture.numberOfTapsRequired = 1
        cell.productImageView.addGestureRecognizer(viewProductGesture)
        
        cell.productName.text = self.myWishlistModelData[indexPath.row].name
        cell.productName.textColor = UIColor.textHeading
        cell.productName.font = UIFont.systemFont(ofSize:15 , weight: .semibold)
        
        let dateData = self.myWishlistModelData[indexPath.row].sku
        cell.skuLabel.text = GlobalData.sharedInstance.language(key: "sku")+" "+dateData
        
        /*
        cell.textView.layer.borderColor = UIColor.lightGray.cgColor
        cell.textView.layer.borderWidth = 0.5
        cell.textView.layer.cornerRadius = 6
        cell.textView.text = self.myWishlistModelData[indexPath.row].description
        cell.textView.tag = 1000 + indexPath.row
         */
        
        cell.quantityLabel.text = GlobalData.sharedInstance.language(key: "qty")
        cell.qtyTextField.text = String(self.myWishlistModelData[indexPath.row].qty)
        cell.qtyTextField.tag = 2000 + indexPath.row
        cell.qtyTextField.textAlignment = .center
        
        cell.startRatings.value = CGFloat(self.myWishlistModelData[indexPath.row].rating)
        cell.startRatings.tintColor = UIColor.button
        cell.startRatings.allowsHalfStars = true
        
        var priceValue : String = ""
        
        if self.myWishlistModelData[indexPath.row].typeId == "bundle" {
            priceValue = self.myWishlistModelData[indexPath.row].formatedMaxPrice + " - " + self.myWishlistModelData[indexPath.row].formatedMinPrice
        }else if self.myWishlistModelData[indexPath.row].typeId == "grouped" {
            priceValue = self.myWishlistModelData[indexPath.row].groupedPrice
        }else{
            priceValue = self.myWishlistModelData[indexPath.row].price
        }
        
        cell.priceLabel.text = GlobalData.sharedInstance.language(key: "price")+" "+priceValue
        
        if indexPath.row == myWishlistModelData.count - 1  && totalCount > myWishlistModelData.count {
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
            
            if self.myWishlistModelData != nil    {
                if totalCount == self.myWishlistModelData.count  {
                    spinner.stopAnimating()
                    self.myWishLIstTableView.tableFooterView = nil
                    self.myWishLIstTableView.tableFooterView?.isHidden = true
                }
            }
        }
    }
    
    //MARK:- Pagination
    func pagination()   {
        whichApiDataToprocess = ""
        pageNumber += 1
        callingHttppApi()
    }
}
*/
