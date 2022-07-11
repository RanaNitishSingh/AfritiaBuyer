//
//  MyDownloads.swift
//  DummySwift
//
//  Created by Webkul on 28/12/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class MyDownloads: UIViewController {
    
    @IBOutlet weak var myDownloadTableView: UITableView!
    @IBOutlet weak var myStoredFiles : UIBarButtonItem!
    
    var myDownloadsModel : MyDownloadsModel!
    var whichApiToProcess:String!
    var pageNumber:Int = 0
    var hashData: String!
    let defaults = UserDefaults.standard
    var fileName:String!
    var emptyDownloadView:UIView!
    var fileUrl:String!
    var directoryContents:NSArray!
    var documentPathUrl:NSURL!
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "mydownload")
        self.navigationController?.isNavigationBarHidden = false
        
        myStoredFiles.title = "mystoredfiles".localized
        
        myDownloadTableView.separatorStyle = .none
        myDownloadTableView.register(MyDownlodableTableViewCell.nib, forCellReuseIdentifier:MyDownlodableTableViewCell.identifier)
        myDownloadTableView.rowHeight = UITableViewAutomaticDimension
        myDownloadTableView.estimatedRowHeight = 200
        
        //Call API
        whichApiToProcess = ""
        pageNumber = 1
        callingHttppApi()
        
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "refreshing".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            myDownloadTableView.refreshControl = refreshControl
        }else {
            myDownloadTableView.backgroundView = refreshControl
        }
        
        emptyDownloadView = UIView(frame: CGRect(x:0, y: SCREEN_HEIGHT/2 - 160 , width: SCREEN_WIDTH, height: 170))
        self.view.addSubview(emptyDownloadView)
        let cartImage = UIImageView(frame: CGRect(x:SCREEN_WIDTH/2-60, y:0, width:120, height: 120))
        cartImage.image = UIImage(named: "empty_downloadview")
        emptyDownloadView.addSubview(cartImage)
        let emptyLabel = UILabel(frame: CGRect(x:0, y: 120, width: SCREEN_WIDTH, height: 13))
        emptyLabel.textColor = UIColor.red
        emptyLabel.text = GlobalData.sharedInstance.language(key: "nodownloadproducts")
        emptyLabel.font = UIFont(name: "Helvetica-Bold", size: 13.0)
        emptyLabel.textAlignment = .center
        emptyDownloadView.addSubview(emptyLabel)
        emptyDownloadView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    //MARK:- Pull to refresh
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        whichApiToProcess = ""
        pageNumber = 1
        callingHttppApi()
        refreshControl.endRefreshing()
    }
    
    //MARK:- Calling API
    func callingHttppApi(){
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()
        let customerId = defaults.object(forKey:"customerId")
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        if(whichApiToProcess == "getDownloadUrl"){
            requstParams["hash"] = hashData
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.downloadProduct, currentView: self){success,responseObject in
                if success == 1{
                    
                    print("sss", responseObject!)
                    
                    self.doFurtherProcessingWithResult(data: responseObject as! NSDictionary)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            requstParams["pageNumber"] = pageNumber
            
            if(pageNumber == 1){
                GlobalData.sharedInstance.showLoader()
                self.view.isUserInteractionEnabled = false
            }
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.myDownloadsList, currentView: self){success,responseObject in
                if success == 1{
                    print("sss", responseObject!)
                    self.doFurtherProcessingWithResult(data: responseObject as! NSDictionary)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data :NSDictionary){
        DispatchQueue.main.async {
            GlobalData.sharedInstance.dismissLoader()
            self.view.isUserInteractionEnabled = true
            if(self.whichApiToProcess == "getDownloadUrl"){
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                if errorCode == true{
                    print(data)
                    self.fileUrl = data.object(forKey: "url") as! String
                    self.fileName = data.object(forKey: "fileName") as! String
                    self.startDownloadingData()
                }else{
                    AlertManager.shared.showErrorSnackBar(msg: data.object(forKey: "message") as! String)
                }
            }else{
                if(self.pageNumber != 1){
                    var myDownloadsListArr = [DownloadsList]()
                    if let arr = JSON(data)["downloadsList"].arrayObject{
                        myDownloadsListArr = arr.map({(val) -> DownloadsList in
                            return DownloadsList(data: JSON(val))
                        })
                    }
                    
                    for val in myDownloadsListArr {
                        self.myDownloadsModel.downloadsList.append(val)
                    }
                    
                    self.myDownloadTableView.reloadData()
                }else{
                    self.myDownloadsModel = MyDownloadsModel(data: JSON(data))
                    if self.myDownloadsModel.downloadsList.count == 0{
                        self.emptyDownloadView.isHidden = false
                    }else{
                        self.emptyDownloadView.isHidden = true
                    }
                    self.myDownloadTableView.reloadData()
                }
            }
        }
    }
    
    func startDownloadingData(){
        do{
            let url = NSURL(string: self.fileUrl)! as URL
            let largeImageData = try Data(contentsOf: url)
            if let bannerImage:UIImage = UIImage(data: largeImageData){
                UIImageWriteToSavedPhotosAlbum(bannerImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            ////////////////////////////////////////  save to document directory ///////////////////////////////////////////
            
            let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentsDirectoryURL.appendingPathComponent(self.fileName)
            
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try largeImageData.write(to: fileURL)
                    print("Image Added Successfully")
                    let AC = UIAlertController(title: "SUCCESS", message:"yourfilehasbeensavedwouldyouliketosee".localized, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        self.documentPathUrl = fileURL as NSURL
                        
                        let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ShowDownloadFile") as! ShowDownloadFile
                        vc.documentUrl = self.documentPathUrl
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                        
                    })
                    AC.addAction(okBtn)
                    AC.addAction(noBtn)
                    self.present(AC, animated: true, completion: nil)
                    
                } catch {
                    print(error)
                }
            } else {
                print("URL already exists")
                self.documentPathUrl = fileURL as NSURL
                
                let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ShowDownloadFile") as! ShowDownloadFile
                vc.documentUrl = self.documentPathUrl
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }catch{
            print("error")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            GlobalData.sharedInstance.dismissLoader()
            AlertManager.shared.showErrorSnackBar(msg: "notloadedtophotodirectory".localized)
        } else {
            GlobalData.sharedInstance.dismissLoader()
            AlertManager.shared.showWarningSnackBar(msg: "savedtophotolibrary".localized)
        }
    }
    
    @IBAction func showStoredFiles(_ sender: Any) {
        let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "MyLocalFiles") as! MyLocalFiles
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyDownloads : UITableViewDelegate, UITableViewDataSource, DownloadBtnPress {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myDownloadsModel != nil  {
            return myDownloadsModel.downloadsList.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyDownlodableTableViewCell.identifier, for: indexPath) as! MyDownlodableTableViewCell
        
        cell.downloadBtn.tag = indexPath.row
        cell.item = myDownloadsModel.downloadsList[indexPath.row]
        cell.delegate = self
        
        if indexPath.row == myDownloadsModel.downloadsList.count - 1 && myDownloadsModel.downloadsList.count != myDownloadsModel.totalCount   {
            //pagination
            pagination()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerOrderDetails") as! CustomerOrderDetails
        vc.incrementId = myDownloadsModel.downloadsList[indexPath.row].incrementId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //for showing the activity loader
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.myDownloadTableView.tableFooterView = spinner
            self.myDownloadTableView.tableFooterView?.isHidden = false
            
            if self.myDownloadsModel != nil    {
                if self.myDownloadsModel.totalCount == self.myDownloadsModel.downloadsList.count  {
                    spinner.stopAnimating()
                    self.myDownloadTableView.tableFooterView = nil
                    self.myDownloadTableView.tableFooterView?.isHidden = true
                }
            }
        }
    }
    
    func pagination(){
        self.pageNumber += 1
        whichApiToProcess = ""
        callingHttppApi()
    }
    
    func downloadBtnClick(index: Int) {
        hashData = myDownloadsModel.downloadsList[index].hash
        whichApiToProcess = "getDownloadUrl"
        callingHttppApi()
    }
}
