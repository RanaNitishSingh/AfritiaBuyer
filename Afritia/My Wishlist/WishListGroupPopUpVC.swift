//
//  WishListGroupPopUpVC.swift
//  Afritia
//
//  Created by Ranjit Mahto on 25/11/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit


class WishListGroupPopUpVC: UIViewController{
    
    @IBOutlet weak var myWishLIstTableView: UITableView!
    @IBOutlet weak var newWishLIstTextField: UITextField!
    @IBOutlet weak var btnAddToWishlist: UIButton!
    
    var callBackOnSubmitClick : ((String,String) -> ())!
    var myWishlistGroupData = [MyWishlistGroupModel]()
    fileprivate var selWishListGroupInfo:MyWishlistGroupModel!
    fileprivate var selItemIndexPath:IndexPath = IndexPath(row:-1, section:-1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWishLIstTableView.tableFooterView = UIView()
        myWishLIstTableView.separatorStyle = .none
        btnAddToWishlist.applyAfritiaTheme()
        
        self.view.isUserInteractionEnabled = true
        
        self.myWishLIstTableView.delegate = self
        self.myWishLIstTableView.dataSource = self
        self.myWishLIstTableView.reloadData()
        
        self.updateButtonSubmitTouchAbility(isEnable:false)
        
//        myWishLIstTableView.separatorStyle = .none
//        let label = UILabel(frame:CGRect(x:0, y: 0, width:SCREEN_WIDTH-150, height: 200))
//        label.text = "Loading"
//        label.textColor = UIColor.black
//        myWishLIstTableView.backgroundView = label
//        label.center = myWishLIstTableView.backgroundView!.center
        
//        GlobalData.sharedInstance.showLoader()
//
//        self.getAllAvailableWishlistGroups { (myWishListGroups) in
//
//            self.myWishLIstTableView.backgroundView = nil
//            self.myWishLIstTableView.separatorStyle = .singleLine
//
//            self.myMultiWishlistData = [MyMultiWishlistModel]()
//
//            for i in 0..<myWishListGroups.count {
//                print(myWishListGroups[i].name)
//                self.myMultiWishlistData.append(myWishListGroups[i])
//            }
//
//            self.view.isUserInteractionEnabled = true
//
//            self.myWishLIstTableView.delegate = self
//            self.myWishLIstTableView.dataSource = self
//            self.myWishLIstTableView.reloadData()
//
//        }
    }
    
    func updateButtonSubmitTouchAbility(isEnable:Bool){
        
        if isEnable {
            btnAddToWishlist.isEnabled = true
            btnAddToWishlist.backgroundColor = UIColor.DarkLavendar
            btnAddToWishlist.setTitleColor(UIColor.white, for:.normal)
        }else{
            btnAddToWishlist.isEnabled = false
            btnAddToWishlist.backgroundColor = UIColor.DimLavendar
            btnAddToWishlist.setTitleColor(UIColor.appSuperLightGrey, for:.normal)
        }
    }
    
    func updateAddNewWishListTextFieldTouchAbility(isEnable:Bool){
        
        if isEnable {
            newWishLIstTextField.isEnabled = true
            newWishLIstTextField.backgroundColor = UIColor.white
            newWishLIstTextField.layer.cornerRadius = 6
            newWishLIstTextField.layer.borderColor = UIColor.DarkLavendar.cgColor
            newWishLIstTextField.layer.borderWidth = 1
            newWishLIstTextField.layer.masksToBounds = true
            newWishLIstTextField.tintColor = UIColor.black
            newWishLIstTextField.becomeFirstResponder()
        }else{
            newWishLIstTextField.isEnabled = false
            newWishLIstTextField.backgroundColor = UIColor.appSuperLightGrey
            newWishLIstTextField.layer.cornerRadius = 6
            newWishLIstTextField.layer.borderColor = UIColor.appSuperLightGrey.cgColor
            newWishLIstTextField.layer.borderWidth = 1
            newWishLIstTextField.layer.masksToBounds = true
            newWishLIstTextField.tintColor = UIColor.black
        }
    }
    
    @IBAction func btnSubmitClick(_ sender:UIButton){
        
        if selItemIndexPath.row == myWishlistGroupData.count {
            if newWishLIstTextField.isEmpty() {
                AlertManager.shared.showInfoSnackBar(msg:"To continue, please enter your new wishlist name")
            }else{
                self.callBackOnSubmitClick("new", newWishLIstTextField.text ?? "Enter new name")
                self.dismiss(animated:true, completion:nil)
            }
        }
        else
        {
            let selWishList = myWishlistGroupData[self.selItemIndexPath.row]
            self.callBackOnSubmitClick(selWishList.id, selWishList.name)
            self.dismiss(animated:true, completion:nil)
        }
    }
    
    @IBAction func btnCloseClick(_ sender:UIBarButtonItem){
        self.dismiss(animated:true, completion:nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WishListGroupPopUpVC : UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- UITableViewDataSource and UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return myWishlistGroupData.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.yellow
        
        self.updateButtonSubmitTouchAbility(isEnable:true)
        self.selItemIndexPath = indexPath
        self.myWishLIstTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //myWishLIstTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListPopUpCell") as! WishListPopUpViewCell
        
        var listInfo:MyWishlistGroupModel!
        if indexPath.row < myWishlistGroupData.count {
            listInfo = myWishlistGroupData[indexPath.row]
            cell.lblName.text = listInfo.name
        }
        else{
            cell.lblName.text = "Add New Wishlist"
        }
        
        cell.lblName.addTapGestureRecognizer {
            self.updateButtonSubmitTouchAbility(isEnable:true)
            self.selItemIndexPath = indexPath
            self.myWishLIstTableView.reloadData()
        }
        
        if indexPath == selItemIndexPath {
            cell.imgRadio.image = UIImage(named:"radio_on")
        }else{
            cell.imgRadio.image = UIImage(named:"radio_off")
        }
        
        if selItemIndexPath.row == myWishlistGroupData.count {
            self.updateAddNewWishListTextFieldTouchAbility(isEnable:true)
        }else{
            self.updateAddNewWishListTextFieldTouchAbility(isEnable:false)
        }
        
        cell.imgRadio.addTapGestureRecognizer {
            self.updateButtonSubmitTouchAbility(isEnable:true)
            self.selItemIndexPath = indexPath
            self.myWishLIstTableView.reloadData()
        }

        //cell.detailTextLabel?.text = "\(listInfo.items.count)"
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
