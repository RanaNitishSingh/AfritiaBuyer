//
//  SocialCenterViewController.swift
//  Afritia
//
//  Created by Ranjit Mahto on 27/10/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit



class SocialCenterViewController: AfritiaBaseViewController {

    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    var viewBy:navBarViewMode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController!.navigationBar.applyAfritiaTheme()
        
        //self.title = "Afritia Social Center"
        // Do any additional setup after loading the view.
        
        self.setUpCustomNavigationBar()
    }
    
    fileprivate func setUpCustomNavigationBar(){
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController!.tabBar.applyAfritiaTheme()
        
        self.changeStatusBarColor(color: UIColor.LightLavendar)
        
        var barViewStyle:NavBarStyle!
        
        if viewBy == navBarViewMode.profile {
            barViewStyle = .compact
            
            afritiaNavBarView.configureLeftButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.back){ (btn) in
                self.navigationController?.popViewController(animated:true)
            }
            
        }else{
            barViewStyle = .full
            afritiaNavBarView.configureLeftButton1(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        }

        afritiaNavBarView.configureLeftButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        
        afritiaNavBarView.configureRightButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.cart) { (btnTitle) in
            self.showMyCart()
        }
        afritiaNavBarView.configureRightButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)

        
        
        afritiaNavBarView.configure(isVisible:true, titleText:nil, titleType:.image, barStyle:barViewStyle) { (searchBy) in
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
