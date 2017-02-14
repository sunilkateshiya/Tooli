//
//  CompnayProfilefeed.swift
//  Tooli
//
//  Created by Impero-Moin on 21/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Popover
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher

class CompnayProfilefeed:UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, NVActivityIndicatorViewable {
    var popover = Popover()
    
    var sharedManager : Globals = Globals.sharedInstance
    var joblist : [JobListM]?
    var speciallist : [OfferListM]?
    var companyId = 0;
    var isFollowing : Bool = false
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    @IBOutlet weak var ObjScrollview: UIScrollView!
    @IBOutlet weak var ImgProfilePic: UIImageView!
    @IBOutlet weak var ImgStar: UIImageView!
    @IBOutlet weak var ImgOnOff: UIImageView!
    @IBOutlet weak var AboutviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var TBLSpecialOffer: UITableView!
    @IBOutlet weak var BtnJobs: UIButton!
    @IBOutlet weak var BtnNotification: UIButton!
    
    @IBOutlet weak var TblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblSkill: UILabel!
    
    @IBOutlet weak var PortfolioView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var AboutView: UIView!
    
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var lblmobile: UILabel!
    @IBOutlet weak var lblstreet: UILabel!
    @IBOutlet weak var lblcity: UILabel!
    @IBOutlet weak var lblpincode: UILabel!
    @IBOutlet weak var lblservicegrp: UILabel!
    @IBOutlet weak var txtbiodesc: UITextView!

    
    @IBOutlet weak var TblTimeline: UITableView!
    
    @IBOutlet weak var PortCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var BtnAbout: UIButton!
    @IBOutlet weak var BtnFollow : UIButton!
    @IBOutlet weak var BtnPortfolio: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ObjScrollview.contentSize.height = 247 + AboutView.frame.size.height
        
        self.BtnPortfolio.isSelected = false
        self.BtnPortfolio.tintColor = UIColor.white
        self.BtnPortfolio.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.BtnAbout.isSelected = true
        self.BtnAbout.tintColor = UIColor.white
        self.BtnAbout.setTitleColor(UIColor.red, for: UIControlState.selected)
        
        
        self.TblTimeline.isHidden = true
        self.PortfolioView.isHidden = true
        self.AboutView.isHidden = false
        
        self.TblTimeline.tag = 1
        
        
        TblTimeline.delegate = self
        TblTimeline.dataSource = self
        TblTimeline.rowHeight = UITableViewAutomaticDimension
        TblTimeline.estimatedRowHeight = 450
        TblTimeline.tableFooterView = UIView()
        
        TBLSpecialOffer.delegate = self
        TBLSpecialOffer.dataSource = self
        TBLSpecialOffer.rowHeight = UITableViewAutomaticDimension
        TBLSpecialOffer.estimatedRowHeight = 450
        TBLSpecialOffer.tableFooterView = UIView()
        
