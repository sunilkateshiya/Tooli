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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var navigationController: MyNavigationController?
    var window: UIWindow?
    var sharedManager : Globals = Globals.sharedInstance
    var locationManager = CLLocationManager()
    var coordinate : CLLocationCoordinate2D!
    var addressString : String!
    var IsMapFirst : Bool!
    override init() {
        coordinate=CLLocationCoordinate2DMake(0, 0)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
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
        print("notification")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
   
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()

    }

    func applicationWillTerminate(_ application: UIApplication) {
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
    

    

}

