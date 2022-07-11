//
/**
 Getkart
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: MyDownlodableTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import UIKit

protocol DownloadBtnPress {
    func downloadBtnClick(index: Int)
}

class MyDownlodableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var remainsDownloads: UILabel!
    @IBOutlet weak var orderid: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var statusVal: UILabel!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    var delegate : DownloadBtnPress?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var item : DownloadsList?{
        didSet{
            date.text = "date".localized + " " + (item?.date)!
            orderid.text = item?.incrementId
            title.text = "prefix".localized + ": " + (item?.proName)!
            statusTitle.text = "status".localized
            statusVal.text = item?.status
            remainsDownloads.text = "remaindownloads".localized + ": " + (item?.remainingDownloads)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func downloadBtnClicked(_ sender: UIButton)   {
        delegate?.downloadBtnClick(index: sender.tag)
    }
}
