//
//  Forgot.swift
//  Tooli
//
//  Created by Impero IT on 10/02/2017.
//  Copyright © 2017 impero. All rights reserved.
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
<<<<<<< HEAD
=======
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
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

                print(JSONResponse["Status"].rawValue)
                
                if JSONResponse != nil{
                    
                    self.view.makeToast(JSONResponse["Message"].rawValue as! String, duration: 3, position: .bottom)
                }
                
            }) {
                (error) -> Void in
                 
                self.stopAnimating()
                self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
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
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Forgot Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
