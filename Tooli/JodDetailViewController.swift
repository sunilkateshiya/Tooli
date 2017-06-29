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
    var JobId = 0
    @IBOutlet weak var ScrollView: UIScrollView!
    var sharedManager : Globals = Globals.sharedInstance
    var jobDetail:JobListM!

    @IBOutlet weak var btnApply: UIButton!
    
     @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet var  tagListView:TagListView!
    
    @IBOutlet weak var tagViewHeight: NSLayoutConstraint!
    
    @IBAction func btnJobApplyAction(_ sender: UIButton)
    {
        btnApplyForJobs()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if(JobId == 0)
        {
            fillDatatoConttrollerFromApi()
            self.JobId = self.jobDetail.PrimaryID
        }
        else
        {
            getDetailsDetail()
        }
    }
    func getDetailsDetail()
    {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "JobID":JobId] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.JobInfo, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            self.jobDetail = Mapper<JobListM>().map(JSONObject: JSONResponse.rawValue)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.fillDatatoConttrollerFromApi()
                }
                else
                {
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "JodDetail Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func fillDatatoConttrollerFromApi()
    {
        lblcompany.text = self.jobDetail.CompanyName as String!
        lblwork.text = self.jobDetail.CompanyTradeCategoryName as String!
        let imgURL = self.jobDetail.CompanyImageLink as String!
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        if(self.jobDetail.StartOn as String! != "")
        {
            lblstart.attributedText = DisPlayCountInLabel(strTitle:"Start Date:", value: self.jobDetail.StartOn)
        }
        if(self.jobDetail.EndOn as String! != "")
        {
            lblfinish.attributedText = DisPlayCountInLabel(strTitle:"Finish Date:", value: self.jobDetail.EndOn)
        }
        if(self.jobDetail.CityName as String! != "")
        {
            lblcity.attributedText = DisPlayCountInLabel(strTitle:"Location:", value: self.jobDetail.CityName)
        }
        lblCatagory.text = self.jobDetail.Title
        //  cell.lbldatetime = self.
        
        if(self.jobDetail.IsSaved)
        {
            btnSave.isSelected = true
        }
        else
        {
            btnSave.isSelected = false
        }
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
        tagViewHeight.constant = tagListView.contentSize.height
        buttomConstraints.constant = 10
    }
    @IBAction func btnfavTimeline(btn : UIButton)  {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.JobId ,
                     "PageType":"4"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    btn.isSelected = !btn.isSelected
                }
                else
                {
                    
                }
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
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

        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "JobID":self.JobId] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.JobApply, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
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
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func DisPlayCountInLabel(strTitle:String,value:String) -> NSMutableAttributedString
    {
        let myString = "\(strTitle)\(value)"
        let myRange = NSRange(location: 0, length: strTitle.length)
        let myRange1 = NSRange(location: strTitle.length, length: value.length)
    
        let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.black]
        let anotherAttribute1 = [ NSForegroundColorAttributeName: UIColor.lightGray]
        let myAttrString = NSMutableAttributedString(string: myString)
        myAttrString.addAttributes(anotherAttribute, range: myRange)
        myAttrString.addAttributes(anotherAttribute1, range: myRange1)
        return myAttrString
    }

}
