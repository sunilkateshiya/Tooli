//
//  AppDelegate.swift
//  Tooli
//
//  Created by Moin Shirazi on 02/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import ObjectMapper
import UserNotifications
import CoreLocation
import Fabric
import Crashlytics
import SwiftR
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var navigationController: MyNavigationController?
    var window: UIWindow?
    var sharedManager : Globals = Globals.sharedInstance
    var locationManager = CLLocationManager()
    var coordinate : CLLocationCoordinate2D!
    var addressString : String!
    var IsMapFirst : Bool!
    let persistentConnection = SignalR("http://tooli.blush.cloud/chat", connectionType: .persistent)
    var isActiveChat : Bool = false;
    var buddyList : ChatList!
    var currentHistory : ChatHistory!
    var currentMessage : MessageList!
    var newMessage : Messages!
    
    
    override init() {
        coordinate=CLLocationCoordinate2DMake(0, 0)
    }
    class func sharedInstance() -> (AppDelegate)
    {
        let sharedinstance = UIApplication.shared.delegate as! AppDelegate
        return sharedinstance
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         GMSPlacesClient.provideAPIKey(Constants.Keys.GOOGLE_PLACE_KEY)
        IsMapFirst = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        IQKeyboardManager.sharedManager().enable = true
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: Constants.KEYS.LOGINKEY) != nil) == true{
            
            if userDefaults.value(forKey: Constants.KEYS.LOGINKEY)! as! Bool == false {
                moveToLogin()
                
            }
            else {
                let userinfo  = userDefaults.object(forKey: Constants.KEYS.USERINFO)
                
                self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: userinfo)
                
                if  self.sharedManager.currentUser.IsSetupProfile {
                    //moveToEditPortfolio()
                    moveToDashboard()
                    //moveToInfo()
                }
                else {
                    moveToInfo()
                }
            }
        }
            
        else{
            moveToLogin()
        }
        
        registerForRemoteNotification()
        UIApplication.shared.applicationIconBadgeNumber = 0

        self.initSignalR();
        
        Fabric.with([Crashlytics.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        self.sharedManager.deviceToken = deviceTokenString
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.sharedManager.deviceToken = "1234"
        print("i am not available in simulator \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        let CompanyID = userInfo["CompanyID"]
        let PrimaryID = userInfo["PrimaryID"]
        let NotificationStatusID = userInfo["NotificationStatusID"] as! Int
        let ContractorID = userInfo["ContractorID"]
        let IsContractor : Bool = (userInfo["IsContractor"]) as! Bool
        let tab : CustomTabBarC = self.navigationController!.viewControllers[0] as! CustomTabBarC;
        if NotificationStatusID == 1 {
            // MESSAGE VC
            let msgVC : MessageTab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageTab") as! MessageTab
            msgVC.selectedSenderId = PrimaryID as! Int
            msgVC.isNext = true
            self.navigationController?.pushViewController(msgVC, animated: true)
            
        } else if NotificationStatusID == 2 {
            // Applied to JOb --> Notification VC
            if  (self.navigationController?.viewControllers.count)! > 1 {
                self.navigationController?.popToRootViewController(animated: false)
            }
            if (tab.selectedIndex != 3){
                tab.selectedIndex = 3;
            }
        } else if NotificationStatusID == 3 {
            
            if  IsContractor {
                let profile : ProfileFeed = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                profile.contractorId = ContractorID as! Int
                self.navigationController?.pushViewController(profile, animated: true)
            }
            else {
                let companyVC : CompnayProfilefeed = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                companyVC.companyId = CompanyID as! Int
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
            
        } else if NotificationStatusID == 4 {
            // Followed via shared link -> Profile VC
            if  IsContractor {
                let profile : ProfileFeed = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                profile.contractorId = ContractorID as! Int
                self.navigationController?.pushViewController(profile, animated: true)
            }
            else {
                let companyVC : CompnayProfilefeed = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                companyVC.companyId = CompanyID as! Int
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
            
        } else if NotificationStatusID == 5
        {
            // Posted New offeer -> Offer VC
            let companyVC : OfferDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            companyVC.OfferId = PrimaryID as! Int
            companyVC.isNotification = true
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else if NotificationStatusID == 6
        {
            let msgVC : MessageTab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageTab") as! MessageTab
            msgVC.selectedSenderId = PrimaryID as! Int
            self.navigationController?.pushViewController(msgVC, animated: true)
        }
    }
    
    @available(iOS 10.0, *)
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        let CompanyID = response.notification.request.content.userInfo["CompanyID"]
        let PrimaryID = response.notification.request.content.userInfo["PrimaryID"]
        let NotificationStatusID = response.notification.request.content.userInfo["NotificationStatusID"] as! Int
        let ContractorID = response.notification.request.content.userInfo["ContractorID"]
        let IsContractor : Bool = (response.notification.request.content.userInfo["IsContractor"]) as! Bool
        let tab : CustomTabBarC = self.navigationController!.viewControllers[0] as! CustomTabBarC;
        if NotificationStatusID == 1 {
            // MESSAGE VC
            let msgVC : MessageTab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageTab") as! MessageTab
            msgVC.selectedSenderId = PrimaryID as! Int
            msgVC.isNext = true
            self.navigationController?.pushViewController(msgVC, animated: true)
            
        } else if NotificationStatusID == 2 {
            // Applied to JOb --> Notification VC
            if  (self.navigationController?.viewControllers.count)! > 1 {
                self.navigationController?.popToRootViewController(animated: false)
            }
            if (tab.selectedIndex != 3){
                tab.selectedIndex = 3;
            }
        } else if NotificationStatusID == 3 {
            
            if  IsContractor {
                let profile : ProfileFeed = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                profile.contractorId = ContractorID as! Int
                self.navigationController?.pushViewController(profile, animated: true)
            }
            else {
                let companyVC : CompnayProfilefeed = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                companyVC.companyId = CompanyID as! Int
                self.navigationController?.pushViewController(companyVC, animated: true)
            }

        } else if NotificationStatusID == 4 {
            // Followed via shared link -> Profile VC
            if  IsContractor {
                let profile : ProfileFeed = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                profile.contractorId = ContractorID as! Int
                self.navigationController?.pushViewController(profile, animated: true)
            }
            else {
                let companyVC : CompnayProfilefeed = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                companyVC.companyId = CompanyID as! Int
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
            
        } else if NotificationStatusID == 5
        {
            // Posted New offeer -> Offer VC
            let companyVC : OfferDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            companyVC.OfferId = PrimaryID as! Int
            companyVC.isNotification = true
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else if NotificationStatusID == 6
        {
         
            
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    func moveToPortfolio(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
        let initialViewController : Addportfolio = storyboard.instantiateViewController(withIdentifier: "Addportfolio") as! Addportfolio
        self.navigationController?.viewControllers = [initialViewController]
        self.window?.rootViewController = self.navigationController
    }
    func moveToEditPortfolio(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
        let initialViewController : PortfolioDetails = storyboard.instantiateViewController(withIdentifier: "PortfolioDetails") as! PortfolioDetails
        
        self.navigationController?.viewControllers = [initialViewController]
        self.window?.rootViewController = self.navigationController
    }
    
    func moveToLogin()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
        let initialViewController : Login = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
        self.navigationController!.viewControllers = [initialViewController]
        self.window?.rootViewController = self.navigationController
        
    }
    
    func moveToDashboard()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
        self.navigationController?.viewControllers = [initialViewController]
        self.window?.rootViewController = self.navigationController

    }
    func moveToInfo()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
        let initialViewController : Info = storyboard.instantiateViewController(withIdentifier: "Info") as! Info

        //let initialViewController : RatesTravel = storyboard.instantiateViewController(withIdentifier: "RatesTravel") as! RatesTravel
        self.navigationController?.viewControllers = [initialViewController]
        self.window?.rootViewController = self.navigationController

    }

    func applicationWillResignActive(_ application: UIApplication) {
            disconnectSignalR()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
   
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        disconnectSignalR()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        initSignalR()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        disconnectSignalR()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (IsMapFirst == true) {
            
            IsMapFirst = false
            coordinate = manager.location!.coordinate
            let locValue : CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatelocation"), object: nil)
        }
        
    }
    func initSignalR(){
        var qs : [String:AnyObject] = [:]
        guard (sharedManager.currentUser != nil) else {
            return
        }
        
        if self.isActiveChat || self.persistentConnection.state == .connected {
            return
        }
        
        
        qs["UserID"] = sharedManager.currentUser.UserID as AnyObject?
        qs["Platform"] = "ios" as AnyObject?
        
        persistentConnection.queryString=qs
        
        // Receievd
        persistentConnection.received = { data in
            guard (data != nil) else {
                return
            }
            
            
            let data1 = Globals.convertToDictionary(text: data as! String)
            print(data1)
            
            switch data1!["status"]! as! String {
            case "buddylist":
                self.buddyList  = Mapper<ChatList>().map(JSONObject: data1)
                
                if self.buddyList == nil {
                    return
                }
                NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED), object: nil) as Notification)
                print(self.buddyList)
                break;
            case "chathistory":
                self.currentHistory = Mapper<ChatHistory>().map(JSONObject: data1)
                NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: Constants.Notifications.CHATHISTORYRETRIVED), object: nil) as Notification)
                break;
            case "messagereceive":
                self.newMessage = Mapper<Messages>().map(JSONObject: data1)
                NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: Constants.Notifications.MESSAGERECEIVED), object: nil) as Notification)
                break;
            default:
                break;
            }
            
            
        }
        persistentConnection.start()
        
        // Connected
        
        persistentConnection.connected = {
            
            self.isActiveChat = true
            
            self.persistentConnection.send(Command.buddyListCommand())
            
        }
        persistentConnection.connectionFailed = { error in
            print(error);
        }
        persistentConnection.connectionSlow = {
            print("slow connection")
        }
        
    }
    func disconnectSignalR()
    {
        if isActiveChat {
            self.isActiveChat = false
            if self.persistentConnection.state == .connected {
                
                print("Sending offline--------------")
                
                self.persistentConnection.stop()
            }
        }
    }
    func setSearchBarWhiteColor(SearchbarView:UISearchBar){
        
        let textFieldInsideSearchBar = SearchbarView.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.white
        let glassIconView = textFieldInsideSearchBar?.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        glassIconView.tintColor = UIColor.white
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor.white
    }
}

