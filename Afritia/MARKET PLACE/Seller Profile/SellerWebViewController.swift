//
//  SellerWebViewController.swift
//  Getkart
//
//  Created by kunal on 28/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import WebKit

class SellerWebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var message:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if message.replacingOccurrences(of: " ", with: "") == "" {
            AlertManager.shared.showWarningSnackBar(msg: "No data available".localized)
        }
        webView.loadHTMLString(message, baseURL: nil)
    }
}
