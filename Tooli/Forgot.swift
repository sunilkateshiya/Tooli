//
//  Forgot.swift
//  Tooli
//
//  Created by Impero IT on 10/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
class Forgot: UIViewController,NVActivityIndicatorViewable {
    @IBOutlet var txtemail : UITextField!
    var sharedManager : Globals = Globals.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnForgot(_ sender: Any) {
        
        var validflag = 0
        if (self.txtemail?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter valid email address", duration: 2, position: .bottom)
            validflag = 1
        }
        
        if validflag == 0 {
            
            
            self.startAnimating()
            let param = ["EmailID": self.txtemail.text!,
                        ] as [String : Any]
            
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.ForgotPassword, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                self.stopAnimating()

                print(JSONResponse["status"].rawValue as! String)
                
                if JSONResponse != nil{
                    
                    self.view.makeToast(JSONResponse["message"].rawValue as! String, duration: 3, position: .bottom)
                }
                
            }) {
                (error) -> Void in
                print(error.localizedDescription)
                self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
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
