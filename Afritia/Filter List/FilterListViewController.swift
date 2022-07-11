



//
//  FilterListViewController.swift
//  MobikulRTL
//
//  Created by rakesh kumar on 24/11/17.
//  Copyright © 2017 webkul. All rights reserved.
//




import UIKit

class FilterListViewController: UIViewController{
   
    var delegate:FilterItemsDelegate?
    var productCollectionViewModel:ProductCollectionViewModel!
    @IBOutlet weak var navBar: UINavigationBar!
    //@IBOutlet weak var filteredTableView: UITableView!
    @IBOutlet weak var filterListTableView: UITableView!
    var layeredDataForFilter :NSArray = []
    var filteredItemArray2 :NSMutableArray = []
    let globalObjectFilter = GlobalData();
    
    //@IBOutlet weak var filteredByLabel: UILabel!
    @IBAction func dismissViewButton(_ sender: Any) {
        
       // let dicti = NSDictionary()
      //  self.delegate?.updateArray(dictArray: dicti, code: "")
        
         dismiss(animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.title = GlobalData.sharedInstance.language(key: "filterby")
//        self.globalObjectFilter.language()

        print("layeredDataForFilter: ", layeredDataForFilter)
//         globalObjectAdvanceSearch.delegate = self;
       //filteredByLabel.text = GlobalData.sharedInstance.language(key: "filterby")
//        self.globalObjectFilter.removeFloatingButton()
        filterListTableView.dataSource = self;
        filterListTableView.delegate = self;
        filterListTableView.reloadData()
    }
    
    
    
    //handleClearAllRegister
    
    @objc func handleRegister(sender: UIButton){
        self.delegate?.removeFromArray(postion: sender.tag)
    }
    
    func handleClearAllRegister(sender: UIButton){
        self.delegate?.removeAllObjFromArray()
    }
    

/*
   //not implemented function
    func addtoFilterList(dict:NSDictionary ,code:String){
        
        if selectedFilter.contains(dict){
            selectedFilter.remove(dict)
        }else{
            selectedFilter.add(dict)
        }
        
        if selectedCode.contains(code){
            selectedCode.remove(code)
        }else{
            selectedCode.add(code)
        }
        
       
        self.filterListTableView.reloadData()
    }
    */
    
    
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//        if(filteredItemArray2.count>0){
//            if(section == 0){
//                let cell = tableView.dequeueReusableCell(withIdentifier: "filterClear") as! FilteredTableViewCell
//                cell.selectionStyle = UITableViewCellSelectionStyle.none
//                cell.clearAllBtn.addTarget(self, action:#selector(handleClearAllRegister(sender:)), for: .touchUpInside)
//                return cell;
//
//            }
//        }
//        let frame = CGRect.zero
//        let view = UIView(frame: frame)
//        return view;
//    }
    
   
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if(filteredItemArray2.count>0){
//            if(section == 0){
//                return 55;
//            }
//        }
//        return 0;
//    }

}

extension FilterListViewController :UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(filteredItemArray2.count>0){
            return layeredDataForFilter.count + 1
        }
         return layeredDataForFilter.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
        if section == 0{
            if filteredItemArray2.count > 0 {
                return filteredItemArray2.count
            }
            return 0
        }
        else{
            var optionsArray: NSArray!
            optionsArray = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at:section) as! NSArray
            return optionsArray.count
        }*/

        
        if(filteredItemArray2.count>0){
            if(section == 0){
                 return filteredItemArray2.count
            }
            else{
                var optionsArray: NSArray!
                optionsArray = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: section-1) as! NSArray
                return optionsArray.count
            }
        }else{
            var optionsArray: NSArray!
            optionsArray = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: section) as! NSArray
            return optionsArray.count
        }
