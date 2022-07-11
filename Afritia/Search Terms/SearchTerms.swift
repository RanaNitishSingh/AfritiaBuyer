//
//  SearchTerms.swift
//  DummySwift
//
//  Created by Webkul on 28/12/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class SearchTerms: AfritiaBaseViewController {
    
    @IBOutlet weak var tableViewCell: UITableView!
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    var searchTermsArray = NSArray()
    var searchTermDict:NSDictionary!
    let defaults = UserDefaults.standard
    var searchtermsViewModel:SearchTermViewModel!
    var categoryType = "searchquery"
    var categoryName = appLanguage.localize(key:"searchresult")
    var categoryId = ""
    var searchQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.navigationItem.title = appLanguage.localize(key: "searchterms")
        
        self.setUpCustomNavigationBar()
        
        tableViewCell.isHidden = true;
        APIServiceManager.shared.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
        callingHttppApi()
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

    func callingHttppApi(){
        var requstParams = [String:Any]();
        GlobalData.sharedInstance.showLoader()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.searchTermList, currentView: self){success,responseObject in
            if success == 1{
                
                self.searchtermsViewModel = SearchTermViewModel(data:JSON(responseObject as! NSDictionary))
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isMovingToParentViewController{
            print("4nd pushed")
        }else{
            print("clear the previous")
            APIServiceManager.shared.removePreviousNetworkCall()
            GlobalData.sharedInstance.dismissLoader()
        }
        //self.navigationController?.isNavigationBarHidden = false
    }
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            GlobalData.sharedInstance.dismissLoader()
            self.view.isUserInteractionEnabled = true;
            self.tableViewCell.delegate = self
            self.tableViewCell.dataSource = self
            self.tableViewCell.isHidden = false
            self.tableViewCell.reloadData()
        }
    }
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "searchtermstoproductcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.categoryName
            viewController.categoryId = self.categoryId
            viewController.categoryType = self.categoryType
            viewController.searchQuery = self.searchQuery
        }
    }*/
}


extension SearchTerms : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchtermsViewModel.getSearchterms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        cell.imageView?.image = UIImage(named:"afritia_icon")?.resizeImageWith(newSize:CGSize(width:25, height: 25), isOpaque: true)
        cell.textLabel?.text = searchtermsViewModel.getSearchterms[indexPath.row].term
        cell.textLabel?.textColor = UIColor.blue
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchQuery = searchtermsViewModel.getSearchterms[indexPath.row].term
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
        vc.categoryName = self.categoryName
        vc.categoryId = self.categoryId
        vc.categoryType = self.categoryType
        vc.searchQuery = self.searchQuery
        self.navigationController?.pushViewController(vc, animated:true)
        
        tableView.deselectRow(at:indexPath, animated:true)
        //self.performSegue(withIdentifier: "searchtermstoproductcategory", sender: self)
    }
}
