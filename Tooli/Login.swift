//
//  Login.swift
//  Tooli
//
//  Created by impero on 19/01/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import SafariServices
import Firebase

class Login: UIViewController, NVActivityIndicatorViewable
{
    @IBOutlet var txtemail : UITextField!
    @IBOutlet var txtpassword : UITextField!
    var sharedManager : Globals = Globals.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = false
        self.sideMenuController()?.sideMenu?.allowPanGesture = false
        self.sideMenuController()?.sideMenu?.allowRightSwipe = false
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Login Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    @IBAction func btnlogin(_ sender: Any) {
        
        if (self.txtemail?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter valid email address", duration: 2, position: .bottom)
        }
        else if ((self.txtpassword?.text?.characters.count)! == 0)
        {
            self.view.makeToast("Please enter password", duration: 2, position: .bottom)
        }
        else
        {
            self.startAnimating()
            let param = ["EmailID": self.txtemail.text!,
                         "Password": self.txtpassword.text!,
                         "Platform": "iOS",
                         "Role":1,
                         "DeviceToken": FIRInstanceID.instanceID().token() ?? "Not found Token"] as [String : Any]
            
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.Signin, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                self.stopAnimating()
                print(JSONResponse["Status"].rawValue)
                if JSONResponse != nil{
                    if JSONResponse["Status"].int == 1
                    {
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(true, forKey: Constants.KEYS.LOGINKEY)
                       userDefaults.set("\(JSONResponse["Result"]["token_type"]) \(JSONResponse["Result"]["access_token"])", forKey: Constants.KEYS.TOKEN)
                        userDefaults.set(JSONResponse["Result"]["IsProfileSetup"].bool, forKey: Constants.KEYS.IS_SET_PROFILE)
                        userDefaults.synchronize()
                        
                        UIApplication.shared.applicationIconBadgeNumber = 0
                        
                        if JSONResponse["Result"]["IsProfileSetup"].bool == true
                        {
                            AppDelegate.sharedInstance().initSignalR();
                            self.appDelegate().moveToDashboard()
                        }
                        else{
                            AppDelegate.sharedInstance().initSignalR();
                            let obj : SignUpVC1 = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC1") as! SignUpVC1
                            self.navigationController?.pushViewController(obj, animated: true)
                        }
                    }
                    else
                    {
                        
                    }
                    self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
                }
                
            }) {
                (error) -> Void in
                self.stopAnimating()
                
                self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
            }
        }
    }
    func appDelegate () -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }

    @IBAction func btnfblogin(_ sender: AnyObject) {
    
        let loginManager = LoginManager()
        //self.startAnimating()
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
           // self.stopAnimating()
            switch loginResult {
                
            case .failed(let error):
                print(error)
            case .cancelled:
                self.view.makeToast("User cancelled login.", duration: 3, position: .bottom)
                print("User cancelled login.")
            case .success(let _, let declinedPermissions, let accessToken):
                
                let connection = GraphRequestConnection()
                let params = ["fields" :"id, email, name, first_name, last_name, gender"]
                connection.add(GraphRequest(graphPath:"me", parameters: params)) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        self.startAnimating()
                    
                        let param = ["FacebookID": response.dictionaryValue?["id"] ?? "123",
                                     "Platform": "iOS",
                                      "EmailID": response.dictionaryValue?["email"] as! String? ?? "",
                                       "FirstName": response.dictionaryValue?["first_name"] as! String? ?? "",
                                       "LastName": response.dictionaryValue?["last_name"] as! String? ?? "",
                                       "Role":1,
                                       "DeviceToken": FIRInstanceID.instanceID().token() ?? "Not found Token"] as [String : Any]
                        
                        print(param)
                        AFWrapper.requestPOSTURL(Constants.URLS.FacebookConnect, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                            (JSONResponse) -> Void in
                            print(self.sharedManager.currentUser)
                            print(JSONResponse["Status"].rawValue)
                            
                            if JSONResponse != nil{
                                
                                if JSONResponse["Status"].int == 1
                                {
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(true, forKey: Constants.KEYS.LOGINKEY)
                                    userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                                    userDefaults.set("\(JSONResponse["Result"]["token_type"]) \(JSONResponse["Result"]["access_token"])", forKey: Constants.KEYS.TOKEN)
                                    userDefaults.set(JSONResponse["Result"]["IsProfileSetup"].bool, forKey: Constants.KEYS.IS_SET_PROFILE)
                                    userDefaults.synchronize()
                                    
                                    if JSONResponse["Result"]["IsProfileSetup"].bool == true {
                                        self.appDelegate().moveToDashboard()
                                        self.appDelegate().initSignalR()
                                    }
                                    else{
                                        let obj : SignUpVC1 = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC1") as! SignUpVC1
                                        self.navigationController?.pushViewController(obj, animated: true)
                                    }
                                }
                                else
                                {
                                    
                                }
                                 self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
                            }
                            
                        }) {
                            (error) -> Void in
                             
                            self.stopAnimating()
                            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
                        }
                        
                        print("Graph Request Succeeded: \(response)")
                    case .failed(let error):
                        self.stopAnimating()
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
            }
        }
    }
    @IBAction func btncreate(_ sender: Any) {
        
        let obj : Register = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! Register
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnforgotpass(_ sender: Any) {
        let obj : Forgot = self.storyboard?.instantiateViewController(withIdentifier: "Forgot") as! Forgot
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
