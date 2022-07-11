//
//  GDPRWebViewController.swift
//  Getkart
//
//  Created by Webkul on 21/08/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit
import WebKit

class GDPRWebViewController: UIViewController {

    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var gdprWebView: WKWebView!
    
    var backImg : UIImage!
    var content : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backImgView.image = backImg
        gdprWebView.layer.cornerRadius = 5.0
        gdprWebView.loadHTMLString(content, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backgroundTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

