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


class NewOtherJodDetailViewController: UIViewController,NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var lblFollowCount: UILabel!
    @IBOutlet weak var lblComanyCity: UILabel!
    @IBOutlet weak var SectorHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var CertificateHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var tabSector: UITableView!
    @IBOutlet weak var tabCertificate: UITableView!
    
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
     @IBOutlet weak var btnUserSave: UIButton!
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
        let companyVC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
        companyVC.userId = jobDetail.UserID
        self.navigationController?.pushViewController(companyVC, animated: true)
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
        lblwork.text = self.jobDetail.TradeName
        
        lblComanyCity.text = self.jobDetail.CityName
        
        let imgURL = self.jobDetail.ProfileImageLink as String!
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        if(self.jobDetail.StartDate as String! != "")
        {
            lblstart.attributedText = DisPlayCountInLabel(strTitle:"Start Date:", value: self.jobDetail.StartDate,lable: lblstart)
        }
        if(self.jobDetail.EndDate as String! != "")
        {
            lblfinish.attributedText = DisPlayCountInLabel(strTitle:"Finish Date:", value: self.jobDetail.EndDate,lable: lblfinish)
        }
        if(self.jobDetail.CityName as String! != "")
        {
            lblcity.attributedText = DisPlayCountInLabel(strTitle:"Job location:", value: self.jobDetail.CityName,lable: lblcity)
            if(self.jobDetail.DistanceAwayText as String! == "")
            {
                lblcity.attributedText = AddMultipulAttributeInLabel(strTitle: "Job location:", value: self.jobDetail.CityName, value1: " sfgsfadsfas dfasd ", lable: lblcity)
            }
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
        if(self.jobDetail.IsUserSaved)
        {
            btnUserSave.isSelected = true
        }
        else
        {
            btnUserSave.isSelected = false
        }
        lblDescription.text = self.jobDetail.Description
        if(self.jobDetail.IsApplied)
        {
            btnApply.isEnabled = false
            btnApply.backgroundColor = UIColor.lightGray
        }
        else
        {
            btnApply.isEnabled = true
        }
        
        lblFollowCount.text = "\(self.jobDetail.TotalFollower) Followers / \(self.jobDetail.TotalFollowing) Followings"
        
        self.tabSector.reloadData()
        self.tabCertificate.reloadData()
        self.SectorHeightConstraints.constant = self.tabSector.contentSize.height
        self.CertificateHeightConstraints.constant = self.tabCertificate.contentSize.height
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tabSector
        {
            return self.jobDetail.SectorNameList.count
        }
        else
        {
            return self.jobDetail.CertificateNameList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tabSector
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! SelctionCell
            cell.lblName.text = self.jobDetail.SectorNameList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! SelctionCell
            cell.lblName.text = self.jobDetail.CertificateNameList[indexPath.row]
            cell.selectionStyle = .none
            return cell
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
    @IBAction func btnSaveUserAsFavorites(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":"\(self.jobDetail.UserID)",
            "PageType":1] as [String : Any]
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
    
    func DisPlayCountInLabel(strTitle:String,value:String,lable:UILabel) -> NSMutableAttributedString
    {
        let myString = "\(strTitle)\(value)"
        let myRange = NSRange(location: 0, length: strTitle.length)
        let myRange1 = NSRange(location: strTitle.length, length: value.length)
    
        let anotherAttribute = [ NSFontAttributeName: UIFont(name: "Oxygen-Light", size: lable.font.pointSize)! ]
        let anotherAttribute1 = [ NSFontAttributeName: UIFont(name: "Oxygen-Bold", size: lable.font.pointSize)! ]
        let myAttrString = NSMutableAttributedString(string: myString)
        myAttrString.addAttributes(anotherAttribute, range: myRange)
        myAttrString.addAttributes(anotherAttribute1, range: myRange1)
        return myAttrString
    }
    func AddMultipulAttributeInLabel(strTitle:String,value:String,value1:String,lable:UILabel) -> NSMutableAttributedString
    {
        let myString = "\(strTitle)\(value)"
        let myRange = NSRange(location: 0, length: strTitle.length)
        let myRange1 = NSRange(location: strTitle.length, length: value.length)
        let myRange2 = NSRange(location: strTitle.length+value.length, length: value1.length)
        
        let anotherAttribute = [ NSFontAttributeName: UIFont(name: "Oxygen-Light", size: lable.font.pointSize)! ]
        let anotherAttribute1 = [ NSFontAttributeName: UIFont(name: "Oxygen-Bold", size: lable.font.pointSize)! ]
        let anotherAttribute2 = [ NSFontAttributeName: UIFont(name: "Oxygen-Light", size: lable.font.pointSize)! ]
        let myAttrString = NSMutableAttributedString(string: myString)
        myAttrString.addAttributes(anotherAttribute, range: myRange)
        myAttrString.addAttributes(anotherAttribute1, range: myRange1)
        myAttrString.addAttributes(anotherAttribute2, range: myRange2)
        return myAttrString
    }
}
