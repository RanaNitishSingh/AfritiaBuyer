//
//  Utility.swift
//

import Foundation
import UIKit
import SwiftMessages

/* remove this for workig code 

public enum Theme {
    case info
    case success
    case warning
    case error
}

public enum AlertBtnAlign {
    case horizontal
    case vertical
}

struct AlertType {
    static let Caution = "Caution"
    static let Warning = "Warning"
    static let Success = "Success"
    static let None = "None"
}

//struct AlertBtnAlign {
//    static let Horizontal = "Horizontal"
//    static let Vertical = "Vertical"
//}

struct AlertTitle {
    static let NoInternet = "No Internet"
    static let InputError = "Input Error"
    static let PasswordUpdated = "Password Updated"
}

struct AlertMessage {
    static let NoInternetConnection = "Please check your internet connection."
    static let EnterEmailId = "Please enter your email id"
    static let EnterValidEmailId = "Please enter valid email id"
    static let EnterYourPassword = "Please enter your valid password"
    static let SelectCountry = "Please select country"
    
    static let RequestTimeOut = "Your request time is out, try again later"
}

struct AlertItem {
    
    var image:UIImage!
    var title:String!
    
    init(btnImage:UIImage?, btnTitle:String){
        self.image = btnImage
        self.title = btnTitle
    }
}

struct AlertOption {
    
    static let photoLib = AlertItem(btnImage: nil, btnTitle:"Photo Library")
    static let camera = AlertItem(btnImage:nil, btnTitle:"Camera")
    static let removeConnection = AlertItem(btnImage: nil, btnTitle:"Remove Connection")
    static let edit = AlertItem(btnImage: nil, btnTitle:"Edit")
    static let delete = AlertItem(btnImage: nil, btnTitle:"Delete")
}

fileprivate struct CustomCRNotification: CRNotificationType {
    var textColor: UIColor
    var backgroundColor: UIColor
    var image: UIImage?
}

typealias SelectedAlertAction = (String) -> Void
typealias alertResposeHandlerWithIndex = (Int, String) -> Void
 */
typealias alertResposeHandler = (Int, String) -> Void


class AlertManager {
    
    class var shared: AlertManager {

        struct Singleton {
            static let shared = AlertManager()
        }
        return Singleton.shared
    }
    
    //MARK: Default AlertMessage Methods
    class func Show(onController:UIViewController, btnTitles:[String], alertTitle:String?, alertMessage:String?, alertStyle:UIAlertController.Style, alertResposeHandler: @escaping alertResposeHandler)
    {
        var myTitle = ""
        var myMessage = ""
        
        if let title = alertTitle {
            myTitle = title
        }
        
        if let msg = alertMessage {
            myMessage = msg
        }
        
        let alertview : UIAlertController = UIAlertController(title: myTitle, message:  myMessage ,preferredStyle: alertStyle)
        
