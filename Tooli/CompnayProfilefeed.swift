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
import SafariServices
import SKPhotoBrowser


class CompnayProfilefeed:UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var btnAgain: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewError: UIView!
    @IBAction func btnAgainErrorAction(_ sender: UIButton)
    {
        self.imgError.isHidden = true
        self.btnAgain.isHidden = true
        self.lblError.isHidden = true
        self.navigationController?.popViewController(animated: true)
//        getMasters()
    }
    
    var popover = Popover()
    
    var sharedManager : Globals = Globals.sharedInstance
    var joblist : [JobListM]?
    var speciallist : [OfferListM]?
    var companyId = 0;
    var isFollowing : Bool = false
    @IBOutlet weak var ImgStar: UIButton!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    @IBOutlet weak var ObjScrollview: UIScrollView!
    @IBOutlet weak var ImgProfilePic: UIImageView!
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
     @IBOutlet weak var BtnMessage: UIButton!
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
        
       //self.ObjScrollview.contentSize.height = 247 + AboutView.frame.size.height
       //  self.ObjScrollview.contentSize.height = 237 + 456
        
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
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblTelTaped(tapGestureRecognizer:)))
        lblmobile.isUserInteractionEnabled = true
        lblmobile.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(lblEmailTaped(tapGestureRecognizer:)))
        lblemail.isUserInteractionEnabled = true
        lblemail.addGestureRecognizer(tapGestureRecognizer2)
        onLoadDetail()
        self.ObjScrollview.contentSize.height = 237 + 456
        
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Company Profilefeed Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func lblTelTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        if(lblmobile.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblmobile.text!))")!))
            {
                UIApplication.shared.openURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblmobile.text!))")!)
            }
            else
            {
                self.view.makeToast("Number not valid.", duration: 3, position: .bottom)
            }
        }
    }
    func lblEmailTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        if(lblemail.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "mailto://\(lblemail.text!)")!))
            {
                UIApplication.shared.openURL(URL(string: "mailto://\(lblemail.text!)")!)
            }
            else
            {
                self.view.makeToast("Email not valid.", duration: 3, position: .bottom)
            }
        }
    }
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-".characters)
        return String(text.characters.filter {okayChars.contains($0) })
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
                self.stopAnimating()
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.isFollowing = !self.isFollowing
                    if (self.isFollowing == true) {
                        self.BtnFollow.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1/255.0, alpha: 1)
                        self.BtnFollow.setTitle("Following", for: UIControlState.normal)
                    }
                    else {
                          self.BtnFollow.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
                        self.BtnFollow.setTitle("Follow", for: UIControlState.normal)
                    }
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
    
    func onLoadDetail(){
        self.viewError.isHidden = false
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
                    self.viewError.isHidden = true
                    self.imgError.isHidden = true
                    self.btnAgain.isHidden = true
                    self.lblError.isHidden = true
                    
                    self.lblName.text = self.sharedManager.selectedCompany.CompanyName
                    self.lblSkill.text = self.sharedManager.selectedCompany.TradeCategoryName
                    self.lblLocation.text = self.sharedManager.selectedCompany.CityName
                    self.lblcity.text = self.sharedManager.selectedCompany.CityName
                    
                    let underlineAttribute2 = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
                    let underlineAttributedString2 = NSAttributedString(string: self.sharedManager.selectedCompany.EmailID, attributes: underlineAttribute2)
                    self.lblemail.attributedText = underlineAttributedString2
                    
                    let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
                    let underlineAttributedString = NSAttributedString(string: self.sharedManager.selectedCompany.ContactNumber, attributes: underlineAttribute)
                    self.lblmobile.attributedText = underlineAttributedString
                    
        
                    self.lblstreet.text = self.sharedManager.selectedCompany.StreetAddress
                    self.lblpincode.text = self.sharedManager.selectedCompany.Zipcode
                    self.lblservicegrp.text = self.sharedManager.selectedCompany.ServiceGroup
                    self.txtbiodesc.text = self.sharedManager.selectedCompany.Description
                    self.txtbiodesc.contentOffset = CGPoint.zero
                    self.isFollowing = self.sharedManager.selectedCompany.IsFollow
                    self.joblist = self.sharedManager.selectedCompany.JobList
                    self.speciallist = self.sharedManager.selectedCompany.OfferList
                   
                    if  self.sharedManager.selectedCompany.IsSaved == true {
                        self.ImgStar.isSelected = true
                    } else {
                        self.ImgStar.isSelected = false
                    }
                    
                    if (self.isFollowing == true) {
                        self.BtnFollow.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1/255.0, alpha: 1)
                        self.BtnFollow.setTitle("Following", for: UIControlState.normal)
                    }
                    else {
                         self.BtnFollow.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
                        self.BtnFollow.setTitle("Follow", for: UIControlState.normal)
                        
                    }
                    if self.sharedManager.selectedCompany.IsFollowing == true {
                        self.BtnMessage.isHidden = false
                    } else {
                        self.BtnMessage.isHidden = true
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
                    self.TblHeightConstraints.constant =  237 + 456
                    self.PortCollectionHeight.constant =  237 + 456
                    self.AboutviewHeight.constant =  237 + 456
                    //self.ObjScrollview.contentSize.height = 247 + self.AboutView.frame.size.height

                    DispatchQueue.main.async{
                      self.ObjScrollview.contentSize.height = 237 + 456
                    }
                    self.TblTimeline.tag = 1
                }
                else
                {
                     _ = self.navigationController?.popViewController(animated: true)
                    AppDelegate.sharedInstance().window?.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                    self.lblError.text = "No company found."
                    self.viewError.isHidden = false
                    self.imgError.isHidden = false
                    self.btnAgain.isHidden = false
                    self.lblError.isHidden = false
                }
                
