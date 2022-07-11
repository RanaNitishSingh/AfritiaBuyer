//
//  SellerProductTableViewCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 06/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

@objc protocol sellerProductViewControllerHandlerDelegate: class {
    func productClick(name:String,image:String,id:String)
    func addToWishList(productID:String, index: Int)
    func removedFromWishList(productID:String, index: Int)
    func addToCompare(productID:String)
}

class SellerProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sellerCollectionLabel: UILabel!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAllButton: UIButton!
    
    var sellerproducts = [SellerRecentProduct]()
    var delegate:sellerProductViewControllerHandlerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewHeight.constant = 20
        productCollectionView.register(UINib(nibName:"ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.backgroundColor = UIColor.white
        
        viewAllButton.setTitle("viewall".localized, for: .normal)
        viewAllButton.applyAfritiaBorederTheme(cornerRadius:5)
        sellerCollectionLabel.text = "  SellerCollection"
        sellerCollectionLabel.applyAfritiaBorederTheme(cornerRadius:5)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension SellerProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sellerproducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
        
        cell.productImage.image = UIImage(named: "ic_placeholder.png")
        cell.layer.cornerRadius = 4
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.appSuperLightGrey.cgColor
        
        let productInfo = sellerproducts[indexPath.row]
        
        cell.productImage.getImageFromUrl(imageUrl: productInfo.productImage)
        cell.productName.text = productInfo.productName
        cell.productPrice.text = productInfo.price
        
        cell.wishListButton.tag = indexPath.row
        cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
        cell.wishListButton.isUserInteractionEnabled = true
        
        cell.addToCompareButton.tag = indexPath.row
        cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
        cell.addToCompareButton.isUserInteractionEnabled = true
        
        if productInfo.isInWishlist {
            cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
        }else{
            cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
        }
        
        if productInfo.isInRange == true{
            if productInfo.specialPrice < productInfo.normalprice{
                cell.productPrice.text = productInfo.formatedSpecialPrice
                let attributeString = NSMutableAttributedString(string: ( productInfo.formatedPrice ))
                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                cell.specialPrice.attributedText = attributeString
                cell.specialPrice.isHidden = false
            }
        }else{
            cell.specialPrice.isHidden = true
        }
        
        self.collectionViewHeight.constant = self.productCollectionView.contentSize.height
        
        if sellerproducts[indexPath.row].isFreeshipping == "Yes"{
            cell.lblShipping.text = "freeshipping".localized
        }else if sellerproducts[indexPath.row].isFreeshipping == "No"{
            cell.lblShipping.text = "shippingword".localized + ": \(productInfo.shippingPrice )"
        }else{
            cell.lblShipping.text = ""
        }
        
        cell.btnQuickViewHeight.constant = 0
        cell.btnQuickView.isHidden = true
        cell.btnQuickView.addTargetClosure { (btn) in
            //self.delegate.productQuickView(productInfo: self.productCollectionModel[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 16 , height: collectionView.frame.size.width/2 + 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.productClick(name: sellerproducts[indexPath.row].productName, image: sellerproducts[indexPath.row].productImage, id: sellerproducts[indexPath.row].id)
    }
    @objc func addToWishList(sender: UIButton){
        
        if sender.image(for: .normal) == #imageLiteral(resourceName: "ic_wishlist_fill")    {
            delegate.removedFromWishList(productID: sellerproducts[sender.tag].wishlistItemId, index: sender.tag)
            sender.setImage(#imageLiteral(resourceName: "ic_wishlist_empty"), for: .normal)
        }else{
            delegate.addToWishList(productID: sellerproducts[sender.tag].id, index: sender.tag)
            sender.setImage(#imageLiteral(resourceName: "ic_wishlist_fill"), for: .normal)
        }        
    }
    
    @objc func addToCompare(sender: UIButton){
        delegate.addToCompare(productID:sellerproducts[sender.tag].id)
    }
}
