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
import SKPhotoBrowser

class ProfileFeed: UIViewController, UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, NVActivityIndicatorViewable,SKPhotoBrowserDelegate{

    
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    
    var popover = Popover()
    let sharedManager : Globals = Globals.sharedInstance
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var contractorId = 0;
    var protfolioId = 0;
    var isPortFolio : Bool = false;
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var profile  : SignIn!
    var isFollowing:Bool = true
    var isFristTime:Bool = true
    
    @IBOutlet weak var lblOwnVehical: UILabel!
    @IBOutlet weak var lblLicenseOwner: UILabel!
    @IBOutlet weak var rateViewHeightConstrints: NSLayoutConstraint!
    
    @IBOutlet weak var txtBoiHeigthConstrainte: NSLayoutConstraint!
    
    @IBOutlet weak var isOwner: UISwitch!
    @IBOutlet weak var isVehical: UISwitch!
    
    
     @IBOutlet var  tagListView:TagListView!
    
    @IBOutlet weak var noListView: UIView!
    @IBOutlet weak var AboutCollectionView: UICollectionView!
    @IBOutlet weak var TblAboutus: UITableView!
    @IBOutlet weak var ObjScrollview: UIScrollView!
    @IBOutlet weak var ObjCollectionView: UICollectionView!
    @IBOutlet weak var ImgProfilePic: UIImageView!
    @IBOutlet weak var ImgStar: UIButton!
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
  //  @IBOutlet weak var HeightAboutView: NSLayoutConstraint!
    
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
    @IBOutlet weak var viewSkillHeightConstraint: NSLayoutConstraint!
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
   // @IBOutlet var lblAbtSkill : UILabel!
    @IBOutlet var lblAbtHourly : UILabel!
    @IBOutlet var lblAbtDaily : UILabel!
    
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
        lblFollowers.text = ""
        lblFollowing.text = ""
        self.TblAboutus.delegate = self
        self.TblAboutus.dataSource = self
        TblTimeline.delegate = self
        TblTimeline.dataSource = self
        TblTimeline.rowHeight = UITableViewAutomaticDimension
        TblTimeline.estimatedRowHeight = 450
        TblTimeline.tableFooterView = UIView()
        TblAboutus.rowHeight = UITableViewAutomaticDimension
        TblAboutus.estimatedRowHeight = 450
        ObjScrollview.delegate = self
        self.tblFollowerHeight.constant = 0
        self.TblHeightConstraints.constant = 0
        self.POrCollectionHeightConstraints.constant = 0
        
        self.AboutviewHeight.constant = 265 * 10
        self.viewSkillHeightConstraint.constant = 300
        self.ObjScrollview.contentSize.height = self.PortCollectionHeight.constant
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
        
        if(isPortFolio)
        {
            self.BtnActivty.isSelected = false
            self.BtnActivty.tintColor = UIColor.white
            self.BtnActivty.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
            
            self.BtnAbout.isSelected = false
            self.BtnAbout.tintColor = UIColor.white
            self.BtnAbout.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
            
            self.BtnPortfolio.isSelected = true
            self.BtnPortfolio.tintColor = UIColor.white
            self.BtnPortfolio.setTitleColor(UIColor.red, for: UIControlState.selected)
        }
        else
        {
            self.BtnPortfolio.isSelected = false
            self.BtnPortfolio.tintColor = UIColor.white
            self.BtnPortfolio.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
            
            self.BtnAbout.isSelected = false
            self.BtnAbout.tintColor = UIColor.white
            self.BtnAbout.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
            
            self.BtnActivty.isSelected = true
            self.BtnActivty.tintColor = UIColor.white
            self.BtnActivty.setTitleColor(UIColor.red, for: UIControlState.selected)
        }
        
