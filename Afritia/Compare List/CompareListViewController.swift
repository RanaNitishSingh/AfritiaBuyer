//
//  CompareListViewController.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 25/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class CompareListViewController: AfritiaBaseViewController{
    
    let defaults = UserDefaults.standard
    var compareListViewModel:CompareListViewModel!
    var storedOffsets = [Int: CGFloat]()
    var compareHomeDataArray:NSMutableArray = []
    var maxLayout:CGFloat = 50
    var productId:String = ""
    var whichApiToProcess:String = ""
    var productName:String = ""
    var imageUrl:String = ""
    
    @IBOutlet weak var emptyCompareLabel: UILabel!
    @IBOutlet weak var table_height: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIServiceManager.shared.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
    
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.navigationItem.title = GlobalData.sharedInstance.language(key: "comparelist")
        
        self.setUpCustomNavigationBar()
        callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.isMovingToParentViewController{
            
        }else{
            print("clear all previous")
            APIServiceManager.shared.removePreviousNetworkCall()
            GlobalData.sharedInstance.dismissLoader()
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
    
    func callingHttppApi(wishlistItemId: String = "", collectionViewTag : Int = 0, index: Int = 0){
        var requstParams = [String:Any]()
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        if defaults.object(forKey:"storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        }
        if defaults.object(forKey: "customerId") != nil{
            requstParams["customerToken"] = defaults.object(forKey: "customerId") as! String
        }
        if defaults.object(forKey: "currency") != nil{
            requstParams["currency"] = defaults.object(forKey: "currency") as! String
        }
        
        if whichApiToProcess == "remove"{
            requstParams["productId"] = self.productId
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.removefromCompare , currentView: self){success,responseObject in
                if success == 1{
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let dict = responseObject as! NSDictionary
                    let error:Bool = dict.object(forKey: "success") as! Bool
                    if error == true{
                        let AC = UIAlertController(title: nil, message: (dict.object(forKey: "message") as! String), preferredStyle: .alert)
                        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        })
                        AC.addAction(noBtn)
                        self.present(AC, animated: true, completion: { })
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }else if whichApiToProcess == "wishlist"{
            requstParams["productId"] = productId
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToWishlist, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    if errorCode == true{
                        AlertManager.shared.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "movedtowishlist"))
                        
                        var compareListData = (self.compareHomeDataArray[collectionViewTag] as! [ComapreListModel])
                        
                        let compareData = compareListData[index]
                        compareData.isInWishlist = true
                        compareData.wishlistItemId = String(data.object(forKey:"itemId") as! Int)
                        
                        compareListData[index] = compareData
                        
                        self.compareHomeDataArray[collectionViewTag]  = compareListData
                    }else{
                        AlertManager.shared.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "notmovedtowishlist"))
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }else if self.whichApiToProcess == "removeDataWishList"{
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]()
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["itemId"] = wishlistItemId
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.removeFromWishList, currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    print(responseObject!)
                    self.view.isUserInteractionEnabled = true
                    
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        AlertManager.shared.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "successwishlistremove"))
                        
                        var compareListData = (self.compareHomeDataArray[collectionViewTag] as! [ComapreListModel])
                        
                        let compareData = compareListData[index]
                        compareData.isInWishlist = false
                        compareData.wishlistItemId = "0"
                        
                        compareListData[index] = compareData
                        
                        self.compareHomeDataArray[collectionViewTag]  = compareListData
                    }
                    else{
                        AlertManager.shared.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "errorwishlist"))
                    }
                    
                }else if success == 2{
                    self.callingHttppApi();
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }else if whichApiToProcess == "addtocart"{
            requstParams["qty"] = "1"
            requstParams["productId"] = productId
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname: AfritiaAPI.addToCart, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    if responseObject?.object(forKey: "defaultCurrency") != nil{
                        self.defaults .set(responseObject!.object(forKey: "defaultCurrency") as! String, forKey: "currency")
                    }
                    
                    
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    GlobalData.sharedInstance.dismissLoader()
                    if data.object(forKey: "quoteId") != nil{
                        let quoteId:String = String(format: "%@", data.object(forKey: "quoteId") as! CVarArg)
                        if quoteId != "0"{
                            self.defaults .set(quoteId, forKey: "quoteId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    if errorCode == true{
                        AlertManager.shared.showSuccessSnackBar(msg:data .object(forKey:"message") as! String )
                        GlobalData.sharedInstance.cartItemsCount = data.object(forKey: "cartCount") as! Int
                        //self.tabBarController!.tabBar.items?[3].badgeValue = String(data.object(forKey: "cartCount") as! Int)
                    }
                    else{
                        AlertManager.shared.showErrorSnackBar(msg: data .object(forKey:"message") as! String)
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        else{
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.compareList, currentView: self){success,responseObject in
                if success == 1{
                    GlobalData.sharedInstance.dismissLoader()
                    self.compareListViewModel = CompareListViewModel(data:JSON(responseObject as! NSDictionary))
                    print(responseObject!)
                    self.view.isUserInteractionEnabled = true
                    self.doFurtherProcessingWithResult();
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        
    }
    
    
    
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            
            self.compareHomeDataArray = [self.compareListViewModel.getProductList]
            print("ssss",self.compareHomeDataArray.count)
            print("pppp",self.compareListViewModel.getProductList.count)
            
            if self.compareListViewModel.getProductList.count > 0 {
                self.tableView.isHidden = false
                self.emptyCompareLabel.isHidden = true
                self.tableView.delegate = self
                self.tableView.dataSource = self;
                self.tableView.reloadData()
            }else {
                self.tableView.isHidden = true
                self.emptyCompareLabel.isHidden = false
                self.emptyCompareLabel.text = GlobalData.sharedInstance.language(key: "emptycomparelist")
            }
        }
        
    }
    
    
    
    @objc func deleteCompare(sender: UIButton){
        let dd:[ComapreListModel] = compareHomeDataArray[0] as! [ComapreListModel]
        whichApiToProcess = "remove";
        self.productId = dd[sender.tag].productId
        self.callingHttppApi()
    }
    
    @objc func addToWishList(sender: UIButton){
        let customerId = defaults.object(forKey: "customerId")
        if(customerId == nil){
            let alertView = UIAlertController(title: "loginrequired".localized, message: "doyouwanttologin".localized, preferredStyle: .alert)
            let loginBtn = UIAlertAction(title: "loginalert".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CustomerLogin") as? CustomerLogin
                self.navigationController?.pushViewController(vc!, animated: true)
            })
            let cancelBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            })
            
            alertView.addAction(cancelBtn)
            alertView.addAction(loginBtn)
            self.present(alertView, animated: true, completion: nil)
        }else{
            
            let dd:[ComapreListModel] = compareHomeDataArray[(sender.superview?.tag)!] as! [ComapreListModel]
            
            if dd[sender.tag].isInWishlist == true{
                //remove wishlist
                sender.setImage(#imageLiteral(resourceName: "ic_wishlist_empty"), for: .normal)
                whichApiToProcess = "removeDataWishList"
                self.productId = dd[sender.tag].productId
                self.callingHttppApi(wishlistItemId: dd[sender.tag].wishlistItemId, collectionViewTag: (sender.superview?.tag)!, index: sender.tag)
            }else{
                //add wishlist
                sender.setImage(#imageLiteral(resourceName: "ic_wishlist_fill"), for: .normal)
                whichApiToProcess = "wishlist"
                self.productId = dd[sender.tag].productId
                self.callingHttppApi(wishlistItemId: "", collectionViewTag: (sender.superview?.tag)!, index: sender.tag)
            }
        }
    }
    
    @objc func addToCart(sender: UIButton){
        let dd:[ComapreListModel] = compareHomeDataArray[0] as! [ComapreListModel]
        
        if dd[sender.tag].typeId == "configurable" || dd[sender.tag].typeId == "bundle" || dd[sender.tag].typeId == "grouped" {
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
            vc.productName = dd[sender.tag].productName
            vc.productId = dd[sender.tag].productId
            vc.productImageUrl = dd[sender.tag].imageUrl
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            whichApiToProcess = "addtocart"
            self.productId = dd[sender.tag].productId
            self.callingHttppApi()
        }
    }
}

extension CompareListViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return compareHomeDataArray.count + self.compareListViewModel.getAttributesValue.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return GlobalData.sharedInstance.language(key: "product")
        }else{
            return compareListViewModel.getAttributsName[section - 1].attributesName
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.DarkLavendar
        var headerTitle = ""
        if section == 0{
            headerTitle = "product".localized
        }else{
            headerTitle = compareListViewModel.getAttributsName[section - 1].attributesName
        }
        
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = headerTitle
            label.font = UIFont.systemFont(ofSize: 15, weight:.medium) // my custom font
            label.textColor = UIColor.white // my custom colour

            headerView.addSubview(label)

            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier: String = "cell"
        let cell:CompareListTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! CompareListTableViewCell
        if indexPath.section == 0{
            cell.collectionView.register(UINib(nibName: "CompareProductCollectionView", bundle: nil), forCellWithReuseIdentifier: "compareproduct")
            
            cell.collectionView.tag = (1 * indexPath.section) + 1
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
            cell.collectionViewOffset = storedOffsets[indexPath.section] ?? 0
        }else{
            cell.collectionView.register(UINib(nibName: "CompareProductAttributeValueCollectionView", bundle: nil), forCellWithReuseIdentifier: "compareproductValue")
            cell.collectionView.tag = (1 * indexPath.section) + 1
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
            cell.collectionViewOffset = storedOffsets[indexPath.section] ?? 0
        }
        
        self.table_height.constant = self.tableView.contentSize.height
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return SCREEN_WIDTH/2.5 + 100
        }else{
            let dd  = compareListViewModel.getAttributesValue[indexPath.section - 1].attributesValueArray
            maxLayout = 50;
            for i in 0  ..< Int((dd?.count)!){
                let actualString:String = dd?[i] as! String;
                let actualHeight = actualString.height(withConstrainedWidth:SCREEN_WIDTH/2.5 + 10 , font: UIFont.systemFont(ofSize: 12.0))
                if actualHeight > maxLayout{
                    maxLayout = actualHeight
                }
            }
            return maxLayout + 20
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0..<(compareHomeDataArray.count + self.compareListViewModel.getAttributesValue.count) {
            let cell2 = self.view.viewWithTag((1 * i) + 1) as? UICollectionView
            
            if cell2 != nil {
                if scrollView.contentOffset.y == 0{
                    cell2!.contentOffset = scrollView.contentOffset
                }
            }
        }
    }
}

