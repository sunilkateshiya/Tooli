//
//  JodDetailViewController.swift
//  Tooli
//
//  Created by Impero IT on 13/02/2017.
//  Copyright © 2017 impero. All rights reserved.
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
    var jobDetail:JobViewM = JobViewM()
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
        lblcompany.isUserInteractionEnabled = true
        lblcompany.addGestureRecognizer(tapGestureRecognizer)
        if(JobId == 0)
        {
            fillDatatoConttrollerFromApi()
            self.JobId = self.jobDetail.JobID
        }
        else
        {
            getDetailsDetail()
        }
    }
    func lblNamedTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if(jobDetail.Role == 1)
        {
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "ContractorProfileView") as! ContractorProfileView
            companyVC.userId = jobDetail.UserID
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else
        {
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            companyVC.userId = jobDetail.UserID
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
    }
    func getDetailsDetail()
    {
        self.startAnimating()
        let param = ["JobID":JobId] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.JobDetail, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            self.jobDetail = Mapper<JobViewM>().map(JSONObject: JSONResponse["Result"].rawValue)!
            if JSONResponse["Status"].int == 1
            {
                self.fillDatatoConttrollerFromApi()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
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
        lblwork.text = self.jobDetail.TradeName + "\n" + self.jobDetail.CityName
        let imgURL = self.jobDetail.ProfileImageLink as String!
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        if(self.jobDetail.StartDate as String! != "")
        {
            lblstart.attributedText = DisPlayCountInLabel(strTitle:"Start Date:", value: self.jobDetail.StartDate)
        }
        if(self.jobDetail.EndDate as String! != "")
        {
            lblfinish.attributedText = DisPlayCountInLabel(strTitle:"Finish Date:", value: self.jobDetail.EndDate)
        }
        if(self.jobDetail.CityName as String! != "")
        {
            lblcity.attributedText = DisPlayCountInLabel(strTitle:"Location:", value: self.jobDetail.CityName)
        }
        lblCatagory.text = self.jobDetail.JobRoleName + " - " + self.jobDetail.JobTradeName
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
        for (index,_) in (self.jobDetail.SectorNameList.enumerated())
        {
            print(index)
            let color:UIColor!
            color = UIColor.lightGray
            tagListView.addTag((self.jobDetail.SectorNameList[index]), target: self, tapAction: #selector(tap(_:)), longPressAction: #selector(longPress(_:)),backgroundColor: color,textColor: UIColor.white)
        }
        
        DispatchQueue.main.async {
            self.tagViewHeight.constant = self.tagListView.contentSize.height + 25 + 30
            self.buttomConstraints.constant = 10
            if(self.jobDetail.SectorNameList.count == 0)
            {
                self.tagViewHeight.constant = 0
            }
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
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSaveAsFavorites(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":"\(self.JobId)",
            "PageType":4] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                sender.isSelected = !sender.isSelected
            }
            self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func btnApplyForJobs()
    {
        self.startAnimating()
        let param = ["JobID":"\(self.JobId)"] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.JobApply, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                self.btnApply.isEnabled = false
                self.jobDetail.IsApplied = true
            }
            self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
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
