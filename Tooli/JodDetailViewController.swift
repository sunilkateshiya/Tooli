//
//  JodDetailViewController.swift
//  Tooli
//
//  Created by Impero IT on 13/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Popover
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher


class JodDetailViewController: UIViewController,NVActivityIndicatorViewable
{
    @IBOutlet weak var buttomConstraints: NSLayoutConstraint!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCatagory: UILabel!
    @IBOutlet var lblcompany: UILabel!
    @IBOutlet var lblwork: UILabel!
    @IBOutlet var lblstart: UILabel!
    @IBOutlet var lblfinish: UILabel!
    @IBOutlet var imguser: UIImageView!
    @IBOutlet var lblcity: UILabel!

    @IBOutlet weak var ScrollView: UIScrollView!
    var sharedManager : Globals = Globals.sharedInstance
    var jobDetail:JobListM!

    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet var  tagListView:TagListView!
    
    
    @IBAction func btnJobApplyAction(_ sender: UIButton)
    {
        btnApplyForJobs()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
     //  txtViewContantSize.constant = 0
     //   secondViewContranit.constant = 0
        lblcity.text = self.jobDetail.CityName as String!
        lblcompany.text = self.sharedManager.selectedCompany.CompanyName as String!
        lblstart.text = self.jobDetail.StartOn as String!
        lblfinish.text = self.jobDetail.EndOn as String!
        lblwork.text = self.sharedManager.selectedCompany.TradeCategoryName as String!
        lblCatagory.text = self.jobDetail.Title
        //  cell.lbldatetime = self.
        let imgURL = self.sharedManager.selectedCompany.ProfileImageLink as String!
        
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        lblDescription.text = self.jobDetail.Description
        if(self.jobDetail.IsApplied)
        {
            btnApply.isEnabled = false
        }
        else
        {
            btnApply.isEnabled = true
        }
        for (index,i) in (self.jobDetail.ServiceList?.enumerated())!
        {
            print(index)
            let color:UIColor!
             color = UIColor.lightGray
          tagListView.addTag((self.jobDetail.ServiceList?[index].Service)!, target: self, tapAction: "tap:", longPressAction: "longPress:",backgroundColor: color,textColor: UIColor.white)
        }
        buttomConstraints.constant = 10
       // print(self.jobDetail.ServiceList)
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func tap(_ sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        print("tap from \(label.text!)")
    }
    func longPress(_ sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        print("long press from \(label.text!)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func btnApplyForJobs()
    {
        return
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID": "" ?? "",
                     "PageType":"4"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.btnApply.isEnabled = false
                    self.jobDetail.IsApplied = true
                }
                else
                {
                    
                }
                
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
}
