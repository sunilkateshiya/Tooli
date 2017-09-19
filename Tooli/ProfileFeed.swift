//
//  ProfileFeed.swift
//  Tooli
//
//  Created by Impero-Moin on 19/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Popover
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher
import SafariServices

class ProfileFeed: UIViewController, UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, NVActivityIndicatorViewable{
    var popover = Popover()
    let sharedManager : Globals = Globals.sharedInstance
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var contractorId = 0;
    var isPortFolio : Bool = false;
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var profile  : SignIn!
    var isFollowing:Bool = true
    
    @IBOutlet weak var noListView: UIView!
    @IBOutlet weak var AboutCollectionView: UICollectionView!
    @IBOutlet weak var TblAboutus: UITableView!
    @IBOutlet weak var ObjScrollview: UIScrollView!
    @IBOutlet weak var ObjCollectionView: UICollectionView!
    @IBOutlet weak var ImgProfilePic: UIImageView!
    @IBOutlet weak var ImgStar: UIImageView!
    @IBOutlet weak var ImgOnOff: UIImageView!
    @IBOutlet weak var ImgAvailable : UIImageView!
    @IBOutlet weak var ImgAvailableProfile : UIImageView!
    @IBOutlet weak var AboutviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var BtnNotification: UIButton!
    
    
    @IBOutlet weak var btnCountFollower: UIButton!
    @IBOutlet weak var tblFollowers: UITableView!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var btnFollwer: UIButton!
    @IBOutlet weak var tblFollowerHeight: NSLayoutConstraint!
    
    @IBAction func BtnNotificationTapped(_ sender: Any) {
        
        self .popOver()
    }
    @IBOutlet weak var TblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var HeightAboutView: NSLayoutConstraint!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblSkill: UILabel!
    
    @IBOutlet weak var POrCollectionHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var PortfolioView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var AboutView: UIView!
    @IBOutlet weak var BtnEditProfile: UIButton!
    @IBOutlet weak var BtnFollow: UIButton!
    
    @IBOutlet weak var BtnMessage: UIButton!
    
    @IBOutlet weak var TblTimeline: UITableView!
    
    @IBOutlet weak var PortCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var BtnAbout: UIButton!
    @IBOutlet weak var BtnActivty: UIButton!
    @IBOutlet weak var BtnPortfolio: UIButton!
    
    // About Outlets
    @IBOutlet var lblAbtDOb : UILabel!
    @IBOutlet var lblAbtTel : UILabel!
    @IBOutlet var lblAbtMob : UILabel!
    @IBOutlet var lblAbtEmail : UILabel!
    
    @IBOutlet var txtAbtViewAbout : UITextView!
    
    @IBOutlet var lblAbtPostCode : UILabel!
    @IBOutlet var lblAbtDistanceCovered : UILabel!
    @IBOutlet var lblAbtTrade : UILabel!
    @IBOutlet var lblAbtSkill : UILabel!
    @IBOutlet var lblAbtHourly : UILabel!
    @IBOutlet var lblAbtDaily : UILabel!
    @IBOutlet var lblAbtLicenceOwner : UILabel!
    @IBOutlet var lblAbtOwnVehicle : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  contractorId == 0 {
            contractorId = (sharedManager.currentUser.ContractorID)
            self.BtnFollow.isHidden = true;
            self.BtnMessage.isHidden = true;
            self.BtnEditProfile.isHidden = false;
        }
        else {
            self.BtnFollow.isHidden = false;
            self.BtnMessage.isHidden = false;
            self.BtnEditProfile.isHidden = true;
        }
        self.TblAboutus.delegate = self
        self.TblAboutus.dataSource = self
        TblTimeline.delegate = self
        TblTimeline.dataSource = self
        TblTimeline.rowHeight = UITableViewAutomaticDimension
        TblTimeline.estimatedRowHeight = 450
        TblTimeline.tableFooterView = UIView()
        ObjScrollview.delegate = self
        self.tblFollowerHeight.constant = 0
        self.TblHeightConstraints.constant = 0
        self.POrCollectionHeightConstraints.constant = 0
        
        self.AboutviewHeight.constant = 0
        
        //self.PortCollectionHeight.constant = 265 * 10
        self.ObjScrollview.contentSize.height = 0
        self.AboutCollectionView.delegate = self
        self.AboutCollectionView.dataSource = self
        
        
        ObjCollectionView.delegate = self
        ObjCollectionView.dataSource =  self
        
        let flow = AboutCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        let flow1 = ObjCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow1.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
        flow1.minimumInteritemSpacing = 3
        flow1.minimumLineSpacing = 3
        
        self.BtnActivty.isSelected = true
        self.BtnActivty.tintColor = UIColor.white
        self.BtnActivty.setTitleColor(UIColor.red, for: UIControlState.selected)
        