        ObjScrollview.delegate = self
        
        
        onLoadDetail()
        
    }
    
    @IBAction func actionFollow(_sender : UIButton) {
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "FollowCompanyID":self.companyId] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.FollowCompanyToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.isFollowing = !self.isFollowing
                    if (self.isFollowing == true) {
                        self.BtnFollow.setTitle("Following", for: UIControlState.normal)
                    }
                    else {
                        self.BtnFollow.setTitle("Follow", for: UIControlState.normal)
                    }
                }
                
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }

        
    }
    
    func onLoadDetail(){
        
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "CompanyID":self.companyId] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.CompanyProfileView, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.selectedCompany = Mapper<CompanyProfileM>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.lblName.text = self.sharedManager.selectedCompany.CompanyName
                    self.lblSkill.text = self.sharedManager.selectedCompany.TradeCategoryName
                    self.lblLocation.text = self.sharedManager.selectedCompany.CityName
                    self.lblcity.text = self.sharedManager.selectedCompany.CityName
                    self.lblemail.text = self.sharedManager.selectedCompany.EmailID
                    self.lblmobile.text = self.sharedManager.selectedCompany.ContactNumber
                    self.lblstreet.text = self.sharedManager.selectedCompany.StreetAddress
                    self.lblpincode.text = self.sharedManager.selectedCompany.Zipcode
                    self.lblservicegrp.text = self.sharedManager.selectedCompany.ServiceGroup
                    self.txtbiodesc.text = self.sharedManager.selectedCompany.Description
                    self.isFollowing = self.sharedManager.selectedCompany.IsFollow
                    self.joblist = self.sharedManager.selectedCompany.JobList
                    self.speciallist = self.sharedManager.selectedCompany.OfferList
                    
                    if (self.isFollowing == true) {
                        self.BtnFollow.setTitle("Following", for: UIControlState.normal)
                    }
                    else {
                        self.BtnFollow.setTitle("Follow", for: UIControlState.normal)
                    }
                    
                    
                    // Image load
                    
                    if self.sharedManager.selectedCompany.ProfileImageLink != "" {
                        let imgURL = self.sharedManager.selectedCompany.ProfileImageLink as String
                        let urlPro = URL(string: imgURL)
                        self.ImgProfilePic?.kf.indicatorType = .activity
                        self.ImgProfilePic?.kf.setImage(with: urlPro)
                        let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.sharedManager.selectedCompany.ProfileImageLink)
                        let optionInfo: KingfisherOptionsInfo = [
                            .downloadPriority(0.5),
                            .transition(ImageTransition.fade(1)),
                            .forceRefresh
                        ]
                        
                        self.ImgProfilePic?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                        
                        //ImgProfilePic?.clipsToBounds = true
                        //ImgProfilePic?.cornerRadius = (ImgProfilePic?.frame.size.width)! / 2
                    }
                    
                    
                    self.TblTimeline.reloadData()
                    self.TBLSpecialOffer.reloadData()
                }
                else
                {
                    
                }
                
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
        
    }
    
    
    
    
    @IBAction func BtnNotificationTapped(_ sender: Any) {
        
        self .popOver()
    }
    @IBAction func BtnJobsTapped(_ sender: Any)
    {
        
        self.TblHeightConstraints.constant = CGFloat(Float(Float(185) * Float((self.joblist!.count))))
        self.ObjScrollview.contentSize.height = 237 + self.TblHeightConstraints.constant
        
        
        self.BtnPortfolio.isSelected = false
        self.BtnPortfolio.tintColor = UIColor.white
        self.BtnPortfolio.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.BtnJobs.isSelected = true
        self.BtnJobs.tintColor = UIColor.white
        self.BtnJobs.setTitleColor(UIColor.red, for: UIControlState.selected)
        
        self.BtnAbout.isSelected = false
        self.BtnAbout.tintColor = UIColor.white
        self.BtnAbout.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.TblTimeline.isHidden = false
        self.PortfolioView.isHidden = true
        self.AboutView.isHidden = true
        //                    self.AboutviewHeight.constant = 185 * 10
        //
        //                    self.PortCollectionHeight.constant = 185 * 10
        //                    self.ObjScrollview.contentSize.height = self.TblHeightConstraints.constant
        
    }
    
    @IBAction func BtnAboutTapped(_ sender: Any) {
        
        
        self.ObjScrollview.contentSize.height = 237 + 456
        
        self.BtnPortfolio.isSelected = false
        self.BtnPortfolio.tintColor = UIColor.white
        self.BtnPortfolio.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.BtnAbout.isSelected = true
        self.BtnAbout.tintColor = UIColor.white
        self.BtnAbout.setTitleColor(UIColor.red, for: UIControlState.selected)
        
        self.BtnJobs.isSelected = true
        self.BtnJobs.tintColor = UIColor.white
        self.BtnJobs.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.TblTimeline.isHidden = true
        self.PortfolioView.isHidden = true
        self.AboutView.isHidden = false
        
        self.TblTimeline.tag = 1
    }
    @IBAction func BtnPortfolioTapped(_ sender: Any) {
        
        self.PortCollectionHeight.constant = self.TBLSpecialOffer.contentSize.height
        self.ObjScrollview.contentSize.height = 237 + self.PortCollectionHeight.constant
    
        self.BtnAbout.isSelected = false
        self.BtnAbout.tintColor = UIColor.white
        self.BtnAbout.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.BtnPortfolio.isSelected = true
        self.BtnPortfolio.tintColor = UIColor.white
        self.BtnPortfolio.setTitleColor(UIColor.red, for: UIControlState.selected)
        
        self.BtnJobs.isSelected = false
        self.BtnJobs.tintColor = UIColor.white
        self.BtnJobs.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.TblTimeline.isHidden = true
        self.PortfolioView.isHidden = false
        self.AboutView.isHidden = true
        
    }
    
    func popOver() {
        
        
        let width = self.view.frame.size.width
        let aView = UIView(frame: CGRect(x: 10, y: 25, width: width, height: 120))
        
        let Available = UIImageView(frame: CGRect(x: 10, y: 13, width: 14 , height: 14))
        Available.image = #imageLiteral(resourceName: "ic_circle_green")
        
        let Availableinweek = UIImageView(frame: CGRect(x: 10, y: 53, width: 14, height: 14))
        Availableinweek.image = #imageLiteral(resourceName: "ic_CircleYellow")
        
        let Availableinmonth = UIImageView(frame: CGRect(x: 10, y: 93, width: 14, height: 14))
        Availableinmonth.image = #imageLiteral(resourceName: "ic_circle_red")
        
        
        
        
        let Share = UIButton(frame: CGRect(x: 40, y: 0, width: width - 30, height: 40))
        Share.setTitle("I am availabale immediately", for: .normal)
        Share.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Share.contentHorizontalAlignment = .left
        Share.setTitleColor(UIColor.darkGray, for: .normal)
        Share.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        
        let border = CALayer()
        let width1 = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: Share.frame.size.height - width1, width:  Share.frame.size.width, height: Share.frame.size.height)
        
        border.borderWidth = width1
        Share.layer.addSublayer(border)
        Share.layer.masksToBounds = true
        
        let Delete = UIButton(frame: CGRect(x: 40, y: 40, width: width - 30, height: 40))
        Delete.setTitle("I am Available in 2-4 weeks", for: .normal)
        Delete.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Delete.setTitleColor(UIColor.darkGray, for: .normal)
        Delete.contentHorizontalAlignment = .left
        Delete.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        let borderDelete = CALayer()
        let widthDelete = CGFloat(1.0)
        borderDelete.borderColor = UIColor.lightGray.cgColor
        borderDelete.frame = CGRect(x: 0, y: Delete.frame.size.height - width1, width:  Delete.frame.size.width, height: Delete.frame.size.height)
        
        borderDelete.borderWidth = widthDelete
        Delete.layer.addSublayer(borderDelete)
        Delete.layer.masksToBounds = true
        
        
        let MonthAvailiblity = UIButton(frame: CGRect(x: 40, y: 80, width: width - 30, height: 40))
        MonthAvailiblity.setTitle("I am Available in 1-3 months", for: .normal)
        MonthAvailiblity.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        MonthAvailiblity.setTitleColor(UIColor.darkGray, for: .normal)
        MonthAvailiblity.contentHorizontalAlignment = .left
        MonthAvailiblity.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        
        aView.addSubview(Delete)
        aView.addSubview(Share)
        aView.addSubview(MonthAvailiblity)
        aView.addSubview(Available)
        aView.addSubview(Availableinmonth)
        aView.addSubview(Availableinweek)
        
        
        let options = [
            .type(.down),
            .cornerRadius(4)
            ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(aView, fromView:BtnNotification)
        
        
        
    }
    func press(button: UIButton) {
        
        popover.dismiss()
        
    }
    
    
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if AboutView.isHidden == true {
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.TblTimeline {
            guard  ((sharedManager.selectedCompany) != nil) else {
                return 0
            }
            if self.joblist == nil {
                self.joblist = sharedManager.selectedCompany.JobList
            }
            return  (self.joblist?.count)!;
        }
        else
        {
            guard  ((sharedManager.selectedCompany) != nil) else {
                return 0
            }
            if self.speciallist == nil {
                self.speciallist = sharedManager.selectedCompany.OfferList
            }
            return  (self.speciallist?.count)!;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == self.TblTimeline {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileFeedCell
            
            cell.lblcity.text = self.joblist?[indexPath.row].CityName as String!
            cell.lblcompany.text = self.joblist?[indexPath.row].Description as String!
            cell.lblstart.text = self.joblist?[indexPath.row].StartOn as String!
            cell.lblfinish.text = self.joblist?[indexPath.row].EndOn as String!
            cell.lblexperience.text = self.joblist?[indexPath.row].Title as String!
            cell.lblwork.text = self.joblist?[indexPath.row].TradeCategoryName as String!
            cell.btnfav!.tag=indexPath.row
           //  cell.btnfav?.addTarget(self, action: #selector(CompnayProfilefeed.btnfavTimeline(btn:)), for: UIControlEvents.touchUpInside)
            if self.joblist?[indexPath.row].IsSaved == true {
                cell.btnfav.isSelected = true
            }
            else{
                cell.btnfav.isSelected = false
            }
            
          //  cell.lbldatetime = self.
            let imgURL = self.joblist?[indexPath.row].ProfileImageLink as String!
            
            let url = URL(string: imgURL!)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpecialOfferCell
             cell.btnfav?.addTarget(self, action: #selector(JobCenter.btnfav(btn:)), for: UIControlEvents.touchUpInside)
            cell.lblCompanyDescription.text = self.speciallist?[indexPath.row].Description as String!
            cell.lblWork.text = self.speciallist?[indexPath.row].Title as String!
            cell.lblCompanyName.text = self.sharedManager.selectedCompany.CompanyName
            cell.btnfav!.tag=indexPath.row
           // cell.btnfav?.addTarget(self, action: #selector(CompnayProfilefeed.btnfavSpecialOffer(btn:)), for: UIControlEvents.touchUpInside)
            if self.speciallist?[indexPath.row].IsSaved == true {
                cell.btnfav.isSelected = true
            }
            else{
                cell.btnfav.isSelected = false
            }
            
            let imgURL = self.speciallist?[indexPath.row].ProfileImageLink as String!
            
            let url = URL(string: imgURL!)
            cell.ImgProfilepic.kf.indicatorType = .activity
            cell.ImgProfilepic.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
            let imgURL1 = self.speciallist?[indexPath.row].OfferImageLink as String!
            
            let url1 = URL(string: imgURL1!)
            cell.ImgCompanyPic.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.TblTimeline
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
            vc.jobDetail = self.joblist?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.OfferDetail = self.speciallist?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func btnfavSpecialOffer(btn : UIButton)  {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.speciallist?[btn.tag].PrimaryID ?? "",
                     "PageType":btn.isSelected == true ? "1" : "2"] as [String : Any]
    
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    if btn.isSelected == true{
                        self.speciallist?[btn.tag].IsSaved = false
                    }
                    else{
                        self.speciallist?[btn.tag].IsSaved = true
                    }
                    self.TBLSpecialOffer.reloadData()
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
    func btnfavTimeline(btn : UIButton)  {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.joblist?[btn.tag].PrimaryID ?? "",
                     "PageType":btn.isSelected == true ? "1" : "2"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    if btn.isSelected == true{
                        self.joblist?[btn.tag].IsSaved = false
                    }
                    else{
                        self.joblist?[btn.tag].IsSaved = true
                    }
                    self.TblTimeline.reloadData()
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
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}
