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


class MyJodDetailViewController: UIViewController,NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
{
    @IBOutlet weak var SectorHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var CertificateHeightConstraints: NSLayoutConstraint!
     @IBOutlet weak var AppliactionTabHeightConstraints: NSLayoutConstraint!
    
    
    @IBOutlet weak var tabApplication: UITableView!
    @IBOutlet weak var tabSector: UITableView!
    @IBOutlet weak var tabCertificate: UITableView!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCatagory: UILabel!
    @IBOutlet var lblstart: UILabel!
    @IBOutlet var lblfinish: UILabel!
    @IBOutlet var lblcity: UILabel!
    var JobId = 0
    @IBOutlet weak var ScrollView: UIScrollView!
    var sharedManager : Globals = Globals.sharedInstance
    var jobDetail:MyJobDetails = MyJobDetails()
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnReopen: UIButton!

    
    
    @IBOutlet var lblViews: UILabel!
    @IBOutlet var lblSaves: UILabel!
    @IBOutlet var lblLikes: UILabel!
    @IBOutlet var lblApplication: UILabel!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tabApplication.rowHeight = UITableViewAutomaticDimension
        tabApplication.estimatedRowHeight = 100
        tabApplication.tableFooterView = UIView()
    }
    
    func lblNamedTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let companyVC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
        companyVC.userId = self.jobDetail.Result.JobView.UserID
        self.navigationController?.pushViewController(companyVC, animated: true)
    }
    func getDetailsDetail()
    {
        self.startAnimating()
        let param = ["JobID":JobId] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.GetJobApplicant, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            self.jobDetail = Mapper<MyJobDetails>().map(JSONObject: JSONResponse.rawValue)!
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
        getDetailsDetail()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
         self.AppliactionTabHeightConstraints.constant = self.tabApplication.contentSize.height
    }
    func fillDatatoConttrollerFromApi()
    {
    
        if(self.jobDetail.Result.JobView.StartDate as String! != "")
        {
            lblstart.attributedText = DisPlayCountInLabel(strTitle:"Start Date:", value: self.jobDetail.Result.JobView.StartDate,lable: lblstart)
        }
        if(self.jobDetail.Result.JobView.EndDate as String! != "")
        {
            lblfinish.attributedText = DisPlayCountInLabel(strTitle:"Finish Date:", value: self.jobDetail.Result.JobView.EndDate,lable: lblfinish)
        }
        if(self.jobDetail.Result.JobView.CityName as String! != "")
        {
            lblcity.attributedText = DisPlayCountInLabel(strTitle:"Location:", value: self.jobDetail.Result.JobView.CityName,lable: lblcity)
            if(self.jobDetail.Result.JobView.DistanceAwayText as String! != "")
            {
                lblcity.attributedText = AddMultipulAttributeInLabel(strTitle: "Job location:", value: self.jobDetail.Result.JobView.CityName, value1: self.jobDetail.Result.JobView.DistanceAwayText, lable: lblcity)
            }
        }
        
        lblSaves.text = "\(self.jobDetail.Result.JobView.TotalSaved) Saves"
        lblViews.text = "\(self.jobDetail.Result.JobView.TotalViewed) Views"
        lblLikes.text = "0 Likes"
        lblApplication.text = "\(self.jobDetail.Result.JobView.TotalApplied) Applications"
        
        lblCatagory.text = self.jobDetail.Result.JobView.JobRoleName + " - " + self.jobDetail.Result.JobView.JobTradeName
        lblDescription.text = self.jobDetail.Result.JobView.Description
        if(self.jobDetail.Result.JobView.IsClose)
        {
            btnReopen.isHidden = false
            btnClose.isHidden = true
            btnEdit.isHidden = true
        }
        else
        {
            btnReopen.isHidden = true
            btnClose.isHidden = false
            btnEdit.isHidden = false
        }
        self.tabSector.reloadData()
        self.tabCertificate.reloadData()
        self.tabApplication.reloadData()
        self.SectorHeightConstraints.constant = self.tabSector.contentSize.height
        self.CertificateHeightConstraints.constant = self.tabCertificate.contentSize.height
        self.AppliactionTabHeightConstraints.constant = self.tabApplication.contentSize.height
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tabSector
        {
            return self.jobDetail.Result.JobView.SectorNameList.count
        }
        else if(tableView == tabApplication)
        {
            return self.jobDetail.Result.JobApplicantList.count
        }
        else
        {
            return self.jobDetail.Result.JobView.CertificateNameList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tabSector
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! SelctionCell
            cell.lblName.text = self.jobDetail.Result.JobView.SectorNameList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        else if(tableView == tabApplication)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewJobCell", for: indexPath) as! NewJobCell
            
            cell.lblJobRole.text = self.jobDetail.Result.JobApplicantList[indexPath.row].FullName
            cell.lblDis.text = "\(self.jobDetail.Result.JobApplicantList[indexPath.row].TotalFollower) Followers / \(self.jobDetail.Result.JobApplicantList[indexPath.row].TotalFollowing) Followings"
            cell.lblTradename.text = self.jobDetail.Result.JobApplicantList[indexPath.row].TradeName + " - " + self.jobDetail.Result.JobApplicantList[indexPath.row].CityName
            
            cell.btnFav.tag=indexPath.row
            cell.btnFav.addTarget(self, action: #selector(btnSaveUserAsFavorites(_:)), for: UIControlEvents.touchUpInside)
            if self.jobDetail.Result.JobApplicantList[indexPath.row].IsSaved == true {
                cell.btnFav.isSelected = true
            }
            else{
                cell.btnFav.isSelected = false
            }
            let imgURL = self.jobDetail.Result.JobApplicantList[indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imgUser.kf.indicatorType = .activity
            cell.imgUser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            cell.btnProfile.tag = indexPath.row
            cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! SelctionCell
            cell.lblName.text = self.jobDetail.Result.JobView.CertificateNameList[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    func btnProfile(_ sender : UIButton)
    {
        let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
        companyVC.userId = self.jobDetail.Result.JobApplicantList[sender.tag].UserID
        self.navigationController?.pushViewController(companyVC, animated: true)
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
    func btnSaveUserAsFavorites(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":"\(self.jobDetail.Result.JobApplicantList[sender.tag].UserID)",
            "PageType":1] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                
                if(self.jobDetail.Result.JobApplicantList[sender.tag].IsSaved)
                {
                    self.jobDetail.Result.JobApplicantList[sender.tag].IsSaved = false
                }
                else
                {
                    self.jobDetail.Result.JobApplicantList[sender.tag].IsSaved = true
                }
                self.tabApplication.reloadData()
            }
            self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    @IBAction func btnEditJobs(_ sender :UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostJobVC") as! PostJobVC
        vc.edit = true
        vc.JobID = self.jobDetail.Result.JobView.JobID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnCloseJobs(_ sender :UIButton)
    {
        self.startAnimating()
        let param = ["JobID":"\(self.JobId)"] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.JobCloseToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                self.btnReopen.isHidden = false
                self.btnClose.isHidden = true
                self.btnEdit.isHidden = true
            }
            self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    @IBAction func btnReopenJobs(_ sender :UIButton)
    {
        self.startAnimating()
        let param = ["JobID":"\(self.JobId)"] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.JobCloseToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                self.btnReopen.isHidden = true
                self.btnClose.isHidden = false
                self.btnEdit.isHidden = false
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
