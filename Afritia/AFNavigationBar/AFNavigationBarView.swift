//
//  AFNavigationBarView.swift
//  Afritia
//
//  Created by Ranjit Mahto on 22/12/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit

typealias barBtnActionHandler = (_ btnTitle:String) -> Void
typealias barStyleHandler = (_ barStyle:NavBarStyle) -> Void
typealias openByHandler = (_ searchOpenBy:SearchOpenBy) -> Void

let navTitleImageFrame = CGRect(x:0, y:0, width:124, height:36)
let navTitlePosition = CGPoint(x:0, y:4)

enum NavBarTitleType:String {
    case text
    case image
}

enum NavBtnType:String {
    case text
    case image
    case none
}

enum SearchOpenBy:String {
    case bar
    case camera
    case mic
    case searchBtn
}

enum NavBarStyle:String {
    case compact
    case full
}

enum NavBarHeight:CGFloat {
    case compact = 44
    case full = 94
}

enum navBarViewMode{
    case tabBar
    case profile
}

struct navIcon {
    static let back = UIImage(named:"nav_icon_back.png")
    static let notification = UIImage(named:"nav_icon_bell.png")
    static let add =  UIImage(named:"nav_icon_add.png")
    static let close =  UIImage(named:"nav_icon_close.png")
    static let done =  UIImage(named:"nav_icon_done.png")
    static let down =  UIImage(named:"nav_icon_down.png")
    static let edit =  UIImage(named:"nav_icon_edit.png")
    static let ellipsis =  UIImage(named:"nav_icon_ellipsis.png")
    static let grid =  UIImage(named:"nav_icon_grid.png")
    static let next =  UIImage(named:"nav_icon_next.png")
    static let search =  UIImage(named:"nav_icon_search.png")
    static let send =  UIImage(named:"nav_icon_send.png")
    static let setting =  UIImage(named:"nav_icon_setting.png")
    static let up =  UIImage(named:"nav_icon_up.png")
    static let chat =  UIImage(named:"nav_icons_chat.png")
    static let cart = UIImage(named:"Action 4.pdf")
    static let filter = UIImage(named:"ic_filter.pdf")
    
    static let appLogo = UIImage(named:"afritia_logo.png")
    
}


class AFNavigationBarView: UIView {
    
    private static let NIB_NAME = "AFNavigationBarView"
    
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var navigationBarBgView: UIView!
    @IBOutlet weak var navBarTitleBgView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchBarBgView: UIView!
    @IBOutlet weak var searchBarViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnMicroPhone: UIButton!
    @IBOutlet weak var btnSearchBar: UIButton!

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblBadgesCount : UILabel!
    @IBOutlet weak var lblBadgesCountWidth : NSLayoutConstraint!
    @IBOutlet weak var lblBadgesCountHeight : NSLayoutConstraint!
    
    
    @IBOutlet weak var leftBtn1 : UIButton!
    @IBOutlet weak var leftBtn2 : UIButton!
    @IBOutlet weak var rightBtn1 : UIButton!
    @IBOutlet weak var rightBtn2 : UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var leftBtn1Width : NSLayoutConstraint!
    @IBOutlet weak var leftBtn2Width : NSLayoutConstraint!
    @IBOutlet weak var rightBtn1Width : NSLayoutConstraint!
    @IBOutlet weak var rightBtn2Width : NSLayoutConstraint!
    @IBOutlet weak var btnSearchWidth: NSLayoutConstraint!
    
    var navBarHeight: NSLayoutConstraint!
    var searchbarStyle : NavBarStyle!
    
    
    /*
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isLeftButton1Hidden: Bool {
        set {
            leftBtn1.isHidden = newValue
        }
        get {
            return leftBtn1.isHidden
        }
    }
    
    var isLeftButton2Hidden: Bool {
        set {
            leftBtn2.isHidden = newValue
        }
        get {
            return leftBtn2.isHidden
        }
    }
    
    var isRightButton1Hidden: Bool {
        set {
            rightBtn1.isHidden = newValue
        }
        get {
            return rightBtn1.isHidden
        }
    }
    
    
    var isRightButton2Hidden: Bool {
        set {
            rightBtn2.isHidden = newValue
        }
        get {
            return rightBtn2.isHidden
        }
    }*/
    //afritiaNavBarView.configureTitleView(isVisible:true, titleType:.image, title:nil, image:navIcon.appLogo)
    /*
    func configureTitleView(isVisible:Bool,titleType:NavBarTitleType, title:String?, image:UIImage?){
        
        if isVisible {
            
            if titleType == .text {
                self.lblTitle.isHidden = false
                self.lblTitle.text = title ?? ""
                
            }
            else if titleType == .image {
                self.lblTitle.isHidden = true
                let titleLogoImgView = UIImageView(frame:CGRect(x:0, y:0, width:130, height:40))
                titleLogoImgView.image = UIImage(named: "afritia_logo")!
                self.navBarTitleBgView.addSubview(titleLogoImgView)
                
            }
        }
    }*/
    
