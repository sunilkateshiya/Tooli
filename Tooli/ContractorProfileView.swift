//
//  ContractorProfileView.swift
//  TooliDemo
//
//  Created by Azharhussain on 25/08/17.
//  Copyright © 2017 Impero IT. All rights reserved.
//

import UIKit
import UIKit
import Popover
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher
import SafariServices
import SKPhotoBrowser

class ContractorProfileView: UIViewController, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource, NVActivityIndicatorViewable,SKPhotoBrowserDelegate
{

     //--------------------------------------
     // MARK: - Global Declaration
     //--------------------------------------
     var userId:String = AppDelegate.sharedInstance().sharedManager.currentUser.UserID
     var FollowerFollowerArry  : [FollowingUserListM] = []
     var OtherContactorProfileVview : OtherContractorModel = OtherContractorModel()
     var Btnisselected : Bool = false
     var popover = Popover()
    
    @IBOutlet var nodataView:UIView!
     //--------------------------------------
     // MARK: - Dynamic NSLayoutConstraint
     //--------------------------------------
     
     @IBOutlet weak var FollowerHeight: NSLayoutConstraint!
     @IBOutlet weak var RecentWorkHeight: NSLayoutConstraint!
     @IBOutlet weak var ActivityHeight: NSLayoutConstraint!
     @IBOutlet weak var TradeHeight: NSLayoutConstraint!
     @IBOutlet weak var SubTradeHeight: NSLayoutConstraint!
     @IBOutlet weak var SectorHeight: NSLayoutConstraint!
     @IBOutlet weak var RateAndTravelHeight: NSLayoutConstraint!
     @IBOutlet weak var ExperienceHeight: NSLayoutConstraint!
     @IBOutlet weak var CertificateHeight: NSLayoutConstraint!
    @IBOutlet weak var SkillHeight: NSLayoutConstraint!
    @IBOutlet weak var SubJobRoleHeight: NSLayoutConstraint!
     
     //--------------------------------------
     // MARK: - UIScrollView
     //--------------------------------------
     
     @IBOutlet weak var objScrollview: UIScrollView!
     
     //--------------------------------------
     // MARK: - UICollectionView
     //--------------------------------------
     
     @IBOutlet weak var ClcRecentWork: UICollectionView!
     
     //--------------------------------------
     // MARK: - UITableView
     //--------------------------------------
     
     @IBOutlet weak var TblSkill: UITableView!
     @IBOutlet weak var TblSubJobRole: UITableView!
     @IBOutlet weak var TblFollowers: UITableView!
     @IBOutlet weak var TblActivity: UITableView!
     @IBOutlet weak var TblSectors: UITableView!
     @IBOutlet weak var TblTradeAndServices: UITableView!
     @IBOutlet weak var TblSubTrade: UITableView!
     @IBOutlet weak var TblRateAndTravels: UITableView!
     @IBOutlet weak var TblExperience: UITableView!
     @IBOutlet weak var TblCertificate: UITableView!
     //--------------------------------------
     // MARK: - UILabelOutlets
     //--------------------------------------
     @IBOutlet weak var lblUserName: UILabel!
     @IBOutlet weak var lblJobName: UILabel!
     @IBOutlet weak var lblPlace: UILabel!
     @IBOutlet weak var lblAboutContractor: UILabel!
     @IBOutlet weak var lblDescriptionContractor: UILabel!
     @IBOutlet weak var lblDOBContractor: UILabel!
     @IBOutlet weak var lblCompanyContractor: UILabel!
     @IBOutlet weak var lblWebsiteContractor: UILabel!
     @IBOutlet weak var lblTelContractor: UILabel!
     @IBOutlet weak var lblMobContractor: UILabel!
     @IBOutlet weak var lblEmailContractor: UILabel!
     @IBOutlet weak var lblLocationCover: UILabel!
     //--------------------------------------
     // MARK: - UIViewOutlets
     //--------------------------------------
     @IBOutlet weak var FollowersFollowingView: UIView!
     @IBOutlet weak var BackToTimeLineView: UIView!
     @IBOutlet weak var AboutUsView: UIView!
     @IBOutlet weak var imgUser: UIImageView!
     @IBOutlet weak var ImgAvailable : UIImageView!
     @IBOutlet weak var ImgAvailableProfile : UIImageView!
    
     //--------------------------------------
     // MARK: - UIButton
     //--------------------------------------
     
     @IBOutlet weak var BtnFollowingHeader: UIButton!
     @IBOutlet weak var BtnFollowerHeader: UIButton!
     @IBOutlet weak var BtnActivity: UIButton!
     @IBOutlet weak var BtnAboutUs: UIButton!
     @IBOutlet weak var BtnRecentWork: UIButton!
     @IBOutlet weak var BtnFollowerWithCount: UIButton!
     @IBOutlet weak var BtnFollowingWithCount: UIButton!
     @IBOutlet weak var BtnDropDown: UIButton!
     @IBOutlet weak var BtnEditProfile: UIButton!
     
     //--------------------------------------
     // MARK: - viewDidLoad
     //--------------------------------------
     override func viewDidLoad()
     {
          super.viewDidLoad()
          objScrollview.delegate = self
          let flow1 = ClcRecentWork.collectionViewLayout as! UICollectionViewFlowLayout
          flow1.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
          flow1.minimumInteritemSpacing = 3
          flow1.minimumLineSpacing = 3
          DelegatesDefine(Tableview: TblActivity)
          DelegatesDefine(Tableview: TblFollowers)
          Delegates(Tableview: TblTradeAndServices)
          Delegates(Tableview: TblSubTrade)
          Delegates(Tableview: TblSectors)
          Delegates(Tableview: TblSkill)
          Delegates(Tableview: TblRateAndTravels)
          Delegates(Tableview: TblExperience)
          Delegates(Tableview: TblCertificate)
         Delegates(Tableview: TblSubJobRole)
          self.BtnBackToTimelineTapped(self)
          self.BtnActivityTapped(self)
        
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = false
        self.sideMenuController()?.sideMenu?.allowPanGesture = false
        self.sideMenuController()?.sideMenu?.allowRightSwipe = false
        
     }
     
