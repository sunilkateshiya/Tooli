//
//  Referrals.swift
//  Tooli
//
//  Created by Aadil on 2/15/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
class Referrals: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet var txtEmail : UITextField!
    let sharedManager : Globals = Globals.sharedInstance
    
    @IBOutlet weak var lblReferralList: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblReferralList.text =  self.sharedManager.currentUser.ReferralLink
        // Do any additional setup after loading the view.
    }
    @IBAction func btnCopyLinkAction(_ sender: UIButton)
    {
        let textToShare = [ lblReferralList.text! ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
       
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
        {
           self.present(activityViewController, animated: true, completion: nil)
        }
        else
        {
            var popup = UIPopoverController()
            popup.contentViewController = activityViewController
            popup.present(from: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/4, width: 0, height: 0) , in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }

//        
//        self.view.makeToast("Referral Link Copy Successfully.", duration: 3, position: .bottom)
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Referrals Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    @IBAction func btnBack (_sender : UIButton)
    {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.moveToDashboard()
    }
    @IBAction func btnChangePassword (_sender : UIButton)
    {
        var isValid = true
        if  self.txtEmail.text == "" {
            isValid = false
            self.view.makeToast("Enter valid Email Id.", duration: 3, position: .bottom)
        }
        
        if  isValid {
            self.startAnimating()
            var param = [:] as [String : Any]
            param["EmailID"]=self.txtEmail.text
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.SendInvitation, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                if JSONResponse != nil {
                    self.stopAnimating()
                    self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
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
}
