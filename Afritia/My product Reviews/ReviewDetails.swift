//
//  ReviewDetails.swift
//  DummySwift
//
//  Created by Webkul on 28/12/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewDetails: AfritiaBaseViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var reviewData: UILabel!
    @IBOutlet weak var reviewDetails: UILabel!
    @IBOutlet weak var dynamicView: UIView!
    @IBOutlet weak var dynamicViewHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    let globalObjectReviewsdetails = GlobalData()
    var reviewDetailsModel:ReviewDetailsModel!
    public var reviewId:String = ""
    var reviewDetailsJson:JSON!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //self.navigationItem.title = "reviewdetails".localized
        //self.navigationController?.isNavigationBarHidden = false
        
        self.setUpCustomNavigationBar()
        
        imageViewHeightConstraints.constant = SCREEN_WIDTH
        scrollView.delegate = self
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated:true)
        //self.automaticallyAdjustsScrollViewInsets = false
        //mainViewHeightConstarints.constant = 200
        
        callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let imageHeight = imageView.frame.height
        let newOrigin = CGPoint(x: 0, y: 0)
        scrollView.contentOffset = newOrigin
        scrollView.contentInset = UIEdgeInsets(top: imageHeight, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageHeight = imageView.frame.height
        let newOrigin = CGPoint(x: 0, y: 0)
        scrollView.contentOffset = newOrigin
        scrollView.contentInset = UIEdgeInsets(top: imageHeight, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /*
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0{
            imageView.frame.size.height = -offsetY
        }
        else{
            imageView.frame.size.height = imageView.frame.height
        }*/
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
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["reviewId"] = reviewId
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname: AfritiaAPI.reviewDetails, currentView: self){success,responseObject in
            if success == 1{
                
                self.reviewDetailsModel = ReviewDetailsModel(data:JSON(responseObject as! NSDictionary))
                print(responseObject!)
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        GlobalData.sharedInstance.dismissLoader()
        //GlobalData.sharedInstance.getImageFromUrl(imageUrl: reviewDetailsModel.imageUrl, imageView: imageView)
        imageView.getImageFromUrl(imageUrl:reviewDetailsModel.imageUrl)
        productName.text = reviewDetailsModel.name
        reviewData.text = reviewDetailsModel.reviewData
        reviewDetails.text = reviewDetailsModel.reviewDetails
        
        var Y:CGFloat = 0
        let ratingDict = JSON(reviewDetailsModel.ratingData)
        
        if ratingDict.count > 0 {
            for i in 0..<ratingDict.count{
                let reviewDict = ratingDict[i]
                
                let reviewLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: 110, height: CGFloat(25)))
                reviewLabel.textColor =  UIColor.black
                reviewLabel.backgroundColor = UIColor.clear
                reviewLabel.font = UIFont(name: REGULARFONT, size: CGFloat(14))!
                reviewLabel.text = reviewDict["ratingCode"].string
                dynamicView.addSubview(reviewLabel)
                
                Y += 30
                
                let starRatingView = HCSStarRatingView(frame: CGRect(x: 10, y: Y, width: 100, height: 20))
                starRatingView.maximumValue = 5
                starRatingView.minimumValue = 0
                starRatingView.allowsHalfStars = true
                starRatingView.value = CGFloat(reviewDict["ratingValue"].floatValue / 20)
                starRatingView.tintColor = UIColor.appStarColor
                starRatingView.isUserInteractionEnabled = false
            
                dynamicView.addSubview(starRatingView)
                Y += 30
            }
        }else{
            
            let reviewLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: 110, height: CGFloat(25)))
            reviewLabel.textColor =  UIColor.black
            reviewLabel.backgroundColor = UIColor.red
            reviewLabel.font = UIFont(name: REGULARFONT, size: CGFloat(14))!
            reviewLabel.text = "Be first to review this product"
            dynamicView.addSubview(reviewLabel)
            
            Y += 30
            
            /*
            let starRatingView = HCSStarRatingView(frame: CGRect(x: 10, y: Y, width: 100, height: 20))
            starRatingView.maximumValue = 5
            starRatingView.minimumValue = 0
            starRatingView.allowsHalfStars = true
            starRatingView.value = 4.5 //CGFloat(reviewDict["ratingValue"].floatValue / 20)
            starRatingView.tintColor = UIColor.appStarColor
            starRatingView.isUserInteractionEnabled = false
        
            dynamicView.addSubview(starRatingView)
            Y += 30
            */
        }
        
//        let averageRating = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: CGFloat(self.dynamicView.frame.size.width - 10), height: CGFloat(20)))
//        averageRating.textColor =  UIColor.black
//        averageRating.backgroundColor = UIColor.clear
//        averageRating.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
//        averageRating.text = GlobalData.sharedInstance.language(key:"youravgreviewdetails" )
//        self.dynamicView.addSubview(averageRating)
//        Y += 30
//
//        let starRatingView = HCSStarRatingView(frame: CGRect(x: 10, y: Y, width: 100, height: 24))
//        starRatingView.maximumValue = 5
//        starRatingView.minimumValue = 0
//        starRatingView.allowsHalfStars = true
//        starRatingView.value = CGFloat(reviewDetailsModel.avgRatingValue)
//        starRatingView.isUserInteractionEnabled = false
//        starRatingView.tintColor = UIColor().HexToColor(hexString:STAR_COLOR)
//        self.dynamicView.addSubview(starRatingView)
//        Y += 30
        
        dynamicViewHeightConstarints.constant += Y + 50
        mainViewHeightConstarints.constant += dynamicViewHeightConstarints.constant
    }
}
