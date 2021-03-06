//
//  BannerTableViewCell.swift
//  WooCommerce
//
//  Created by Webkul  on 04/11/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

@objc protocol bannerViewControllerHandlerDelegate: class {
    func bannerProductClick(type:String,image:String,id:String,title:String)
}

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: CHIPageControlPaprika!
    
    var index:Int = 0
    var bannerCollectionModel = [BannerData]()
    var delegate:bannerViewControllerHandlerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerCollectionViewHeight.constant = SCREEN_WIDTH/2
        bannerCollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerImageCell")
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        pageControl.radius = 4
        pageControl.tintColor = UIColor.appLightGrey
        pageControl.currentPageTintColor = UIColor.button
        pageControl.padding = 6
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension BannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = bannerCollectionModel.count
        if bannerCollectionModel.count>0{
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
        }
        return bannerCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerImageCell", for: indexPath) as! BannerImageCell
        
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:bannerCollectionModel[indexPath.row].imageUrl , imageView: cell.bannerImageView)
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: SCREEN_WIDTH/2 - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var  id:String = ""
        if bannerCollectionModel[indexPath.row].bannerType == "category"{
            id = bannerCollectionModel[indexPath.row].bannerId
        }else{
            id  = bannerCollectionModel[indexPath.row].productId
        }
        
        delegate.bannerProductClick(type: bannerCollectionModel[indexPath.row].bannerType, image: bannerCollectionModel[indexPath.row].imageUrl, id: id,title:bannerCollectionModel[indexPath.row].bannerName)
    }
    
    @objc func scrollAutomatically(){
        if index == bannerCollectionModel.count{
            index = 0
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        pageControl.set(progress: index, animated: true)
        if bannerCollectionView.numberOfItems(inSection: 0) > index{
            bannerCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        index += 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        for cell: UICollectionViewCell in self.bannerCollectionView.visibleCells {
            let indexPathValue = self.bannerCollectionView.indexPath(for: cell)!
            pageControl.set(progress: indexPathValue.row, animated: true)
            break
        }
    }
}