        for i in 0..<btnTitles.count{
            
            if btnTitles[i] == "cancel".localized {
                
                let actionTarget = UIAlertAction(title:btnTitles[i], style: .cancel) { (defaultOK) in
                    alertResposeHandler(i, btnTitles[i])
                }
                alertview.addAction(actionTarget)
            }
            else
            {
                let actionTarget = UIAlertAction(title:btnTitles[i], style: .default) { (defaultOK) in
                    alertResposeHandler(i, btnTitles[i])
                }
                alertview.addAction(actionTarget)
            }
            
        }
        onController.present(alertview, animated: true)
    }
    
    
    //MARK: Bar AlertMessage Methods
    func showSuccessSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.success)
        info.button?.isHidden = true
        info.configureContent(title: GlobalData.sharedInstance.language(key: "success"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        infoConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        infoConfig.duration = .seconds(seconds: 3)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showWarningSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.warning)
        info.button?.isHidden = true
        info.configureContent(title: GlobalData.sharedInstance.language(key: "warning"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        infoConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        infoConfig.duration = .seconds(seconds: 3)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showErrorSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.error)
        info.button?.isHidden = true
        info.configureContent(title: GlobalData.sharedInstance.language(key: "error"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        infoConfig.presentationStyle = .top
        infoConfig.dimMode = .gray(interactive: true)
        infoConfig.duration = .forever
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showInfoSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.configureContent(title: "info".localized, body: msg)
        info.button?.isHidden = true
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        infoConfig.presentationStyle = .top
        infoConfig.dimMode = .gray(interactive: true)
        infoConfig.duration = .forever
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showSnackBarWithAction(onView:UIViewController, theme:Theme, msg:String, actionBtnTitle:String, actionHandler: ((_ btnTitle:String) -> Void)?){
        
        let msgView = MessageView.viewFromNib(layout: .messageView)
        msgView.configureTheme(theme)
        msgView.button?.isHidden = false
        
        var icon = ""
        var title = ""
        if theme == .success {
            icon = "✓"
            title = "Sucess"
        }else if theme == .error {
            icon = "✗"
            title = "Error"
        }else if theme == .info {
            icon = "ℹ︎"
            title = "Info"
        }else if theme == .warning{
            icon = "⍵"
            title = "Warning"
        }
        
        msgView.configureContent(title:title, body: msg, iconImage: nil, iconText: icon, buttonImage: nil, buttonTitle: actionBtnTitle) { _ in
            SwiftMessages.hide()
            onView.dismiss(animated:true, completion:{
                actionHandler!(actionBtnTitle)
            })
        }
        
        var msgConfig = SwiftMessages.defaultConfig
        msgConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        msgConfig.presentationStyle = .top
        msgConfig.dimMode = .blur(style: UIBlurEffectStyle.light, alpha: 0.4, interactive: true)
        msgConfig.duration = .forever
        SwiftMessages.show(config: msgConfig, view: msgView)
    }
    
    /*
    class func ShowOptionPopUpViewDep(onController:UIViewController,alertId:String?, btnItems:[AlertItem], isShowCancelBtn:Bool, cancelBtnTitle:String? ,alertTitle:String?, alertMessage:String?, alerStyle:YBAlertControllerStyle, alertResposeHandler: @escaping alertResposeHandlerWithIndex)
    {
        let alertController = YBAlertController(title: alertTitle , message: alertMessage, style: alerStyle)
        // let alertController = YBAlertController(style: .ActionSheet)
        alertController.touchingOutsideDismiss = true
        alertController.animated = false
        alertController.overlayColor = UIColor(white:0, alpha: 0.3)
        alertController.delegate = onController as? YBAlertControllerDelegate
        alertController.identifier = alertId
        
        //customize title
        // if title is nil or empty, the title Label is hidden
        alertController.title = alertTitle
        alertController.titleFont = UIFont.systemFont(ofSize:15, weight:.semibold)
        alertController.titleTextColor = AppColor.AppBlue
        
        //customize messege
        // if message is nil or empty, the message Label is hidden
        alertController.message = alertMessage
        alertController.messageFont = UIFont.systemFont(ofSize:15, weight:.medium)
        alertController.messageTextColor = UIColor.darkGray
        
        //customize button
        alertController.buttonFont = UIFont.systemFont(ofSize:15, weight:.regular)
        alertController.buttonTextColor = UIColor.darkGray
        alertController.buttonIconColor = UIColor.darkGray

//        // add a button
//        alertController.addButton(icon: UIImage(named: "comment"), title: "Comment", target: self, selector: Selector("tap"))
        
        // add a button with closure
//        alertController.addButton(icon:UIImage(named: "tweet"), title: "Tweet", action: {
//            print("button tapped 1")
//        })

        // add a button (No image)
        //        alertController.addButton(title:"Open in Safari", target: self, selector: Selector("tap"))
        
            for i in 0..<btnItems.count{
                
                alertController.addButton(icon:btnItems[i].image, title:btnItems[i].title, action: {
                    print("button tapped 1")
                    alertResposeHandler(i, btnItems[i].title)
                })
            }
        
        if isShowCancelBtn && cancelBtnTitle != nil{
            //customize Cancel Button
            // if cancelButtonTitle is nil or empty, the cancel button is hidden
            alertController.cancelButtonTitle = cancelBtnTitle!
            alertController.cancelButtonFont = UIFont.systemFont(ofSize:15, weight:.regular)
            alertController.cancelButtonTextColor = UIColor.red
        }
        
        // if you use a cancel Button, set cancelButtonTitle
         //alertController.cancelButtonTitle = "Cancel"
        
        // show alert
        alertController.show()
    }*/
    
    /*
   class func ShowCustomActionView(onController:UIViewController, title:String, subTitle:String, items:[MenuItem], itemHeight:Int ,isShowCancel:Bool, isAllowDismissOnTap:Bool, alertResposeHandler: @escaping alertResposeHandlerWithIndex) {
        
        let dotmenupopupvc = MenuPopupSBReference.instance.DotMenuOptionActionVC
        //dotmenupopupvc.delegate = delegate!
        dotmenupopupvc.Items = items
        dotmenupopupvc.menuTitleText = title
        dotmenupopupvc.menuSubTitleText = subTitle
        dotmenupopupvc.isShowCancel = isShowCancel
        dotmenupopupvc.isAllowDismissOnTap = isAllowDismissOnTap
        
        //let menuItemHeight = 50
        dotmenupopupvc.menuHeight = CGFloat(itemHeight)
        
        var titleHeight:CGFloat = 0
        if dotmenupopupvc.menuTitleText != "" || dotmenupopupvc.menuSubTitleText != "" {
            titleHeight = 60
        }
        
        var cancelItemHeight:CGFloat = 0
        if dotmenupopupvc.isShowCancel == true{
            cancelItemHeight = dotmenupopupvc.menuHeight
        }
        
        dotmenupopupvc.contentSizeInPopup = CGSize(width:SCREEN_WIDTH, height: titleHeight + CGFloat(dotmenupopupvc.Items.count * itemHeight) +  cancelItemHeight + AppFunction.getsafeAreaBottomHeight())
        
        dotmenupopupvc.callBack = {(index, title) in
            print("CALL BACK :", title)
            alertResposeHandler(index, title)
        }

        let dotMenuPopUp = AppFunction.createOptionPopUp(containerVC: dotmenupopupvc)
        dotMenuPopUp.present(in:onController)
    }
    
    class func ShowCustomAlertView(onController:UIViewController,
                             btnTitles:[String]?,btnAlign:AlertBtnAlign ,alertTitle:String?, alertMessage:String?, alertImage:UIImage?,isAutoHide:Bool,allowTapDismiss:Bool,alertResposeHandler: @escaping alertResposeHandlerWithIndex)
    {
        
        // Create the dialog
        let popup = PopupDialog(title: alertTitle, message: alertMessage, image: alertImage, tapGestureDismissal:allowTapDismiss)
        
        popup.transitionStyle = .zoomIn
        
        if btnAlign == .horizontal {
            popup.buttonAlignment = .horizontal
        }else{
            popup.buttonAlignment = .vertical
        }
        //popup.tapGestureDismissal = false
        //popup.preferredContentSize = CGSize(width: 300, height: 250)
        
        let overlayAppearance = PopupDialogOverlayView.appearance()
        overlayAppearance.color           = .darkGray
        overlayAppearance.blurRadius      = 0.5
        overlayAppearance.blurEnabled     = false
        overlayAppearance.liveBlurEnabled = false
        overlayAppearance.opacity         = 0.4
        
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.backgroundColor      = .white
        dialogAppearance.titleFont            = .boldSystemFont(ofSize: 14)
        dialogAppearance.titleColor           = AppColor.AppBlue
        dialogAppearance.titleTextAlignment   = .center
        dialogAppearance.messageFont          = .systemFont(ofSize: 14)
        dialogAppearance.messageColor         = AppColor.TextLightBlack
        dialogAppearance.messageTextAlignment = .center
        
        
        let containerAppearance = PopupDialogContainerView.appearance()
        containerAppearance.backgroundColor = AppColor.OffWhite
        containerAppearance.cornerRadius    = 4
        containerAppearance.shadowEnabled   = true
        containerAppearance.shadowColor     = .black
        containerAppearance.shadowOpacity   = 0.4
        containerAppearance.shadowRadius    = 5
        containerAppearance.shadowOffset    = CGSize(width: 1, height:1)
        //containerAppearance.shadowPath      = CGPath(...)
        
 
        let buttonAppearance = DefaultButton.appearance()
        // Default button
        buttonAppearance.titleFont      = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .medium)
        buttonAppearance.titleColor     = UIColor.white
        buttonAppearance.buttonColor    = AppColor.AppBlue
        buttonAppearance.separatorColor = UIColor(white: 0.9, alpha: 1)
        
        if let btns = btnTitles {
            
            var popUpButtons = [DefaultButton]()
            
            for i in 0..<btns.count{
                
                let button = DefaultButton(title: btns[i]) {
                    alertResposeHandler(i, btns[i])
                }
                popUpButtons.append(button)
            }
            popup.addButtons(popUpButtons)
        }else{
            popup.autoDissmissDialogAfterDelay(delayTime:3.0)
        }

        if isAutoHide {
            popup.autoDissmissDialogAfterDelay(delayTime:3.0)
        }
        
        // Present dialog
        onController.present(popup, animated: true, completion: nil)
        
    }
    
    class func showMessageBarWithImage(_ title: String, message: String, image:UIImage) {
        
        let infoImage = AppImage.icon.infoInRound?.tintedWithColor(color:AppColor.TanGold)
        let customNotification = CustomCRNotification(textColor: UIColor.gray, backgroundColor: UIColor.white, image: infoImage)
        CRNotifications.showNotification(type: customNotification, title: title, message: message, dismissDelay:5)
        
    }

    class func showMessageBar(_ theme: Theme, strMessage: String) {
        
        switch theme {
         
        case .info:
            
            ISMessages.showCardAlert(withTitle:"Info", message: strMessage, duration: 2.0, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.info, alertPosition: ISAlertPosition.top) { (isHidden) in
                if isHidden {
                    print("Alert is hidden")
                }
            }
            ISMessages.hideAlert(animated: true)

        case .success:
            
            let successImage = AppImage.icon.checkInRound?.tintedWithColor(color:AppColor.TanGreen)
            
            let customNotification = CustomCRNotification(textColor: UIColor.gray, backgroundColor: UIColor.white, image: successImage)
            CRNotifications.showNotification(type: customNotification, title: "Success", message: strMessage, dismissDelay: 2.0)
            
        case .warning:
            
            let infoImage = AppImage.icon.infoInRound?.tintedWithColor(color:AppColor.TanGold)
            let customNotification = CustomCRNotification(textColor: UIColor.gray, backgroundColor: UIColor.white, image: infoImage)
            CRNotifications.showNotification(type: customNotification, title: "Warning", message: strMessage, dismissDelay: 2.0)
            
        case .error:
            
            let errorImage = AppImage.icon.closeInRound?.tintedWithColor(color:AppColor.TanRed)
            let customNotification = CustomCRNotification(textColor: UIColor.gray, backgroundColor: UIColor.white, image: errorImage)
            CRNotifications.showNotification(type: customNotification, title: "Error", message: strMessage, dismissDelay: 2.0)
            
        }
    }
    
    class func showErrorBar(errTitle:String, errMessage:String) {

        let errorImage = AppImage.icon.closeInRound?.tintedWithColor(color:AppColor.TanRed)
        let customNotification = CustomCRNotification(textColor: UIColor.gray, backgroundColor: UIColor.white, image: errorImage)
        CRNotifications.showNotification(type: customNotification, title: errTitle, message: errMessage, dismissDelay: 2.0)
    }*/
}