extension CompareListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            let dd:[ComapreListModel] = compareHomeDataArray[collectionView.tag - 1] as! [ComapreListModel]
            return dd.count
        }else {
            let dd  = compareListViewModel.getAttributesValue[collectionView.tag - 2].attributesValueArray
            return (dd?.count)!;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "compareproduct", for: indexPath) as! CompareProductCollectionView
            
            let dd:[ComapreListModel] = compareHomeDataArray[collectionView.tag - 1] as! [ComapreListModel]
            cell.productName.text = dd[indexPath.row].productName
            cell.priceValue.text = dd[indexPath.row].price
            cell.ratingValue.value = dd[indexPath.row].rating
            
            if dd[indexPath.row].isInWishlist == true{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
            }else{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty"), for: .normal)
            }
            
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: dd[indexPath.row].imageUrl, imageView: cell.imageViewData)
            cell.layer.borderColor = UIColor.LightLavendar.cgColor
            cell.layer.borderWidth = 0.5
            cell.backgroundColor = UIColor.white
            
            cell.deleteButton.addTarget(self, action: #selector(CompareListViewController.deleteCompare(sender:)), for: .touchUpInside)
            cell.deleteButton.isUserInteractionEnabled = true
            cell.deleteButton.tag = indexPath.row
            
            cell.wishListButton.addTarget(self, action: #selector(CompareListViewController.addToWishList(sender:)), for: .touchUpInside)
            cell.wishListButton.isUserInteractionEnabled = true
            cell.wishListButton.superview?.tag = collectionView.tag - 1
            cell.wishListButton.tag = indexPath.row
            
            
            cell.addToCartButton.addTarget(self, action: #selector(CompareListViewController.addToCart(sender:)), for: .touchUpInside)
            cell.addToCartButton.isUserInteractionEnabled = true
            cell.addToCartButton.tag = indexPath.row
            
            if dd[indexPath.row].hasOption == 1{
                cell.addToCartButton.isHidden = true
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "compareproductValue", for: indexPath) as! CompareProductAttributeValueCollectionView
            cell.layer.borderColor = UIColor.appLightGrey.cgColor
            cell.layer.borderWidth = 0.5
            let dd:Array  = compareListViewModel.getAttributesValue[collectionView.tag - 2].attributesValueArray
            cell.value.text = (dd[indexPath.row] as? String)?.html2String
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dd:[ComapreListModel] = compareHomeDataArray[0] as! [ComapreListModel]
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = dd[indexPath.row].productName
        vc.productId = dd[indexPath.row].productId
        vc.productImageUrl = dd[indexPath.row].imageUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CompareListViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1{
            return CGSize(width: SCREEN_WIDTH/2.5 + 10, height:SCREEN_WIDTH/2.5 + 80)
        }else{
            return CGSize(width: SCREEN_WIDTH/2.5 + 10, height:maxLayout)
        }
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
