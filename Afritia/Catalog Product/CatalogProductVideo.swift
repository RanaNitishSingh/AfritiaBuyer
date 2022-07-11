//
/**
VitheiPhsar
@Category Webkul
@author Webkul <support@webkul.com>
FileName: CatalogProductVideo.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/


import UIKit
import YoutubePlayerView

class CatalogProductVideo: UICollectionViewCell {

    @IBOutlet weak var productVideoView : YoutubePlayerView!
    
    static var identifier: String  {
        return String(describing: self)
    }
    
    static var nib : UINib  {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
