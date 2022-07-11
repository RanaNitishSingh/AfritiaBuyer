//
//  SearchSuggestion.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 08/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

struct SearchViewOpenBy{
    static let searchBar = "Open By Search Bar"
    static let CameraIcon = "Open By Camera Icon"
    static let MicIcon = "Open By Mic Icon"
}

class SearchSuggestion: UIViewController , SuggestionDataHandlerDelegate {
    
    //Custom Navigation Bar
    
    @IBOutlet weak var searchMainBgView:UIView!
    @IBOutlet weak var navigationBarBgView: UIView!
    @IBOutlet weak var navBarTitleBgView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBarBgView: UIView!
    
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnMicroPhone: UIButton!
   
    @IBOutlet weak var lblTitle : UILabel!
    
    @IBOutlet weak var leftBtn1 : UIButton!
    @IBOutlet weak var leftBtn2 : UIButton!
    
    @IBOutlet weak var rightBtn1 : UIButton!
    @IBOutlet weak var rightBtn2 : UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var searchBar: UISearchBar!
    //@IBOutlet weak var btnBack: UIButton!
    //@IBOutlet weak var btnBackWidth: NSLayoutConstraint!
    //@IBOutlet weak var searchBarBgView: UIView!
    
    var searchActive:Bool = false
    var searchtext:String = ""
    let defaults = UserDefaults.standard
    var searchSuggestionViewModel:SearchSuggestionViewModel!
    var resultArray:Array = [AnyObject]()
    var categoryType = "searchquery"
    var categoryName = "searchresult".localized
    var categoryId = ""
    var searchQuery = ""
    var productImageUrl:String = ""
    var productId:String = ""
    var productName:String = ""
    var signalForViewController = Int()
    var searchFrom:String = ""
    
    let IS_IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    var emptyView:EmptyPlaceHolderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.LightLavendar
        self.setUpCustomNavigationUI()
        
        /*
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.title = "Search Store"
        self.navigationController!.navigationBar.removeHairLine()
         */

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(SearchSuggestionCell.nib, forCellReuseIdentifier: SearchSuggestionCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        
        tableView.separatorColor = UIColor.LightLavendar

    }
    
    func setUpCustomNavigationUI(){
        self.navigationController?.isNavigationBarHidden = true
        self.configureTitleView(isVisible:true, titleType:.image, title:nil, image:navIcon.appLogo)
        
        self.navigationBarBgView.backgroundColor = UIColor.clear
        self.navBarTitleBgView.backgroundColor = UIColor.clear
        self.searchBar.changeSearchBarColor(color:UIColor.white)
        self.searchBarBgView.applyRoundCornerBorder(radius:6, width: 0.5, color:UIColor.DarkLavendar)
        
        searchBar.placeholder = "searchentirestore".localized
        searchBar.delegate = self
        searchBar.isLoading = false
    }
    
    func setUpNavigationBarButtonVisibiliy(){
        
        self.leftBtn1.isHidden = false
        self.leftBtn2.isHidden = true
        self.rightBtn1.isHidden = true
        self.rightBtn2.isHidden = true
        
        self.leftBtn1.addTargetClosure { (btn) in
            self.navigationController?.popViewController(animated: false)
        }
        
        if searchFrom == SearchViewOpenBy.searchBar{
            self.leftBtn1.isHidden = false
            searchBar.becomeFirstResponder()
        }
        else if searchFrom == SearchViewOpenBy.CameraIcon{
            
            self.leftBtn1.isHidden = false
            let imgDetectVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ImageDetectorController") as! ImageDetectorController
            imgDetectVC.delegate = self
            self.present(imgDetectVC, animated:true, completion:nil)
            //self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if searchFrom == SearchViewOpenBy.MicIcon{
            //show back btn
            //self.btnBackWidth.constant = 30
            self.leftBtn1.isHidden = false
            //self.performSegue(withIdentifier: "testdetector", sender: self)
            //self.showTextAndImageDetectionActionSheet()
            
            let textDetectVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TextDetectorController") as! TextDetectorController
            textDetectVC.delegate = self
            self.present(textDetectVC, animated:true, completion:nil)
            //self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            //hide back btn
            //self.btnBackWidth.constant = 0
            self.leftBtn1.isHidden = true
            searchBar.becomeFirstResponder()
        }
    }
    
