//
//  Login.swift
//  Tooli
//
//  Created by Moin Shirazi on 19/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView

class Login: UIViewController, NVActivityIndicatorViewable {

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
        
            var validflag = 0
            if (self.txtemail?.text?.characters.count)! == 0  {
                self.view.makeToast("Please enter valid email address", duration: 2, position: .bottom)
                validflag = 1
            }
            else if ((self.txtpassword?.text?.characters.count)! == 0)
            {
                self.view.makeToast("Please enter password", duration: 2, position: .bottom)
                validflag = 1
            }
            
            if validflag == 0 {
                
                    self.startAnimating()
                    let param = ["EmailID": self.txtemail.text!,
                                 "Password": self.txtpassword.text!,
                                 "Platform": "iOS",
                                 "DeviceToken": self.sharedManager.deviceToken] as [String : Any]
                    
                    print(param)
                    AFWrapper.requestPOSTURL(Constants.URLS.ContractorSignIn, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                        (JSONResponse) -> Void in
                        
                        self.stopAnimating()
                        self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                        
                        print(self.sharedManager.currentUser)
                        print(JSONResponse["status"].rawValue as! String)
                        
                        if JSONResponse != nil{
                            
                            if self.sharedManager.currentUser.status == "1"
                            {
                                
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(true, forKey: Constants.KEYS.LOGINKEY)
                                
                                    userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                                    userDefaults.set(false, forKey: Constants.KEYS.ISINITSIGNALR)
                                    userDefaults.synchronize()
                                
                                     UIApplication.shared.applicationIconBadgeNumber = 0
                                  AppDelegate.sharedInstance().initSignalR();
                                if self.sharedManager.currentUser.IsSetupProfile == true {
                                
                                
                                    self.appDelegate().moveToDashboard()
                                    
                                }
                                else{
                                    AppDelegate.sharedInstance().initSignalR();
                                    let obj : Info = self.storyboard?.instantiateViewController(withIdentifier: "Info") as! Info
                                    self.navigationController?.pushViewController(obj, animated: true)
                                }
                            }
                            else if(self.sharedManager.currentUser.status == "-2")
                            {
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(true, forKey: Constants.KEYS.LOGINKEY)
                                
                                userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                                userDefaults.synchronize()
                                self.appDelegate().initSignalR()
                                let obj : Info = self.storyboard?.instantiateViewController(withIdentifier: "Info") as! Info
                                self.navigationController?.pushViewController(obj, animated: true)
                            }
                            else
                            {
                                
                            }
                            self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
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
                    
                        let param = ["FBAccountID": response.dictionaryValue?["id"] ?? "123",
                                     "Platform": "iOS",
                                      "EmailID": response.dictionaryValue?["email"] as! String? ?? "",
                                       "FirstName": response.dictionaryValue?["first_name"] as! String? ?? "",
                                       "LastName": response.dictionaryValue?["last_name"] as! String? ?? "",
                                     "DeviceToken": self.sharedManager.deviceToken] as [String : Any]
                        
                        print(param)
                        AFWrapper.requestPOSTURL(Constants.URLS.ContractorFacebookConnect, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                            (JSONResponse) -> Void in
                            
                            self.stopAnimating()
                            self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                            
                            print(self.sharedManager.currentUser)
                            print(JSONResponse["status"].rawValue as! String)
                            
                            if JSONResponse != nil{
                                
                                if self.sharedManager.currentUser.status == "1"
                                {
                                    
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(true, forKey: Constants.KEYS.LOGINKEY)
                                    
                                    userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                                    userDefaults.synchronize()
                                    
                                    if self.sharedManager.currentUser.IsSetupProfile == true {
                                        self.appDelegate().moveToDashboard()
                                        self.appDelegate().initSignalR()
                                    }
                                    else{
                                        let obj : Info = self.storyboard?.instantiateViewController(withIdentifier: "Info") as! Info
                                        self.navigationController?.pushViewController(obj, animated: true)
                                        
                                    }
                                }
                                else if(self.sharedManager.currentUser.status == "-2")
                                {
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(true, forKey: Constants.KEYS.LOGINKEY)
                                    
                                    userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                                    userDefaults.synchronize()
                                    self.appDelegate().initSignalR()
                                    let obj : Info = self.storyboard?.instantiateViewController(withIdentifier: "Info") as! Info
                                    self.navigationController?.pushViewController(obj, animated: true)
                                }
                                else
                                {
                                    
                                }
                                 self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
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
