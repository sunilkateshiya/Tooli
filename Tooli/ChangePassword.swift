//
//  ChangePassword.swift
//  Tooli
//
//  Created by Aadil on 2/15/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
class ChangePassword: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet var txtCurrentPassword : UITextField!
    @IBOutlet var txtNewPassword : UITextField!
    @IBOutlet var txtConfirmPassword : UITextField!
    let sharedManager : Globals = Globals.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack (_sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "ChangePassword Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    @IBAction func btnChangePassword (_sender : UIButton) {
        var isValid = true
        if  self.txtCurrentPassword.text == "" {
            isValid = false
            self.view.makeToast("Enter valid current password.", duration: 3, position: .bottom)
        }
        else if self.txtNewPassword.text == "" {
            isValid = false
            self.view.makeToast("Enter valid new password.", duration: 3, position: .bottom)
        }
        else if self.txtConfirmPassword.text == "" {
            isValid = false
            self.view.makeToast("Enter valid confirm password.", duration: 3, position: .bottom)
        }
        else if self.txtConfirmPassword.text != self.txtNewPassword.text {
            isValid = false
            self.view.makeToast("New password and confirm password are mismatch.", duration: 3, position: .bottom)
        }
        
        if  isValid {
            self.startAnimating()
            var param = [:] as [String : Any]
            param["ContractorID"] = sharedManager.currentUser.ContractorID
            param["CurrentPassword"] = self.txtCurrentPassword.text
            param["NewPassword"] = self.txtNewPassword.text
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.ChangePassword, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                if JSONResponse != nil {
                    self.stopAnimating()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
                
            }) {
                (error) -> Void in
                self.stopAnimating()
                self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
            }
        }
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
