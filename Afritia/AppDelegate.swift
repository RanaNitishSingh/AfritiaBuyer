//
//  AppDelegate.swift
//  Magento2V4Theme
//
//  Created by Webkul on 07/02/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

import FirebaseAnalytics
import FirebaseMessaging
import UserNotifications
import Firebase
import Siren
import GoogleMaps
import RealmSwift
import GoogleSignIn
//import FBSDKCoreKit
//import TwitterKit
import Stripe
import IQKeyboardManagerSwift
import DropDown

//global
var deviceTokenData = ""


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    /*
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }*/
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        STPAPIClient.shared.publishableKey = appConstant.stripePublishKeyTest
        
        if #available(iOS 11.0, *) {
            UIImageView.appearance().accessibilityIgnoresInvertColors = true
        }
        UITabBar.appearance().tintColor =  UIColor.button
        GMSServices.provideAPIKey(appConstant.googleAPIKey)
        
        //version update
        self.setupSiren()
        
        IQKeyboardManager.shared.enable = true
        
        let languageCode = UserDefaults.standard
        if languageCode.string(forKey: "language") == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        //Push
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: Notification.Name.MessagingRegistrationTokenRefreshed,
                                               object: nil)
        
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        //Google sign in setup
        GIDSignIn.sharedInstance()?.clientID = appConstant.googleLoginClientID
        GIDSignIn.sharedInstance()?.delegate = self
      
        
        
        //Facebook
//        ApplicationDelegate.shared.application(
//                    application,
//                    didFinishLaunchingWithOptions: launchOptions
//                )
        
        //Twitter ranjit stop
        //TWTRTwitter.sharedInstance().start(withConsumerKey:TWITTER_CONSUMER_KEY, consumerSecret:TWITTER_CONSUMER_SECRET_KEY)
        
        DropDown.startListeningToKeyboard()
        
        /*
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }*/
        
        //Notification setup
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        //
        
        if let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.application(application, didReceiveRemoteNotification: remoteNotif)
            })
        }
        
        self.realamMigration()
        
        return true
    }
    
    
    //MARK:- Google siignIn Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("user email : \(user.profile.email ?? "No Email found")")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let googleHandler = GIDSignIn.sharedInstance().handle(url as URL,
                                                              sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?,
                                                              annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
      //  let fbHandler = ApplicationDelegate.shared.application(app, open: url,
      //      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
      //      annotation: options[UIApplication.OpenURLOptionsKey.annotation]
      //  )
        //let twitterHandler = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        return googleHandler //|| fbHandler //|| twitterHandler
    }
    
    

    
    
    
    
    func realamMigration(){
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).

            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        var _:Realm = {
            return try! Realm()
        }()
    }
    
    
    //MARK:- Version Update
    func setupSiren() {
        let siren = Siren.shared
        // Optional
        //siren.delegate = self
        // Optional
        //siren.debugEnabled = true
        
        // Optional - Defaults to .Option
        //        siren.alertType = .option // or .force, .skip, .none
        
        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
        //        siren.majorUpdateAlertType = .option
        //        siren.minorUpdateAlertType = .option
        //        siren.patchUpdateAlertType = .option
        //        siren.revisionUpdateAlertType = .option
        
        //siren.alertType = .option
    }
    
    //MARK:- Push Notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var tokenq = ""
        
        for i in 0..<deviceToken.count {
            tokenq = tokenq + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        deviceTokenData = tokenq;
        Messaging.messaging().apnsToken = deviceToken as Data
        
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        if Messaging.messaging().fcmToken != nil {
            print("SSSSSSSS")
            
            Messaging.messaging().subscribe(toTopic: "/topics/getkart_ios")
        }
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        /*if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            deviceTokenData = refreshedToken
            let defaults = UserDefaults.standard;
            defaults.set(refreshedToken, forKey: "deviceToken");
            defaults.synchronize()
            callingHttppApi();
            Messaging.messaging().subscribe(toTopic: "/topics/getkart_ios")
        }*/
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
      /*  guard InstanceID.instanceID().token() != nil else {
            return;
        }
        
        Messaging.messaging().subscribe(toTopic: "/topics/getkart_ios")
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().disconnect()
        
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        } */
    }
    
    func callingHttppApi(){
        var requstParams = [String:Any]();
        let customerId = DEFAULTS.object(forKey:"customerId")
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }else{
            requstParams["customerToken"] = ""
        }
        requstParams["token"] = deviceTokenData
        requstParams["os"] = "ios"
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.registerDevice, currentView: UIViewController()){success,responseObject in
            if success == 1{
                print(responseObject!)
            }else if success == 2{
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        
        if UIApplication.shared.applicationState == .inactive {// tap
            if userInfo["notificationType"] as! String  == "category"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "product"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "custom"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "other"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil, userInfo: userInfo)
            }
        }else if UIApplication.shared.applicationState == .background{
            var count:Int = 0;
            if DEFAULTS.object(forKey: "notificationCount") != nil{
                let stored = (DEFAULTS.object(forKey: "notificationCount") as! String);
                count = Int(stored)! + 1;
                let data =  String(format: "%d", count as CVarArg)
                DEFAULTS.set(data, forKey: "notificationCount");
                
            }else{
                DEFAULTS.set("1", forKey: "notificationCount");
                count = 1;
            }
            if count > 0{
                application.applicationIconBadgeNumber = count;
            }
        }
    }
    //MARK:-
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        GlobalData.sharedInstance.remainderNotificationCall()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //version update
        //Siren.shared.checkVersion(checkType: .immediately)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        DEFAULTS.set("0", forKey: "notificationCount")
        application.applicationIconBadgeNumber = 0;
        
        //version update
        //Siren.shared.checkVersion(checkType: .immediately)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//MARK:- Push in Foreground
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller
            if let tabVC = topController as? UITabBarController   {
                tabVC.selectedIndex = 0
                let navigation:UINavigationController = (topController as! UITabBarController).viewControllers?[0] as! UINavigationController
                navigation.popToRootViewController(animated: true)
            }
        }
        
        let type =  response.notification.request.identifier
        
        if type != "appuse"{
            if userInfo["notificationType"] as! String  == "category"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "product"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "custom"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "other"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil, userInfo: userInfo)
            }
        }
        
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        Messaging.messaging().subscribe(toTopic: "/topics/afritia_ios")
       // Messaging.messaging().shouldEstablishDirectChannel = true
        connectToFcm()
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
    // [END ios_10_data_message]
}

//MARK:- Font Style
struct AppFontName {
    static let regular = REGULARFONT
    static let bold = BOLDFONT
    static let italic = ITALICFONT
}



/*
//MARK:- Siren (App Version)
extension AppDelegate: SirenDelegate
{
    func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
        print(#function, alertType)
    }
    
    func sirenUserDidCancel() {
        print(#function)
    }
    
    func sirenUserDidSkipVersion() {
        print(#function)
    }
    
    func sirenUserDidLaunchAppStore() {
        print(#function)
    }
    
    func sirenDidFailVersionCheck(error: Error) {
        print(#function, error)
    }
    
    func sirenLatestVersionInstalled() {
        print(#function, "Latest version of app is installed")
    }
    
    func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: SirenLookupModel) {
        print(#function, "\(lookupModel)")
    }
    
    // This delegate method is only hit when alertType is initialized to .none
    func sirenDidDetectNewVersionWithoutAlert(title: String, message: String, updateType: UpdateType) {
        print(#function, "\n\(title)\n\(message).\nRelease type: \(updateType.rawValue.capitalized)")
    }
}
*/
