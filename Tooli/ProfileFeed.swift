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

class ProfileFeed: UIViewController, UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, NVActivityIndicatorViewable{
    var popover = Popover()
    var contractorId = 0;
    var isPortFolio : Bool = false;
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var profile  : SignIn!
    let sharedManager : Globals = Globals.sharedInstance
    @IBOutlet weak var AboutCollectionView: UICollectionView!
    @IBOutlet weak var TblAboutus: UITableView!
    @IBOutlet weak var ObjScrollview: UIScrollView!
    @IBOutlet weak var ObjCollectionView: UICollectionView!
    @IBOutlet weak var ImgProfilePic: UIImageView!
    @IBOutlet weak var ImgStar: UIImageView!
    @IBOutlet weak var ImgOnOff: UIImageView!
    @IBOutlet weak var AboutviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var BtnNotification: UIButton!
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
    
    @IBOutlet weak var BtnFollow: UIButton!
    
    @IBOutlet weak var BtnMessage: UIButton!
    
    @IBOutlet weak var TblTimeline: UITableView!
    
    @IBOutlet weak var PortCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var BtnAbout: UIButton!
    
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
        
        
        self.TblAboutus.delegate = self
        self.TblAboutus.dataSource = self
        TblTimeline.delegate = self
        TblTimeline.dataSource = self
        TblTimeline.rowHeight = UITableViewAutomaticDimension
        TblTimeline.estimatedRowHeight = 450
        TblTimeline.tableFooterView = UIView()
        ObjScrollview.delegate = self
        
        
        self.TblHeightConstraints.constant = 265 * 10
        self.AboutviewHeight.constant = 265 * 10
        
        self.PortCollectionHeight.constant = 265 * 10
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
        
        getProfile()
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
        
        self.lblAbtDOb.text = self.profile.DOB
        self.lblAbtMob.text = self.profile.MobileNumber
        self.lblAbtTel.text = self.profile.LandlineNumber
        self.lblAbtDaily.text = self.profile.PerDayRate
        self.lblAbtHourly.text = self.profile.PerDayRate
        self.lblAbtEmail.text = self.profile.EmailID
        self.txtAbtViewAbout.text = self.profile.Aboutme
        self.txtAbtViewAbout.isSelectable = false
        self.txtAbtViewAbout.isEditable = false
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
        //set Image
        if self.profile.ProfileImageLink != "" {
            let imgURL = self.profile.ProfileImageLink as String
            let urlPro = URL(string: imgURL)
            self.ImgProfilePic?.kf.setImage(with: urlPro)
            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.profile.ProfileImageLink)
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1)),
                
            ]
            
            ImgProfilePic?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
            
            //ImgProfilePic?.clipsToBounds = true
            //ImgProfilePic?.cornerRadius = (ImgProfilePic?.frame.size.width)! / 2
        }
    }
    
    @IBAction func BtnFollowTapped(_ sender: Any) {
    }
    
    @IBAction func BtnMessageTapped(_ sender: Any) {
    }
    @IBAction func BtnAboutTapped(_ sender: Any) {
        
        self.PortCollectionHeight.constant = self.ObjCollectionView.contentSize.height + 20
        //self.ObjScrollview.contentSize.height = 237 + self.PortCollectionHeight.constant
        
        self.ObjScrollview.contentSize.height = 237 + AboutView.frame.size.height
        
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
        self.TblAboutus.tag = 2
        self.ObjCollectionView.tag = 3
        self.AboutCollectionView.tag = 4
        
        //          self.HeightConstraints.constant = 0
        //          self.PortCollectionHeight.constant = 0
    }
    @IBAction func BtnPortfolioTapped(_ sender: Any) {
        
        self.PortCollectionHeight.constant = self.ObjCollectionView.contentSize.height + 20
        self.ObjScrollview.contentSize.height = 237 + self.PortCollectionHeight.constant
        
        self.BtnAbout.isSelected = false
        self.BtnAbout.tintColor = UIColor.white
        self.BtnAbout.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
        
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
            return 10
        }
        else
        {
            if  self.profile != nil {
                self.AboutviewHeight.constant = CGFloat(Float(Float(160) * Float((self.profile.ExperienceList?.count)!)))
                self.HeightAboutView.constant = 867 + self.AboutviewHeight.constant
                return  (self.profile.ExperienceList?.count)!
                
            }
            self.AboutviewHeight.constant = 0
            self.HeightAboutView.constant = 867
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == self.TblTimeline {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            //               cell.textLabel?.text = "Trades " +  "\(indexPath.row)"
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
            Collectcell.PortfolioImage?.kf.setImage(with: urlPro)
            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: (self.profile.PortfolioList?[indexPath.row].ThumbnailImageLink)!)
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1)),
            ]
            
            
            
            Collectcell.PortfolioImage?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: { (img1, err, cacheType, url1) in
                //
                if (err != nil) {
                    Collectcell.PortfolioImage.image = #imageLiteral(resourceName: "ic_pdf")
                    self.profile.CertificateFileList?[indexPath.row].IsPDF=true
                    
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
            
            if  self.profile.CertificateFileList?[indexPath.row].IsPDF == true {
                 Collectcell.PortfolioImage.image = #imageLiteral(resourceName: "ic_pdf")
            }
            else {
            
            let imgURL = (self.profile.CertificateFileList?[indexPath.row].FileLink)! as String
            let urlPro = URL(string: imgURL)
            Collectcell.PortfolioImage?.kf.setImage(with: urlPro)
            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: (self.profile.CertificateFileList?[indexPath.row].FileLink)!)
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1)),
                //.forceRefresh
            ]
            
            
            
            Collectcell.PortfolioImage?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: { (img1, err, cacheType, url1) in
                //
                if (err != nil) {
                    Collectcell.PortfolioImage.image = #imageLiteral(resourceName: "ic_pdf")
                    self.profile.CertificateFileList?[indexPath.row].IsPDF=true
                    
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView.tag == 3 {
            let itemsPerRow:CGFloat = 2
            let hardCodedPadding:CGFloat = 5
            let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            let itemHeight : CGFloat = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
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
        if  self.profile.CertificateFileList?[indexPath.row].IsPDF == true {
            let url = URL(string: (self.profile.CertificateFileList?[indexPath.row].FileLink)!)
            if (UIApplication.shared.canOpenURL(url!)){
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}