//                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            self.viewError.isHidden = false
            self.imgError.isHidden = false
            self.btnAgain.isHidden = false
            self.lblError.isHidden = false
           // self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
        
    }
    
    @IBAction func BtnNotificationTapped(_ sender: Any) {
        
        self .popOver()
    }
    @IBAction func BtnJobsTapped(_ sender: Any)
    {
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
        setupLayout()
    }
    
    @IBAction func BtnAboutTapped(_ sender: Any) {
        
        self.BtnPortfolio.isSelected = false
        self.BtnPortfolio.tintColor = UIColor.white
        self.BtnPortfolio.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.BtnAbout.isSelected = true
        self.BtnAbout.tintColor = UIColor.white
        self.BtnAbout.setTitleColor(UIColor.red, for: UIControlState.selected)
        
        self.BtnJobs.isSelected = false
        self.BtnJobs.tintColor = UIColor.white
        self.BtnJobs.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.TblTimeline.isHidden = true
        self.PortfolioView.isHidden = true
        self.AboutView.isHidden = false
        
        self.TblTimeline.tag = 1
        setupLayout()
    }
    @IBAction func BtnPortfolioTapped(_ sender: Any)
    {

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
        setupLayout()
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
     setupLayout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setupLayout()
    {
        if(self.BtnJobs.isSelected)
        {
            self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
            self.AboutviewHeight.constant = self.TblTimeline.contentSize.height
            self.PortCollectionHeight.constant = self.TblTimeline.contentSize.height
            self.ObjScrollview.contentSize.height = 237 + self.TblHeightConstraints.constant
            
        }
        else if(self.BtnAbout.isSelected)
        {
            self.AboutviewHeight.constant = 237 + 456
            self.PortCollectionHeight.constant = 237 + 456
            self.TblHeightConstraints.constant  = 237 + 456
            self.ObjScrollview.contentSize.height = 237 + 456
        }
        else if(self.BtnPortfolio.isSelected)
        {
            self.PortCollectionHeight.constant = self.TBLSpecialOffer.contentSize.height
            self.AboutviewHeight.constant = self.TBLSpecialOffer.contentSize.height
            self.TblHeightConstraints.constant = self.TBLSpecialOffer.contentSize.height
            self.ObjScrollview.contentSize.height = 237 + self.PortCollectionHeight.constant
        }
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
    @IBAction func btnHomeScreenAction(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    @IBAction func BtnMessageTapped(_ sender: UIButton)
    {
        if AppDelegate.sharedInstance().persistentConnection.state == .connected {
            AppDelegate.sharedInstance().persistentConnection.send(Command.messageSendCommand(friendId: String(self.sharedManager.selectedCompany.FollowUserID), msg: ""))
            NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED), object: nil) as Notification)
            let msgVC : MessageTab = self.storyboard?.instantiateViewController(withIdentifier: "MessageTab") as! MessageTab
            msgVC.selectedSenderId = self.sharedManager.selectedCompany.FollowUserID
            msgVC.isNext = true
            self.navigationController?.pushViewController(msgVC, animated: true)
        }
        else
        {
            AppDelegate.sharedInstance().initSignalR()
            AppDelegate.sharedInstance().persistentConnection.send(Command.messageSendCommand(friendId: String(self.sharedManager.selectedCompany.FollowUserID), msg: ""))
            NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED), object: nil) as Notification)
            let msgVC : MessageTab = self.storyboard?.instantiateViewController(withIdentifier: "MessageTab") as! MessageTab
            msgVC.selectedSenderId = self.sharedManager.selectedCompany.FollowUserID
            msgVC.isNext = true
            self.navigationController?.pushViewController(msgVC, animated: true)
        }

    }
    @IBAction func btnfav(btn : UIButton)
    {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.sharedManager.selectedCompany.PrimaryID,
                     "PageType": "1"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    btn.isSelected = !btn.isSelected
                    if self.sharedManager.currentUser.IsSaved == true{
                        self.sharedManager.currentUser.IsSaved = false
                    }
                    else{
                        self.sharedManager.currentUser.IsSaved = true
                    }
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == self.TblTimeline {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileFeedCell
            
            cell.lblcity.text = self.joblist?[indexPath.row].CityName as String!
            cell.lblcompany.text = self.joblist?[indexPath.row].Title as String!
            if(self.joblist?[indexPath.row].StartOn as String! != "")
            {
                 cell.lblstart.attributedText = DisPlayCountInLabel(strTitle:"Start Date:", value: (self.joblist?[indexPath.row].StartOn)!)
            }
            if(self.joblist?[indexPath.row].EndOn as String! != "")
            {
                cell.lblfinish.attributedText = DisPlayCountInLabel(strTitle:"Finish Date:", value: (self.joblist?[indexPath.row].EndOn)!)
            }
    
            cell.lblexperience.text = self.joblist?[indexPath.row].Description as String!
            cell.lblwork.text = self.joblist?[indexPath.row].TradeCategoryName as String!
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(CompnayProfilefeed.btnfavTimeline(btn:)), for: UIControlEvents.touchUpInside)
            if self.joblist?[indexPath.row].IsSaved == true {
                cell.btnfav.isSelected = true
            }
            else{
                cell.btnfav.isSelected = false
            }
            
            cell.lbldatetime.text = self.joblist![indexPath.row].DistanceText as String!
            let imgURL = self.joblist?[indexPath.row].ProfileImageLink as String!
            
            let url = URL(string: imgURL!)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpecialOfferCell
            cell.lblCompanyDescription.text = "\(self.speciallist![indexPath.row].Description))"
            cell.lblTitle.text = ""
            cell.lblWork.text = "\(self.speciallist![indexPath.row].PriceTag) - \(self.speciallist![indexPath.row].AddedOn)"
            cell.lblCompanyName.text = self.speciallist?[indexPath.row].Title as String!
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(CompnayProfilefeed.btnfavSpecialOffer(btn:)), for: UIControlEvents.touchUpInside)
            if self.speciallist?[indexPath.row].IsSaved == true {
                cell.btnfav.isSelected = true
            }
            else{
                cell.btnfav.isSelected = false
            }
            cell.lblCompanyDescription.tag = indexPath.row
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
            cell.lblCompanyDescription.isUserInteractionEnabled = true
            cell.lblCompanyDescription.addGestureRecognizer(tapGestureRecognizer)
            let imgURL = self.speciallist?[indexPath.row].ProfileImageLink as String!
            
            let url = URL(string: imgURL!)
            cell.ImgProfilepic.kf.indicatorType = .activity
            cell.ImgProfilepic.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
            let imgURL1 = self.speciallist?[indexPath.row].OfferImageLink as String!
            
            let url1 = URL(string: imgURL1!)
            cell.ImgProfilepic.kf.setImage(with: url1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                if(image != nil)
                {
                    cell.setCustomImage(image : image!)
                }
                if(cell.isReload)
                {
                    cell.isReload = false
                    tableView.reloadData()
                }
            })
            return cell
            
        }
    }
    func lblNamedTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
         let lbl = tapGestureRecognizer.view as! UILabel
        if(UIApplication.shared.canOpenURL(URL(string: (self.speciallist?[lbl.tag].RedirectLink)!)!))
        {
            let openLink = NSURL(string : (self.speciallist?[lbl.tag].RedirectLink)!)
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: openLink as! URL)
                present(svc, animated: true, completion: nil)
            } else {
                let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                port.strUrl = (self.speciallist?[lbl.tag].RedirectLink)!
                self.navigationController?.pushViewController(port, animated: true)
                
            }
        }
        else
        {
            return
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
                     "PageType":"5"] as [String : Any]
    
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
                
//                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func btnfavTimeline(btn : UIButton)  {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.joblist?[btn.tag].PrimaryID ?? "",
                     "PageType":"4"] as [String : Any]
        
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
                
//                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
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
