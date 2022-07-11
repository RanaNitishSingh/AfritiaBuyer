//
//  SellerListController.swift
//  Getkart
//
//  Created by kunal on 01/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerListController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var searchQuery:String = ""
    var sellerListViewModel:SellerListViewModel!
    var sellerId:String = ""
    var sellername:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyAfritiaTheme()
        self.navigationItem.title = "sellerlist".localized //GlobalData.sharedInstance.language(key: "sellerlist")
        
        tableView.register(UINib(nibName: "SellerListViewCell", bundle: nil), forCellReuseIdentifier: "SellerListViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = UIColor.clear
        searchTextField.placeholder = "Search Seller By Shop Name";
        callingHttppApi()
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        let storeId = DEFAULTS.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        requstParams["searchQuery"] = searchQuery
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/sellerlist", currentView: self){success,responseObject in
            if success == 1{
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.sellerListViewModel = SellerListViewModel(data:dict)
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }else{
                    AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                print("dsd", responseObject)
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.sellerListViewModel.sellerListModel.count == 0 {
            AlertManager.shared.showWarningSnackBar(msg: "nosellerfoundwithsearchquery".localized)
        }
        return self.sellerListViewModel.sellerListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerListViewCell", for: indexPath) as! SellerListViewCell
        cell.sellerName.setTitle(self.sellerListViewModel.sellerListModel[indexPath.row].shopTitle , for: .normal)
        cell.noOfProducts.text = self.sellerListViewModel.sellerListModel[indexPath.row].productCount
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerListViewModel.sellerListModel[indexPath.row].logo, imageView: cell.sellerImage)
        
        cell.sellerName.addTarget(self, action: #selector(seeSellerProfile(sender:)), for: .touchUpInside)
        cell.sellerName.isUserInteractionEnabled = true;
        cell.sellerName.tag = indexPath.row
        
        cell.viewAllButton.addTarget(self, action: #selector(viewAllData(sender:)), for: .touchUpInside)
        cell.viewAllButton.isUserInteractionEnabled = true;
        cell.viewAllButton.tag = indexPath.row
        
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func seeSellerProfile(sender: UIButton){
        self.sellerId = self.sellerListViewModel.sellerListModel[sender.tag].sellerId
        let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "SellerDetailsViewController") as! SellerDetailsViewController
        vc.profileUrl = sellerId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewAllData(sender: UIButton){
        self.sellerId = self.sellerListViewModel.sellerListModel[sender.tag].sellerId
        self.sellername = self.sellerListViewModel.sellerListModel[sender.tag].shopTitle
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
        vc.categoryName = sellername
        vc.categoryType = "marketplace"
        vc.sellerId = sellerId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searcButtonPress(_ sender: UIButton) {
        searchQuery = searchTextField.text!
        callingHttppApi()
    }
}
