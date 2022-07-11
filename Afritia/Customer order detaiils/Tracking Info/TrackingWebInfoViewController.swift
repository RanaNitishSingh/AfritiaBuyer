//
/**
FashionHub
@Category Webkul
@author Webkul <support@webkul.com>
FileName: TrackingWebInfoViewController.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/


import UIKit
import WebKit

class TrackingWebInfoViewController: UIViewController {

    @IBOutlet weak var trackingInfoWebView: WKWebView!
    var trackingUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.applyAfritiaTheme()
        self.title = "trackinginfo".localized  //GlobalData.sharedInstance.language(key: "trackinginfo")
        let urlReq = URLRequest(url: URL(string: trackingUrl)!)
        self.trackingInfoWebView.load(urlReq)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