    func configureLeftButton1(isVisible:Bool, btnType:NavBtnType,btnTitle:String?, btnImage:UIImage?, actionHandler:barBtnActionHandler?){
        
        if isVisible {
            leftBtn1.isHidden = false
            leftBtn1Width.constant = 40
            
        }else{
            leftBtn1Width.constant = 0
            leftBtn1.isHidden = true
        }
        
        if btnType == .text {
            if let title = btnTitle {
                leftBtn1.setTitle(title, for: .normal)
            }
            else{
                leftBtn1.setTitle("", for: .normal)
            }
        }
        
        if btnType == .image{
            if let image = btnImage {
                leftBtn1.setImage(image, for: .normal)
                leftBtn1.setTitle("", for: .normal)
            }else{
                leftBtn1.setImage(nil, for:.normal)
            }
        }

        if let handler = actionHandler {
            leftBtn1.addTargetClosure { (btn) in
                handler(btn.titleLabel?.text ?? "")
            }
        }
        
    }
    
    func configureLeftButton2(isVisible:Bool,btnType:NavBtnType, btnTitle:String?, btnImage:UIImage?, actionHandler:barBtnActionHandler?){
        
        if isVisible {
            leftBtn2.isHidden = false
            leftBtn2Width.constant = 40
            
        }else{
            leftBtn2.isHidden = true
            leftBtn2Width.constant = 0
        }
        
        if btnType == .text {
            if let title = btnTitle {
                leftBtn2.setTitle(title, for: .normal)
            }
            else{
                leftBtn2.setTitle("", for: .normal)
            }
        }
        
        if btnType == .image{
            if let image = btnImage {
                leftBtn2.setImage(image, for: .normal)
                leftBtn2.setTitle("", for: .normal)
            }else{
                leftBtn2.setImage(nil, for:.normal)
            }
        }

        if let handler = actionHandler {
            leftBtn2.addTargetClosure { (btn) in
                handler(btn.titleLabel?.text ?? "")
            }
        }
        
    }
    
    func configureRightButton1(isVisible:Bool,btnType:NavBtnType, btnTitle:String?, btnImage:UIImage?, actionHandler: barBtnActionHandler?){
        
        if isVisible {
            rightBtn1.isHidden = false
            rightBtn1Width.constant = 40
            
        }else{
            rightBtn1.isHidden = true
            rightBtn1Width.constant = 0
        }
        
        if btnType == .text {
            if let title = btnTitle {
                rightBtn1.setTitle(title, for: .normal)
            }
            else{
                rightBtn1.setTitle("", for: .normal)
            }
        }
        
        if btnType == .image{
            if let image = btnImage {
                rightBtn1.setImage(image, for: .normal)
                rightBtn1.setTitle("", for: .normal)
            }else{
                rightBtn1.setImage(nil, for:.normal)
            }
        }

        if let handler = actionHandler {
            rightBtn1.addTargetClosure { (btn) in
                handler("RignrBarButton1")
            }
            
            if GlobalData.sharedInstance.cartItemsCount > 0{
                lblBadgesCount.addTapGestureRecognizer {
                    handler("RignrBarButton1")
                }
            }
        }
    
        self.UpdateBadgesCount(itemCount: GlobalData.sharedInstance.cartItemsCount)
    }
    
    func UpdateBadgesCount(itemCount:Int){
        
        if itemCount > 0 {
            
            self.lblBadgesCountWidth.constant = 16
            self.lblBadgesCountHeight.constant = 16
            self.lblBadgesCount.isHidden = false
            
            if itemCount > 0 && itemCount < 10 {
                self.lblBadgesCountWidth.constant = 16
            }else if itemCount > 9 && itemCount < 100{
                self.lblBadgesCountWidth.constant = 22
            }else{
                self.lblBadgesCountWidth.constant = 30
            }
            
            self.lblBadgesCount.layer.cornerRadius = 8
            self.lblBadgesCount.layer.masksToBounds = true
            
            if itemCount > 99 {
                self.lblBadgesCount.text = "99+"
            }else{
                self.lblBadgesCount.text = "\(itemCount)"
            }
            
        }else{
            self.lblBadgesCount.text = ""
            self.lblBadgesCountWidth.constant = 0
            self.lblBadgesCountHeight.constant = 0
            self.lblBadgesCount.isHidden = true
        }
    }
    
