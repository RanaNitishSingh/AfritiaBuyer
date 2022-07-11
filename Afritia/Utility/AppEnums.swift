//
//  AppEnums.swift
//  MusicLinkUp
//
//  Created by Karan B on 30/06/18.
//  Copyright © 2018 Karan B. All rights reserved.
//

import Foundation
import UIKit

enum navBarTitleType:String{
    
    case Title = "DefaultTitle"
    case CustomTitle = "CustomTitle"
    case CustomImage = "CustomImage"
    case SearchBar = "SearchBar"
    
    init?(type: String) {
        
        switch type.lowercased(){
            
        case "DefaultTitle" : self = .Title
        case "CustomTitle" : self = .CustomTitle
        case "CustomImage" : self = .CustomImage
        case "SearchBar" : self = .SearchBar
            
        default: return nil
        }
    }
}

enum navLeftBtnType:String{
    
    case CustomBack = "CustomBack"
    case ProfileImgBtn = "ProfileImgBtn"
    case noLeftBtn = "noLeftBtn"
    case DissmissClose = "DissmissClose"
    case PopClose = "PopClose"

    init?(type: String) {
        
        switch type.lowercased(){
        case "CustomBack" : self = .CustomBack
        case "ProfileImgBtn" : self = .ProfileImgBtn
        case "noLeftBtn" : self = .noLeftBtn
        case "DissmissClose" : self = .DissmissClose
        case "PopClose" : self = .PopClose
        default: return nil
        }
    }
}

enum navRightBtnType:String{
    
    case Setting = "Setting"
    case DissmissClose = "DissmissClose"
    case MoreMenuBtn = "MoreMenuBtn"
    case noRightBtn = "noRightBtn"
    case PopClose = "PopClose"
    
    init?(type: String) {
        
        switch type.lowercased(){
        case "Setting" : self = .Setting
        case "DissmissClose" : self = .DissmissClose
        case "MoreMenuBtn" : self = .MoreMenuBtn
        case "noRightBtn" : self = .noRightBtn
        case "PopClose" : self = .PopClose
        default: return nil
        }
    }
}

enum ActionDescriptor {
    case rename, move, share, delete, alone
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .rename: return "Rename"
        case .move: return "Move"
        case .share: return "Share"
        case .delete: return "Delete"
        case .alone: return "Alone"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .rename: name = "rename_folder"
        case .move: name = "move_folder"
        case .share: name = "share_folder"
        case .delete: name = "delete_folder"
        case .alone: name = "move_folder"
        }
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .rename: return UIColor.systemBlue
        case .move: return UIColor.systemOrange
        case .share: return UIColor.systemGreen
        case .delete: return UIColor.systemRed
        case .alone: return UIColor.systemTeal
        }
    }
}

enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}
