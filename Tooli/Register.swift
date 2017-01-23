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

class Register: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var txtemail : UITextField!
    @IBOutlet var txtpassword : UITextField!
    @IBOutlet var txtfname : UITextField!
    @IBOutlet var txtlname : UITextField!
    @IBOutlet var txtconfmpass : UITextField!
    var sharedManager : Globals = Globals.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            self.view.makeToast("Please enter valid email address", duration: 3, position: .bottom)
            validflag = 1
        }
        else if (self.txtpassword?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter password", duration: 3, position: .bottom)
            validflag = 1
        }
        else if self.txtpassword?.text != self.txtconfmpass?.text  {
            self.view.makeToast("Confirm password should be same as password.", duration: 3, position: .bottom)
            validflag = 1
        }
    
        
        if validflag == 0 {
            
            
            self.startAnimating()
            let param = ["FBAccountID": "",
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
                        
                        userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                        userDefaults.synchronize()
                    
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
                print(error.localizedDescription)
                self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
            }
            
        }

    }
    
    @IBAction func btnBack(_ sender: Any) {
        
      _ = self.navigationController?.popViewController(animated: true)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