    func configureRightButton2(isVisible:Bool, btnType:NavBtnType, btnTitle:String?, btnImage:UIImage?, actionHandler:barBtnActionHandler?){
        
        if isVisible {
            rightBtn2.isHidden = false
            rightBtn2Width.constant = 40
            if btnType == .text {
                if let title = btnTitle {
                    rightBtn2.setTitle(title, for: .normal)
                }
                else{
                    rightBtn2.setTitle("", for: .normal)
                }
            }
            
            if btnType == .image{
                if let image = btnImage {
                    rightBtn2.setImage(image, for: .normal)
                    rightBtn2.setTitle("", for: .normal)
                }else{
                    rightBtn2.setImage(nil, for:.normal)
                }
            }

            if let handler = actionHandler {
                rightBtn2.addTargetClosure { (btn) in
                    handler(btn.titleLabel?.text ?? "")
                }
            }
            
        }else{
            rightBtn2.isHidden = true
            rightBtn2Width.constant = 0
        }
    }
    
    func configure (isVisible:Bool, titleText:String?, titleType:NavBarTitleType, barStyle:NavBarStyle, openByHandler:openByHandler?, styleHandler:barStyleHandler?){
        
        if isVisible {
            
            self.navBarTitleBgView.backgroundColor = UIColor.clear
            
            if titleType == .text {
                self.lblTitle.isHidden = false
                if let myTitle = titleText {
                    self.lblTitle.text = myTitle
                }else{
                    self.lblTitle.text = "No Title"
                }
            }
            else if titleType == .image {
                
                self.lblTitle.isHidden = true
                let titleLogoImgView = UIImageView(frame:navTitleImageFrame)
                titleLogoImgView.image = UIImage(named: "afritia_logo")!
                
                self.navBarTitleBgView.addSubview(titleLogoImgView)
                //titleLogoImgView.frame = CGRect(x: 0, y: 4, width: 124, height: 36)
                titleLogoImgView.frame.origin = navTitlePosition
            }
            
            btnCamera.addTargetClosure { (btn) in
                openByHandler!(SearchOpenBy.camera)
            }
            
            btnMicroPhone.addTargetClosure { (btn) in
                openByHandler!(SearchOpenBy.mic)
            }
            
            btnSearchBar.addTapGestureRecognizer {
                openByHandler!(SearchOpenBy.bar)
            }
            
            if barStyle == .full {
                styleHandler!(.full)
                btnSearch.isHidden = true
                btnSearchWidth.constant = 0
                searchBarViewHeight.constant = 50
            }
            
            if barStyle == .compact {
                styleHandler!(.compact)
                btnSearch.isHidden = false
                btnSearchWidth.constant = 40
                searchBarViewHeight.constant = 00
            }
            
            btnSearch.addTargetClosure { (btn) in
                openByHandler!(SearchOpenBy.searchBtn)
            }
            
            /*
            // manage style
            if barStyle == .full {
                styleHandler!(.full)
                btnSearch.isHidden = true
                searchBarViewHeight.constant = 50
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                
                //setNeedsLayout()
                
            }else if barStyle == .compact {
                styleHandler!(.compact)
                btnSearch.isHidden = false
                searchBarViewHeight.constant = 00
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                //setNeedsLayout()
            }
            
            btnSearch.addTargetClosure { (btn) in
                actionHandler!("showfullsearchbar")
                self.btnSearch.isHidden = true
                self.searchBarViewHeight.constant = 50
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                //self.setNeedsLayout()
            }*/
            
        }
        else{
            
            self.leftBtn1.isHidden = true
            self.leftBtn2.isHidden = true
            self.leftBtn1Width.constant = 0
            self.leftBtn2Width.constant = 0
            self.rightBtn1.isHidden = true
            self.rightBtn2.isHidden = true
            self.btnSearch.isHidden = true
            self.lblTitle.isHidden = false
            self.lblTitle.text = "not configure"
            self.navBarTitleBgView.backgroundColor = UIColor.DimLavendar
            self.lblTitle.backgroundColor = UIColor.yellow
            self.lblTitle.textAlignment = .center
        }
    }
    