//
//        if(section == 0){
//            return filteredItemArray2.count
//        }
//        else{
//            if(filteredItemArray2.count>0){
//                var optionsArray: NSArray!
//                optionsArray = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: section-1) as! NSArray
//                return optionsArray.count
//            }
//            else{
//
//                var optionsArray: NSArray!
//                optionsArray = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: section) as! NSArray
//                return optionsArray.count
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
        if indexPath.section == 0 {
            
            if filteredItemArray2.count>0 {
                let selectedObj = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at:0) as! NSArray
                
                let dicti = selectedObj[indexPath.row] as! NSDictionary
                
                let code2 = (layeredDataForFilter[indexPath.section] as AnyObject).value(forKey: "code") as! String
                self.delegate?.updateArray(dictArray: dicti, code: code2)
            }
        }
        else{
            
            let selectedObj = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: indexPath.section) as! NSArray
            
            let dicti = selectedObj[indexPath.row] as! NSDictionary
            
            let code2 = (layeredDataForFilter[indexPath.section] as AnyObject).value(forKey: "code") as! String
            self.delegate?.updateArray(dictArray: dicti, code: code2)
        }*/
        
        
        if(filteredItemArray2.count>0){
            if(indexPath.section == 0){

            }
            else{
                let selectedObj = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: indexPath.section-1) as! NSArray
                
                let dicti = selectedObj[indexPath.row] as! NSDictionary
                
                let code2: String = (layeredDataForFilter[indexPath.section-1] as AnyObject).value(forKey: "code") as! String
                
                self.delegate?.updateArray(dictArray: dicti, code: code2)
            }
            
        }
        else{
            let selectedObj = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: indexPath.section) as! NSArray
            
            let dicti = selectedObj[indexPath.row] as! NSDictionary
            
            let code2 = (layeredDataForFilter[indexPath.section] as AnyObject).value(forKey: "code") as! String
            self.delegate?.updateArray(dictArray: dicti, code: code2)
        }
    }
    
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(filteredItemArray2.count>0){
            if(section == 0){
                return "";
            }
            else{
                
               return (layeredDataForFilter[section-1] as AnyObject).value(forKey: "label") as! String
            }

        }
        else{
            return (layeredDataForFilter[section] as AnyObject).value(forKey: "label") as! String
        }
    }*/
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.DarkLavendar
        
        var headerTitle = ""
        if(filteredItemArray2.count>0){
            if(section == 0){
                headerTitle = "";
            }else{
                headerTitle = (layeredDataForFilter[section-1] as AnyObject).value(forKey: "label") as! String
            }
        }
        else{
            headerTitle = (layeredDataForFilter[section] as AnyObject).value(forKey: "label") as! String
        }
        
        /*
        if(section == 0){
            if filteredItemArray2.count > 0{
                headerTitle = (layeredDataForFilter[0] as AnyObject).value(forKey: "label") as! String
            }else{
                headerTitle = ""
            }
        }
        else{
            headerTitle = (layeredDataForFilter[section] as AnyObject).value(forKey: "label") as! String
        }*/
        
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = headerTitle
            label.font = UIFont.systemFont(ofSize: 15, weight:.medium) // my custom font
            label.textColor = UIColor.white // my custom colour

            headerView.addSubview(label)

            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(filteredItemArray2.count>0){
            if(section == 0){
                return 0
            }else{
                return 40
            }
        }else{
            return 40
        }

        /*
        if(section == 0){
            if filteredItemArray2.count > 0 {
                return 40
            }
            return 0
        }
        else{
            return 40
        }*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(filteredItemArray2.count>0){
            if(indexPath.section == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "filters") as! FilteredTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.filteredLabel.text = (filteredItemArray2.value(forKey: "label") as! NSArray).object(at: indexPath.row) as? String
                cell.redCrossBtn.tag = indexPath.row
                cell.redCrossBtn.addTarget(self, action:#selector(handleRegister(sender:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "filtertotal") as! FilterTotalListTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                let temp: NSArray!
                if(filteredItemArray2.count>0){
                    temp = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: indexPath.section-1) as! NSArray;
                }
                else{
                    temp = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: indexPath.section) as! NSArray;
                }
                
                let dicti = temp[indexPath.row] as! NSDictionary
                
               
                
                if let countInt = (dicti.value(forKey: "count") as? Int) {
                    cell.listNameLabel.text = (dicti.value(forKey: "label") as! String) + " (\(countInt))"
                } else if let countStr = (dicti.value(forKey: "count") as? String) {
                    cell.listNameLabel.text = (dicti.value(forKey: "label") as! String) + " (\(countStr))"
                }
                
                cell.selectionStyle = .none
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "filtertotal") as! FilterTotalListTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let temp: NSArray!
            if(filteredItemArray2.count>0){
                temp = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: indexPath.section-1) as! NSArray;
            }
            else{
                temp = (layeredDataForFilter.value(forKey: "options") as! NSArray).object(at: indexPath.section) as! NSArray;
            }
            
            let dicti = temp[indexPath.row] as! NSDictionary
            
           
            
            if let countInt = (dicti.value(forKey: "count") as? Int) {
                cell.listNameLabel.text = (dicti.value(forKey: "label") as! String) + " (\(countInt))"
            } else if let countStr = (dicti.value(forKey: "count") as? String) {
                cell.listNameLabel.text = (dicti.value(forKey: "label") as! String) + " (\(countStr))"
            }

            cell.selectionStyle = .none
            return cell
        }
        
    }
    
}
