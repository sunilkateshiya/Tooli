//
//  AppDelegate.swift
//  Tooli
//
//  Created by impero on 02/01/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import ObjectMapper
import UserNotifications
import CoreLocation
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces
import GLNotificationBar
import FirebaseCore
import Firebase
import FirebaseMessaging
import SwiftR
import SwiftyJSON
import NVActivityIndicatorView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate,FIRMessagingDelegate,NVActivityIndicatorViewable
{
    var navigationController: MyNavigationController?
    var window: UIWindow?
    var sharedManager : Globals = Globals.sharedInstance
    var locationManager = CLLocationManager()
    var coordinate : CLLocationCoordinate2D!
    var addressString : String!
    
    var simpleHub: Hub!
    var hubConnection: SignalR!
    
    var buddyList:GetAllBuddyList = GetAllBuddyList()
    var MsgListOfBuddy:GetBuddyMsgList = GetBuddyMsgList()
    
    var isConnected:Bool = false
    var cureentChatUserId:String = ""
    var isChatActive:Bool = false
    var popUpView:PopupView?
    
    override init()
    {
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

        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        

        
        if (UserDefaults.standard.value(forKey: Constants.KEYS.TOKEN) == nil)
        {
            UserDefaults.standard.set("", forKey: Constants.KEYS.TOKEN)
        }
        if (UserDefaults.standard.value(forKey: Constants.KEYS.LOGINKEY) == nil)
        {
            UserDefaults.standard.set(false, forKey: Constants.KEYS.LOGINKEY)
        }
        if (UserDefaults.standard.value(forKey: Constants.KEYS.IS_SET_PROFILE) == nil)
        {
            UserDefaults.standard.set(false, forKey: Constants.KEYS.IS_SET_PROFILE)
        }
        if (UserDefaults.standard.value(forKey: Constants.KEYS.USERINFO) == nil)
        {
            let UserData : UserDataM = UserDataM()
            let serializedUser1 = Mapper().toJSON(UserData)
            print(serializedUser1)
            let userDefaults = UserDefaults.standard
            userDefaults.set(serializedUser1, forKey: Constants.KEYS.USERINFO)
            userDefaults.synchronize()
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        IQKeyboardManager.sharedManager().enable = true
        
        if UserDefaults.standard.value(forKey: Constants.KEYS.LOGINKEY) as! Bool == true
        {
            if UserDefaults.standard.value(forKey: Constants.KEYS.IS_SET_PROFILE) as! Bool == true
            {
                moveToDashboard()
            }
            else
            {
                moveToInfo()
            }
        }
        else
        {
           // testNaviGation()
            MoveToLoginScreen()
        }
        Fabric.with([Crashlytics.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Optional: configure GAI options.
        
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true
        registerForRemoteNotification()
        return true
    }
    func addNoDataView(view:UIView,frame:CGRect,viewController:UIViewController,strMsg:String)
    {
        removeNoDataView()
        AppDelegate.sharedInstance().popUpView = PopupView(frame:frame)
        AppDelegate.sharedInstance().popUpView?.frame = frame
        AppDelegate.sharedInstance().popUpView?.delegate = viewController as? RetryButtonDeleget
        view.addSubview(AppDelegate.sharedInstance().popUpView!)
        AppDelegate.sharedInstance().popUpView?.lblTitle.text = strMsg
        
    }
    func removeNoDataView()
    {
        if(AppDelegate.sharedInstance().popUpView != nil)
        {
            AppDelegate.sharedInstance().popUpView?.removeFromSuperview()
        }
    }
    func registerForRemoteNotification()
    {
        if #available(iOS 10.0, *)
        {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                    FIRMessaging.messaging().remoteMessageDelegate = self
                    
                    print(FIRInstanceID.instanceID().token() ?? "Not found Token")
                }
            }
        }
        else
        {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            
        }
        FIRApp.configure()
        FIRMessaging.messaging().remoteMessageDelegate = self
        print(FIRInstanceID.instanceID().token() ?? "Not found Token")
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .unknown)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        self.sharedManager.deviceToken = deviceTokenString
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        self.sharedManager.deviceToken = "1234"
        print("i am not available in simulator \(error)")
    }
    func messaging(_ messaging: FIRMessaging, didRefreshRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
    }
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage)
    {
        print(remoteMessage.appData)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    {
         print(userInfo)
        if(UIApplication.shared.applicationState == .active)
        {
            var temp = JSON(userInfo)
            let notificationBar = GLNotificationBar(title: "Tooli", message: temp["aps"]["alert"]["body"].string , preferredStyle: .simpleBanner, handler: { (true) in
                self.RedirectFromNotification(userInfo)
            })
            notificationBar.showTime(2)
            return
        }
        else
        {
          RedirectFromNotification(userInfo)
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
         print(response.notification.request.content.userInfo)
        if(UIApplication.shared.applicationState == .active)
        {
            var temp = JSON(response.notification.request.content.userInfo)
            let notificationBar = GLNotificationBar(title: "Tooli", message: temp["aps"]["alert"]["body"].string , preferredStyle: .simpleBanner, handler: { (true) in
                self.RedirectFromNotification(response.notification.request.content.userInfo)
            })
            notificationBar.showTime(2)
            return
        }
        else
        {
             RedirectFromNotification(response.notification.request.content.userInfo)
        }
        print(response.notification.request.content.userInfo)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
    }
    
    func RedirectFromNotification(_ userInfo:[AnyHashable : Any])
    {
        print(userInfo)
        print(JSON(userInfo))
        var temp = JSON(userInfo)
        let NotificationStatusID = Int(temp["NotificationStatus"].string!)!
        let Role = Int(temp["Role"].string!)!
        let NotificationPageTypeID = Int(temp["NotificationPageType"].string!)!
        let UserID = temp["UserID"].string!
        let TablePrimaryID = Int(temp["TablePrimaryID"].string!)!
        
        if NotificationStatusID == 0
        {
            // MESSAGE VC
            switch NotificationPageTypeID
            {
            case 0:
                self.moveToDashboard()
                break
            case 1:
                self.moveToDashboard()
                break
            case 2:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 1
                self.navigationController?.viewControllers = [initialViewController]
                self.window?.rootViewController = self.navigationController
                break
            case 3:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 3
                self.navigationController?.viewControllers = [initialViewController]
                self.window?.rootViewController = self.navigationController
                break
            case 4:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 4
                self.navigationController?.viewControllers = [initialViewController]
                self.window?.rootViewController = self.navigationController
                break
            case 5:
                let msgVC  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 4
                self.navigationController?.viewControllers = [initialViewController,msgVC]
                self.window?.rootViewController = self.navigationController
                break
            case 6:
                let msgVC : SpecialOfferList = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpecialOfferList") as! SpecialOfferList
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 0
                self.navigationController?.viewControllers = [initialViewController,msgVC]
                self.window?.rootViewController = self.navigationController
                break
                
            case 7:
                let msgVC : SpecialOfferList = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpecialOfferList") as! SpecialOfferList
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 0
                self.navigationController?.viewControllers = [initialViewController,msgVC]
                self.window?.rootViewController = self.navigationController
                break
            case 8:
                let msgVC : SavedView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SavedView") as! SavedView
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 0
                self.navigationController?.viewControllers = [initialViewController,msgVC]
                self.window?.rootViewController = self.navigationController
                break
            case 9:
                let msgVC : Connections = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Connections") as! Connections
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 0
                self.navigationController?.viewControllers = [initialViewController,msgVC]
                self.window?.rootViewController = self.navigationController
                break
            case 10:
                let msgVC : Referrals = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Referrals") as! Referrals
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 0
                self.navigationController?.viewControllers = [initialViewController,msgVC]
                self.window?.rootViewController = self.navigationController
                break
            case 11:
                let msgVC : Statistics = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Statistics") as! Statistics
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 0
                self.navigationController?.viewControllers = [initialViewController,msgVC]
                self.window?.rootViewController = self.navigationController
                break
            case 12:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 2
                self.navigationController?.viewControllers = [initialViewController]
                self.window?.rootViewController = self.navigationController
                break
                
            case 13:
                let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                port.strUrl = "https://www.tooli.co.uk/Files/Document/Terms_Condition.pdf"
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 0
                self.navigationController?.viewControllers = [initialViewController,port]
                self.window?.rootViewController = self.navigationController
                break
            case 14:
                let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                port.strUrl = "https://www.tooli.co.uk/Files/Document/Privacy_Policy.pdf"
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 0
                self.navigationController?.viewControllers = [initialViewController,port]
                self.window?.rootViewController = self.navigationController
                break
            case 15:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! UITabBarController
                initialViewController.selectedIndex = 0
                self.navigationController?.viewControllers = [initialViewController]
                self.window?.rootViewController = self.navigationController
                self.callWSSignOut()
                break
            default:
                self.moveToDashboard()
                break
            }
        }
        else if NotificationStatusID == 1
        {
            // MESSAGE VC
            let msgVC : MessageTab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageTab") as! MessageTab
            self.navigationController?.pushViewController(msgVC, animated: true)
            
        } else if NotificationStatusID == 2
        {
            // Applied to JOb --> Notification VC
            let tab : CustomTabBarC = self.navigationController!.viewControllers[0] as! CustomTabBarC;
            if  (self.navigationController?.viewControllers.count)! > 1
            {
                self.navigationController?.popToRootViewController(animated: false)
            }
            if (tab.selectedIndex != 3)
            {
                tab.selectedIndex = 3;
            }
        } else if NotificationStatusID == 3
        {
            if(Role == 1)
            {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                vc.userId = UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if(Role == 2)
            {
                print("Company")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
                vc.userId = UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if(Role == 3)
            {
                print("Supplier")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
                vc.userId = UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if NotificationStatusID == 4
        {
            let companyVC : OfferDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            companyVC.OfferId = TablePrimaryID
            companyVC.isNotification = true
            self.navigationController?.pushViewController(companyVC, animated: true)
            
        } else if NotificationStatusID == 5
        {
            if(Role == 1)
            {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                vc.userId = UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if(Role == 2)
            {
                print("Company")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
                vc.userId = UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if(Role == 3)
            {
                print("Supplier")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
                vc.userId = UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func moveToPortfolio()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
        let initialViewController : Addportfolio = storyboard.instantiateViewController(withIdentifier: "Addportfolio") as! Addportfolio
        self.navigationController?.viewControllers = [initialViewController]
        self.window?.rootViewController = self.navigationController
    }
    func moveToEditPortfolio()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
        let initialViewController : PortfolioDetails = storyboard.instantiateViewController(withIdentifier: "PortfolioDetails") as! PortfolioDetails
        
        self.navigationController?.viewControllers = [initialViewController]
        self.window?.rootViewController = self.navigationController
    }
    
    func MoveToLoginScreen()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
        let initialViewController : Login = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
        self.navigationController!.viewControllers = [initialViewController]
        self.window?.rootViewController = self.navigationController
    }
    
    func moveToDashboard()
    {
        let userDefaults = UserDefaults.standard
        let userinfo  = userDefaults.object(forKey: Constants.KEYS.USERINFO)
        self.sharedManager.currentUser = Mapper<UserDataM>().map(JSONObject: userinfo)!
        
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
        let initialViewController : SignUpVC1 = storyboard.instantiateViewController(withIdentifier: "SignUpVC1") as! SignUpVC1

        //let initialViewController : RatesTravel = storyboard.instantiateViewController(withIdentifier: "RatesTravel") as! RatesTravel
        self.navigationController?.viewControllers = [initialViewController]
        self.window?.rootViewController = self.navigationController

    }

    func testNaviGation()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = storyboard.instantiateViewController(withIdentifier: "MyNavigationController") as? MyNavigationController
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "EditContractorProfile") as! EditContractorProfile
        self.navigationController?.viewControllers = [initialViewController]
        self.window?.rootViewController = self.navigationController
    }
    func applicationWillResignActive(_ application: UIApplication)
    {
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: Constants.KEYS.LOGINKEY) != nil) == true{
            
            if userDefaults.value(forKey: Constants.KEYS.LOGINKEY)! as! Bool == true
            {
                disconnectSignalR()
            }
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: Constants.KEYS.LOGINKEY) != nil) == true{
            
            if userDefaults.value(forKey: Constants.KEYS.LOGINKEY)! as! Bool == true
            {
                disconnectSignalR()
            }
        }
       
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        let userDefaults = UserDefaults.standard
//        if (userDefaults.value(forKey: Constants.KEYS.LOGINKEY) != nil) == true{
//            
//            if userDefaults.value(forKey: Constants.KEYS.LOGINKEY)! as! Bool == true {
//                initSignalR()
//                
//            }
//        }
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: Constants.KEYS.LOGINKEY) != nil) == true{
            
            if userDefaults.value(forKey: Constants.KEYS.LOGINKEY)! as! Bool == true
            {
                if(self.hubConnection != nil)
                {
                     self.hubConnection.start()
                }
                else
                {
                    initSignalR()
                }
               
            }
        }
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        disconnectSignalR()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func GetNotificationCount()
    {
        do
        {
            try AppDelegate.sharedInstance().simpleHub.invoke("SendNotificationUpdates", arguments: [AppDelegate.sharedInstance().sharedManager.currentUser.UserID])
        }
        catch
        {
            print(error)
        }
    }
    func initSignalR()
    {
        //http://192.168.2.239/TOOLiChat_Dev

        print("Call the SignalR")
        if(AppDelegate.sharedInstance().sharedManager.currentUser.UserID == "")
        {
            return
        }
        if(hubConnection != nil)
        {
            if(hubConnection.state == .connected)
            {
                return
            }
        }
        
        hubConnection = SignalR(Constants.URLS.ChatUrl_Base_Url)
        hubConnection.queryString = ["UserID": AppDelegate.sharedInstance().sharedManager.currentUser.UserID]
        simpleHub = Hub("chatHub")
        
        hubConnection.addHub(simpleHub)
        
       simpleHub.on("receivedConversation") { args in
         print("Message: \(String(describing: args))")
        self.MsgListOfBuddy = Mapper<GetBuddyMsgList>().map(JSONObject: JSON(args).array?[0].rawValue)!
        if(self.isChatActive)
        {
            if(self.cureentChatUserId == self.MsgListOfBuddy.Result.last?.ChatUserID)
            {
                do {
                    try AppDelegate.sharedInstance().simpleHub.invoke("ReadMessage", arguments: ["\(self.MsgListOfBuddy.Result.last!.ChatMessageID)"])
                }
                catch
                {
                    print(error)
                }
            }
        }
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: Constants.Notifications.CHATHISTORYRETRIVED), object: nil) as Notification)
        
            // self.stopAnimating()
        }
        simpleHub.on("fireDisconnect") { args in
            print("Message: \(String(describing: args))")
            self.hubConnection.stop()
            self.hubConnection.start()
        }
        simpleHub.on("receivedSendNotificationUpdates") { args in
            print("Message: \(String(describing: args))")
            print(Mapper<UnreadCountResponse>().map(JSONObject:JSON(args).array?[0].rawValue)!)
        }
        simpleHub.on("receivedBuddyList") { args in
             print("Message: \(String(describing: args))")
            if((JSON(args).array?.count)!  <= 0)
            {
                return
            }
            
            self.buddyList = Mapper<GetAllBuddyList>().map(JSONObject:JSON(args).array?[0].rawValue)!
            NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED), object: nil) as Notification)
        }
        simpleHub.on("receivedMessage") { args in
            print("Message: \(String(describing: args))")
            if((JSON(args).array?.count)!  <= 0)
            {
                return
            }
            let temp:GetBuddyMsgList  = Mapper<GetBuddyMsgList>().map(JSONObject: JSON(args).array?[0].rawValue)!
            
            for tm in temp.Result
            {
                if(self.isChatActive)
                {
                    if(self.cureentChatUserId == tm.ChatUserID)
                    {
                        self.MsgListOfBuddy.Result.append(tm)
                        
                         NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: Constants.Notifications.MESSAGERECEIVED), object: nil) as Notification)
                        do {
                            try AppDelegate.sharedInstance().simpleHub.invoke("ReadMessage", arguments: ["\(tm.ChatMessageID)"])
                        }
                        catch
                        {
                            print(error)
                        }
                    }
                }
                else
                {
                    if(!tm.IsSendByMe)
                    {
                        let notificationBar = GLNotificationBar(title: "\(tm.Name) has sent you a message.", message: tm.MessageText , preferredStyle: .simpleBanner, handler: { (true) in
                            let chatDetail : MessageDetails = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageDetails") as! MessageDetails
                            let currentBuddy : BuddyM = BuddyM()
                            currentBuddy.IsReadLastMessage = true
                            currentBuddy.Role = tm.Role
                            currentBuddy.ChatUserID = tm.ChatUserID
                            currentBuddy.Name = tm.Name
                            chatDetail.currentBuddy = currentBuddy
                            self.navigationController?.pushViewController(chatDetail, animated: true)
                        })
                      notificationBar.showTime(2)
                    }
                    do
                    {
                        try AppDelegate.sharedInstance().simpleHub.invoke("GetBuddyList", arguments: [])
                    }
                    catch
                    {
                        print(error)
                    }
                }
            }
        }
        hubConnection.starting = { [weak self] in
            print("Starting...")
        }
        
        hubConnection.reconnecting = { [weak self] in
            print("Reconnecting...")
        }
        
        hubConnection.connected = { [weak self] in
            self?.isConnected = true
            print("Connected. Connection ID: \(String(describing: self!.hubConnection.connectionID))")
        }
        
        hubConnection.reconnected = { [weak self] in
            print("Reconnected. Connection ID: \(String(describing: self!.hubConnection.connectionID))")
        }
        
        hubConnection.disconnected = { [weak self] in
            self?.isConnected = false
            print("Disconnected.")
        }
        hubConnection.connectionSlow = { print("Connection slow...")
             self.isConnected = false
        }
        
        hubConnection.error = { [weak self] error in
            print("Error: \(String(describing: error))")
        
            if let source = error?["source"] as? String , source == "TimeoutException" {
                print("Connection timed out. Restarting...")
               // self?.hubConnection.start()
            }
        }
        hubConnection.start()
    }

    func disconnectSignalR()
    {
        if(hubConnection != nil)
        {
            hubConnection.stop()
        }
    }
    func setSearchBarWhiteColor(SearchbarView:UISearchBar)
    {
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
    func callWSSignOut()
    {
        let param = [:] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.Signout, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            print(JSONResponse["Status"].rawValue)
            if JSONResponse != nil{
                if JSONResponse["Status"].int == 1
                {
                    let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    app.disconnectSignalR()
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(false, forKey: Constants.KEYS.LOGINKEY)
                    userDefaults.synchronize()
                    app.MoveToLoginScreen()
                }
                else
                {
                    
                }
            }
        })
        {(error) -> Void in
        }
    }
}

