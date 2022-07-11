//
//  AfritiaBaseViewController.swift
//  Afritia
//
//  Created by Ranjit Mahto on 23/12/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit

class AfritiaBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // Custom Navigation Action
    
    @objc func showSearchStoreBySearchBar() {
        //self.searchViewOpenBy = SearchViewOpenBy.searchBar
        //self.performSegue(withIdentifier: "search", sender: self)
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SearchSuggestion") as! SearchSuggestion
        vc.searchFrom = SearchViewOpenBy.searchBar
        self.navigationController?.pushViewController(vc, animated:false)
        
    }
    
    @objc func showSearchStoreByCamera() {
        if AppFunction.isRealDevice(){
            view.endEditing(true)
            self.tabBarController?.tabBar.isHidden = true
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SearchSuggestion") as! SearchSuggestion
            vc.searchFrom = SearchViewOpenBy.CameraIcon
            self.navigationController?.pushViewController(vc, animated:false)
            
            //self.searchViewOpenBy = SearchViewOpenBy.CameraIcon
            //self.performSegue(withIdentifier: "search", sender: self)
        }
        else{
            AlertManager.shared.showInfoSnackBar(msg:"Device not found.")
        }
    }
    
    @objc func showSearchStoreByMicrophone() {
        
        if AppFunction.isRealDevice(){
            view.endEditing(true)
            self.tabBarController?.tabBar.isHidden = true
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SearchSuggestion") as! SearchSuggestion
            vc.searchFrom = SearchViewOpenBy.MicIcon
            self.navigationController?.pushViewController(vc, animated: false)
            
            //self.searchViewOpenBy = SearchViewOpenBy.MicIcon
            //self.performSegue(withIdentifier: "search", sender: self)
        }
        else{
            AlertManager.shared.showInfoSnackBar(msg:"Device not found.")
        }
    }
    
    /*
    @objc func showNotifications(){
        self.performSegue(withIdentifier: "notification", sender: self)
    }*/
    
    @objc func showMyCart(){
        view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = true
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MyCart") as! MyCart
        self.navigationController?.pushViewController(vc, animated: true)
        //self.performSegue(withIdentifier: "notification", sender: self)
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