    /*
    func configureSearchBar(isVisible:Bool, actionHandler:barBtnActionHandler?){
    
        if isVisible {
            
            btnCamera.addTargetClosure { (btn) in
                actionHandler!(SearchViewOpenBy.CameraIcon)
            }
            
            btnMicroPhone.addTargetClosure { (btn) in
                actionHandler!(SearchViewOpenBy.MicIcon)
            }
            
            btnSearchBar.addTapGestureRecognizer {
                actionHandler!(SearchViewOpenBy.searchBar)
            }
        }
    }*/
    
    /*
    func configureSearchBarStyle(barStyle:NavBarStyle,styleHandler:barStyleHandler?, actionHandler:barBtnActionHandler?){
    
        if barStyle == .full {
            styleHandler!(.full)
            btnSearch.isHidden = true
            searchBarViewHeight.constant = 50
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            //setNeedsLayout()
            
        }else if barStyle == .compact {
            styleHandler!(.compact)
            btnSearch.isHidden = false
            searchBarViewHeight.constant = 00
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            //setNeedsLayout()
        }
        
        btnSearch.addTargetClosure { (btn) in
            actionHandler!("showfullsearchbar")
            self.btnSearch.isHidden = true
            self.searchBarViewHeight.constant = 50
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            //self.setNeedsLayout()
        }
    }*/
    
    
    /*
    var leftButton1_Image:UIImage {
        set {
            leftBtn1.image = newValue
        }
        get {
            return leftBtn1.image!
        }
    }
    
    var leftButton2_Image:UIImage {
        set {
            leftBtn2.image = newValue
        }
        get {
            return leftBtn1.image!
        }
    }
    
    var rightButton1_Image:UIImage {
        set {
            rightBtn1.image = newValue
        }
        get {
            return rightBtn1.image!
        }
    }
    
    var rightButton2_Image:UIImage {
        set {
            rightBtn2.image = newValue
        }
        get {
            return rightBtn1.image!
        }
    }*/
    
    /*
    var isRightFirstButtonEnabled: Bool {
        set {
            rightBtn1.isEnabled = newValue
        }
        get {
            return rightFirstButton.isEnabled
        }
    }*/
    
    override func awakeFromNib() {
        initWithNib()
        //self.setNavigationItems()
        
        //self.navigationBar.items?[0].setImageTitleView(titleImage: UIImage(named: "afritia_logo")!)
        navigationBarBgView.backgroundColor = UIColor.clear
        navBarTitleBgView.backgroundColor = UIColor.clear
        
        //let logoTitleView = self.getImageTitleView(titleImage:UIImage(named: "afritia_logo")!)
        //self.navBarTitleBgView.addSubview(logoTitleView)
        //logoTitleView.center = navBarTitleBgView.center
        
        
        
        self.searchBar.changeSearchBarColor(color:UIColor.white)
        self.searchBarBgView.applyRoundCornerBorder(radius:6, width: 0.5, color:UIColor.DarkLavendar)
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(AFNavigationBarView.NIB_NAME, owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
    
    /*
    func setNavigationItems(){
        
        let leftBtn = UIBarButtonItem(image:UIImage(named: "ic_notification"), style: .plain, target: self, action:#selector(self.doBarBtnAction))
        
        let rightBtn = UIBarButtonItem(image:UIImage(named: "ic_notification"), style: .plain, target: self, action:#selector(self.doBarBtnAction))
        
        let leftBtnItem = UINavigationItem()
        leftBtnItem.leftBarButtonItem = leftBtn
        
        let rightBtnItem = UINavigationItem()
        leftBtnItem.rightBarButtonItem = rightBtn
        
        let ImagetitleView = UINavigationItem()
        ImagetitleView.setImageTitleView(titleImage: UIImage(named: "afritia_logo")!)
        
        //self.navigationBar.items = [leftBtnItem, ImagetitleView, rightBtnItem]
    
    }*/
    
    func getImageTitleView(titleImage:UIImage) {
        
        //let navTitleView = UIView(frame: CGRect(x: 0, y: 0, width:SCREEN_WIDTH - 45, height: titleLogoImgView.frame.height))
        //navTitleView.backgroundColor = UIColor.red
        //navTitleView.addSubview(titleLogoImgView)
        
        //return navTitleView
        
    }
    
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

/*
extension AFNavigationBarView : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = true
        self.searchViewOpenBy = SearchViewOpenBy.searchBar
        self.performSegue(withIdentifier: "search", sender: self)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = true
        self.searchViewOpenBy = "home_controller_searchbar_camera_icon"
        self.performSegue(withIdentifier: "search", sender: self)
    }
}
*/
