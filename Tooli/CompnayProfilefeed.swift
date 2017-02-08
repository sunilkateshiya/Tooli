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
    
    
    
    func onLoadDetail(){
        
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "CompanyID":"1"] as [String : Any]
        
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
                    
                    self.joblist = self.sharedManager.selectedCompany.JobList
                    self.speciallist = self.sharedManager.selectedCompany.OfferList

                    
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
    @IBAction func BtnJobsTapped(_ sender: Any) {
        
        self.TblHeightConstraints.constant = 185 * 10
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
        
        //          self.HeightConstraints.constant = 0
        //          self.PortCollectionHeight.constant = 0
    }
    @IBAction func BtnPortfolioTapped(_ sender: Any) {
        
        self.PortCollectionHeight.constant = 291 * 5
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
        
        
        //          self.PortCollectionHeight.constant = self.ObjCollectionView.contentSize.height
        
        
        
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
          //  cell.lbldatetime = self.
            let imgURL = self.joblist?[indexPath.row].ProfileImageLink as String!
            
            let url = URL(string: imgURL!)
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpecialOfferCell
            
            cell.lblCompanyDescription.text = self.speciallist?[indexPath.row].Description as String!
            cell.lblWork.text = self.speciallist?[indexPath.row].Title as String!
            cell.lblCompanyName.text = self.sharedManager.selectedCompany.CompanyName
            let imgURL = self.speciallist?[indexPath.row].ProfileImageLink as String!
            
            let url = URL(string: imgURL!)
            cell.ImgProfilepic.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            

            let imgURL1 = self.speciallist?[indexPath.row].OfferImageLink as String!
            
            let url1 = URL(string: imgURL1!)
            cell.ImgCompanyPic.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            
            return cell
            
        }
       
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
