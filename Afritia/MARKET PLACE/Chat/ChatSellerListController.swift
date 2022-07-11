//
//  ChatSellerListController.swift
//  Getkart
//
//  Created by yogesh on 13/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ChatSellerListController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTableView: UITableView!
    var chatSellerListViewModel:ChatSellerListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyAfritiaTheme()
        self.navigationItem.title = "sellerlist".localized
        chatTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        chatTableView.rowHeight = UITableViewAutomaticDimension
        self.chatTableView.estimatedRowHeight = 50
        self.chatTableView.separatorColor = UIColor.clear
        callingHttppApi()
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()
        
        let storeId = DEFAULTS.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = DEFAULTS.object(forKey:"customerId")
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/chat/sellerList", currentView: self){success,responseObject in
            if success == 1{
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.chatSellerListViewModel = ChatSellerListViewModel(data:dict)
                    //remove the admin from seller list if exists
                    self.chatSellerListViewModel.removeAdminSeller()
                    self.chatTableView.delegate = self
                    self.chatTableView.dataSource = self
                    self.chatTableView.reloadData()
                    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatSellerListViewModel.chatSellerListModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        cell.name.text = self.chatSellerListViewModel.chatSellerListModel[indexPath.row].name
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:  self.chatSellerListViewModel.chatSellerListModel[indexPath.row].profileImage, imageView:cell.profileImage)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ChatMessaging") as! ChatMessaging
        vc.customerId = self.chatSellerListViewModel.chatSellerListModel[indexPath.row].customerID
        vc.token = self.chatSellerListViewModel.chatSellerListModel[indexPath.row].token
        vc.customerName = self.chatSellerListViewModel.chatSellerListModel[indexPath.row].name
        vc.apiKey = self.chatSellerListViewModel.apiKey
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
