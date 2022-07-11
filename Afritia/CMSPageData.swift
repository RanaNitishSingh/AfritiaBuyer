//
//  CMSPageData.swift
//  Ajmal
//
//  Created by Webkul on 05/05/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit
import WebKit

class CMSPageData: UIViewController{
    
    public var cmsId:String!
    public var cmsName:String!
    let defaults = UserDefaults.standard;
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var cmsdataTextView: UITextView!
    
    var isShowInWebView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.isNavigationBarHidden = false
        self.callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
        self.navigationController?.navigationBar.applyAfritiaTheme()
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        requstParams["id"] = cmsId
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.cmsData, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            if success == 1
            {
                print("sss", responseObject!)
                let data = responseObject as! NSDictionary
                
                if let heading = data.object(forKey: "title") as? String    {
                    self.navigationController?.navigationBar.topItem?.title = heading
                }
                
                let webContent = data.object(forKey: "content") as! String
                if self.isShowInWebView == true {
                    self.cmsdataTextView.isHidden = true
                    self.webView.loadHTMLString(webContent, baseURL: nil)
                    self.loadhtmlDescriptionInWebView(htmlContent: webContent)
                }
                else
                {
                    self.cmsdataTextView.isHidden = false
                    self.cmsdataTextView.attributedText = webContent.htmlAttributedString(size:16, color: .Lead)
                }
            }
            else if success == 2{
                self.callingHttppApi();
            }
               // self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
        }
    }
    
    func loadhtmlDescriptionInWebView(htmlContent:String){
        
        //guard let path = Bundle.main.path(forResource: "style", ofType: "css") else {
                   // return WKWebView()
                //}
                
        let path = Bundle.main.path(forResource: "style", ofType: "css")
        let cssString = try! String(contentsOfFile: path!).components(separatedBy: .newlines).joined()
                let source = """
                var style = document.createElement('style');
                style.innerHTML = '\(cssString)';
                document.head.appendChild(style);
                """
                
                let userScript = WKUserScript(source: source,
                                              injectionTime: .atDocumentEnd,
                                              forMainFrameOnly: true)
                
                let userContentController = WKUserContentController()
                userContentController.addUserScript(userScript)
                
                //let configuration = WKWebViewConfiguration()
                //configuration.userContentController = userContentController
                
                //let webView = WKWebView(frame: .zero ,configuration: configuration)
        self.webView.frame = .zero
        //descWebView.configuration = configuration
        //self.webView.navigationDelegate = self
        self.webView.scrollView.isScrollEnabled = true
        self.webView.scrollView.bounces = false
        
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
                let htmlEnd = "</BODY></HTML>"
                let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        self.webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
}