        if(self.BtnAbout.isSelected)
        {
            self.TblTimeline.isHidden = true
            self.PortfolioView.isHidden = true
            self.AboutView.isHidden = false
        }
        if(self.BtnActivty.isSelected)
        {
            self.TblTimeline.isHidden = false
            self.PortfolioView.isHidden = true
            self.AboutView.isHidden = true
        }
        if(self.BtnPortfolio.isSelected)
        {
            self.TblTimeline.isHidden = true
            self.PortfolioView.isHidden = false
            self.AboutView.isHidden = true
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblModTaped(tapGestureRecognizer:)))
        lblAbtMob.isUserInteractionEnabled = true
        lblAbtMob.addGestureRecognizer(tapGestureRecognizer)
        
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblTelTaped(tapGestureRecognizer:)))
        lblAbtTel.isUserInteractionEnabled = true
        lblAbtTel.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(lblEmailTaped(tapGestureRecognizer:)))
        lblAbtEmail.isUserInteractionEnabled = true
        lblAbtEmail.addGestureRecognizer(tapGestureRecognizer2)
        
        
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(lblFollowersTaped(tapGestureRecognizer:)))
        lblFollowers.isUserInteractionEnabled = true
        lblFollowers.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(lblFollowingsTaped(tapGestureRecognizer:)))
        lblFollowing.isUserInteractionEnabled = true
        lblFollowing.addGestureRecognizer(tapGestureRecognizer4)
        getProfile()
    }
    
    func lblModTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        if(lblAbtMob.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblAbtMob.text!))")!))
            {
                 UIApplication.shared.openURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblAbtMob.text!))")!)
            }
            else
            {
               self.view.makeToast("Mobile Number not valid.", duration: 3, position: .bottom) 
            }
        }
    }
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    func lblTelTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
    
        if(lblAbtTel.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblAbtTel.text!))")!))
            {
                UIApplication.shared.openURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblAbtTel.text!))")!)
            }
            else
            {
                self.view.makeToast("Number not valid.", duration: 3, position: .bottom)
            }
        }
    }
    func lblEmailTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        if(lblAbtEmail.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "mailto://\(lblAbtEmail.text!)")!))
            {
                UIApplication.shared.openURL(URL(string: "mailto://\(lblAbtEmail.text!)")!)
            }
            else
            {
                self.view.makeToast("Email not valid.", duration: 3, position: .bottom)
            }
        }
    }
    func lblFollowersTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        isFollowing = false
        btnFollwer.isSelected = true
        btnFollowing.isSelected = false
        if(self.profile.FollowerList?.count == 0)
        {
            noListView.isHidden = false
        }
        else
        {
            noListView.isHidden = true
        }
        
        self.TblTimeline.isHidden = true
        self.PortfolioView.isHidden = true
        self.AboutView.isHidden = true
        
        tblFollowers.isHidden = false
        tblFollowers.reloadData()
        self.TblTimeline.reloadData()
        
        DispatchQueue.main.async
            {
                self.TblHeightConstraints.constant = self.tblFollowerHeight.constant
                self.POrCollectionHeightConstraints.constant = self.tblFollowerHeight.constant
                self.tblFollowerHeight.constant = 237 + self.tblFollowers.contentSize.height
                self.ObjScrollview.contentSize.height = self.tblFollowerHeight.constant
        }
         self.btnCountFollower.isUserInteractionEnabled = true
        let myRange = NSRange(location: 0, length: 16)
        let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.black]
        let myAttrString = NSMutableAttributedString(string: "Back to Timeline")
        myAttrString.addAttributes(anotherAttribute, range: myRange)
        btnCountFollower.setAttributedTitle(myAttrString, for: UIControlState.normal)
        lblFollowers.text = ""
        lblFollowing.text = ""
    }
    func lblFollowingsTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        isFollowing = true
        btnFollwer.isSelected = false
        btnFollowing.isSelected = true
        
        if(self.profile.FollowingList?.count == 0)
        {
            noListView.isHidden = false
        }
        else
        {
            noListView.isHidden = true
        }
        self.TblTimeline.isHidden = true
        self.PortfolioView.isHidden = true
        self.AboutView.isHidden = true
        
        tblFollowers.isHidden = false
        tblFollowers.reloadData()
        self.TblTimeline.reloadData()
        
        DispatchQueue.main.async
            {
                self.TblHeightConstraints.constant = self.tblFollowerHeight.constant
                self.POrCollectionHeightConstraints.constant = self.tblFollowerHeight.constant
                self.tblFollowerHeight.constant = 237 + self.tblFollowers.contentSize.height
                self.ObjScrollview.contentSize.height = self.tblFollowerHeight.constant
        }
        
        self.btnCountFollower.isUserInteractionEnabled = true
        let myRange = NSRange(location: 0, length: 16)
        let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.black]
        let myAttrString = NSMutableAttributedString(string: "Back to Timeline")
        myAttrString.addAttributes(anotherAttribute, range: myRange)
        btnCountFollower.setAttributedTitle(myAttrString, for: UIControlState.normal)
        lblFollowers.text = ""
        lblFollowing.text = ""
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    override func viewWillAppear(_ animated: Bool) {
    
        if  contractorId == sharedManager.currentUser.ContractorID
        {
            getProfile()
        }
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Profile Feed Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
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
    @IBAction func btnOpenFollowerAction(_ sender: UIButton)
    {
        noListView.isHidden = true
        self.DisPlayCountInLabel(FollowingCount: "\(self.profile.FollowingList!.count) ", followerCount: "\(self.profile.FollowerList!.count) ")
        
        tblFollowers.isHidden = true
        tblFollowerHeight.constant = 0
        if(self.BtnAbout.isSelected)
        {
            self.TblTimeline.isHidden = true
            self.PortfolioView.isHidden = true
            self.AboutView.isHidden = false
        }
        if(self.BtnActivty.isSelected)
        {
            self.TblTimeline.isHidden = false
            self.PortfolioView.isHidden = true
            self.AboutView.isHidden = true
        }
        if(self.BtnPortfolio.isSelected)
        {
            self.TblTimeline.isHidden = true
            self.PortfolioView.isHidden = false
            self.AboutView.isHidden = true
        }
        setLayoutInView()
       
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
        setLayoutInView()
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
        setLayoutInView()
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
                    self.profile = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                    
                    DispatchQueue.main.async
                        {
                            self.setProfile()
                        }
                    self.stopAnimating()
                }
                else
                {
                    self.stopAnimating()
                    _ = self.navigationController?.popViewController(animated: true)
                    AppDelegate.sharedInstance().window?.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
             
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
        
    }
    @IBAction func btnSaveContractor(btn : UIButton)
    {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.profile.ContractorID,
                     "PageType": "2"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    btn.isSelected = !btn.isSelected
                    if self.profile.IsSaved == true{
                        self.profile.IsSaved = false
                    }
                    else{
                        self.profile.IsSaved = true
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
    func setProfile(){
        self.lblName.text = self.profile.FirstName + " " + self.profile.LastName
        self.lblSkill.text = self.profile.TradeCategoryName
        self.lblLocation.text = self.profile.CityName
        
        // Setting About Info :
        
        if  self.profile.IsSaved == true {
            self.ImgStar.isSelected = true
        } else {
            self.ImgStar.isSelected = false
        }
        
        if self.profile.IsFollow == true {
            self.BtnFollow.setTitle("Following", for: UIControlState.normal)
            self.BtnFollow.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1/255.0, alpha: 1)
        } else {
            self.BtnFollow.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
            self.BtnFollow.setTitle("Follow", for: UIControlState.normal)
        }
        if  contractorId == sharedManager.currentUser.ContractorID
        {
            self.BtnFollow.isHidden = true;
            self.BtnMessage.isHidden = true;
            self.BtnEditProfile.isHidden = false;
            self.ImgStar.isHidden = true
        }
        else
        {
            self.ImgStar.isHidden = false
            if self.profile.IsFollowing == true {
                self.BtnMessage.isHidden = false
            } else {
                self.BtnMessage.isHidden = true
            }
            self.BtnEditProfile.isHidden = true;
        }
        if(!BtnAbout.isSelected)
        {
            if(self.profile.PortfolioList?.count == 0)
            {
                noListView.isHidden = false
            }
            else
            {
                noListView.isHidden = true
            }
        }
        if(!tblFollowers.isHidden)
        {
            if(isFollowing == false)
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
            else{
                if(self.profile.FollowingList?.count == 0)
                {
                    noListView.isHidden = false
                }
                else
                {
                    noListView.isHidden = true
                }
            }
        }
        self.lblAbtDOb.text = self.profile.DOB
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: self.profile.MobileNumber, attributes: underlineAttribute)
        self.lblAbtMob.attributedText = underlineAttributedString
        
        
        let underlineAttribute1 = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString1 = NSAttributedString(string: self.profile.LandlineNumber, attributes: underlineAttribute1)
        self.lblAbtTel.attributedText = underlineAttributedString1
        
        self.lblAbtHourly.text = self.profile.PerHourRate
        self.lblAbtDaily.text = self.profile.PerDayRate
        
        let underlineAttribute2 = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString2 = NSAttributedString(string: self.profile.EmailID, attributes: underlineAttribute2)
        self.lblAbtEmail.attributedText = underlineAttributedString2
        self.txtAbtViewAbout.text = self.profile.Aboutme
        
    
        self.lblAbtPostCode.text = self.profile.Zipcode
        self.lblAbtDistanceCovered.text = String(self.profile.DistanceRadius)
        self.lblAbtTrade.text = self.profile.TradeCategoryName
        
        tagListView.reset()
        var ProfileSkills : [String] = []
        for skill in self.profile.ServiceList! {
            let color:UIColor!
            color = UIColor.lightGray
            tagListView.addTag(skill.ServiceName, target: self, tapAction: "tap:", longPressAction: "longPress:",backgroundColor: color,textColor: UIColor.black)
            ProfileSkills.append(skill.ServiceName)
        }
         viewSkillHeightConstraint.constant = tagListView.contentSize.height + 10
        if(self.profile.ServiceList!.count == 0)
        {
           viewSkillHeightConstraint.constant = 20
        }
        txtBoiHeigthConstrainte.constant = txtAbtViewAbout.contentSize.height
        if(self.profile.Aboutme == "")
        {
          txtBoiHeigthConstrainte.constant = 0
        }
        self.lblAbtTrade.text = self.profile.TradeCategoryName
        self.isOwner.isOn  = self.profile.IsLicenceHeld
        self.isVehical.isOn = self.profile.IsOwnVehicle
        
        self.isVehical.isHidden = true
        self.isOwner.isHidden = true
        self.rateViewHeightConstrints.constant = 177
        if(self.isOwner.isOn)
        {
          // self.isOwner.isHidden = false
        
        }
        else
        {
            lblLicenseOwner.text = nil
           self.rateViewHeightConstrints.constant = 147
        }
       
        if(self.isVehical.isOn)
        {
          //  self.isVehical.isHidden = false
        }
        else
        {
           
             lblOwnVehical.text = nil
            self.rateViewHeightConstrints.constant = self.rateViewHeightConstrints.constant - 30
        }
        
        if(lblAbtMob.text == "")
        {
            lblAbtMob.text = "N/A"
        }
        if(lblAbtTel.text == "")
        {
            lblAbtTel.text = "N/A"
        }
        if(lblAbtEmail.text == "")
        {
            lblAbtEmail.text = "N/A"
        }
        if(lblAbtDOb.text == "")
        {
            lblAbtDOb.text = "N/A"
        }
        if(lblAbtPostCode.text == "")
        {
            lblAbtPostCode.text = "---"
        }
        if(lblAbtDistanceCovered.text == "")
        {
            lblAbtDistanceCovered.text = "N/A"
        }
        if(lblAbtTrade.text == "")
        {
            lblAbtTrade.text = "N/A"
        }

    
        self.TblAboutus.reloadData()
        self.TblTimeline.reloadData()
        self.AboutCollectionView.reloadData()
        self.ObjCollectionView.reloadData()
        self.tblFollowers.reloadData()
         
        print("\(self.profile.FollowingList!.count) ")
        print("\(self.profile.FollowerList!.count) ")
        if(tblFollowers.isHidden)
        {
            
            self.DisPlayCountInLabel(FollowingCount: "\(self.profile.FollowingList!.count) ", followerCount: "\(self.profile.FollowerList!.count) ")
        }
      
       
        self.TblTimeline.reloadData()
        setLayoutInView()
        
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
        if(self.profile.ExperienceList?.count == 0)
        {
            self.TblHeightConstraints.constant = 0
        }
        else
        {
        
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
        
        if(isPortFolio)
        {
            if(isFristTime)
            {
                for  porotfolio:Portfolio in self.profile.PortfolioList!
                {
                    if(porotfolio.PrimaryID == protfolioId)
                    {
                        self.isFristTime = false
                        
                        let port : PortfolioDetails = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PortfolioDetails") as! PortfolioDetails
                        port.portfolio = porotfolio
                        self.navigationController?.pushViewController(port, animated: false)
                    }
                }
            }
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
                         self.BtnFollow.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
                    } else {
                          self.BtnFollow.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1/255.0, alpha: 1)
                        self.profile.IsFollow = true
                        self.BtnFollow.setTitle("Following", for: UIControlState.normal)
                    }
                    self.getProfile()

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
        else
        {
            AppDelegate.sharedInstance().initSignalR()
            appDelegate?.persistentConnection.send(Command.messageSendCommand(friendId: String(self.profile.UserID), msg: ""))
            NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED), object: nil) as Notification)
            let msgVC : MessageTab = self.storyboard?.instantiateViewController(withIdentifier: "MessageTab") as! MessageTab
            msgVC.selectedSenderId = self.profile.UserID
            msgVC.isNext = true
            self.navigationController?.pushViewController(msgVC, animated: true)
        }
    }

    @IBAction func BtnActivtyTapped(_ sender: Any) {

        self.TblTimeline.reloadData()
        
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
        if(self.profile.PortfolioList?.count == 0)
        {
            noListView.isHidden = false
        }
        else
        {
            noListView.isHidden = true
        }
         setLayoutInView()
    }
    @IBAction func BtnAboutTapped(_ sender: Any) {
       
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
        noListView.isHidden = true
        setLayoutInView()
    }
    @IBAction func BtnPortfolioTapped(_ sender: Any)
    {
        setLayoutInView()
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
        noListView.isHidden = true
         setLayoutInView()
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
             
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        setLayoutInView()
    }
    func setLayoutInView()
    {
         txtBoiHeigthConstrainte.constant = txtAbtViewAbout.contentSize.height
        if(!tblFollowers.isHidden)
        {
            DispatchQueue.main.async
                {
                    self.TblHeightConstraints.constant = self.tblFollowerHeight.constant
                    self.AboutviewHeight.constant = self.tblFollowerHeight.constant
                    self.POrCollectionHeightConstraints.constant = self.tblFollowerHeight.constant
                    self.tblFollowerHeight.constant = 237 + self.tblFollowers.contentSize.height
                    self.ObjScrollview.contentSize.height = self.tblFollowerHeight.constant
            }
            return
        }
        if(self.BtnAbout.isSelected)
        {
            DispatchQueue.main.async
                {
                    self.AboutviewHeight.constant = self.TblAboutus.contentSize.height
                    if(self.profile.ExperienceList?.count == 0)
                    {
                        self.AboutviewHeight.constant = 0
                    }
                   // self.AboutviewHeight.constant = self.TblAboutus.contentSize.height
                    
                    self.tblFollowerHeight.constant = 237 + self.AboutCollectionView.frame.size.height + self.AboutCollectionView.frame.origin.y
                    self.TblHeightConstraints.constant = 237 + self.AboutCollectionView.frame.size.height + self.AboutCollectionView.frame.origin.y
                    self.POrCollectionHeightConstraints.constant = 237 + self.AboutCollectionView.frame.size.height + self.AboutCollectionView.frame.origin.y
                    if(self.profile.CertificateFileList?.count == 0)
                    {
                        self.ObjScrollview.contentSize.height = 237 + self.AboutCollectionView.frame.origin.y
                    }
                    else
                    {
                        self.ObjScrollview.contentSize.height = 237 + self.AboutCollectionView.frame.size.height + self.AboutCollectionView.frame.origin.y
                    }
            }
        }
        if(self.BtnActivty.isSelected)
        {
            DispatchQueue.main.async {
                self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
                self.tblFollowerHeight.constant = self.TblTimeline.contentSize.height
               // self.AboutviewHeight.constant = self.TblTimeline.contentSize.height
                self.POrCollectionHeightConstraints.constant = self.TblTimeline.contentSize.height
                self.ObjScrollview.contentSize.height = 237 + self.TblHeightConstraints.constant
            }
        }
        if(self.BtnPortfolio.isSelected)
        {
            DispatchQueue.main.async
                {
                    self.tblFollowerHeight.constant = self.ObjCollectionView.contentSize.height
                  //  self.AboutviewHeight.constant = self.ObjCollectionView.contentSize.height
                    self.TblHeightConstraints.constant = self.ObjCollectionView.contentSize.height
                    self.POrCollectionHeightConstraints.constant = self.ObjCollectionView.contentSize.height
                    self.ObjScrollview.contentSize.height = 237 + self.POrCollectionHeightConstraints.constant + 20
            }
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
                return  (self.profile.ExperienceList?.count)!
                
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.TblTimeline {
            let lastRowIndex = tableView.numberOfRows(inSection: 0)
            if indexPath.row == lastRowIndex - 1
            {
                self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == self.TblTimeline {
            
            let cvimgcnt : Int = (self.profile.PortfolioList![indexPath.row].PortfolioImageList.count)
            
            if cvimgcnt == 0{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashBoardTvCell
                
                
                let myString = "\(self.profile.FirstName + " " + self.profile.LastName)-\(self.profile.TradeCategoryName) \(self.profile.PortfolioList![indexPath.row].Caption)"
                var myRange = NSRange(location:("\(self.profile.FirstName + " " + self.profile.LastName)").length+1, length: "\(self.profile.TradeCategoryName) \(self.profile.PortfolioList![indexPath.row].Caption)".length)
                let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                
                let myAttrString = NSMutableAttributedString(string: myString)
                let anotherAttribute1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: (cell.lbltitle.font?.pointSize)!)]
                var myRange1 = NSRange(location:0, length: "\(self.profile.FirstName + " " + self.profile.LastName)".length+1)
                myAttrString.addAttributes(anotherAttribute1, range: myRange1)
                myAttrString.addAttributes(anotherAttribute, range: myRange)
                cell.lbltitle.attributedText = myAttrString
                
                cell.lbltitle.tag = indexPath.row
               
                
                cell.lbldate.text = "\(self.profile.PortfolioList![indexPath.row].DateTimeCaption)-\(self.profile.PortfolioList![indexPath.row].Location)"
                cell.lblhtml.text = self.profile.PortfolioList![indexPath.row].Description as String!
                
                let imgURL = self.profile.PortfolioList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(btnfav(btn:)), for: UIControlEvents.touchUpInside)
                
                if self.profile.PortfolioList![indexPath.row].IsSaved == true {
                    cell.btnfav.isSelected = true
                }
                else{
                    cell.btnfav.isSelected = false
                    
                }
                return cell
            }
                
            else if cvimgcnt == 1{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! DashBoardTv1Cell
                let myString = "\(self.profile.FirstName + " " + self.profile.LastName)-\(self.profile.TradeCategoryName) \(self.profile.PortfolioList![indexPath.row].Caption)"
                var myRange = NSRange(location:("\(self.profile.FirstName + " " + self.profile.LastName)").length+1, length: "\(self.profile.TradeCategoryName) \(self.profile.PortfolioList![indexPath.row].Caption)".length)
                let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                
                let myAttrString = NSMutableAttributedString(string: myString)
                myAttrString.addAttributes(anotherAttribute, range: myRange)
                let anotherAttribute1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: (cell.lbltitle.font?.pointSize)!)]
               var myRange1 = NSRange(location:0, length: "\(self.profile.FirstName + " " + self.profile.LastName)".length+1)
                myAttrString.addAttributes(anotherAttribute1, range: myRange1)
                cell.lbltitle.attributedText = myAttrString
                
                cell.lbltitle.tag = indexPath.row
                
                 cell.lbldate.text = "\(self.profile.PortfolioList![indexPath.row].DateTimeCaption)-\(self.profile.PortfolioList![indexPath.row].Location)"
                cell.lblhtml.text = self.profile.PortfolioList![indexPath.row].Description as String!
                
                let imgURL = self.profile.PortfolioList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnPortfolio!.tag=indexPath.row
                cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(btnfav(btn:)), for: UIControlEvents.touchUpInside)
                
                if self.profile.PortfolioList![indexPath.row].IsSaved == true {
                    cell.btnfav.isSelected = true
                }
                else{
                    cell.btnfav.isSelected = false
                    
                }
                let imgURL1 = self.profile.PortfolioList![indexPath.row].PortfolioImageList[0].PortfolioImageLink as String!
                let url1 = URL(string: imgURL1!)
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: url1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                    if(error == nil)
                    {
                        if(image != nil)
                        {
                            cell.setCustomImage(image : image!)
                            if(cell.isReload)
                            {
                                cell.isReload = false
                                tableView.reloadData()
                            }
                        }
                    }
                })
                return cell
            }
                
            else if cvimgcnt == 2{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DashBoardTv2Cell
                let myString = "\(self.profile.FirstName + " " + self.profile.LastName)-\(self.profile.TradeCategoryName) \(self.profile.PortfolioList![indexPath.row].Caption)"
                var myRange = NSRange(location:("\(self.profile.FirstName + " " + self.profile.LastName)").length+1, length: "\(self.profile.TradeCategoryName) \(self.profile.PortfolioList![indexPath.row].Caption)".length)
                let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                
                let myAttrString = NSMutableAttributedString(string: myString)
                myAttrString.addAttributes(anotherAttribute, range: myRange)
                let anotherAttribute1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: (cell.lbltitle.font?.pointSize)!)]
               var myRange1 = NSRange(location:0, length: "\(self.profile.FirstName + " " + self.profile.LastName)".length+1)
                myAttrString.addAttributes(anotherAttribute1, range: myRange1)
                cell.lbltitle.attributedText = myAttrString
                
                cell.lbltitle.tag = indexPath.row
            
                
                 cell.lbldate.text = "\(self.profile.PortfolioList![indexPath.row].DateTimeCaption)-\(self.profile.PortfolioList![indexPath.row].Location)"
                cell.lblhtml.text = self.profile.PortfolioList![indexPath.row].Description as String!
                
                let imgURL = self.profile.PortfolioList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnPortfolio!.tag=indexPath.row
                cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(btnfav(btn:)), for: UIControlEvents.touchUpInside)
                
                if self.profile.PortfolioList![indexPath.row].IsSaved == true {
                    cell.btnfav.isSelected = true
                }
                else{
                    cell.btnfav.isSelected = false
                    
                }
                
                let imgURL1 = self.profile.PortfolioList![indexPath.row].PortfolioImageList[0].PortfolioImageLink as String!
                let url1 = URL(string: imgURL1!)
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                let imgURL2 = self.profile.PortfolioList![indexPath.row].PortfolioImageList[1].PortfolioImageLink as String!
                let url2 = URL(string: imgURL2!)
                cell.img2.kf.indicatorType = .activity
                cell.img2.kf.setImage(with: url2, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                return cell
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DashBoardTv3Cell
                let myString = "\(self.profile.FirstName + " " + self.profile.LastName)-\(self.profile.TradeCategoryName) \(self.profile.PortfolioList![indexPath.row].Caption)"
                var myRange = NSRange(location:("\(self.profile.FirstName + " " + self.profile.LastName)").length+1, length: "\(self.profile.TradeCategoryName) \(self.profile.PortfolioList![indexPath.row].Caption)".length)
                let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                
                let myAttrString = NSMutableAttributedString(string: myString)
                myAttrString.addAttributes(anotherAttribute, range: myRange)
                let anotherAttribute1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: (cell.lbltitle.font?.pointSize)!)]
               var myRange1 = NSRange(location:0, length: "\(self.profile.FirstName + " " + self.profile.LastName)".length+1)
                myAttrString.addAttributes(anotherAttribute1, range: myRange1)
                cell.lbltitle.attributedText = myAttrString
                
                cell.lbltitle.tag = indexPath.row
                
                
               cell.lbldate.text = "\(self.profile.PortfolioList![indexPath.row].DateTimeCaption)-\(self.profile.PortfolioList![indexPath.row].Location)"
                cell.lblhtml.text = self.profile.PortfolioList![indexPath.row].Description as String!
                
                let imgURL = self.profile.PortfolioList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnPortfolio!.tag=indexPath.row
                cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(btnfav(btn:)), for: UIControlEvents.touchUpInside)
                
                if self.profile.PortfolioList![indexPath.row].IsSaved == true {
                    cell.btnfav.isSelected = true
                }
                else{
                    cell.btnfav.isSelected = false
                    
                }
                
                let imgURL1 = self.profile.PortfolioList![indexPath.row].PortfolioImageList[0].PortfolioImageLink as String!
                let url1 = URL(string: imgURL1!)
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                let imgURL2 = self.profile.PortfolioList![indexPath.row].PortfolioImageList[1].PortfolioImageLink as String!
                let url2 = URL(string: imgURL2!)
                cell.img2.kf.indicatorType = .activity
                cell.img2.kf.setImage(with: url2, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                let imgURL3 = self.profile.PortfolioList![indexPath.row].PortfolioImageList[2].PortfolioImageLink as String!
                let url3 = URL(string: imgURL3!)
                cell.img3.kf.indicatorType = .activity
                cell.img3.kf.setImage(with: url3, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                cell.overlayView.isHidden = true
                if(cvimgcnt > 3)
                {
                    cell.overlayView.isHidden = false
                    cell.lblPhotoCount.text = "+\(cvimgcnt - 3)\nView All"
                }
                return cell
            }
        }
        else if(tableView == self.tblFollowers)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowingListCell
            if(isFollowing)
            {
                let urlPro = URL(string: (self.profile.FollowingList?[indexPath.row].ProfileImageLink)!)
                cell.imgProfile?.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: (self.profile.FollowingList?[indexPath.row].ProfileImageLink)! + "FollowingCell")
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
                     cell.btnFollowButton.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1/255.0, alpha: 1)
                    cell.btnFollowButton.isSelected = true
                   
                }
                else
                {
                     cell.btnFollowButton.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
                    
                    cell.btnFollowButton.isSelected = false
                }
                if(self.profile.FollowingList![indexPath.row].IsContractor)
                {
                    if(self.profile.FollowingList![indexPath.row].ContractorID == sharedManager.currentUser.ContractorID)
                    {
                      cell.btnFollowButton.isHidden = true
                    }
                    else
                    {
                      cell.btnFollowButton.isHidden = false
                    }
                }
                else
                {
                   cell.btnFollowButton.isHidden = false
                }
            }
            else
            {
                cell.imgProfile?.kf.indicatorType = .activity
                let urlPro = URL(string: (self.profile.FollowerList?[indexPath.row].ProfileImageLink)!)
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: (self.profile.FollowerList?[indexPath.row].ProfileImageLink)! + "FollowerCell")
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
                   cell.btnFollowButton.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1.0/255.0, alpha: 1)
                    cell.btnFollowButton.isSelected = true
                }
                else
                {
                      cell.btnFollowButton.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
                    cell.btnFollowButton.isSelected = false
                }
                if(self.profile.FollowerList![indexPath.row].IsContractor)
                {
                    if(self.profile.FollowerList![indexPath.row].ContractorID == sharedManager.currentUser.ContractorID)
                    {
                        cell.btnFollowButton.isHidden = true
                    }
                    else
                    {
                        cell.btnFollowButton.isHidden = false
                    }
                }
                else
                {
                    cell.btnFollowButton.isHidden = false
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(tableView == tblFollowers)
        {
            if(isFollowing)
            {
                if(self.profile.FollowingList![indexPath.row].IsContractor)
                {
                    let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                    companyVC.contractorId = self.profile.FollowingList![indexPath.row].PrimaryID
                    self.navigationController?.pushViewController(companyVC, animated: true)
                }
                else
                {
                     let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                    companyVC.companyId = self.profile.FollowingList![indexPath.row].PrimaryID
                     self.navigationController?.pushViewController(companyVC, animated: true)
                }
               
            }
            else
            {
                if(self.profile.FollowerList![indexPath.row].IsContractor)
                {
                    let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                    companyVC.contractorId = self.profile.FollowerList![indexPath.row].PrimaryID
                    self.navigationController?.pushViewController(companyVC, animated: true)
                }
                else
                {
                    let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                    companyVC.companyId = self.profile.FollowerList![indexPath.row].PrimaryID
                    self.navigationController?.pushViewController(companyVC, animated: true)
                }
            }
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
                
            }
            
        }) {
            (error) -> Void in
             
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
                if  self.contractorId == sharedManager.currentUser.ContractorID {
                    return (self.profile.PortfolioList?.count)!+1
                }
                else
                {
                    return (self.profile.PortfolioList?.count)!
                }
                
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
            
            if  self.contractorId == sharedManager.currentUser.ContractorID {
                if((self.profile.PortfolioList?.count) == indexPath.row)
                {
                    Collectcell.PortfolioImage.image = UIImage(named: "ic_Addimgae")
                    Collectcell.btnRemove.isHidden = true
                    Collectcell.imgRemove.isHidden = true
                    Collectcell.lblTitle.text = "Add Portfolio Item"
                    return Collectcell
                }
                else
                {
                    
                }
            }
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
            let itemsPerRow:CGFloat = 2.5
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
        }
        else if collectionView == AboutCollectionView && self.profile.CertificateFileList?[indexPath.row].IsImage == true
        {
        
            let photo = SKPhoto.photoWithImageURL((self.profile.CertificateFileList?[indexPath.row].FileLink)!)
            photo.caption = ("")
            photo.shouldCachePhotoURLImage = true
        
            let browser = SKPhotoBrowser(photos: [photo])
            browser.initializePageIndex(indexPath.row)
            browser.delegate = self
            
            present(browser, animated: true, completion: nil)
        }
        else if collectionView == self.ObjCollectionView {
            
            if  self.contractorId == sharedManager.currentUser.ContractorID {
                // Redirect to edit portfolio
                if((self.profile.PortfolioList?.count) != indexPath.row)
                {
                    let port : Editportfolio = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Editportfolio") as! Editportfolio
                    port.portfolioId = (self.profile.PortfolioList?[indexPath.row].PrimaryID)!
                    self.navigationController?.pushViewController(port, animated: true)
                }
                else
                {
                    let port : Addportfolio = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Addportfolio") as! Addportfolio

                    self.navigationController?.pushViewController(port, animated: true)
                }
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
        
        var strUrlTogaling = ""
        var param = [:] as! [String:Any]
        if(isFollowing)
        {
            if(self.profile.FollowingList![sender.tag].IsContractor)
            {
                strUrlTogaling = Constants.URLS.FollowContractorToggle
                param = ["FollowContractorID": self.profile.FollowingList![sender.tag].ContractorID,
                         "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
            }
            else
            {
                strUrlTogaling = Constants.URLS.FollowCompanyToggle
                param = ["FollowCompanyID": self.profile.FollowingList![sender.tag].CompanyID,
                         "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
            }
        }
        else
        {
            if(self.profile.FollowerList![sender.tag].IsContractor)
            {
                  strUrlTogaling = Constants.URLS.FollowContractorToggle
                param = ["FollowContractorID": self.profile.FollowerList![sender.tag].ContractorID,
                         "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
                
            }
            else
            {
                  strUrlTogaling = Constants.URLS.FollowCompanyToggle
                param = ["FollowCompanyID": self.profile.FollowerList![sender.tag].CompanyID,
                         "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
            }
        }
    
        print(param)
        AFWrapper.requestPOSTURL(strUrlTogaling, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            // self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    
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
                    self.getProfile()
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
             
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    
    func DisPlayCountInLabel(FollowingCount:String,followerCount:String)
    {
        let myString = "\(FollowingCount)Following"
         let myString1 = "\(followerCount)Followers"
        
        let myRange = NSRange(location: 0, length: FollowingCount.length)
        let myRange1 = NSRange(location: 0, length: followerCount.length)
        let myRange2 = NSRange(location: FollowingCount.length, length: 9)
        let myRange3 = NSRange(location: followerCount.length, length: 9)
       
        
        let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.black]
        let anotherAttribute1 = [ NSForegroundColorAttributeName: UIColor.lightGray]
        
        let myAttrString = NSMutableAttributedString(string: myString)
        let myAttrString1 = NSMutableAttributedString(string: myString1)
        
        myAttrString.addAttributes(anotherAttribute, range: myRange)
        myAttrString.addAttributes(anotherAttribute1, range: myRange2)
        myAttrString1.addAttributes(anotherAttribute, range: myRange1)
        myAttrString1.addAttributes(anotherAttribute1, range: myRange3)
        
        lblFollowing.attributedText = myAttrString
        lblFollowers.attributedText = myAttrString1
        
       
        self.btnCountFollower.isUserInteractionEnabled = false
      
        let myAttrString2 = NSMutableAttributedString(string: "")
        btnCountFollower.setAttributedTitle(myAttrString2, for: UIControlState.normal)
    }
}