    func configureTitleView(isVisible:Bool,titleType:NavBarTitleType, title:String?,image:UIImage?){
        
        if isVisible {
            
            if titleType == .text {
                self.lblTitle.isHidden = false
                if let titleText = title {
                    self.lblTitle.text = titleText
                }else{
                    self.lblTitle.text = ""
                }
            }
            else if titleType == .image {
                self.lblTitle.isHidden = true
                if let titleImage = image {
                    let titleLogoImgView = UIImageView(frame:navTitleImageFrame)
                    titleLogoImgView.image = titleImage //UIImage(named: "afritia_logo")!
                    self.navBarTitleBgView.addSubview(titleLogoImgView)
                    //titleLogoImgView.frame = CGRect(x: 0, y: 4, width: 124, height: 36)
                    titleLogoImgView.frame.origin = navTitlePosition
                }else{
                    
                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        self.setUpNavigationBarButtonVisibiliy()

    }
        
    func DisplayEmptyDataView(isVisible:Bool){
        
        if isVisible {
            emptyView = EmptyPlaceHolderView(frame: self.view.frame)
            emptyView.emptyImages.image = UIImage(named: "empty_search")!
            emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "tryagain"), for: .normal)
            emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptysearch")
            emptyView.callBackBtnAction = {(action) in
                self.searchBar.text = ""
                self.searchBar.isLoading = false
            }
            
            tableView.backgroundView = emptyView
            tableView.separatorStyle = .none
            
        }else{
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
    
    /*
    @objc func browseCategory(sender: UIButton){
        self.searchBar.text = ""
        searchBar.isLoading = false
    }*/
    
    /*
    func showTextAndImageDetectionActionSheet(){
        
        view.endEditing(true)
        
        AlertManager.Show(onController: self, btnTitles:["textDetection".localized, "imagedetection".localized, "cancel".localized], alertTitle: "chooseaction".localized, alertMessage:nil, alertStyle: .actionSheet) { (btnIndex, btnTitle) in
            
            if btnIndex == 0 {
                self.performSegue(withIdentifier: "testdetector", sender: self)
            }
            else if btnIndex == 1 {
                self.performSegue(withIdentifier: "imagesegue", sender: self)
            }
            
        }
    }*/
    
    @IBAction func btnBackClick(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.selectedIndex = 0
    }
    
    
    @IBAction func btnCameraClick(_ sender:Any) {
        
        if AppFunction.isRealDevice(){
            view.endEditing(true)
            let imgDetectvc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ImageDetectorController") as! ImageDetectorController
            imgDetectvc.delegate = self
            self.present(imgDetectvc, animated:true, completion:nil)
        }
        else{
            AlertManager.shared.showInfoSnackBar(msg:"Device not found.")
        }
        
        
    }
    
    @IBAction func btnMicrophoneClick(_ sender:Any) {
        
        if AppFunction.isRealDevice(){
            view.endEditing(true)
            let textDetectVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TextDetectorController") as! TextDetectorController
            textDetectVC.delegate = self
            self.present(textDetectVC, animated:true, completion:nil)
        }
        else{
            AlertManager.shared.showInfoSnackBar(msg:"Device not found.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func callingHttppApi(){
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["searchQuery"] = searchtext
        requstParams["currency"] = UserManager.getCurrencyType

        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.searchSuggesion, currentView: self){success,responseObject in
            
            if success == 1 {
                print("sfsfs", responseObject!)
                self.searchSuggestionViewModel = SearchSuggestionViewModel(data:JSON(responseObject as! NSDictionary))
                self.doFurtherProcessingWithResult()
                GlobalData.sharedInstance.dismissLoader()
            } else if success == 2 {
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        
        if searchSuggestionViewModel.getSuggestedHints.count == 0 && searchSuggestionViewModel.getSuggestedproduct.count == 0{
            //self.tableView.isHidden = true
            //self.emptyView.isHidden = false
            
            self.DisplayEmptyDataView(isVisible:true)
            /*
            tableView.setEmptyView(emtyImage: UIImage(named: "empty_search")!,
                                   title: "No Data Found",
                                   message:"emptysearch".localized,
                                   btnTitle: "tryagain".localized) { (title) in
                self.searchBar.text = ""
                self.searchBar.isLoading = false
                self.searchBar.becomeFirstResponder()
            }*/
            
            searchBar.isLoading = false
        }else{
            resultArray = [searchSuggestionViewModel.getSuggestedHints as AnyObject,
                           searchSuggestionViewModel.getSuggestedproduct as AnyObject]
            
            if resultArray[0].count > 0 || resultArray[1].count > 0 {
                self.DisplayEmptyDataView(isVisible:false)
                
                searchBar.isLoading = false
                tableView.delegate = self
                tableView.dataSource = self
                tableView.reloadData()
                
                //tableView.restore()
                //self.emptyView.isHidden = true
                //self.tableView.isHidden = false
                
            }
        }
    }
    
    func suggestedData(data: String, signalToMove: Int) {
        signalForViewController = signalToMove
        searchBar.text = data
        searchtext = data
        searchBar.isLoading = true
        APIServiceManager.shared.removePreviousNetworkCall()
        self.view.endEditing(true)
        callingHttppApi()
    }

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "productcategory") {
            
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.categoryName
            viewController.categoryId = self.categoryId
            viewController.categoryType = self.categoryType
            viewController.searchQuery = self.searchQuery
        }else if (segue.identifier! == "testdetector") {
            let viewController:TextDetectorController = segue.destination as UIViewController as! TextDetectorController
            viewController.delegate = self
        }else if (segue.identifier! == "imagesegue") {
            let viewController:ImageDetectorController = segue.destination as UIViewController as! ImageDetectorController
            viewController.delegate = self
        }
    }*/
}

extension SearchSuggestion : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2{
            searchBar.isLoading = true
            searchtext = searchText
            APIServiceManager.shared.removePreviousNetworkCall()
            callingHttppApi()
            searchBar.resignFirstResponder()
            
        }else{
            searchBar.isLoading = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
        vc.categoryName = self.categoryName
        vc.categoryId = self.categoryId
        vc.categoryType = self.categoryType
        vc.searchQuery = searchBar.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        navigationController?.popViewController(animated: true)
    }
    
    /*
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
        self.showTextAndImageDetectionActionSheet()
        
    }*/
}

extension SearchSuggestion : UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return resultArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier:"cell")
            cell.textLabel?.font = UIFont(name: REGULARFONT, size: 13.0)
            cell.detailTextLabel?.font = UIFont(name: BOLDFONT, size: 13.0)
            
            let suggestedHints:[SearchsuggestionHints] = resultArray[indexPath.section] as! [SearchsuggestionHints]
            cell.textLabel?.text = suggestedHints[indexPath.row].label
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchSuggestionCell.identifier, for: indexPath) as! SearchSuggestionCell
            
