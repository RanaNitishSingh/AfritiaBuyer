//
//  PreviewViewController.swift
//  3D Touch Swift
//
//  Created by Jay Versluis on 04/12/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

import UIKit


protocol PreviewControllerDelegate {
    func previewAddToCart()
    func previewShare()
}

class PreviewViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

@IBOutlet var tableView: UITableView!
var productDescription:String = ""
var imageUrl:String = ""
var delegate:PreviewControllerDelegate!
var requiredOptions:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ShowPreviewCell", bundle: nil), forCellReuseIdentifier: "ShowPreviewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ShowPreviewCell = tableView.dequeueReusableCell(withIdentifier: "ShowPreviewCell") as! ShowPreviewCell
        cell.productDescription.text = self.productDescription
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl, imageView: cell.productImage)
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl, imageView: cell.productBackgroundImage)
        
        cell.selectionStyle = .none
        return cell
    }
    

    // MARK: Preview Actions
    
    override var previewActionItems : [UIPreviewActionItem] {
    
        // setup a list of preview actions
        let action1 = UIPreviewAction.init(title: "addtocart".localized, style: UIPreviewActionStyle.default) { (UIPreviewAction, UIViewController) -> Void in
            self.delegate.previewAddToCart()
        }
        let image1 = UIImage(named: "Action 4")
        action1.setValue(image1, forKey: "image")
        
        
        let action2 = UIPreviewAction.init(title: "share".localized, style: UIPreviewActionStyle.default) { (UIPreviewAction, UIViewController) -> Void in
            self.delegate.previewShare()
        }
        
        let image2 = UIImage(named: "ic_share")
        action2.setValue(image2, forKey: "image")
        
        let action3 = UIPreviewAction.init(title: "cancel".localized, style: UIPreviewActionStyle.destructive) { (UIPreviewAction, UIViewController) -> Void in
            NSLog("Selected Action was selected")
        }
        
        // add them to an array
        var actions:NSArray!
        
        if requiredOptions == 0{
          actions = NSArray.init(objects: action1, action2, action3)
        }else{
          actions = NSArray.init(objects: action2, action3)
        }
        
        // add all actions to a group
        let group = UIPreviewActionGroup.init(title: "quickaction".localized, style: UIPreviewActionStyle.default, actions: actions as! [UIPreviewAction])
        
        // add the group to an array (yes, this is indeed ridiculous)
        let groupedGroup = NSArray.init(object: group)
        
        // and return them (return the array of actions instead to see all items ungrouped)
        return groupedGroup as! [UIPreviewActionItem]

    }

}
