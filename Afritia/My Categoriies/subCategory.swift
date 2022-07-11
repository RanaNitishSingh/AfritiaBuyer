//
//  subCategory.swift
//  DummySwift
//
//  Created by Webkul on 11/11/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class subCategory: AfritiaBaseViewController{
    
    public  var subCategoryData :NSDictionary = [:]
    public var categoryName = " "
    var subCategoryMenuData:NSMutableArray = []
    var categoryId:String = " "
    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    @IBOutlet weak var subCategoryTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCustomNavigationBar()
        
        //self.navigationController!.isNavigationBarHidden = false
        //self.title = categoryName
        
        subCategoryTable.register(SubCategoryTableViewCell.nib, forCellReuseIdentifier: SubCategoryTableViewCell.identifier)
        subCategoryTable.rowHeight = UITableViewAutomaticDimension
        subCategoryTable.estimatedRowHeight = 200
        
        self.subCategoryMenuData.add(GlobalData.sharedInstance.language(key: "viewall")+" "+(subCategoryData["name"] as? String ?? "empty"))
        
        let childArray : NSArray? = subCategoryData .object(forKey:"children") as? NSArray
        if let itemsArray = childArray{
            for (item) in itemsArray{
                let childStoreData:NSDictionary = item as! NSDictionary;
                self.subCategoryMenuData.add(childStoreData["name"] as? String ?? "empty")
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "subCategoryToProductCategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryType = ""
            viewController.categoryName = self.categoryName
            viewController.categoryId = self.categoryId
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateTable()
    }
    
    func animateTable() {
        self.subCategoryTable.reloadData()
        
        let cells = subCategoryTable.visibleCells
        let tableHeight: CGFloat = subCategoryTable.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            
            index += 1
        }
    }
}

extension subCategory : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategoryMenuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubCategoryTableViewCell.identifier, for: indexPath) as! SubCategoryTableViewCell
        cell.item = subCategoryMenuData[indexPath.row] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let childArray : NSArray? = subCategoryData .object(forKey:"children") as? NSArray
        if indexPath.row == 0{
            /*
            categoryName = subCategoryData["name"] as! String
            categoryId = subCategoryData["category_id"] as! String
            self.performSegue(withIdentifier: "subCategoryToProductCategory", sender: self)*/
            
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
            vc.categoryId = (subCategoryData["category_id"] as! String)
            vc.categoryName = (subCategoryData["name"] as! String)
            vc.categoryType = ""
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else{
            let childDict: NSDictionary = childArray? .object(at: indexPath.row - 1) as! NSDictionary
            if (childDict.object(forKey: "children") as! NSArray).count > 0{
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let initViewController: subCategory? = (sb.instantiateViewController(withIdentifier: "subCategory") as? subCategory)
                initViewController?.subCategoryData = childDict
                initViewController?.categoryName = (childDict.object(forKey: "name") as? String)!
                initViewController?.modalTransitionStyle = .flipHorizontal
                self.navigationController?.pushViewController(initViewController!, animated: true)
            }else{
                /*
                categoryName = childDict .object(forKey: "name") as! String
                categoryId = childDict .object(forKey: "category_id") as! String
                self.performSegue(withIdentifier: "subCategoryToProductCategory", sender: self)*/
                
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
                vc.categoryId = (childDict .object(forKey: "category_id") as! String)
                vc.categoryName = (childDict .object(forKey: "name") as! String)
                vc.categoryType = ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