            let suggestedProducts:[SearchSuggestionModel] = resultArray[indexPath.section] as! [SearchSuggestionModel]
            
            cell.productImg.image = UIImage(named: "ic_placeholder.png")
            cell.productName.text = suggestedProducts[indexPath.row].productName
            
            //special price case
            if suggestedProducts[indexPath.row].hasSpecialPrice {
                let attributeString = NSMutableAttributedString(string: "\(suggestedProducts[indexPath.row].specialPrice) \(suggestedProducts[indexPath.row].price)")
                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: (suggestedProducts[indexPath.row].specialPrice).count+1, length: suggestedProducts[indexPath.row].price.count))
                cell.productPrice.attributedText = attributeString
            }else{
                cell.productPrice.text = suggestedProducts[indexPath.row].price
            }
            
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:suggestedProducts[indexPath.row].productImage , imageView: cell.productImg)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1  && resultArray[section].count > 0 {
            return GlobalData.sharedInstance.language(key: "popularproducts")
        }else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 60
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            let suggestedHints:[SearchsuggestionHints] = resultArray[indexPath.section] as! [SearchsuggestionHints]
            print(suggestedHints[indexPath.row].label)
            //self.searchQuery = suggestedHints[indexPath.row].label
            //self.performSegue(withIdentifier: "productcategory", sender: self)
            
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
            vc.categoryName = self.categoryName
            vc.categoryId = self.categoryId
            vc.categoryType = self.categoryType
            vc.searchQuery = suggestedHints[indexPath.row].label
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if indexPath.section == 1{
            let suggestedProducts:[SearchSuggestionModel] = resultArray[indexPath.section] as! [SearchSuggestionModel]
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
            vc.productName = suggestedProducts[indexPath.row].productName
            vc.productId = suggestedProducts[indexPath.row].id
            vc.productImageUrl = suggestedProducts[indexPath.row].productImage
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}



extension UISearchBar {
    
    private var textField: UITextField? {
        return subviews.first?.subviews.compactMap { $0 as? UITextField }.first
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.color = UIColor.button
                    newActivityIndicator.backgroundColor = UIColor.white
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
