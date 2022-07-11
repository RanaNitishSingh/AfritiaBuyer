//
//  Categories.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 24/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class Categories: AfritiaBaseViewController {
    
    @IBOutlet weak var catgryCollectionView: UICollectionView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    var tempCategoryData : NSMutableArray = [];
    var tempCategoryId : NSMutableArray = [];
    var categoryMenuData:NSMutableArray = []
    var headingTitleData:NSMutableArray = []
    var categoryDict :NSDictionary = [:]
    var categoryName:String!
    var categoryId:String!
    var homeViewModel : HomeViewModel!
    var categoryChildData:NSArray!
    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.LightLavendar
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.LightLavendar
        }*/
        
        //self.setStatusBarBackgroundColor(color:UIColor.LightLavendar)
        //self.view.backgroundColor = UIColor.PureWhite
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.green
        
        self.setUpCustomNavigationBar()
        
        //self.navigationController?.isNavigationBarHidden = true
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.navigationItem.title = GlobalData.sharedInstance.language(key: "categories")
        
        //afritiaNavBarView.configureTitleView(isVisible:true, titleType:.image, title:nil, image1: UIImage(named: "afritia_logo")!)
        
        //afritiaNavBarView.isLeftButton1Hidden = true
        //afritiaNavBarView.isLeftButton2Hidden = true
        
        //let height: CGFloat = 80 //whatever height you want to add to the existing height
        //let bounds = self.navigationController!.navigationBar.bounds
        //self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
        let paymentViewNavigationController = self.tabBarController?.viewControllers?[0]
        let nav = paymentViewNavigationController as! UINavigationController;
        let paymentMethodViewController = nav.viewControllers[0] as! HomeViewController
        homeViewModel = paymentMethodViewController.homeViewModel;
        
        let categoryDataItemsArray  = homeViewModel.cateoryData;
        categoryChildData =   categoryDataItemsArray!["children"] as? NSArray;
        if let itemsArray = categoryChildData{
            for (item) in itemsArray{
                let cData:NSDictionary = item as! NSDictionary
                self.tempCategoryData.add(cData["name"] as! String )
                self.tempCategoryId.add(cData["category_id"] as! String )
            }
        }
        
        categoryMenuData = tempCategoryData;
        catgryCollectionView.register(UINib(nibName: "CategoryTypeCell", bundle: nil), forCellWithReuseIdentifier: "categoryTypeCell")
        catgryCollectionView.dataSource = self
        catgryCollectionView.delegate = self
        catgryCollectionView.reloadData()
        
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: GlobalData.sharedInstance.language(key: "refreshing"), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
    }
    
    func setUpCustomNavigationBar(){
        self.changeStatusBarColor(color: UIColor.LightLavendar)
        self.navigationController?.isNavigationBarHidden = true
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.navigationItem.title = GlobalData.sharedInstance.language(key: "categories")
        
        afritiaNavBarView.configureLeftButton1(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        afritiaNavBarView.configureLeftButton2(isVisible:false, btnType: .none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        afritiaNavBarView.configureRightButton1(isVisible:true, btnType: .image, btnTitle:nil, btnImage:navIcon.cart) { (btnTitle) in
            self.showMyCart()
        }
        afritiaNavBarView.configureRightButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        
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
    func setStatusBarBackgroundColor(color: UIColor) {

            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            statusBar.backgroundColor = color
        }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalData.sharedInstance.dismissLoader()
        APIServiceManager.shared.removePreviousNetworkCall()
        
        let promptview = UIView(frame:CGRect(x:0, y: 0, width:UIScreen.main.bounds.width, height:80))
        view.backgroundColor = UIColor.DarkLavendar
        self.navigationController?.navigationBar.addSubview(promptview)
        
        //let newSize = CGSize(width:UIScreen.main.bounds.width, height:100)
        //self.navigationController?.navigationBar.sizeThatFits(newSize)
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "subCategorySegue") {
            let viewController:subCategory = segue.destination as UIViewController as! subCategory
            viewController.categoryName = categoryDict .object(forKey: "name") as! String
            viewController.subCategoryData = categoryDict as NSDictionary
        }
        if(segue.identifier! == "categorySegue"){
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.categoryName
            viewController.categoryType = ""
            viewController.categoryId = self.categoryId
        }
    }
}


//MARK:- UICollectionView
extension Categories : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- UICollectionView
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryMenuData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryTypeCell", for: indexPath) as! CategoryTypeCell
        cell.layer.borderColor = UIColor.LightLavendar.cgColor
        cell.layer.borderWidth = 0.5
        
        let contentForThisRow  = categoryMenuData[indexPath.row]
        cell.categoryName.text = contentForThisRow as? String
        cell.categoryName.textColor = UIColor.darkGray
        //cell.backgroundImageView.getImageFromUrl(imageUrl: <#T##String#>)
        cell.backgroundImageView.contentMode = .scaleAspectFill
        cell.backgroundImageView.clipsToBounds = true
        
        if indexPath.section == 0{
            for i in 0..<homeViewModel.categoryImage.count{
                if tempCategoryId[indexPath.row] as! String == homeViewModel.categoryImage[i].id{
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl: homeViewModel.categoryImage[i].bannerImage, imageView: cell.backgroundImageView)
                    break
                }
            }
        }
        
        return cell
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let currentCellCount = self.productCollectionView.numberOfItems(inSection: 0)
        if totalCount > currentCellCount{
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }else{
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.startAnimate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    */
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/2, height:SCREEN_WIDTH/2.5 + 70)
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            categoryDict  = categoryChildData .object(at: indexPath.row) as! NSDictionary
            let childArray : NSArray = categoryDict .object(forKey:"children") as! NSArray
            print(childArray)
            
            if childArray.count > 0 {
                self.performSegue(withIdentifier: "subCategorySegue", sender: self)
            }else {
                categoryName = categoryDict.object(forKey: "name") as? String;
                categoryId = categoryDict.object(forKey: "category_id") as? String
                self.performSegue(withIdentifier: "categorySegue", sender: self)
            }
        }
    }
}

extension UIApplication {

    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

//MARK:- UITableView
/*
extension Categories : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH / 2.5
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryMenuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CategoriesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoriesTableViewCell
        let contentForThisRow  = categoryMenuData[indexPath.row]
        cell.categoryName.text = contentForThisRow as? String
        cell.categoryName.textColor = UIColor.darkGray
        cell.backgroundImageView.image = UIImage(named: "ic_placeholder.png")
        cell.backgroundImageView.contentMode = .scaleAspectFill
        cell.backgroundImageView.clipsToBounds = true
        
        if indexPath.section == 0{
            for i in 0..<homeViewModel.categoryImage.count{
                if tempCategoryId[indexPath.row] as! String == homeViewModel.categoryImage[i].id{
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl: homeViewModel.categoryImage[i].bannerImage, imageView: cell.backgroundImageView)
                    break
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            categoryDict  = categoryChildData .object(at: indexPath.row) as! NSDictionary
            let childArray : NSArray = categoryDict .object(forKey:"children") as! NSArray
            print(childArray)
            
            if childArray.count > 0 {
                self.performSegue(withIdentifier: "subCategorySegue", sender: self)
            }else {
                categoryName = categoryDict.object(forKey: "name") as? String;
                categoryId = categoryDict.object(forKey: "category_id") as? String
                self.performSegue(withIdentifier: "categorySegue", sender: self)
            }
        }
    }
}
*/



