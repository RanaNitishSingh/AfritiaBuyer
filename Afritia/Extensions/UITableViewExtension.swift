//
//  UITableViewExtension.swift
//  Afritia
//
//  Created by Ranjit Mahto on 09/10/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewController {
    
    func sizeHeaderToFit() {
          if let headerView = tableView.tableHeaderView {
              
              headerView.setNeedsLayout()
              headerView.layoutIfNeeded()
              
              let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
              var frame = headerView.frame
              frame.size.height = height
              headerView.frame = frame
              
              tableView.tableHeaderView = headerView
          }
      }
      
      func sizeFooterToFit() {
          if let footerView = tableView.tableFooterView {
              footerView.setNeedsLayout()
              footerView.layoutIfNeeded()
              
              let height = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
              var frame = footerView.frame
              frame.size.height = height
              footerView.frame = frame
              
              tableView.tableFooterView = footerView
          }
      }
}

extension UITableView {
    func reloadDataWithAutoSizingCellWorkAround() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
    }
    
    func setEmptyView(emtyImage:UIImage, title: String, message: String, btnTitle:String ,completionHandler: @escaping (_ respMsg:String) -> Void) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        //emptyView.backgroundColor = UIColor.yellow
        
        let imageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        let btnRefresh = UIButton(type:.custom)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        btnRefresh.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font =  UIFont.systemFont(ofSize: 20)
        //titleLabel.backgroundColor = UIColor.orange
        
        
        messageLabel.textColor = UIColor.darkGray
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        //messageLabel.backgroundColor = UIColor.cyan
        
        
        btnRefresh.setTitle(btnTitle, for: .normal)
        btnRefresh.addTargetClosure { (btn) in
            completionHandler(btnTitle)
        }
        
        emptyView.addSubview(imageView)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        emptyView.addSubview(btnRefresh)
        
        /*
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        */
        
        NSLayoutConstraint.activate([imageView.centerXAnchor.constraint(equalTo: imageView.superview!.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: imageView.superview!.topAnchor, constant: 100),
            imageView.widthAnchor.constraint(equalToConstant:200), imageView.heightAnchor.constraint(equalToConstant:200)
            ])
        
        let titleExpHeight = AppFunction.getTextHeightWithParaSpace(text:title, textWidth:SCREEN_WIDTH-40, space:0, fontsize:20)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: titleLabel.superview!.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: titleLabel.superview!.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant:titleExpHeight)
            ])
        
        let msgExpHeight = AppFunction.getTextHeightWithParaSpace(text:message, textWidth:SCREEN_WIDTH-40, space:0, fontsize:16)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageLabel.heightAnchor.constraint(equalToConstant:msgExpHeight)
            ])
        
        NSLayoutConstraint.activate([
            btnRefresh.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            btnRefresh.centerXAnchor.constraint(equalTo: messageLabel.centerXAnchor),
            btnRefresh.heightAnchor.constraint(equalToConstant:40),
            btnRefresh.widthAnchor.constraint(equalToConstant:160)
            ])
        
        imageView.image = emtyImage
        imageView.alpha = 08
        imageView.contentMode = .scaleAspectFill
        
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        
        btnRefresh.setBackgroundColor(UIColor.DarkLavendar, for: .normal)
        btnRefresh.layer.cornerRadius = 20
        btnRefresh.layer.borderWidth = 1
        btnRefresh.layer.borderColor = UIColor.LightLavendar.cgColor
        btnRefresh.clipsToBounds = true
        btnRefresh.setBackgroundColor(UIColor.LightLavendar, for: .highlighted)
        //btnRefresh.customizeWithBorderAndHalfRoundCorner()
        
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }

}

extension UITableViewCell {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

// how to use parentViewController
/*
 if let parentViewController = self.parentViewController as? SellerDashBoardController {
     parentViewController.present(alert, animated: true, completion: nil)
 }
 */