     func DelegatesDefine(Tableview:UITableView)
     {
          Tableview.delegate = self
          Tableview.dataSource = self
          Tableview.rowHeight = UITableViewAutomaticDimension
          Tableview.estimatedRowHeight = 450
          Tableview.tableFooterView = UIView()
     }
     func Delegates(Tableview:UITableView)
     {
          Tableview.delegate = self
          Tableview.dataSource = self
          Tableview.separatorStyle = .none
     }
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
     }
    @IBAction func btnBack(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func homePage(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
     //--------------------------------------
     // MARK: - UITableViewDataSource
     //--------------------------------------
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
          if tableView == TblFollowers
          {
               return self.FollowerFollowerArry.count
          }
          else if tableView == TblSubJobRole
          {
            return OtherContactorProfileVview.Result.JobRoleNameList.count
          }
          else if tableView == TblTradeAndServices
          {
            
               return OtherContactorProfileVview.Result.TradeNameList.count
          }
          else if tableView == TblSubTrade
          {
            return OtherContactorProfileVview.Result.SubTradeNameList.count
          }
          else if tableView == TblSectors
          {
               return OtherContactorProfileVview.Result.SectorNameList.count
          }
          else if tableView == TblSkill
          {
            return OtherContactorProfileVview.Result.ServiceNameList.count
          }
          else if tableView == TblRateAndTravels
          {
               return OtherContactorProfileVview.Result.RateAndTraval.count
          }
          else if tableView == TblExperience
          {
               return OtherContactorProfileVview.Result.ExperinceList.count
          }
          else if tableView == TblCertificate
          {
               return OtherContactorProfileVview.Result.CertificateList.count
          }
          else if tableView == TblActivity
          {
             return self.OtherContactorProfileVview.Result.ActivityList.count
          }
          else
          {
               return 0
          }
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
          if tableView == TblFollowers
          {
               let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowingListCell
               cell.lblName.text =  self.FollowerFollowerArry[indexPath.row].Name
               cell.lblCategory.text = self.FollowerFollowerArry[indexPath.row].TradeName
               if self.FollowerFollowerArry[indexPath.row].ProfileImageLink != ""
               {
                    let imgURL = self.FollowerFollowerArry[indexPath.row].ProfileImageLink as String
                    let urlPro = URL(string: imgURL)
                    cell.imgProfile.kf.indicatorType = .activity
                    let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.FollowerFollowerArry[indexPath.row].ProfileImageLink + "Main")
                    let optionInfo: KingfisherOptionsInfo = [
                         .downloadPriority(0.5),
                         .transition(ImageTransition.fade(1)),
                         ]
                    cell.imgProfile?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
               }
            if self.FollowerFollowerArry[indexPath.row].IsFollowing
            {
                cell.btnFollowButton.setTitle("FOLLOWING", for: .normal)
                cell.btnFollowButton.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1/255.0, alpha: 1)
            }
            else
            {
                cell.btnFollowButton.setTitle("FOLLOW", for: .normal)
                cell.btnFollowButton.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
            }
                if(self.FollowerFollowerArry[indexPath.row].IsMe)
                {
                    cell.btnFollowButton.isHidden = true
                }
                else
                {
                    cell.btnFollowButton.isHidden = false
                }
                cell.btnFollowButton.tag = indexPath.row
                cell.btnFollowButton.addTarget(self, action: #selector(btnUserFollow(_:)), for: UIControlEvents.touchUpInside)
            
               return cell
          }
          else if tableView == TblActivity
          {
            if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PageType == 2)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardSpecialOffer", for: indexPath) as! DashBoardSpecialOffer
                cell.likeHeight.constant = 0
                cell.lblTitle.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].OfferView.CompanyName
                cell.lblDate.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].OfferView.Title + " - " + self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].OfferView.PriceTag
                
                cell.lblDis.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].OfferView.Description
                cell.btnFav.tag = indexPath.row
                cell.btnProfile.tag = indexPath.row
                cell.btnView.tag = indexPath.row
                cell.btnSave.tag = indexPath.row
                cell.btnLike.tag = indexPath.row
                
                if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].OfferView.IsSaved == true)
                {
                    cell.btnFav.isSelected = true
                    cell.btnSave.isSelected = true
                }
                else
                {
                    cell.btnFav.isSelected = false
                    cell.btnSave.isSelected = false
                }
                
                cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                
                let imgURL = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].OfferView.ProfileImageLink)
                let urlPro = URL(string: imgURL)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.imgUser.kf.indicatorType = .activity
                cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                
                
                let imgURLImg1 = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].OfferView.ImageLink)
                let urlProImg1 = URL(string: imgURLImg1)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                let optionInfoImg1: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                    if(image != nil)
                    {
                        cell.setCustomImage(image : image!)
                    }
                })
                
                return cell
            }
            else if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PageType == 3)
            {
                
                if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList.count == 0)
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardTextCell", for: indexPath) as! DashBoardTextCell
                    cell.likeHeight.constant = 0
                    cell.lblTitle.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.CompanyName + " - " + self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.TradeName
                    cell.lblDis.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.Description
                    cell.lblDate.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.TimeCaption
                    
                    cell.btnFav.tag = indexPath.row
                    cell.btnProfile.tag = indexPath.row
                    
                    cell.btnSave.tag = indexPath.row
                    cell.btnLike.tag = indexPath.row
                    if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.IsSaved == true)
                    {
                        cell.btnFav.isSelected = true
                        cell.btnSave.isSelected = true
                    }
                    else
                    {
                        cell.btnFav.isSelected = false
                        cell.btnSave.isSelected = false
                    }
                    
                    cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                    
                    let imgURL = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.ProfileImageLink)
                    let urlPro = URL(string: imgURL)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                    let optionInfo: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.imgUser.kf.indicatorType = .activity
                    cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                    
                    return cell
                }
                else if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList.count == 1)
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard01Cell", for: indexPath) as! DashBoard01Cell
                    cell.likeHeight.constant = 0
                    cell.lblTitle.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.CompanyName + " - " + self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.TradeName
                    cell.lblDate.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.TimeCaption
                    cell.lblDis.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.Description
                    cell.btnFav.tag = indexPath.row
                    cell.btnProfile.tag = indexPath.row
                    cell.btnView.tag = indexPath.row
                    cell.btnSave.tag = indexPath.row
                    cell.btnLike.tag = indexPath.row
                    cell.btnPortfolio.tag = indexPath.row
                    if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.IsSaved == true)
                    {
                        cell.btnFav.isSelected = true
                        cell.btnSave.isSelected = true
                    }
                    else
                    {
                        cell.btnFav.isSelected = false
                        cell.btnSave.isSelected = false
                    }
                    
                    cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnPortfolio.addTarget(self, action: #selector(btnPortfolio(_:)), for: UIControlEvents.touchUpInside)
                    
                    let imgURL = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.ProfileImageLink)
                    let urlPro = URL(string: imgURL)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                    let optionInfo: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.imgUser.kf.indicatorType = .activity
                    cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                    
                    
                    let imgURLImg1 = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                    let urlProImg1 = URL(string: imgURLImg1)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                    let optionInfoImg1: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.img1.kf.indicatorType = .activity
                    cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                        if(image != nil)
                        {
                            cell.setCustomImage(image : image!)
                        }
                    })
                    
                    return cell
                }
                else if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList.count == 2)
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard02Cell", for: indexPath) as! DashBoard02Cell
                    cell.likeHeight.constant = 0
                    cell.lblTitle.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.CompanyName + " - " + self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.TradeName

                    cell.lblDate.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.TimeCaption
                    cell.lblDis.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.Description
                    cell.btnFav.tag = indexPath.row
                    cell.btnProfile.tag = indexPath.row
                    cell.btnView.tag = indexPath.row
                    cell.btnSave.tag = indexPath.row
                    cell.btnLike.tag = indexPath.row
                    cell.btnPortfolio.tag = indexPath.row
                    
                    if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.IsSaved == true)
                    {
                        cell.btnFav.isSelected = true
                        cell.btnSave.isSelected = true
                    }
                    else
                    {
                        cell.btnFav.isSelected = false
                        cell.btnSave.isSelected = false
                    }
                    
                    cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnPortfolio.addTarget(self, action: #selector(btnPortfolio(_:)), for: UIControlEvents.touchUpInside)
                    
                    let imgURL = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.ProfileImageLink)
                    let urlPro = URL(string: imgURL)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                    let optionInfo: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.imgUser.kf.indicatorType = .activity
                    cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                    
                    let imgURLImg1 = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                    let urlProImg1 = URL(string: imgURLImg1)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                    let optionInfoImg1: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.img1.kf.indicatorType = .activity
                    cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
                    
                    let imgURLImg2 = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList[1].ImageLink)
                    let urlProImg2 = URL(string: imgURLImg2)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouceImg2 = ImageResource(downloadURL: urlProImg2!, cacheKey: imgURLImg2)
                    let optionInfoImg2: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.img2.kf.indicatorType = .activity
                    cell.img2.kf.setImage(with: tmpResouceImg2, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg2, progressBlock: nil, completionHandler: nil)
                    
                    return cell
                }
                else if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList.count == 3)
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard03Cell", for: indexPath) as! DashBoard03Cell
                    cell.likeHeight.constant = 0
                    cell.lblTitle.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.CompanyName + " - " + self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.TradeName
                    cell.lblDate.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.TimeCaption
                    cell.lblDis.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.Description
                    
                    cell.btnFav.tag = indexPath.row
                    cell.btnProfile.tag = indexPath.row
                    cell.btnView.tag = indexPath.row
                    cell.btnSave.tag = indexPath.row
                    cell.btnLike.tag = indexPath.row
                    cell.btnPortfolio.tag = indexPath.row
                    
                    if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.IsSaved == true)
                    {
                        cell.btnFav.isSelected = true
                        cell.btnSave.isSelected = true
                    }
                    else
                    {
                        cell.btnFav.isSelected = false
                        cell.btnSave.isSelected = false
                    }
                    
                    cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnPortfolio.addTarget(self, action: #selector(btnPortfolio(_:)), for: UIControlEvents.touchUpInside)
                    
                    
                    let imgURL = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.ProfileImageLink)
                    let urlPro = URL(string: imgURL)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                    let optionInfo: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.imgUser.kf.indicatorType = .activity
                    cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                    
                    let imgURLImg1 = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                    let urlProImg1 = URL(string: imgURLImg1)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                    let optionInfoImg1: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.img1.kf.indicatorType = .activity
                    cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
                    
                    let imgURLImg2 = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList[1].ImageLink)
                    let urlProImg2 = URL(string: imgURLImg2)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouceImg2 = ImageResource(downloadURL: urlProImg2!, cacheKey: imgURLImg2)
                    let optionInfoImg2: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.img2.kf.indicatorType = .activity
                    cell.img2.kf.setImage(with: tmpResouceImg2, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg2, progressBlock: nil, completionHandler: nil)
                    
                    let imgURLImg3 = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList[2].ImageLink)
                    let urlProImg3 = URL(string: imgURLImg3)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouceImg3 = ImageResource(downloadURL: urlProImg3!, cacheKey: imgURLImg3)
                    let optionInfoImg3: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.img3.kf.indicatorType = .activity
                    cell.img3.kf.setImage(with: tmpResouceImg3, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg3, progressBlock: nil, completionHandler: nil)
                    
                    cell.overlayView.isHidden = true
                    
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard03Cell", for: indexPath) as! DashBoard03Cell
                    cell.likeHeight.constant = 0
                    cell.lblTitle.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.CompanyName + " - " + self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.TradeName

                    cell.lblDate.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.TimeCaption
                    cell.lblDis.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.Description
                    
                    cell.btnFav.tag = indexPath.row
                    cell.btnProfile.tag = indexPath.row
                    cell.btnView.tag = indexPath.row
                    cell.btnSave.tag = indexPath.row
                    cell.btnLike.tag = indexPath.row
                    cell.btnPortfolio.tag = indexPath.row
                    
                    if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.IsSaved == true)
                    {
                        cell.btnFav.isSelected = true
                        cell.btnSave.isSelected = true
                    }
                    else
                    {
                        cell.btnFav.isSelected = false
                        cell.btnSave.isSelected = false
                    }
                    
                    cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                    cell.btnPortfolio.addTarget(self, action: #selector(btnPortfolio(_:)), for: UIControlEvents.touchUpInside)
                    
                    let imgURL = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.ProfileImageLink)
                    let urlPro = URL(string: imgURL)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                    let optionInfo: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.imgUser.kf.indicatorType = .activity
                    cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                    
                    let imgURLImg1 = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                    let urlProImg1 = URL(string: imgURLImg1)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                    let optionInfoImg1: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.img1.kf.indicatorType = .activity
                    cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
                    
                    let imgURLImg2 = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList[1].ImageLink)
                    let urlProImg2 = URL(string: imgURLImg2)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouceImg2 = ImageResource(downloadURL: urlProImg2!, cacheKey: imgURLImg2)
                    let optionInfoImg2: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.img2.kf.indicatorType = .activity
                    cell.img2.kf.setImage(with: tmpResouceImg2, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg2, progressBlock: nil, completionHandler: nil)
                    
                    let imgURLImg3 = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList[2].ImageLink)
                    let urlProImg3 = URL(string: imgURLImg3)
                    cell.imgUser.kf.indicatorType = .activity
                    let tmpResouceImg3 = ImageResource(downloadURL: urlProImg3!, cacheKey: imgURLImg3)
                    let optionInfoImg3: KingfisherOptionsInfo = [
                        .downloadPriority(0.5),
                        .transition(ImageTransition.fade(1))
                    ]
                    cell.img3.kf.indicatorType = .activity
                    cell.img3.kf.setImage(with: tmpResouceImg3, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg3, progressBlock: nil, completionHandler: nil)
                    
                    cell.overlayView.isHidden = false
                    cell.lblPhotoCount.text = "+ \(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PortfolioView.PortfolioImageList.count - 3)\nView All"
                    
                    return cell
                }
            }
            else if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PageType == 4)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardJobCell", for: indexPath) as! DashBoardJobCell
                cell.likeHeight.constant = 0
                cell.lblTitle.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].JobView.JobRoleName + " - " + self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].JobView.TradeName
                cell.lblCompanyname.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].JobView.CompanyName
                cell.lblDis.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].JobView.Description
                cell.btnFav.tag = indexPath.row
                cell.btnProfile.tag = indexPath.row
                cell.btnView.tag = indexPath.row
                cell.btnSave.tag = indexPath.row
                cell.btnLike.tag = indexPath.row
                
                if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].JobView.IsSaved == true)
                {
                    cell.btnFav.isSelected = true
                    cell.btnSave.isSelected = true
                }
                else
                {
                    cell.btnFav.isSelected = false
                    cell.btnSave.isSelected = false
                }
                cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                
                let imgURL = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].JobView.ProfileImageLink)
                let urlPro = URL(string: imgURL)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.imgUser.kf.indicatorType = .activity
                cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                
                return cell
            }
            else if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PageType == 5)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardTextCell", for: indexPath) as! DashBoardTextCell
                cell.likeHeight.constant = 0
                cell.lblTitle.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PostView.Name 
                cell.lblDis.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PostView.StatusText
                cell.lblDate.text = self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PostView.TimeCaption
                
                cell.btnFav.tag = indexPath.row
                cell.btnProfile.tag = indexPath.row
                cell.btnSave.tag = indexPath.row
                cell.btnLike.tag = indexPath.row
                if(self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PostView.IsSaved == true)
                {
                    cell.btnFav.isSelected = true
                    cell.btnSave.isSelected = true
                }
                else
                {
                    cell.btnFav.isSelected = false
                    cell.btnSave.isSelected = false
                }
                
                cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                
                let imgURL = (self.OtherContactorProfileVview.Result.ActivityList[indexPath.row].PostView.ProfileImageLink)
                let urlPro = URL(string: imgURL)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.imgUser.kf.indicatorType = .activity
                cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard03Cell", for: indexPath) as! DashBoard03Cell
                
                return cell
            }
          }
        if tableView == TblSubJobRole
        {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! SelctionCell
            cell1.lblName.text = OtherContactorProfileVview.Result.JobRoleNameList[indexPath.row]
            return cell1
        }
        else if tableView == TblTradeAndServices
          {
               let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! SelctionCell
               cell1.lblName.text = OtherContactorProfileVview.Result.TradeNameList[indexPath.row]
               return cell1
          }
           else  if tableView == TblSubTrade
            {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! SelctionCell
            cell1.lblName.text = OtherContactorProfileVview.Result.SubTradeNameList[indexPath.row]
            return cell1
            }
          else if tableView == TblSectors
          {
               let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! SelctionCell
               cell2.lblName.text = OtherContactorProfileVview.Result.SectorNameList[indexPath.row]
               return cell2
          }
          else if tableView == TblSkill
          {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! SelctionCell
            cell2.lblName.text = OtherContactorProfileVview.Result.ServiceNameList[indexPath.row]
            return cell2
          }
          else if tableView == TblRateAndTravels
          {
               let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! SelctionCell
               cell3.lblName.text = OtherContactorProfileVview.Result.RateAndTraval[indexPath.row]
               return cell3
          }
          else if tableView == TblExperience
          {
               let cell4 = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! SelctionCell
               cell4.lblName.text = OtherContactorProfileVview.Result.ExperinceList[indexPath.row].Title + ", " + OtherContactorProfileVview.Result.ExperinceList[indexPath.row].CompanyName + ", " + OtherContactorProfileVview.Result.ExperinceList[indexPath.row].ExperienceYear
               return cell4
          }
          else
          {
               let cell5 = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! SelctionCell
               cell5.lblName.text = OtherContactorProfileVview.Result.CertificateList[indexPath.row].CertificateName
               cell5.btnView.addTarget(self, action: #selector(ViewCertificate(sender:)), for: UIControlEvents.touchUpInside)
               cell5.btnView.tag = indexPath.row
               return cell5
          }
          
     }
     //--------------------------------------
     // MARK: - BtnEditProfileTapped
     //--------------------------------------
     @IBAction func BtnEditProfileTapped(_ sender: UIButton)
     {
        let vc  = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditContractorProfile") as! EditContractorProfile
        self.navigationController?.pushViewController(vc, animated: true)
     }
     //--------------------------------------
     // MARK: - FollowUnfollow From List
     //--------------------------------------
     
     func ViewCertificate(sender : UIButton)
     {
          let index = sender.tag
          if self.OtherContactorProfileVview.Result.CertificateList[index].FileType == ".pdf"
          {
            let openLink = NSURL(string : self.OtherContactorProfileVview.Result.CertificateList[index].CertificateFileLink)
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: openLink! as URL)
                present(svc, animated: true, completion: nil)
            } else {
                let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                port.strUrl = self.OtherContactorProfileVview.Result.CertificateList[index].CertificateFileLink
                self.navigationController?.pushViewController(port, animated: true)
                
            }
          }
          else
          {
            let photo = SKPhoto.photoWithImageURL(self.OtherContactorProfileVview.Result.CertificateList[index].CertificateFileLink)
            photo.caption = ("")
            photo.shouldCachePhotoURLImage = true
            
            let browser = SKPhotoBrowser(photos: [photo])
            browser.initializePageIndex(0)
            browser.delegate = self
            
            present(browser, animated: true, completion: nil)
          }
     }
     //--------------------------------------
     // MARK: - CollectionView Delgates
     //--------------------------------------
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
     {
          return self.OtherContactorProfileVview.Result.PortfolioList.count + 1
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
     {
          if indexPath.item == self.OtherContactorProfileVview.Result.PortfolioList.count{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Add", for: indexPath) as! AddImageCell
               return cell
          }
          else
          {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCell
               let imgURL = self.OtherContactorProfileVview.Result.PortfolioList[indexPath.item].PortfolioImageList[0].ImageLink
               let urlPro = URL(string: imgURL)
               cell.PortfolioImage.kf.indicatorType = .activity
               let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.OtherContactorProfileVview.Result.PortfolioList[indexPath.item].PortfolioImageList[0].ImageLink + "Main")
               let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    ]
               cell.PortfolioImage?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
               cell.lblTitle.text = self.OtherContactorProfileVview.Result.PortfolioList[indexPath.item].Title
               cell.btnRemove.tag = indexPath.item
               cell.btnRemove.addTarget(self, action: #selector(RemovePortfilio(_:)), for: .touchUpInside)
               return cell
          }
          
     }
    
     //--------------------------------------
     // MARK: - DropDownTapped
     //--------------------------------------
     @IBAction func DropDownTapped(_ sender: UIButton)
     {
          self.popOver()
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
          popover.show(aView, fromView:BtnDropDown)
     }
     func press(button: UIButton)
     {
          self.startAnimating()
          let param = ["AvailableStatus": button.tag - 20000] as [String : Any]
          
          print(param)
          AFWrapper.requestPOSTURL(Constants.URLS.ConctractorUpdateStatus, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
               (JSONResponse) -> Void in
               
               // self.stopAnimating()
               print(JSONResponse["Status"].rawValue)

            if JSONResponse["Status"].int == 1
            {
                self.stopAnimating()
                self.popover.dismiss()
                if (button.tag - 20000) == 1 {
                    self.ImgAvailable.image = #imageLiteral(resourceName: "ic_circle_green")
                    self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_circle_green")
                }
                else if(button.tag - 20000) == 2 {
                    self.ImgAvailable.image = #imageLiteral(resourceName: "ic_CircleYellow")
                    self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_CircleYellow")
                }
                else if(button.tag - 20000) == 3 {
                    self.ImgAvailable.image = #imageLiteral(resourceName: "ic_circle_red")
                    self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_circle_red")
                }
            }
            else
            {
                self.stopAnimating()
                self.popover.dismiss()
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
            }
            
          }) {
               (error) -> Void in
               self.stopAnimating()
               self.popover.dismiss()
               
               self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
          }
     }
     //--------------------------------------
     // MARK: - Button Followers
     //--------------------------------------
     @IBAction func BtnFollowersTapped(_ sender: UIButton)
     {
          BtnFollowersFromHeaderTapped(self)
          self.FollowersFollowingView.isHidden = true
          self.BackToTimeLineView.isHidden = false
          self.TblFollowers.isHidden = false
          self.ClcRecentWork.isHidden = true
          self.TblActivity.isHidden = true
          self.AboutUsView.isHidden = true
          self.BtnRecentWork.isSelected = false
          self.BtnAboutUs.isSelected = false
          self.BtnActivity.isSelected = false
          setLayout()
        if(self.FollowerFollowerArry.count == 0)
        {
            self.nodataView.isHidden = false
        }
        else
        {
            self.nodataView.isHidden = true
        }
     }
    
     
     //--------------------------------------
     // MARK: - Button Following
     //--------------------------------------
     @IBAction func BtnFollowingTapped(_ sender: UIButton)
     {
          BtnFollowingFromHeaderTapped(self)
          self.FollowersFollowingView.isHidden = true
          self.BackToTimeLineView.isHidden = false
          self.TblFollowers.isHidden = false
          self.ClcRecentWork.isHidden = true
          self.TblActivity.isHidden = true
          self.AboutUsView.isHidden = true
          self.BtnRecentWork.isSelected = false
          self.BtnAboutUs.isSelected = false
          self.BtnActivity.isSelected = false
          setLayout()
        if(self.FollowerFollowerArry.count == 0)
        {
            self.nodataView.isHidden = false
        }
        else
        {
            self.nodataView.isHidden = true
        }
        
     }
    
     //--------------------------------------
     // MARK: - Button Back To Timeline
     //--------------------------------------
     @IBAction func BtnBackToTimelineTapped(_ sender: Any)
     {
        self.nodataView.isHidden = true
          self.FollowersFollowingView.isHidden = false
          self.BackToTimeLineView.isHidden = true
          self.BtnActivity.isSelected = true
          self.BtnRecentWork.isSelected = false
          self.BtnAboutUs.isSelected = false
          self.TblFollowers.isHidden = true
          self.ClcRecentWork.isHidden = true
          self.TblActivity.isHidden = false
          self.AboutUsView.isHidden = true
          self.ActivityHeight.constant = self.TblActivity.contentSize.height
          self.RecentWorkHeight.constant = self.TblActivity.contentSize.height
        
        if(self.OtherContactorProfileVview.Result.ActivityList.count == 0)
        {
            self.nodataView.isHidden = false
        }
        else
        {
            self.nodataView.isHidden = true
        }
     }
    
    
     //--------------------------------------
     // MARK: - Button Following From Header
     //--------------------------------------
     @IBAction func BtnFollowingFromHeaderTapped(_ sender: Any)
     {
          self.BtnFollowingHeader.isSelected = true
          self.BtnFollowerHeader.isSelected = false
          self.BtnFollowerHeader.backgroundColor = UIColor.clear
          self.BtnFollowingHeader.backgroundColor = UIColor.white
            self.FollowerFollowerArry = self.OtherContactorProfileVview.Result.FollowingUserList
          self.TblFollowers.reloadData()
          self.ActivityHeight.constant = self.TblFollowers.contentSize.height
          self.RecentWorkHeight.constant = self.TblFollowers.contentSize.height
          self.FollowerHeight.constant = self.TblFollowers.contentSize.height
          setLayout()
        if(self.FollowerFollowerArry.count == 0)
        {
            self.nodataView.isHidden = false
        }
        else
        {
            self.nodataView.isHidden = true
        }
     }
     
     //--------------------------------------
     // MARK: - Button Followers From Header
     //--------------------------------------
     @IBAction func BtnFollowersFromHeaderTapped(_ sender: Any)
     {
          self.BtnFollowingHeader.isSelected = false
          self.BtnFollowerHeader.isSelected = true
          self.BtnFollowerHeader.backgroundColor = UIColor.white
          self.BtnFollowingHeader.backgroundColor = UIColor.clear
          self.FollowerFollowerArry = self.OtherContactorProfileVview.Result.FollowerUserList
          self.TblFollowers.reloadData()
          self.ActivityHeight.constant = self.TblFollowers.contentSize.height
          self.RecentWorkHeight.constant = self.TblFollowers.contentSize.height
          self.FollowerHeight.constant = self.TblFollowers.contentSize.height
          setLayout()
        if(self.FollowerFollowerArry.count == 0)
        {
            self.nodataView.isHidden = false
        }
        else
        {
            self.nodataView.isHidden = true
        }
     }
     
     
     //--------------------------------------
     // MARK: - Button Activity
     //--------------------------------------
     @IBAction func BtnActivityTapped(_ sender: Any)
     {
          self.TblActivity.reloadData()
          self.BtnActivity.isSelected = true
          self.BtnAboutUs.isSelected = false
          self.BtnRecentWork.isSelected = false
          self.TblFollowers.isHidden = true
          self.ClcRecentWork.isHidden = true
          self.TblActivity.isHidden = false
          self.AboutUsView.isHidden = true
          self.ActivityHeight.constant = self.TblActivity.contentSize.height
          self.RecentWorkHeight.constant = self.TblActivity.contentSize.height
          setLayout()
        if(self.OtherContactorProfileVview.Result.ActivityList.count == 0)
        {
            self.nodataView.isHidden = false
        }
        else
        {
            self.nodataView.isHidden = true
        }
     }
     
     
     //--------------------------------------
     // MARK: - Button About
     //--------------------------------------
     @IBAction func BtnAboutTapped(_ sender: UIButton)
     {
            self.nodataView.isHidden = true
          self.BtnActivity.isSelected = false
          self.BtnAboutUs.isSelected = true
          self.BtnRecentWork.isSelected = false
          self.TblFollowers.isHidden = true
          self.ClcRecentWork.isHidden = true
          self.TblActivity.isHidden = true
          self.AboutUsView.isHidden = false
          self.ActivityHeight.constant = 2000
          self.RecentWorkHeight.constant = 2000
          setLayout()
     }
     
     
     //--------------------------------------
     // MARK: - Button Recent Work
     //--------------------------------------
     @IBAction func BtnRecentWorkTapped(_ sender: UIButton)
     {
            self.nodataView.isHidden = true
          self.BtnActivity.isSelected = false
          self.BtnAboutUs.isSelected = false
          self.BtnRecentWork.isSelected = true
          self.TblFollowers.isHidden = true
          self.ClcRecentWork.isHidden = false
          self.TblActivity.isHidden = true
          self.AboutUsView.isHidden = true
          self.RecentWorkHeight.constant = self.ClcRecentWork.contentSize.height
          self.ActivityHeight.constant = self.ClcRecentWork.contentSize.height
          setLayout()
     }
     //--------------------------------------
     // MARK: - viewWillAppear
     //--------------------------------------
     override func viewWillAppear(_ animated: Bool) {
          self.ContractorProfileViewApi()
     }
     
     //--------------------------------------
     // MARK: - ContractorProfileViewApi
     //--------------------------------------
     func ContractorProfileViewApi()
     {
            self.nodataView.isHidden = true
          self.startAnimating()
          let param = ["UserID":AppDelegate.sharedInstance().sharedManager.currentUser.UserID] as [String : Any]
          AFWrapper.requestPOSTURL(Constants.URLS.ContractorProfileView, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
               (JSONResponse) -> Void in
               self.stopAnimating()
               self.OtherContactorProfileVview = Mapper<OtherContractorModel>().map(JSONObject: JSONResponse.rawValue)!
               if JSONResponse["Status"].int == 1
               {
                    self.SetRateTravalData()
                    self.ProfileData()
                    self.HeightOfUItable()
                    self.AboutUsData()
                    self.TblTradeAndServices.reloadData()
                    self.TblSubTrade.reloadData()
                    self.TblSectors.reloadData()
                    self.TblSkill.reloadData()
                    self.TblSubJobRole.reloadData()
                    self.TblRateAndTravels.reloadData()
                    self.TblExperience.reloadData()
                    self.TblCertificate.reloadData()
                    self.ClcRecentWork.reloadData()
                    self.TblActivity.reloadData()
                    if(self.BtnActivity.isSelected)
                    {
                        self.BtnActivityTapped(self)
                    }
                    else if(self.BtnAboutUs.isSelected)
                    {
                      self.BtnAboutTapped(self.BtnAboutUs)
                    }
                    else
                    {
                        self.BtnRecentWorkTapped(self.BtnRecentWork)
                    }
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
     
     //--------------------------------------
     // MARK: - HeightOfUItable
     //--------------------------------------
     
     func HeightOfUItable()
     {
        if self.OtherContactorProfileVview.Result.JobRoleNameList.count > 5
        {
            self.SubJobRoleHeight.constant = 0
            self.SubJobRoleHeight.constant = CGFloat((5 * 35) + 44)
            self.TblSubJobRole.isScrollEnabled = true
        }
        else
        {
            self.SubJobRoleHeight.constant = 0
            self.SubJobRoleHeight.constant = CGFloat((self.OtherContactorProfileVview.Result.JobRoleNameList.count * 35) + 44)
            self.TblSubJobRole.isScrollEnabled = false
        }
        
          if self.OtherContactorProfileVview.Result.TradeNameList.count > 5
          {
               self.TradeHeight.constant = 0
               self.TradeHeight.constant = CGFloat((5 * 35) + 44)
               self.TblTradeAndServices.isScrollEnabled = true
          }
          else
          {
               self.TradeHeight.constant = 0
               self.TradeHeight.constant = CGFloat((self.OtherContactorProfileVview.Result.TradeNameList.count * 35) + 44)
               self.TblTradeAndServices.isScrollEnabled = false
          }
        if self.OtherContactorProfileVview.Result.SubTradeNameList.count > 5
        {
            self.SubTradeHeight.constant = 0
            self.SubTradeHeight.constant = CGFloat((5 * 35) + 44)
            self.TblSubTrade.isScrollEnabled = true
        }
        else
        {
            self.SubTradeHeight.constant = 0
            if(self.OtherContactorProfileVview.Result.SubTradeNameList.count == 0)
            {
                
            }
            else
            {
                self.SubTradeHeight.constant = CGFloat((self.OtherContactorProfileVview.Result.SubTradeNameList.count * 35) + 44)
            }
            self.TblSubTrade.isScrollEnabled = false
        }
          if self.OtherContactorProfileVview.Result.SectorNameList.count > 5
          {
               self.SectorHeight.constant = 0
               self.SectorHeight.constant = CGFloat((5 * 35) + 44)
               self.TblSectors.isScrollEnabled = true
          }
          else
          {
               self.SectorHeight.constant = 0
               self.SectorHeight.constant = CGFloat((self.OtherContactorProfileVview.Result.SectorNameList.count * 35) + 44)
               self.TblSectors.isScrollEnabled = false
          }
        if self.OtherContactorProfileVview.Result.ServiceNameList.count > 5
        {
            self.SkillHeight.constant = 0
            self.SkillHeight.constant = CGFloat((5 * 35) + 44)
            self.TblSkill.isScrollEnabled = true
        }
        else
        {
            self.SkillHeight.constant = 0
            if(self.OtherContactorProfileVview.Result.ServiceNameList.count == 0)
            {
            
            }
            else
            {
               self.SkillHeight.constant = CGFloat((self.OtherContactorProfileVview.Result.ServiceNameList.count * 35) + 44)
            }
            self.TblSkill.isScrollEnabled = false
        }
        
          if self.OtherContactorProfileVview.Result.RateAndTraval.count > 5
          {
            self.RateAndTravelHeight.constant = 0
            self.RateAndTravelHeight.constant = CGFloat((self.OtherContactorProfileVview.Result.RateAndTraval.count * 35) + 44)
            self.TblRateAndTravels.isScrollEnabled = false
          }
          else
          {
            self.RateAndTravelHeight.constant = 0
            self.RateAndTravelHeight.constant = CGFloat((self.OtherContactorProfileVview.Result.RateAndTraval.count * 35) + 44)
            self.TblRateAndTravels.isScrollEnabled = false
          }
          if self.OtherContactorProfileVview.Result.ExperinceList.count > 5
          {
               self.ExperienceHeight.constant = 0
               self.ExperienceHeight.constant = CGFloat((5 * 35) + 44)
               self.TblExperience.isScrollEnabled = true
          }
          else
          {
               self.ExperienceHeight.constant = 0
               self.ExperienceHeight.constant = CGFloat((self.OtherContactorProfileVview.Result.ExperinceList.count * 35) + 44)
               self.TblExperience.isScrollEnabled = false
          }
          
          
          if self.OtherContactorProfileVview.Result.CertificateList.count > 5
          {
               self.CertificateHeight.constant = 0
               self.CertificateHeight.constant = CGFloat((5 * 35) + 44)
               self.TblCertificate.isScrollEnabled = true
          }
          else
          {
            self.CertificateHeight.constant = 0
            if(self.OtherContactorProfileVview.Result.CertificateList.count == 0)
            {
                
            }
            else
            {
                self.CertificateHeight.constant = CGFloat((self.OtherContactorProfileVview.Result.CertificateList.count * 35) + 44)
            }
            self.TblCertificate.isScrollEnabled = false
          }
     }
     
     //--------------------------------------
     // MARK: - AboutUsData
     //--------------------------------------
     
     func AboutUsData()
     {
          self.lblAboutContractor.text = "About " + self.OtherContactorProfileVview.Result.FullName
          self.lblDescriptionContractor.text = self.OtherContactorProfileVview.Result.Description
          self.lblDOBContractor.text = self.OtherContactorProfileVview.Result.BirthDate
          self.lblCompanyContractor.text = self.OtherContactorProfileVview.Result.CompanyName
        
        if self.OtherContactorProfileVview.Result.IsEmailPublic
        {
            self.lblEmailContractor.setUnderLineToLabel(strText: self.OtherContactorProfileVview.Result.CompanyEmailID)
            let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(lblEmailTaped(tapGestureRecognizer:)))
            lblEmailContractor.isUserInteractionEnabled = true
            lblEmailContractor.addGestureRecognizer(tapGestureRecognizer2)
        }
        else
        {
            self.lblEmailContractor.text = "xxxxxxxxxxxxx"
        }
        if self.OtherContactorProfileVview.Result.IsPhonePublic
        {
            self.lblTelContractor.setUnderLineToLabel(strText: self.OtherContactorProfileVview.Result.PhoneNumber)
            
            let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblTelTaped(tapGestureRecognizer:)))
            lblTelContractor.isUserInteractionEnabled = true
            lblTelContractor.addGestureRecognizer(tapGestureRecognizer1)
        }
        else
        {
            self.lblTelContractor.text = "xxxxxxxxxxxxx"
            
        }
        if self.OtherContactorProfileVview.Result.IsMobilePublic
        {
            self.lblMobContractor.setUnderLineToLabel(strText: self.OtherContactorProfileVview.Result.MobileNumber)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblModTaped(tapGestureRecognizer:)))
            lblMobContractor.isUserInteractionEnabled = true
            lblMobContractor.addGestureRecognizer(tapGestureRecognizer)
            
        }
        else
        {
            self.lblMobContractor.text = "xxxxxxxxxxxxx"
        }
        self.lblWebsiteContractor.setUnderLineToLabel(strText: self.OtherContactorProfileVview.Result.Website)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblWebsiteTaped(tapGestureRecognizer:)))
        lblWebsiteContractor.isUserInteractionEnabled = true
        lblWebsiteContractor.addGestureRecognizer(tapGestureRecognizer)
        
          self.lblLocationCover.text = self.OtherContactorProfileVview.Result.FullName + " covers within " + String(self.OtherContactorProfileVview.Result.DistanceRadius) + " miles of " + self.OtherContactorProfileVview.Result.CityName
     }
    
    func lblModTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        if(lblMobContractor.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblMobContractor.text!))")!))
            {
                UIApplication.shared.openURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblMobContractor.text!))")!)
            }
            else
            {
                self.view.makeToast("Mobile Number not valid.", duration: 3, position: .bottom)
            }
        }
    }
    func lblWebsiteTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        if(lblWebsiteContractor.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "\( lblWebsiteContractor.text!)")!))
            {
                UIApplication.shared.openURL(URL(string: "\(lblWebsiteContractor.text!)")!)
            }
            else
            {
                self.view.makeToast("Website url not valid.", duration: 3, position: .bottom)
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
        if(lblTelContractor.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblTelContractor.text!))")!))
            {
                UIApplication.shared.openURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblTelContractor.text!))")!)
            }
            else
            {
                self.view.makeToast("Number not valid.", duration: 3, position: .bottom)
            }
        }
    }
    func lblEmailTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        if(lblEmailContractor.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "mailto://\(lblEmailContractor.text!)")!))
            {
                UIApplication.shared.openURL(URL(string: "mailto://\(lblEmailContractor.text!)")!)
            }
            else
            {
                self.view.makeToast("Email not valid.", duration: 3, position: .bottom)
            }
        }
    }
    func SetRateTravalData()
    {
        
        if(self.OtherContactorProfileVview.Result.IsPerHourRatePublic)
        {
            self.OtherContactorProfileVview.Result.RateAndTraval.append(Constants.Money.Pound+self.OtherContactorProfileVview.Result.PerHourRate + " Hourly Rate" )
        }
        else
        {
            if(self.OtherContactorProfileVview.Result.PerHourRate != "")
            {
                self.OtherContactorProfileVview.Result.RateAndTraval.append("xxxxxxxxxx" + " Hourly Rate" )
            }
        }
        if(self.OtherContactorProfileVview.Result.IsPerDayRatePublic)
        {
            self.OtherContactorProfileVview.Result.RateAndTraval.append(Constants.Money.Pound+self.OtherContactorProfileVview.Result.PerDayRate + " Day Rate")
        }
        else
        {
            if(self.OtherContactorProfileVview.Result.PerDayRate != "")
            {
                self.OtherContactorProfileVview.Result.RateAndTraval.append("xxxxxxxxxx" + "  Day Rate" )
            }
        }
        if(self.OtherContactorProfileVview.Result.IsLicenceHeld)
        {
            self.OtherContactorProfileVview.Result.RateAndTraval.append("Driving License")
        }
        if(self.OtherContactorProfileVview.Result.IsOwnVehicle)
        {
            self.OtherContactorProfileVview.Result.RateAndTraval.append("Own Vehical")
        }
    }
    
    @IBAction func btnMyJobAction(_ sender: UIButton)
    {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "JobMyVC") as! JobMyVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
     //--------------------------------------
     // MARK: - ProfileData
     //--------------------------------------
     
     func ProfileData()
     {
          self.lblUserName.text = self.OtherContactorProfileVview.Result.FullName
          self.lblJobName.text = self.OtherContactorProfileVview.Result.DepartmentName + "-" + self.OtherContactorProfileVview.Result.TradeName
          self.lblPlace.text = self.OtherContactorProfileVview.Result.CityName
          if self.OtherContactorProfileVview.Result.ProfileImageLink != "" {
               let imgURL = self.OtherContactorProfileVview.Result.ProfileImageLink as String
               let urlPro = URL(string: imgURL)
               self.imgUser.kf.indicatorType = .activity
               let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.OtherContactorProfileVview.Result.ProfileImageLink + "Main")
               let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    ]
               self.imgUser?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
          }
          
        if self.OtherContactorProfileVview.Result.AvailableStatus == 1 {
            self.ImgAvailable.image = #imageLiteral(resourceName: "ic_circle_green")
            self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_circle_green")
        }
        else if self.OtherContactorProfileVview.Result.AvailableStatus == 2 {
            self.ImgAvailable.image = #imageLiteral(resourceName: "ic_CircleYellow")
            self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_CircleYellow")
        }
        else if self.OtherContactorProfileVview.Result.AvailableStatus == 3 {
            self.ImgAvailable.image = #imageLiteral(resourceName: "ic_circle_red")
            self.ImgAvailableProfile.image = #imageLiteral(resourceName: "ic_circle_red")
        }
        
          self.BtnFollowingWithCount.setTitle(String(self.OtherContactorProfileVview.Result.TotalFollowing) + " Following", for: .normal)
          self.BtnFollowerWithCount.setTitle(String(self.OtherContactorProfileVview.Result.TotalFollower) + " Follower", for: .normal)
     }
     
     //--------------------------------------
     // MARK: - scrollViewDidScroll
     //--------------------------------------
     
     func scrollViewDidScroll(_ scrollView: UIScrollView)
     {
          setLayout()
     }
     
     //--------------------------------------
     // MARK: - scrollViewDidScroll
     //--------------------------------------
     func setLayout()
     {
          DispatchQueue.main.async{
               if self.BtnActivity.isSelected
               {
                    self.objScrollview.contentSize.height =
                         self.TblActivity.frame.origin.y +  self.TblActivity.contentSize.height + 20
               }
               else if self.BtnAboutUs.isSelected
               {
                    self.objScrollview.contentSize.height = self.ClcRecentWork.frame.origin.y + self.TblCertificate.frame.origin.y + self.TblCertificate.frame.height + 20
                    
               }
               else if self.BtnRecentWork.isSelected
               {
                    self.objScrollview.contentSize.height = self.ClcRecentWork.frame.origin.y + self.ClcRecentWork.contentSize.height + 20
               }
               else
               {
                    self.objScrollview.contentSize.height = self.ClcRecentWork.frame.origin.y + self.TblFollowers.contentSize.height + 20
               }
          }
     }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let padding: CGFloat = 15
        let collectionCellSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.item == self.OtherContactorProfileVview.Result.PortfolioList.count
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Addportfolio") as! Addportfolio
            vc.isFromProfile = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Editportfolio") as! Editportfolio
            vc.portfolioId = self.OtherContactorProfileVview.Result.PortfolioList[indexPath.row].PortfolioID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func btnProfile (_ sender : UIButton)
    {
        
    }
    func RemovePortfilio(_ sender:UIButton)
    {
        self.startAnimating()
        let param = ["PortfolioID":self.OtherContactorProfileVview.Result.PortfolioList[sender.tag].PortfolioID] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PortfolioDelete, params :param as [String : AnyObject]? ,headers : nil  ,  success:
            {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                self.OtherContactorProfileVview.Result.PortfolioList.remove(at: sender.tag)
                self.ClcRecentWork.reloadData()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func btnPortfolio (_ sender : UIButton)
    {
        OpenDetailPageUsingPageType(index: sender.tag)
    }
    func btnLikeAction(_ sender : UIButton)
    {
        
    }
    func btnViewAction(_ sender : UIButton)
    {
        OpenDetailPageUsingPageType(index: sender.tag)
    }
    @IBAction func btnContractorSaveStatus(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":userId,
                     "PageType":1] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                sender.isSelected = !sender.isSelected
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func btnUserFollow(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["FollowingUserID":self.FollowerFollowerArry[sender.tag].UserID] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.AccountFollowToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                if(self.FollowerFollowerArry[sender.tag].IsFollowing)
                {
                    self.FollowerFollowerArry[sender.tag].IsFollowing = false
                }
                else
                {
                    self.FollowerFollowerArry[sender.tag].IsFollowing = true
                }
                if(self.BtnFollowingHeader.isSelected == true)
                {
                    if(self.OtherContactorProfileVview.Result.FollowingUserList[sender.tag].IsSaved)
                    {
                        self.OtherContactorProfileVview.Result.FollowingUserList[sender.tag].IsSaved = false
                    }
                    else
                    {
                        self.OtherContactorProfileVview.Result.FollowingUserList[sender.tag].IsSaved = true
                    }
                }
                else
                {
                    if(self.OtherContactorProfileVview.Result.FollowerUserList[sender.tag].IsSaved)
                    {
                        self.OtherContactorProfileVview.Result.FollowerUserList[sender.tag].IsSaved = false
                    }
                    else
                    {
                        self.OtherContactorProfileVview.Result.FollowerUserList[sender.tag].IsSaved = true
                    }
                }
                self.TblFollowers.reloadData()
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    @IBAction func btnProfileUserFollow(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":userId,
                     "PageType":1] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.AccountFollowToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func btnSaveStatus(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PrimaryID,
                     "PageType":self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PageType] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                if sender.isSelected == true
                {
                    if(self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PageType == 2)
                    {
                        self.OtherContactorProfileVview.Result.ActivityList[sender.tag].OfferView.IsSaved = false
                    }
                    else if(self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PageType == 3)
                    {
                        self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PortfolioView.IsSaved = false
                    }
                    else if(self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PageType == 4)
                    {
                        self.OtherContactorProfileVview.Result.ActivityList[sender.tag].JobView.IsSaved = false
                    }
                    else if(self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PageType == 5)
                    {
                        self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PostView.IsSaved = false
                    }
                }
                else
                {
                    if(self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PageType == 2)
                    {
                        self.OtherContactorProfileVview.Result.ActivityList[sender.tag].OfferView.IsSaved = true
                    }
                    else if(self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PageType == 3)
                    {
                        self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PortfolioView.IsSaved = true
                    }
                    else if(self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PageType == 4)
                    {
                        self.OtherContactorProfileVview.Result.ActivityList[sender.tag].JobView.IsSaved = true
                    }
                    else if(self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PageType == 5)
                    {
                        self.OtherContactorProfileVview.Result.ActivityList[sender.tag].PostView.IsSaved = true
                    }
                }
                self.TblActivity.reloadData()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func OpenDetailPageUsingPageType(index:Int)
    {
        if(self.OtherContactorProfileVview.Result.ActivityList[index].PageType == 0)
        {
            print("Admin")
        }
        else if(self.OtherContactorProfileVview.Result.ActivityList[index].PageType == 1)
        {
            print("Contractor")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
            vc.userId = self.OtherContactorProfileVview.Result.ActivityList[index].UserID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.OtherContactorProfileVview.Result.ActivityList[index].PageType == 2)
        {
            print("Offer")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.OfferDetail = self.OtherContactorProfileVview.Result.ActivityList[index].OfferView
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.OtherContactorProfileVview.Result.ActivityList[index].PageType == 3)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortfolioDetails") as! PortfolioDetails
            vc.portfolio = self.OtherContactorProfileVview.Result.ActivityList[index].PortfolioView
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.OtherContactorProfileVview.Result.ActivityList[index].PageType == 4)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
            vc.jobDetail = self.OtherContactorProfileVview.Result.ActivityList[index].JobView
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.OtherContactorProfileVview.Result.ActivityList[index].PageType == 5)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
            vc.jobDetail = self.OtherContactorProfileVview.Result.ActivityList[index].JobView
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(tableView == TblFollowers)
        {
            if(self.FollowerFollowerArry[indexPath.row].Role == 0)
            {
                print("Admin")
            }
            else if(self.FollowerFollowerArry[indexPath.row].Role == 1)
            {
                if(self.FollowerFollowerArry[indexPath.row].IsMe)
                {
                    
                }
                else
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                    vc.userId = self.FollowerFollowerArry[indexPath.row].UserID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if(self.FollowerFollowerArry[indexPath.row].Role == 2)
            {
                print("Company")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
                vc.userId = self.FollowerFollowerArry[indexPath.row].UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if(self.FollowerFollowerArry[indexPath.row].Role == 3)
            {
                print("Supplier")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
                vc.userId = self.FollowerFollowerArry[indexPath.row].UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
