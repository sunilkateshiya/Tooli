//
//  Register.swift
//  Tooli
//
//  Created by Moin Shirazi on 19/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView
import Toast_Swift
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import SVWebViewController
import SafariServices

class Register: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var lblTextPravricy: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet var txtemail : UITextField!
    @IBOutlet var txtpassword : UITextField!
    @IBOutlet var txtfname : UITextField!
    @IBOutlet var txtlname : UITextField!
    @IBOutlet var txtconfmpass : UITextField!
    var sharedManager : Globals = Globals.sharedInstance
    var fbid:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Register Screen")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        // Do any additional setup after loading the view.
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Accept Terms of Service", attributes: underlineAttribute)
        self.lblTextPravricy.attributedText = underlineAttributedString
        
    }

    @IBAction func btnregister(_ sender: Any) {
        
        var validflag = 0
        if (self.txtfname?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter first name", duration: 3, position: .bottom)
            validflag = 1
        }
        else if (self.txtlname?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter last name", duration: 3, position: .bottom)
            validflag = 1
        }
        else if (self.txtemail?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter email address", duration: 3, position: .bottom)
            validflag = 1
        }
        else if(self.isValidEmail(testStr: self.txtemail.text!) == false)
        {
            self.view.makeToast("Please enter valid email address", duration: 3, position: .bottom)
            validflag = 1
        }
            
        else if (self.txtpassword?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter password", duration: 3, position: .bottom)
            validflag = 1
        }
        else if (self.txtpassword?.text?.characters.count)! < 6  {
            self.view.makeToast("Minimum 6 & maximum 20 character allowed.", duration: 3, position: .bottom)
            validflag = 1
        }
        else if (self.txtconfmpass?.text?.characters.count)! < 6  {
            self.view.makeToast("Minimum 6 & maximum 20 character allowed.", duration: 3, position: .bottom)
            validflag = 1
        }
        else if self.txtpassword?.text != self.txtconfmpass?.text  {
            self.view.makeToast("Confirm password should be same as password.", duration: 3, position: .bottom)
            validflag = 1
        }
        else if !btnAccept.isSelected  {
            self.view.makeToast("Please Accept Terms of Service.", duration: 3, position: .bottom)
            validflag = 1
        }
        
        if validflag == 0 {
            
            
            self.startAnimating()
            registerData()
        }
    }
    @IBAction func btnAcceptAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func btnOpenPdf(_ sender: UIButton)
    {
        let openLink = NSURL(string : "https://www.tooli.co.uk/Files/Document/Privacy_Policy.pdf")
        
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(url: openLink as! URL)
            present(svc, animated: true, completion: nil)
        } else {
            let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
            port.strUrl = "https://www.tooli.co.uk/Files/Document/Privacy_Policy.pdf"
            self.navigationController?.pushViewController(port, animated: true)
            
        }
    }
    func registerData()
    {
        let param = ["FBAccountID": self.fbid,
                     "EmailID": self.txtemail.text!,
                     "Password": self.txtpassword.text!,
                     "FirstName":self.txtfname.text!,
                     "LastName":self.txtlname.text!,
                     "UseReferenceID":"",
                     "Platform": "iOS",
                     "DeviceToken": self.sharedManager.deviceToken] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorSignUp, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    let userDefaults = UserDefaults.standard
                     userDefaults.set(true, forKey: Constants.KEYS.LOGINKEY)
                    userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                    userDefaults.synchronize()
                     AppDelegate.sharedInstance().initSignalR();
                    let obj : Info = self.storyboard?.instantiateViewController(withIdentifier: "Info") as! Info
                    self.navigationController?.pushViewController(obj, animated: true)
                }
                else
                {
                    if(self.fbid != "")
                    {
                        self.txtemail.text = ""
                        self.txtfname.text = ""
                        self.txtlname.text = ""
                        self.fbid = ""
                    }
                    
                }
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }

    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    @IBAction func btnBack(_ sender: Any) {
        
      _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnfblogin(_ sender: AnyObject) {
        
        let loginManager = LoginManager()
        //self.startAnimating()
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            
            //self.stopAnimating()
            
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                self.view.makeToast("User cancelled signup.", duration: 3, position: .bottom)
                print("User cancelled lo gin.")
            case .success(let _, let declinedPermissions, let accessToken):
                
                let connection = GraphRequestConnection()
                let params = ["fields" :"id, email, name, first_name, last_name, gender"]
                connection.add(GraphRequest(graphPath:"me", parameters: params)) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        print("Graph Request Succeeded: \(response)")
                        self.txtemail.text = response.dictionaryValue?["email"] as! String?
                        self.txtfname.text = response.dictionaryValue?["first_name"] as! String?
                        self.txtlname.text = response.dictionaryValue?["last_name"] as! String?
                        self.fbid = (response.dictionaryValue?["id"] as! String?)!
                        if(self.txtemail.text != "")
                        {
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
                                
                                self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                                
                                self.stopAnimating()
                                
                                print(JSONResponse["status"].rawValue as! String)
                                
                                if JSONResponse != nil{
                                     
                                    if JSONResponse["status"].rawString()! == "1"
                                    {
                                        let userDefaults = UserDefaults.standard
                                        
                                        userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                                         userDefaults.set(true, forKey: Constants.KEYS.LOGINKEY)
                                        userDefaults.synchronize()
                                         AppDelegate.sharedInstance().initSignalR();
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
                        else
                        {
                            self.view.makeToast(" Email address is mandatory. Please connect with Facebook again and provide email access.when facebook email not retrive", duration: 3, position: .bottom)
                        }
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
