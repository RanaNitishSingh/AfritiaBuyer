//
//  MyProductReviews.swift
//  DummySwift
//
//  Created by Webkul on 22/11/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class MyProductReviews: AfritiaBaseViewController {

    @IBOutlet weak var productReviewsTableView: UITableView!
    @IBOutlet weak var emptylbl : UILabel!
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    var whichApiDataToprocess: String = ""
    var pageNumber:Int = 0
    var loadPageRequestFlag: Bool = false
    var indexPathValue:IndexPath!
    var reviewId:String!
    let defaults = UserDefaults.standard
    var myProductReviewViewModel:MyProductReviewViewModel!
    
    let globalObjectMyProductReviews = GlobalData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.title = appLanguage.localize(key: "myproductreview")
        
        self.setUpCustomNavigationBar()
        
        pageNumber = 1
        loadPageRequestFlag = true
        
        productReviewsTableView.separatorStyle = .none
        productReviewsTableView.rowHeight = 200
        productReviewsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        callingHttppApi()
        
        emptylbl.isHidden = true
        emptylbl.text = appLanguage.localize(key: "Noproductreviewsavailable")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
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
        
        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        var requstParams = [String:Any]();
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        requstParams["pageNumber"] = "1"
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.reviewList, currentView: self){success,responseObject in
            if success == 1{
                
                print((responseObject as! NSDictionary))
                self.myProductReviewViewModel = MyProductReviewViewModel(data: JSON(responseObject as! NSDictionary))
                self.doFurtherProcessingWithResult()
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            GlobalData.sharedInstance.dismissLoader()
            self.view.isUserInteractionEnabled = true
            self.productReviewsTableView.delegate = self
            self.productReviewsTableView.dataSource = self
            self.productReviewsTableView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.productReviewsTableView.numberOfRows(inSection: 0)
        for cell: UITableViewCell in self.productReviewsTableView.visibleCells {
            indexPathValue = self.productReviewsTableView.indexPath(for: cell)!
            if indexPathValue.row == self.productReviewsTableView.numberOfRows(inSection: 0) - 1 {
                if (myProductReviewViewModel.totalCout > currentCellCount) && loadPageRequestFlag{
                    whichApiDataToprocess = ""
                    pageNumber += 1
                    loadPageRequestFlag = false
                    callingHttppApi()
                }
            }
        }
    }
    
    @objc func viewDetails(_ recognizer: UITapGestureRecognizer) {
        reviewId = myProductReviewViewModel.getMyProductReviewData[(recognizer.view?.tag)!].id
        self.performSegue(withIdentifier: "reviewDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "reviewDetails") {
            let viewController:ReviewDetails = segue.destination as UIViewController as! ReviewDetails
            viewController.reviewId = reviewId
        }
    }
}

extension MyProductReviews : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myProductReviewViewModel.getMyProductReviewData.count > 0    {
            emptylbl.isHidden = true
            return myProductReviewViewModel.getMyProductReviewData.count
        }else{
            emptylbl.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyproductreviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reviewcell") as! MyproductreviewTableViewCell
        cell.imageData.image = UIImage(named: "ic_placeholder.png")
        cell.productName.text = myProductReviewViewModel.getMyProductReviewData[indexPath.row].productName
        cell.productName.font = UIFont.systemFont(ofSize:15, weight:.semibold)
        cell.date.text = myProductReviewViewModel.getMyProductReviewData[indexPath.row].date
        cell.detailsLabel.text = myProductReviewViewModel.getMyProductReviewData[indexPath.row].details
        cell.viewButton.tag = indexPath.row
        
        let viewByTap = UITapGestureRecognizer(target: self, action: #selector(self.viewDetails))
        viewByTap.numberOfTapsRequired = 1
        cell.viewButton.addGestureRecognizer(viewByTap)
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: myProductReviewViewModel.getMyProductReviewData[indexPath.row].imageUrl, imageView: cell.imageData!)
        
        if myProductReviewViewModel.getMyProductReviewData[indexPath.row].ratingData.count > 0{
            let dict = JSON(myProductReviewViewModel.getMyProductReviewData[indexPath.row].ratingData[0])
            cell.ratingView.value = CGFloat(dict["ratingValue"].floatValue / 20)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH/3 + 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productId = myProductReviewViewModel.getMyProductReviewData[indexPath.row].productId
        vc.productName = myProductReviewViewModel.getMyProductReviewData[indexPath.row].productName
        vc.productImageUrl = myProductReviewViewModel.getMyProductReviewData[indexPath.row].imageUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