        getProfile()
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    override func viewWillAppear(_ animated: Bool) {

         getProfile()
    }
    @IBAction func btnOpenFollowerAction(_ sender: UIButton)
    {
        if(tblFollowers.isHidden)
        {
            if(isFollowing)
            {
                if(self.profile.FollowingList?.count == 0)
                {
                    noListView.isHidden = false
                }
                else
                {
                    noListView.isHidden = true
                }

            }
            else
            {
                if(self.profile.FollowerList?.count == 0)
                {
                    noListView.isHidden = false
                }
                else
                {
                    noListView.isHidden = true
                }
            }
            
            let myRange = NSRange(location: 0, length: 16)
            let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.black]
            let myAttrString = NSMutableAttributedString(string: "Back to Timeline")
            myAttrString.addAttributes(anotherAttribute, range: myRange)
            btnCountFollower.setAttributedTitle(myAttrString, for: UIControlState.normal)
        
            self.TblTimeline.isHidden = true
            self.PortfolioView.isHidden = true
            self.AboutView.isHidden = true
            
            tblFollowers.isHidden = false
            tblFollowers.reloadData()
            tblFollowerHeight.constant = 237 + self.tblFollowers.contentSize.height
            self.ObjScrollview.contentSize.height = tblFollowerHeight.constant
        }
        else
        {
            noListView.isHidden = true
             btnCountFollower.setAttributedTitle(self.DisPlayCountInLabel(FollowingCount: "\(self.profile.FollowingList!.count) ", followerCount: "\(self.profile.FollowerList!.count) "), for: UIControlState.normal)
            
            tblFollowers.isHidden = true
            tblFollowerHeight.constant = 0
            self.ObjScrollview.contentSize.height = tblFollowerHeight.constant
            if(self.BtnAbout.isSelected)
            {
                self.AboutView.isHidden =  false
                self.ObjScrollview.contentSize.height = 237 + AboutView.frame.size.height
            }
            if(self.BtnActivty.isSelected)
            {
                 self.TblTimeline.isHidden = false
                self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
                self.TblTimeline.reloadData()
                self.POrCollectionHeightConstraints.constant = self.TblTimeline.contentSize.height
                self.ObjScrollview.contentSize.height = 237 + self.TblHeightConstraints.constant
            }
            if(self.BtnPortfolio.isSelected)
            {
                 self.PortfolioView.isHidden = false
                DispatchQueue.main.async
                    {
                        self.TblHeightConstraints.constant = self.ObjCollectionView.contentSize.height
                        self.POrCollectionHeightConstraints.constant = self.ObjCollectionView.contentSize.height
                        self.ObjScrollview.contentSize.height = 237 + self.POrCollectionHeightConstraints.constant + 20
                        
                }
            }
        }
    }
    @IBAction func btnFollowingAction(_ sender: UIButton)
    {
        if(self.profile.FollowingList?.count == 0)
        {
            noListView.isHidden = false
        }
        else
        {
            noListView.isHidden = true
        }
        
        btnFollwer.isSelected = false
        btnFollowing.isSelected = true
        
        btnFollwer.backgroundColor = UIColor.clear
        btnFollowing.backgroundColor = UIColor.white
        isFollowing = true
        tblFollowers.reloadData()
        
        tblFollowerHeight.constant = 217 + self.tblFollowers.contentSize.height
        self.ObjScrollview.contentSize.height = tblFollowerHeight.constant
    }
    @IBAction func btnFollowersAction(_ sender: UIButton)
    {
        if(self.profile.FollowerList?.count == 0)
        {
            noListView.isHidden = false
        }
        else
        {
            noListView.isHidden = true
        }
        btnFollwer.isSelected = true
        btnFollowing.isSelected = false
        
        btnFollwer.backgroundColor = UIColor.white
        btnFollowing.backgroundColor = UIColor.clear
        isFollowing = false
        tblFollowers.reloadData()
        tblFollowerHeight.constant = 217 + self.tblFollowers.contentSize.height
        self.ObjScrollview.contentSize.height = tblFollowerHeight.constant
    }
    func getProfile(){
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "ProfileContractorID": self.contractorId,] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorProfileView, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            // self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    self.profile = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                    self.setProfile()
                    
                }
                else
                {
                    self.stopAnimating()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
        
    }
    
    func setProfile(){
        self.lblName.text = self.profile.FirstName + " " + self.profile.LastName
        self.lblSkill.text = self.profile.TradeCategoryName
        self.lblLocation.text = self.profile.CityName
        
        // Setting About Info :
        
        if  self.profile.IsSaved == true {
            self.ImgStar.isHidden = false
        } else {
            self.ImgStar.isHidden = true
        }
        
        if self.profile.IsFollow == true {
            self.BtnFollow.setTitle("Following", for: UIControlState.normal)
        } else {
            self.BtnFollow.setTitle("Follow", for: UIControlState.normal)
        }
        if  contractorId == sharedManager.currentUser.ContractorID
        {
            self.BtnFollow.isHidden = true;
            self.BtnMessage.isHidden = true;
            self.BtnEditProfile.isHidden = false;
        }
        else
        {
            if self.profile.IsFollowing == true {
                self.BtnMessage.isHidden = false
            } else {
                self.BtnMessage.isHidden = true
            }
            self.BtnEditProfile.isHidden = true;
        }
        self.lblAbtDOb.text = self.profile.DOB
        self.lblAbtMob.text = self.profile.MobileNumber
        self.lblAbtTel.text = self.profile.LandlineNumber
        self.lblAbtDaily.text = self.profile.PerDayRate
        self.lblAbtHourly.text = self.profile.PerDayRate
        self.lblAbtEmail.text = self.profile.EmailID
        self.txtAbtViewAbout.text = self.profile.Aboutme
        self.lblAbtPostCode.text = self.profile.Zipcode
        self.lblAbtDistanceCovered.text = String(self.profile.DistanceRadius)
        self.lblAbtTrade.text = self.profile.TradeCategoryName
        var ProfileSkills : [String] = []
        for skill in self.profile.ServiceList! {
            ProfileSkills.append(skill.ServiceName)
        }
        self.lblAbtSkill.text = ProfileSkills.joined(separator: ",")
        self.lblAbtTrade.text = self.profile.TradeCategoryName
        self.lblAbtLicenceOwner.text = String(self.profile.IsLicenceHeld)
        self.lblAbtOwnVehicle.text = String(self.profile.IsOwnVehicle)
        
        self.TblAboutus.reloadData()
        self.TblTimeline.reloadData()
        self.AboutCollectionView.reloadData()
        self.ObjCollectionView.reloadData()
        self.tblFollowers.reloadData()
        
        btnCountFollower.setAttributedTitle(self.DisPlayCountInLabel(FollowingCount: "\(self.profile.FollowingList!.count) ", followerCount: "\(self.profile.FollowerList!.count) "), for: UIControlState.normal)
    
        
        self.TblTimeline.reloadData()
        tblFollowerHeight.constant = 0
        self.ObjScrollview.contentSize.height = tblFollowerHeight.constant
        if(self.BtnAbout.isSelected)
        {
            self.AboutView.isHidden =  false
            self.ObjScrollview.contentSize.height = 237 + AboutView.frame.size.height
        }
        if(self.BtnActivty.isSelected)
        {
            self.TblTimeline.isHidden = false
            DispatchQueue.main.async
                {
                    self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
                    self.TblTimeline.reloadData()
                    self.POrCollectionHeightConstraints.constant = self.TblTimeline.contentSize.height
                    self.ObjScrollview.contentSize.height = 237 + self.TblHeightConstraints.constant
            }
        }
        if(self.BtnPortfolio.isSelected)
        {
            self.PortfolioView.isHidden = false
            DispatchQueue.main.async
                {
                    self.TblHeightConstraints.constant = self.ObjCollectionView.contentSize.height
                    self.POrCollectionHeightConstraints.constant = self.ObjCollectionView.contentSize.height
                    self.ObjScrollview.contentSize.height = 237 + self.POrCollectionHeightConstraints.constant + 20
                    
            }
        }
        
        //set Image
        if self.profile.ProfileImageLink != "" {
            let imgURL = self.profile.ProfileImageLink as String
            let urlPro = URL(string: imgURL)
            self.ImgProfilePic?.kf.indicatorType = .activity
            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.profile.ProfileImageLink + "Main")
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1)),
                
            ]
            
            ImgProfilePic?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
            
            //ImgProfilePic?.clipsToBounds = true
            //ImgProfilePic?.cornerRadius = (ImgProfilePic?.frame.size.width)! / 2
        }
        
        if  self.contractorId == self.sharedManager.currentUser.ContractorID {
            self.BtnNotification.isHidden = false
            self.ImgAvailable.isHidden = false
            
            if self.profile.AvailableStatusID == 1 {
                self.ImgAvailable.image = #imageLiteral(resourceName: "ic_circle_green")
                self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_circle_green")
            }
            else if self.profile.AvailableStatusID == 2 {
                self.ImgAvailable.image = #imageLiteral(resourceName: "ic_CircleYellow")
                self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_CircleYellow")
            }
            else if self.profile.AvailableStatusID == 3 {
                self.ImgAvailable.image = #imageLiteral(resourceName: "ic_circle_red")
                self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_circle_red")
            }

        }
        else {
            self.BtnNotification.isHidden = true
            self.ImgAvailable.isHidden = true
        }
    
    }
    
    @IBAction func BtnEditTapped(_ sender: UIButton) {
        let editProfile : EditProfile = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    @IBAction func BtnFollowTapped(_ sender: Any) {
        
        self.startAnimating()
        let param = ["FollowContractorID": self.profile.ContractorID,
                     "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.FollowContractorToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            // self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    if self.profile.IsFollow == true {
                        self.profile.IsFollow = false
                        self.BtnFollow.setTitle("Follow", for: UIControlState.normal)
                    } else {
                        self.profile.IsFollow = true
                        self.BtnFollow.setTitle("Following", for: UIControlState.normal)
                    }
                    
                }
                else
                {
                    self.stopAnimating()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
        
    }
    
    @IBAction func BtnMessageTapped(_ sender: Any)
    {
        if self.appDelegate!.persistentConnection.state == .connected {
            appDelegate?.persistentConnection.send(Command.messageSendCommand(friendId: String(self.profile.UserID), msg: ""))
             NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED), object: nil) as Notification)
            let msgVC : MessageTab = self.storyboard?.instantiateViewController(withIdentifier: "MessageTab") as! MessageTab
            msgVC.selectedSenderId = self.profile.UserID
            msgVC.isNext = true
            self.navigationController?.pushViewController(msgVC, animated: true)
        }
    }

    @IBAction func BtnActivtyTapped(_ sender: Any) {
//        if self.profile != nil {
        
//        }
        self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
        self.TblTimeline.reloadData()
        self.POrCollectionHeightConstraints.constant = self.TblTimeline.contentSize.height
        self.ObjScrollview.contentSize.height = 237 + self.TblHeightConstraints.constant
        self.BtnPortfolio.isSelected = false
        self.BtnPortfolio.tintColor = UIColor.white
        self.BtnPortfolio.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.BtnAbout.isSelected = false
        self.BtnAbout.tintColor = UIColor.white
        self.BtnAbout.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.BtnActivty.isSelected = true
        self.BtnActivty.tintColor = UIColor.white
        self.BtnActivty.setTitleColor(UIColor.red, for: UIControlState.selected)
        
        
        self.TblTimeline.isHidden = false
        self.PortfolioView.isHidden = true
        self.AboutView.isHidden = true
        
        self.TblTimeline.tag = 1
        self.TblAboutus.tag = 2
        self.ObjCollectionView.tag = 3
        self.AboutCollectionView.tag = 4
        
        //          self.HeightConstraints.constant = 0
        //          self.PortCollectionHeight.constant = 0
    }
    @IBAction func BtnAboutTapped(_ sender: Any) {
        
        self.ObjScrollview.contentSize.height = 237 + AboutView.frame.size.height
        
        self.BtnPortfolio.isSelected = false
        self.BtnPortfolio.tintColor = UIColor.white
        self.BtnPortfolio.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.BtnAbout.isSelected = true
        self.BtnAbout.tintColor = UIColor.white
        self.BtnAbout.setTitleColor(UIColor.red, for: UIControlState.selected)
        
        self.BtnActivty.isSelected = false
        self.BtnActivty.tintColor = UIColor.white
        self.BtnActivty.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.TblTimeline.isHidden = true
        self.PortfolioView.isHidden = true
        self.AboutView.isHidden = false
        
        self.TblTimeline.tag = 1
        self.TblAboutus.tag = 2
        self.ObjCollectionView.tag = 3
        self.AboutCollectionView.tag = 4
        
        //          self.HeightConstraints.constant = 0
        //          self.PortCollectionHeight.constant = 0
    }
    @IBAction func BtnPortfolioTapped(_ sender: Any)
    {
        DispatchQueue.main.async
            {
            self.TblHeightConstraints.constant = self.ObjCollectionView.contentSize.height
            self.POrCollectionHeightConstraints.constant = self.ObjCollectionView.contentSize.height
            self.ObjScrollview.contentSize.height = 237 + self.POrCollectionHeightConstraints.constant + 20
        }
        self.BtnAbout.isSelected = false
        self.BtnAbout.tintColor = UIColor.white
        self.BtnAbout.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.BtnActivty.isSelected = false
        self.BtnActivty.tintColor = UIColor.white
        self.BtnActivty.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
        self.BtnPortfolio.isSelected = true
        self.BtnPortfolio.tintColor = UIColor.white
        self.BtnPortfolio.setTitleColor(UIColor.red, for: UIControlState.selected)
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
        Share.setTitle("I am available immediately", for: .normal)
        Share.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Share.contentHorizontalAlignment = .left
        Share.setTitleColor(UIColor.darkGray, for: .normal)
        Share.tag = 20001
        Share.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        
        let border = CALayer()
        let width1 = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: Share.frame.size.height - width1, width:  Share.frame.size.width, height: Share.frame.size.height)
        
        border.borderWidth = width1
        Share.layer.addSublayer(border)
        Share.layer.masksToBounds = true
        
        
        let Delete = UIButton(frame: CGRect(x: 40, y: 40, width: width - 30, height: 40))
        Delete.setTitle("I am available in 2-4 weeks", for: .normal)
        Delete.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Delete.setTitleColor(UIColor.darkGray, for: .normal)
        Delete.contentHorizontalAlignment = .left
        Delete.tag = 20002
        Delete.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        let borderDelete = CALayer()
        let widthDelete = CGFloat(1.0)
        borderDelete.borderColor = UIColor.lightGray.cgColor
        borderDelete.frame = CGRect(x: 0, y: Delete.frame.size.height - width1, width:  Delete.frame.size.width, height: Delete.frame.size.height)
        
        borderDelete.borderWidth = widthDelete
        Delete.layer.addSublayer(borderDelete)
        Delete.layer.masksToBounds = true
        
        
        let MonthAvailiblity = UIButton(frame: CGRect(x: 40, y: 80, width: width - 30, height: 40))
        MonthAvailiblity.setTitle("I am available in 1-3 months", for: .normal)
        MonthAvailiblity.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        MonthAvailiblity.setTitleColor(UIColor.darkGray, for: .normal)
        MonthAvailiblity.contentHorizontalAlignment = .left
        MonthAvailiblity.tag = 20003
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
        
        self.startAnimating()
        let param = ["AvailableStatusID": button.tag - 20000,
                     "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorChangeStatus, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            // self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    self.popover.dismiss()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                    self.profile.AvailableStatusID = button.tag - 20000
                    
                    if self.profile.AvailableStatusID == 1 {
                        self.ImgAvailable.image = #imageLiteral(resourceName: "ic_circle_green")
                        self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_circle_green")
                    }
                    else if self.profile.AvailableStatusID == 2 {
                        self.ImgAvailable.image = #imageLiteral(resourceName: "ic_CircleYellow")
                        self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_CircleYellow")
                    }
                    else if self.profile.AvailableStatusID == 3 {
                        self.ImgAvailable.image = #imageLiteral(resourceName: "ic_circle_red")
                        self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_circle_red")
                    }
                    
                }
                else
                {
                    self.stopAnimating()
                    self.popover.dismiss()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.popover.dismiss()
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
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
            if self.profile != nil {
                //self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
                return (self.profile.PortfolioList?.count)!
            }
            else {
                return 0
            }
        }
        else if(tableView == self.tblFollowers)
        {
            if(isFollowing)
            {
                if self.profile != nil {
                    //self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
                    return (self.profile.FollowingList?.count)!
                }
                else {
                    return 0
                }
            }
            else
            {
                if self.profile != nil {
                    //self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
                    return (self.profile.FollowerList?.count)!
                }
                else {
                    return 0
                }
            }
        }
        else
        {
            if  self.profile != nil {
                self.AboutviewHeight.constant = CGFloat(Float(Float(110) * Float((self.profile.ExperienceList?.count)!)))
                self.HeightAboutView.constant = 867 + self.AboutviewHeight.constant
                return  (self.profile.ExperienceList?.count)!
                
            }
            self.AboutviewHeight.constant = 0
            self.HeightAboutView.constant = 867
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.TblTimeline {
            let lastRowIndex = tableView.numberOfRows(inSection: 0)
            if indexPath.row == lastRowIndex - 1 {
                self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
            }
        }
//        if tableView == tblFollowers
//        {
//            let lastRowIndex = tableView.numberOfRows(inSection: 0)
//            if indexPath.row == lastRowIndex - 1 {
//                self.tblFollowerHeight.constant = self.tblFollowers.contentSize.height
//            }
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == self.TblTimeline {
            let cell : TimelineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimelineCell
            let tmpPortfolio : Portfolio = self.profile.PortfolioList![indexPath.row]
            // Set Image of user
            if tmpPortfolio.IsSaved == true {
                cell.imgFav.image = #imageLiteral(resourceName: "ic_fav_selected")
            }
            else {
                cell.imgFav.image = #imageLiteral(resourceName: "ic_fav")
            }
            if self.profile.ProfileImageLink != "" {
                let imgURL = self.profile.ProfileImageLink as String
                let urlPro = URL(string: imgURL)
                cell.imgProfile?.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.profile.ProfileImageLink + "ProfileCell")
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    
                    ]
                
                cell.imgProfile?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                
                //ImgProfilePic?.clipsToBounds = true
                //ImgProfilePic?.cornerRadius = (ImgProfilePic?.frame.size.width)! / 2
            }
            
            //cell.imguser
            cell.lblName.text = self.profile.FirstName + " " + self.profile.LastName
            cell.lblCaption.text = tmpPortfolio.Caption
            cell.lblTitle.text = tmpPortfolio.Description
            cell.lblDate.text = tmpPortfolio.Date + " at " + tmpPortfolio.Time + " - " + tmpPortfolio.Location
            
            
            // Handling the button click
            
            cell.btnProfile!.tag=indexPath.row
            cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
            
            cell.btnPortfolio!.tag=indexPath.row
            cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
            
            cell.btnFav!.tag=indexPath.row
            cell.btnFav?.addTarget(self, action: #selector(JobCenter.btnfav(btn:)), for: UIControlEvents.touchUpInside)
            
            // Remove all Subviews from View 
            for view in cell.imgView.subviews {
                view.removeFromSuperview()
            }
            cell.imgHeight.constant = 160
            cell.portfolioHeight.constant = 160
            // Set Image for Album Images
            if tmpPortfolio.PortfolioImageList.count >= 3 {
                var count = 0
                var x = 5;
                for img in tmpPortfolio.PortfolioImageList {
                    if  count < 3
                    {
                        let imgView : UIImageView = UIImageView(frame: CGRect(x: x, y: 5, width: Int((Constants.ScreenSize.SCREEN_WIDTH / 3 ) - 20), height: 130))
                        
                        
                        if tmpPortfolio.PortfolioImageList[count].PortfolioImageLink != "" {
                            let imgURL = tmpPortfolio.PortfolioImageList[count].PortfolioImageLink as String
                            let urlPro = URL(string: imgURL)
                           
                            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: tmpPortfolio.PortfolioImageList[count].PortfolioImageLink)
                            let optionInfo: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1)),
                                
                                ]
                            imgView.kf.indicatorType = .activity
                            imgView.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                            imgView.clipsToBounds = true
                            imgView.contentMode = UIViewContentMode.scaleAspectFill
                            //ImgProfilePic?.clipsToBounds = true
                            //ImgProfilePic?.cornerRadius = (ImgProfilePic?.frame.size.width)! / 2
                        }
                        
                        //imgView.image = UIImage(named: "image")
                        cell.imgView.addSubview(imgView);
                        x = x + 5 + Int((Constants.ScreenSize.SCREEN_WIDTH / 3 ) - 20)
                        count = count + 1
                    }
                }
            }
            else if tmpPortfolio.PortfolioImageList.count == 2 {
                var count = 0
                var x = 5;
                for img in tmpPortfolio.PortfolioImageList {
                    if  count < 2
                    {
                        let imgView : UIImageView = UIImageView(frame: CGRect(x: x, y: 5, width: Int((Constants.ScreenSize.SCREEN_WIDTH / 2 ) - 15), height: 140))
                        if tmpPortfolio.PortfolioImageList[count].PortfolioImageLink != "" {
                            let imgURL = tmpPortfolio.PortfolioImageList[count].PortfolioImageLink as String
                            let urlPro = URL(string: imgURL)
                            
                            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: tmpPortfolio.PortfolioImageList[count].PortfolioImageLink)
                            let optionInfo: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1)),
                                
                                ]
                            imgView.kf.indicatorType = .activity
                            imgView.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                            imgView.clipsToBounds = true
                            imgView.contentMode = UIViewContentMode.scaleAspectFill
                            //ImgProfilePic?.clipsToBounds = true
                            //ImgProfilePic?.cornerRadius = (ImgProfilePic?.frame.size.width)! / 2
                        }
                        cell.imgView.addSubview(imgView);
                        x = x + 5 + Int((Constants.ScreenSize.SCREEN_WIDTH / 2 ) - 15)
                        count = count + 1
                    }
                }
                
            }
            else if tmpPortfolio.PortfolioImageList.count == 1 {
                var count = 0
                var x = 5;
                for img in tmpPortfolio.PortfolioImageList {
                    if  count < 1
                    {
                        let imgView : UIImageView = UIImageView(frame: CGRect(x: x, y: 5, width: Int((Constants.ScreenSize.SCREEN_WIDTH / 2 ) - 10), height: 150))
                        if tmpPortfolio.PortfolioImageList[count].PortfolioImageLink != "" {
                            let imgURL = tmpPortfolio.PortfolioImageList[count].PortfolioImageLink as String
                            let urlPro = URL(string: imgURL)
                            
                            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: tmpPortfolio.PortfolioImageList[count].PortfolioImageLink)
                            let optionInfo: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1)),
                                
                                ]
                            imgView.kf.indicatorType = .activity
                            imgView.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                            imgView.clipsToBounds = true
                            imgView.contentMode = UIViewContentMode.scaleAspectFill
                            //ImgProfilePic?.clipsToBounds = true
                            //ImgProfilePic?.cornerRadius = (ImgProfilePic?.frame.size.width)! / 2
                        }
                        cell.imgView.addSubview(imgView);
                        x = x + 5 + Int((Constants.ScreenSize.SCREEN_WIDTH / 1 ) - 10)
                        count = count + 1
                    }
                }
                cell.imgHeight.constant = 160
                cell.portfolioHeight.constant = 160
            }
            else {
                // Reduce height constraint of table by views height
                cell.imgHeight.constant = 0
                cell.portfolioHeight.constant = 0
            }
            
            
            //               cell.textLabel?.text = "Trades " +  "\(indexPath.row)"
            return cell
            
        }
        else if(tableView == self.tblFollowers)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowingListCell
            if(isFollowing)
            {
                cell.imgProfile?.kf.indicatorType = .activity
                let urlPro = URL(string: (self.profile.FollowingList?[indexPath.row].ProfileImageLink)!)
                cell.imgProfile?.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.profile.ProfileImageLink + "FollowingCell")
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    
                    ]
                cell.imgProfile?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                cell.lblName.text = self.profile.FollowingList?[indexPath.row].Name
                cell.lblCategory.text = "\(self.profile.FollowingList![indexPath.row].TradeCategoryName),\(self.profile.FollowingList![indexPath.row].CityName)"
                cell.lblCategory.numberOfLines  = 2
                cell.btnFollowButton.isHidden = false
                cell.btnFollowButton.tag = indexPath.row
                cell.btnFollowButton.addTarget(self, action: #selector(ProfileFeed.FollowUnfollowTapped(_:)), for: UIControlEvents.touchUpInside)
                
                if(self.profile.FollowingList![indexPath.row].IsFollow)
                {
                      cell.btnFollowButton.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
                    cell.btnFollowButton.isSelected = true
                   
                }
                else
                {
                     cell.btnFollowButton.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1/255.0, alpha: 1)
                    cell.btnFollowButton.isSelected = false
                }
            }
            else
            {
                cell.imgProfile?.kf.indicatorType = .activity
                let urlPro = URL(string: (self.profile.FollowerList?[indexPath.row].ProfileImageLink)!)
                cell.imgProfile?.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.profile.ProfileImageLink + "FollowerCell")
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    
                    ]
                
                cell.imgProfile?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                cell.lblName.text = self.profile.FollowerList?[indexPath.row].Name
                cell.lblCategory.text = "\(self.profile.FollowerList![indexPath.row].TradeCategoryName),\(self.profile.FollowerList![indexPath.row].CityName)"
                cell.btnFollowButton.tag = indexPath.row
                cell.btnFollowButton.addTarget(self, action: #selector(ProfileFeed.FollowUnfollowTapped(_:)), for: UIControlEvents.touchUpInside)
                cell.btnFollowButton.tag = indexPath.row
                if(self.profile.FollowerList![indexPath.row].IsFollow)
                {
                     cell.btnFollowButton.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
                    cell.btnFollowButton.isSelected = true
                }
                else
                {
                     cell.btnFollowButton.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1.0/255.0, alpha: 1)
                    cell.btnFollowButton.isSelected = false
                }
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExperienceCell
            cell.lblJobTitle.text = self.profile.ExperienceList?[indexPath.row].Title
            cell.lblCompanyName.text = self.profile.ExperienceList?[indexPath.row].CompanyName
            cell.lblFrom.text = self.profile.ExperienceList?[indexPath.row].ExperienceYear
            
            return cell
        }
    }
    
    
    func btnProfile (btn : UIButton) {
//        
//        
//        let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
//        obj.contractorId = (self.profile?[btn.tag].ContractorID)!
//        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    func btnPortfolio (btn : UIButton) {
        let obj : PortfolioDetails = self.storyboard?.instantiateViewController(withIdentifier: "PortfolioDetails") as! PortfolioDetails
        obj.portfolio = (self.profile?.PortfolioList?[btn.tag])!
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func btnfav(btn : UIButton)  {
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.profile.PortfolioList?[btn.tag].PrimaryID ?? "-1",
                     "PageType":6] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.jobList = Mapper<JobList>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    if self.profile.PortfolioList?[btn.tag].IsSaved  == false {
                        self.profile.PortfolioList?[btn.tag].IsSaved = true
                    }
                    else {
                        self.profile.PortfolioList?[btn.tag].IsSaved = false
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

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == AboutCollectionView {
            if  self.profile != nil {
                return (self.profile.CertificateFileList?.count)!
            }
            else {
                return 0
            }
        }
        else if collectionView == ObjCollectionView {
            if  self.profile != nil {
                let itemsPerRow:CGFloat = 2
                let hardCodedPadding:CGFloat = 5
                let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
                let itemHeight : CGFloat = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
                self.POrCollectionHeightConstraints.constant = CGFloat(((itemHeight/2) * CGFloat((profile.PortfolioList?.count)!)))
                return (self.profile.PortfolioList?.count)!
            }
            else {
                return 0
            }
        }
        else {
            return 10
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == ObjCollectionView {
            let Collectcell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCell
            
            Collectcell.lblTitle.text = self.profile.PortfolioList?[indexPath.row].Title
            
            let imgURL = (self.profile.PortfolioList?[indexPath.row].ThumbnailImageLink)! as String
            let urlPro = URL(string: imgURL)
            
            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: (self.profile.PortfolioList?[indexPath.row].ThumbnailImageLink)!)
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1)),
            ]
            Collectcell.PortfolioImage?.kf.indicatorType = .activity
            
            if  self.contractorId == sharedManager.currentUser.ContractorID {
                Collectcell.btnRemove.isHidden = false
                Collectcell.imgRemove.isHidden = false
                Collectcell.btnRemove.tag = indexPath.row
                Collectcell.btnRemove.addTarget(self, action: #selector(removePortfolio(sender:)), for: UIControlEvents.touchUpInside)
            }
            else {
                Collectcell.btnRemove.isHidden = true
                Collectcell.imgRemove.isHidden = true
            }

            
            Collectcell.PortfolioImage?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: { (img1, err, cacheType, url1) in
                //
                if (err != nil) {
                    Collectcell.PortfolioImage.image = #imageLiteral(resourceName: "ic_placeholder")
                    //self.profile.CertificateFileList?[indexPath.row].IsPDF=true
                }
                else {
                    Collectcell.PortfolioImage.image = img1
                }
            })
            
            return Collectcell
        }
        else if collectionView == AboutCollectionView
        {
            let Collectcell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCell
            
            if  self.profile.CertificateFileList?[indexPath.row].IsImage == false {
                 Collectcell.PortfolioImage.image = #imageLiteral(resourceName: "ic_pdf")
                Collectcell.lblTitle.text =  (self.profile.CertificateFileList?[indexPath.row].CertificateCategoryName)! as String
            }
            else {
            
            let imgURL = (self.profile.CertificateFileList?[indexPath.row].FileLink)! as String
            let urlPro = URL(string: imgURL)
            Collectcell.PortfolioImage?.kf.indicatorType = .activity
                Collectcell.lblTitle.text =  (self.profile.CertificateFileList?[indexPath.row].CertificateCategoryName)! as String

            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: (self.profile.CertificateFileList?[indexPath.row].FileLink)!)
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1)),
                //.forceRefresh
            ]
            
            
            
            Collectcell.PortfolioImage?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: { (img1, err, cacheType, url1) in
                //
                if (err != nil) {
                    Collectcell.PortfolioImage.image = #imageLiteral(resourceName: "ic_placeholder")
                    
                    
                }
                else {
                    Collectcell.PortfolioImage.image = img1
                }
            })
            }
            
            return Collectcell
            
        }
        else {
            let Collectcell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCell
            
            return Collectcell

        }
    }
    
    @IBAction func removePortfolio(sender : UIButton) {
        //PortfolioDelete
        
        let alert = UIAlertController(title: "Delete Album ?", message: "Are you sure you want to delete the album ? ", preferredStyle: UIAlertControllerStyle.alert);
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            self.startAnimating()
            let param = ["PortfolioID": self.profile.PortfolioList![sender.tag].PrimaryID,
                         "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.PortfolioDelete, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                // self.stopAnimating()
                
                print(JSONResponse["status"].rawValue as! String)
                
                if JSONResponse != nil {
                    
                    if JSONResponse["status"].rawString()! == "1"
                    {
                        self.stopAnimating()
                        
                        self.profile = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                        self.setProfile()
                        
                        self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                        
                    }
                    else
                    {
                        self.stopAnimating()
                        self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                    }
                }
                
            }) {
                (error) -> Void in
                self.stopAnimating()
                print(error.localizedDescription)
                self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
            }

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
        }))
        
        
        self.present(alert, animated: true) { 
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == self.ObjCollectionView {
            let itemsPerRow:CGFloat = 2
            let hardCodedPadding:CGFloat = 5
            let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            let itemHeight : CGFloat = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        else if collectionView.tag == 3 {
            let itemsPerRow:CGFloat = 2
            let hardCodedPadding:CGFloat = 5
            let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            let itemHeight : CGFloat = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else if(collectionView == AboutCollectionView)
        {
            let itemsPerRow:CGFloat = 2
            let hardCodedPadding:CGFloat = 0
            let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            let itemHeight : CGFloat = (collectionView.bounds.width / itemsPerRow) - 30
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else
        {
            let itemsPerRow:CGFloat = 2
            let hardCodedPadding:CGFloat = 5
            let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            let itemHeight : CGFloat = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == AboutCollectionView && self.profile.CertificateFileList?[indexPath.row].IsImage == false
        {
            
            let openLink = NSURL(string : (self.profile.CertificateFileList?[indexPath.row].FileLink)!)
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: openLink as! URL)
                present(svc, animated: true, completion: nil)
            } else {
                let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                port.strUrl = (self.profile.CertificateFileList?[indexPath.row].FileLink)!
                self.navigationController?.pushViewController(port, animated: true)

            }
        } else if collectionView == self.ObjCollectionView {
            
            if  self.contractorId == sharedManager.currentUser.ContractorID {
                // Redirect to edit portfolio
                let port : Editportfolio = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Editportfolio") as! Editportfolio
                port.portfolioId = (self.profile.PortfolioList?[indexPath.row].PrimaryID)!
                self.navigationController?.pushViewController(port, animated: true)
                
            }
            else {
                let port : PortfolioDetails = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PortfolioDetails") as! PortfolioDetails
                port.portfolio = self.profile.PortfolioList?[indexPath.row]
                self.navigationController?.pushViewController(port, animated: true)
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        if contractorId == (sharedManager.currentUser.ContractorID) {
            let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            app.moveToDashboard()

        }
        else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    func FollowUnfollowTapped(_ sender: UIButton) {
        
        self.startAnimating()
        
        var FollowContractorID = 0
        var strUrlTogaling = ""
        
        if(self.profile.FollowingList![sender.tag].IsContractor)
        {
            strUrlTogaling = Constants.URLS.FollowContractorToggle
            if(isFollowing)
            {
                FollowContractorID = self.profile.FollowingList![sender.tag].ContractorID
            }
            else
            {
                FollowContractorID = self.profile.FollowerList![sender.tag].ContractorID
            }
        }
        else
        {
            strUrlTogaling = Constants.URLS.FollowContractorToggle
            if(isFollowing)
            {
                FollowContractorID = self.profile.FollowingList![sender.tag].CompanyID
            }
            else
            {
                FollowContractorID = self.profile.FollowerList![sender.tag].CompanyID
            }
        }
        
        let param = ["FollowContractorID": FollowContractorID,
                     "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(strUrlTogaling, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            // self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    if(self.isFollowing)
                    {
                        if(self.profile.FollowingList![sender.tag].IsFollow)
                        {
                            self.profile.FollowingList![sender.tag].IsFollow = false
                        }
                        else
                        {
                            self.profile.FollowingList![sender.tag].IsFollow = true
                        }

                    }
                    else
                    {
                        if(self.profile.FollowerList![sender.tag].IsFollow)
                        {
                            self.profile.FollowerList![sender.tag].IsFollow = false
                        }
                        else
                        {
                            self.profile.FollowerList![sender.tag].IsFollow = true
                        }

                    }
                    self.tblFollowers.reloadData()
                }
                else
                {
                    self.stopAnimating()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func DisPlayCountInLabel(FollowingCount:String,followerCount:String) -> NSMutableAttributedString
    {
        let myString = "\(FollowingCount)Following \(followerCount)Followers"
        let myRange = NSRange(location: 0, length: FollowingCount.length)
        let myRange2 = NSRange(location: FollowingCount.length, length: 10)
        let myRange3 = NSRange(location: FollowingCount.length+10+followerCount.length, length: 9)
        let myRange1 = NSRange(location: followerCount.length+10, length: followerCount.length)
        let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.black]
         let anotherAttribute1 = [ NSForegroundColorAttributeName: UIColor.lightGray]
        let myAttrString = NSMutableAttributedString(string: myString)
        myAttrString.addAttributes(anotherAttribute, range: myRange)
        myAttrString.addAttributes(anotherAttribute, range: myRange1)
         myAttrString.addAttributes(anotherAttribute1, range: myRange2)
         myAttrString.addAttributes(anotherAttribute1, range: myRange3)
        return myAttrString
    }
}
