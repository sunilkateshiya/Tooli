//
//  Referrals.swift
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
class Referrals: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet var txtEmail : UITextField!
    let sharedManager : Globals = Globals.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack (_sender : UIButton)
    {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.moveToDashboard()
    }
    @IBAction func btnChangePassword (_sender : UIButton) {
        var isValid = true
        if  self.txtEmail.text == "" {
            isValid = false
            self.view.makeToast("Enter valid Email Id.", duration: 3, position: .bottom)
        }
        
        if  isValid {
            self.startAnimating()
            var param = [:] as [String : Any]
            param["ContractorID"] = sharedManager.currentUser.ContractorID
            param["EmailID"]=self.txtEmail.text
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.InviteReferral, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
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
