//
//  SavedView.swift
//  Tooli
//
//  Created by Impero IT on 15/02/2017.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import Popover
import Kingfisher
import ActionSheetPicker_3_0
import ObjectMapper
import NVActivityIndicatorView
import GooglePlaces
import Toast_Swift
import Alamofire
import SafariServices

<<<<<<< HEAD
class SavedView: UIViewController, NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource,RetryButtonDeleget {
=======
class SavedView: UIViewController, NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource {
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73

    @IBOutlet weak var btnAgain: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewError: UIView!
    @IBAction func btnAgainErrorAction(_ sender: UIButton)
    {
          onLoadDetail()
    }
    @IBOutlet weak var BtnType: UIButton!
    var popover = Popover()
    let sharedManager : Globals = Globals.sharedInstance
<<<<<<< HEAD
    var strType  = 0
    var allDic : [String:Any] = [:]
    @IBOutlet var tvdashb : UITableView!
    var TotalCount:Int = 0
    var savedPageList:GetSavedItemList = GetSavedItemList()
    
    var isFull : Bool = false
    var isCallWebService : Bool = true
    var currentPage = 1
    var activityIndicator = UIActivityIndicatorView()
    
=======
    var savelist : SavedPageList!
    var strType  = 0
    var allDic : [String:Any] = [:]
    
    @IBOutlet var tvdashb : UITableView!
    var TotalCount:Int = 0
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tvdashb.delegate = self
        tvdashb.dataSource = self
        tvdashb.rowHeight = UITableViewAutomaticDimension
        tvdashb.estimatedRowHeight = 100
<<<<<<< HEAD
        //tvdashb.tableFooterView = UIView()
        self.viewError.isHidden = true

        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.startAnimating()
        
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = false
        self.sideMenuController()?.sideMenu?.allowPanGesture = false
        self.sideMenuController()?.sideMenu?.allowRightSwipe = false
=======
        tvdashb.tableFooterView = UIView()
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        
        onLoadDetail()
        // Do any additional setup after loading the view.
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    
    @IBAction func BtnTypeTapped(_ sender: UIButton) {
        
        self .popOver()
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.moveToDashboard()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func popOver()
    {
        let width = self.view.frame.size.width
        let aView = UIView(frame: CGRect(x: 10, y: 25, width: width, height: 240))
    
        let Share = UIButton(frame: CGRect(x: 10, y: 0, width: width - 30, height: 40))
        Share.setTitle("All", for: .normal)
        Share.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Share.contentHorizontalAlignment = .center
        Share.setTitleColor(UIColor.darkGray, for: .normal)
        Share.tag = 30000
        Share.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        
        let border = CALayer()
        let width1 = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: Share.frame.size.height - width1, width:  Share.frame.size.width, height: Share.frame.size.height)
        
        border.borderWidth = width1
        Share.layer.addSublayer(border)
        Share.layer.masksToBounds = true
        
        
        let Companie = UIButton(frame: CGRect(x: 10, y: 40, width: width - 30, height: 40))
<<<<<<< HEAD
        Companie.setTitle("User", for: .normal)
        Companie.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Companie.setTitleColor(UIColor.darkGray, for: .normal)
        Companie.contentHorizontalAlignment = .center
=======
        Companie.setTitle("Company", for: .normal)
        Companie.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Companie.setTitleColor(UIColor.darkGray, for: .normal)
        Companie.contentHorizontalAlignment = .left
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        Companie.tag = 30001
        Companie.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        let borderDelete = CALayer()
        let widthDelete = CGFloat(1.0)
        borderDelete.borderColor = UIColor.lightGray.cgColor
        borderDelete.frame = CGRect(x: 0, y: Companie.frame.size.height - width1, width:  Companie.frame.size.width, height: Companie.frame.size.height)
        
        borderDelete.borderWidth = widthDelete
        Companie.layer.addSublayer(borderDelete)
        Companie.layer.masksToBounds = true
        
    
        
        let Contractor = UIButton(frame: CGRect(x: 10, y: 80, width: width - 30, height: 40))
        Contractor.setTitle("Offer", for: .normal)
        Contractor.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Contractor.setTitleColor(UIColor.darkGray, for: .normal)
<<<<<<< HEAD
        Contractor.contentHorizontalAlignment = .center
=======
        Contractor.contentHorizontalAlignment = .left
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        Contractor.tag = 30002
        Contractor.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        let borderDelete1 = CALayer()
        borderDelete1.borderColor = UIColor.lightGray.cgColor
        borderDelete1.frame = CGRect(x: 0, y: Contractor.frame.size.height - width1, width:  Contractor.frame.size.width, height: Contractor.frame.size.height)
        
        borderDelete1.borderWidth = widthDelete
        Contractor.layer.addSublayer(borderDelete1)
        Contractor.layer.masksToBounds = true
        
        
        let Posts = UIButton(frame: CGRect(x: 10, y: 120, width: width - 30, height: 40))
        Posts.setTitle("Portfolio", for: .normal)
        Posts.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Posts.setTitleColor(UIColor.darkGray, for: .normal)
<<<<<<< HEAD
        Posts.contentHorizontalAlignment = .center
=======
        Posts.contentHorizontalAlignment = .left
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        Posts.tag = 30003
        Posts.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        let borderDelete2 = CALayer()
        borderDelete2.borderColor = UIColor.lightGray.cgColor
        borderDelete2.frame = CGRect(x: 0, y: Posts.frame.size.height - width1, width:  Posts.frame.size.width, height: Posts.frame.size.height)
        
        borderDelete2.borderWidth = widthDelete
        Posts.layer.addSublayer(borderDelete2)
        Posts.layer.masksToBounds = true
        
        
        let Jobs = UIButton(frame: CGRect(x: 10, y: 160, width: width - 30, height: 40))
        Jobs.setTitle("Jobs", for: .normal)
        Jobs.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Jobs.setTitleColor(UIColor.darkGray, for: .normal)
<<<<<<< HEAD
        Jobs.contentHorizontalAlignment = .center
=======
        Jobs.contentHorizontalAlignment = .left
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        Jobs.tag = 30004
        Jobs.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        let borderDelete3 = CALayer()
        borderDelete3.borderColor = UIColor.lightGray.cgColor
        borderDelete3.frame = CGRect(x: 0, y: Jobs.frame.size.height - width1, width:  Jobs.frame.size.width, height: Jobs.frame.size.height)
        
        borderDelete3.borderWidth = widthDelete
        Jobs.layer.addSublayer(borderDelete3)
        Jobs.layer.masksToBounds = true
        
        
        let Offers = UIButton(frame: CGRect(x: 10, y: 200, width: width - 30, height: 40))
<<<<<<< HEAD
        Offers.setTitle("Post", for: .normal)
        Offers.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Offers.setTitleColor(UIColor.darkGray, for: .normal)
        Offers.contentHorizontalAlignment = .center
        Offers.tag = 30005
        Offers.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
       
=======
        Offers.setTitle("Offers", for: .normal)
        Offers.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Offers.setTitleColor(UIColor.darkGray, for: .normal)
        Offers.contentHorizontalAlignment = .left
        Offers.tag = 30005
        Offers.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        

>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        
        aView.addSubview(Share)
        aView.addSubview(Companie)
        aView.addSubview(Contractor)
        aView.addSubview(Posts)
        aView.addSubview(Jobs)
        aView.addSubview(Offers)
        
        let options = [
            .type(.down),
            .cornerRadius(4)
            ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(aView, fromView:BtnType)
        
    }
    func press(button: UIButton)
<<<<<<< HEAD
    {
        print(button.tag)
        BtnType.setTitle(button.titleLabel!.text!, for: UIControlState.normal)
        BtnType.setTitle(button.titleLabel!.text!, for: UIControlState.selected)
        if((button.tag - 30000) == 0)
        {
            self.strType = 0
        }
            else  if((button.tag - 30000) == 1)
        {
            self.strType = 1
        }
            else  if((button.tag - 30000) == 2)
        {
            self.strType = 2
        }
        else  if((button.tag - 30000) == 3)
        {
            self.strType = 3
        }
        else  if((button.tag - 30000) == 4)
        {
            self.strType = 4
        }
        else  if((button.tag - 30000) == 5)
        {
            self.strType = 5
        }
        else  if((button.tag - 30000) == 6)
        {
            self.strType = 6
        }
        currentPage = 1
        onLoadDetail()
        tvdashb.reloadData()
        self.popover.dismiss()
=======
    {
        print(button.tag)
        BtnType.setTitle(button.titleLabel!.text!, for: UIControlState.normal)
        BtnType.setTitle(button.titleLabel!.text!, for: UIControlState.selected)
        if((button.tag - 30000) == 0)
        {
            self.strType = 0
        }
            else  if((button.tag - 30000) == 1)
        {
            self.strType = 1
        }
            else  if((button.tag - 30000) == 2)
        {
            self.strType = 2
        }
        else  if((button.tag - 30000) == 3)
        {
            self.strType = 3
        }
        else  if((button.tag - 30000) == 4)
        {
            self.strType = 4
        }
        else  if((button.tag - 30000) == 5)
        {
            self.strType = 5
        }
        else  if((button.tag - 30000) == 6)
        {
            self.strType = 6
        }
        tvdashb.reloadData()
        self.popover.dismiss()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard  ((sharedManager.savedPageList) != nil) else
        {
            return 0
        }
        if(strType == 0)
        {
            self.TotalCount = 0
            self.TotalCount = self.TotalCount + (self.savelist.CompanieList?.count)!
            self.TotalCount = self.TotalCount + (self.savelist.ContractorList?.count)!
            self.TotalCount = self.TotalCount + (self.savelist.PostList?.count)!
            self.TotalCount = self.TotalCount + (self.savelist.JobList?.count)!
            self.TotalCount = self.TotalCount + (self.savelist.OfferList?.count)!
            
            return TotalCount
        }
        else if(strType == 1)
        {
            return (self.savelist.CompanieList!.count)
        }
        else if(strType == 2)
        {
            return (self.savelist.ContractorList!.count)
        }
        else if(strType == 3)
        {
            return (self.savelist.PostList!.count)
        }
        else if(strType == 4)
        {
           return (self.savelist.JobList!.count)
        }
        else if(strType == 5)
        {
            return (self.savelist.OfferList!.count)
        }
        else
        {
            return 0
        }
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Saved View Screen.")
        
<<<<<<< HEAD
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.savedPageList.Result.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(self.savedPageList.Result[indexPath.row].PageType == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionNewCell", for: indexPath) as! ConnectionNewCell
            cell.lblName.text = self.savedPageList.Result[indexPath.row].UserView.FullName as String!
            cell.lblDis.text =  self.savedPageList.Result[indexPath.row].UserView.Description as String!
            
            cell.lblAway.text = self.savedPageList.Result[indexPath.row].UserView.CityName
            if(self.savedPageList.Result[indexPath.row].UserView.DistanceAwayText != "")
            {
                 cell.lblAway.text = cell.lblAway.text! + " - " + self.savedPageList.Result[indexPath.row].UserView.DistanceAwayText
            }
            
            cell.btnFav.tag=indexPath.row
            cell.btnSave.tag=indexPath.row
            cell.btnView.tag=indexPath.row

            cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
            cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
            cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
            
            cell.btnFav.isSelected = true
            cell.btnSave.isSelected = true
            
            let imgURL = self.savedPageList.Result[indexPath.row].UserView.ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imgUser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
        }
        else if(self.savedPageList.Result[indexPath.row].PageType == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardSpecialOffer", for: indexPath) as! DashBoardSpecialOffer
            cell.likeHeight.constant = 0
            cell.lblTitle.text = self.savedPageList.Result[indexPath.row].OfferView.CompanyName
            cell.lblDate.text = self.savedPageList.Result[indexPath.row].OfferView.Title + " - " + self.savedPageList.Result[indexPath.row].OfferView.PriceTag
            
            cell.lblDis.text = self.savedPageList.Result[indexPath.row].OfferView.Description
            cell.btnFav.tag = indexPath.row
            cell.btnProfile.tag = indexPath.row
            cell.btnView.tag = indexPath.row
            cell.btnSave.tag = indexPath.row
            cell.btnLike.tag = indexPath.row
            
            cell.btnFav.isSelected = true
            cell.btnSave.isSelected = true
            
            cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
            cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
            cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
            cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
            cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
            
            let imgURL = (self.savedPageList.Result[indexPath.row].OfferView.ProfileImageLink)
            let urlPro = URL(string: imgURL)
            cell.imgUser.kf.indicatorType = .activity
            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1))
            ]
            cell.imgUser.kf.indicatorType = .activity
            cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
            
            
            let imgURLImg1 = (self.savedPageList.Result[indexPath.row].OfferView.ImageLink)
            let urlProImg1 = URL(string: imgURLImg1)
            cell.imgUser.kf.indicatorType = .activity
            let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
            let optionInfoImg1: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1))
            ]
            cell.img1.kf.indicatorType = .activity
            cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
            
            return cell
        }
        else if(self.savedPageList.Result[indexPath.row].PageType == 3)
        {
            
            if(self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList.count == 0)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardTextCell", for: indexPath) as! DashBoardTextCell
                cell.likeHeight.constant = 0
                cell.lblTitle.text = self.savedPageList.Result[indexPath.row].PortfolioView.CompanyName + " - " + self.savedPageList.Result[indexPath.row].PortfolioView.TradeName
                cell.lblDis.text = self.savedPageList.Result[indexPath.row].PortfolioView.Description
                cell.lblDate.text = self.savedPageList.Result[indexPath.row].PortfolioView.TimeCaption
                
                cell.btnFav.tag = indexPath.row
                cell.btnProfile.tag = indexPath.row
                
                cell.btnSave.tag = indexPath.row
                cell.btnLike.tag = indexPath.row
                cell.btnFav.isSelected = true
                cell.btnSave.isSelected = true
                
                cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                
                let imgURL = (self.savedPageList.Result[indexPath.row].PortfolioView.ProfileImageLink)
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
            else if(self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList.count == 1)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard01Cell", for: indexPath) as! DashBoard01Cell
                cell.likeHeight.constant = 0
                cell.lblTitle.text = self.savedPageList.Result[indexPath.row].PortfolioView.CompanyName + " - " + self.savedPageList.Result[indexPath.row].PortfolioView.TradeName
                cell.lblDate.text = self.savedPageList.Result[indexPath.row].PortfolioView.TimeCaption
                cell.lblDis.text = self.savedPageList.Result[indexPath.row].PortfolioView.Description
                cell.btnFav.tag = indexPath.row
                cell.btnProfile.tag = indexPath.row
                cell.btnView.tag = indexPath.row
                cell.btnSave.tag = indexPath.row
                cell.btnLike.tag = indexPath.row
                
                cell.btnFav.isSelected = true
                cell.btnSave.isSelected = true
                
                cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                
                let imgURL = (self.savedPageList.Result[indexPath.row].PortfolioView.ProfileImageLink)
                let urlPro = URL(string: imgURL)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.imgUser.kf.indicatorType = .activity
                cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                
                
                let imgURLImg1 = (self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                let urlProImg1 = URL(string: imgURLImg1)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                let optionInfoImg1: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
                
                return cell
            }
            else if(self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList.count == 2)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard02Cell", for: indexPath) as! DashBoard02Cell
                cell.likeHeight.constant = 0
                cell.lblTitle.text = self.savedPageList.Result[indexPath.row].PortfolioView.CompanyName + " - " + self.savedPageList.Result[indexPath.row].PortfolioView.TradeName
                cell.lblDate.text = self.savedPageList.Result[indexPath.row].PortfolioView.TimeCaption
                cell.lblDis.text = self.savedPageList.Result[indexPath.row].PortfolioView.Description
                cell.btnFav.tag = indexPath.row
                cell.btnProfile.tag = indexPath.row
                cell.btnView.tag = indexPath.row
                cell.btnSave.tag = indexPath.row
                cell.btnLike.tag = indexPath.row
                
                cell.btnFav.isSelected = true
                cell.btnSave.isSelected = true
                
                cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                
                let imgURL = (self.savedPageList.Result[indexPath.row].PortfolioView.ProfileImageLink)
                let urlPro = URL(string: imgURL)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.imgUser.kf.indicatorType = .activity
                cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                
                let imgURLImg1 = (self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                let urlProImg1 = URL(string: imgURLImg1)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                let optionInfoImg1: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
                
                let imgURLImg2 = (self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList[1].ImageLink)
                let urlProImg2 = URL(string: imgURLImg1)
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
            else if(self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList.count == 3)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard03Cell", for: indexPath) as! DashBoard03Cell
                cell.likeHeight.constant = 0
                cell.lblTitle.text = self.savedPageList.Result[indexPath.row].PortfolioView.CompanyName + " - " + self.savedPageList.Result[indexPath.row].PortfolioView.TradeName
                cell.lblDate.text = self.savedPageList.Result[indexPath.row].PortfolioView.TimeCaption
                cell.lblDis.text = self.savedPageList.Result[indexPath.row].PortfolioView.Description
                
                cell.btnFav.tag = indexPath.row
                cell.btnProfile.tag = indexPath.row
                cell.btnView.tag = indexPath.row
                cell.btnSave.tag = indexPath.row
                cell.btnLike.tag = indexPath.row
                
                cell.btnFav.isSelected = true
                cell.btnSave.isSelected = true
                
                cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                
                let imgURL = (self.savedPageList.Result[indexPath.row].PortfolioView.ProfileImageLink)
                let urlPro = URL(string: imgURL)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.imgUser.kf.indicatorType = .activity
                cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                
                let imgURLImg1 = (self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                let urlProImg1 = URL(string: imgURLImg1)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                let optionInfoImg1: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
=======
        
        if strType == 0
        {
            var indexpath:Int = 0
            if(indexPath.row < (self.savelist.CompanieList?.count)!)
            {
                indexpath = indexPath.row
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectionCell
                cell.lbltitle.text = self.savelist.CompanieList![indexpath].UserFullName as String!
                cell.lbldate.text = self.savelist.CompanieList![indexpath].CityName as! String
                cell.lblTitle1.text = self.savelist.CompanieList![indexpath].CompanyName as! String
                cell.lblhtml.text = self.savelist.CompanieList![indexpath].Description
                
                cell.btnfav!.tag=indexpath
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavCompny(btn:)), for: UIControlEvents.touchUpInside)
                if self.savelist.CompanieList![indexpath].IsSaved == true {
                    cell.btnfav.isSelected = true
                }
                else{
                    cell.btnfav.isSelected = false
                }
                let imgURL = self.savelist.CompanieList![indexpath].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                return cell
            }
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!))
            {
                indexpath = indexPath.row - (self.savelist.CompanieList?.count)!
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ConnectionCell
                cell.lbllocatn.text = self.savelist.ContractorList![indexpath].CityName as String!
                cell.lblcompany.text = self.savelist.ContractorList![indexpath].CompanyName as String!
                cell.lblwork.text = self.savelist.ContractorList![indexpath].TradeCategoryName as String!
                
                cell.btnfav!.tag=indexpath
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavContractore(btn:)), for: UIControlEvents.touchUpInside)
               
                    cell.btnfav.isSelected = true
                
                let imgURL = self.savelist.ContractorList![indexpath].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                return cell
            }
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!))
            {
                indexpath = indexPath.row - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!)
                let cvimgcnt : Int = (self.savelist.PostList![indexpath].PortfolioImageList.count)
                if cvimgcnt == 0{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DashBoardTvCell
                    
                    cell.lbltitle.text = self.savelist.PostList![indexpath].UserFullName as String!
                    cell.lbldate.text = "\(self.savelist.PostList![indexpath].Date) at \(self.savelist.PostList![indexpath].Time)-\(self.savelist.PostList![indexpath].Location)"
                    cell.lblhtml.text = self.savelist.PostList![indexpath].Description as String!
                    
                    let imgURL = self.savelist.PostList![indexpath].ProfileImageLink as String!
                    let url = URL(string: imgURL!)
                    cell.imguser.kf.indicatorType = .activity
                    cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    cell.btnProfile!.tag=indexpath
                    cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                    
                    
                    cell.btnfav!.tag=indexpath
                    cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)
                    
                    cell.btnfav.isSelected = true
                    return cell
                    
                }
                    
                else if cvimgcnt == 1{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DashBoardTv1Cell
                    cell.lbltitle.text = self.savelist.PostList![indexpath].UserFullName as String!
                    cell.lbldate.text = "\(self.savelist.PostList![indexpath].Date) at \(self.savelist.PostList![indexpath].Time)-\(self.savelist.PostList![indexpath].Location)"
                    cell.lblhtml.text = self.savelist.PostList![indexpath].Description as String!
                    
                    let imgURL = self.savelist.PostList![indexpath].ProfileImageLink as String!
                    let url = URL(string: imgURL!)
                    cell.imguser.kf.indicatorType = .activity
                    cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    cell.btnProfile!.tag=indexpath
                   
                    
                    cell.btnfav!.tag=indexpath
                    cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)

                        cell.btnfav.isSelected = true

                    
                    let imgURL1 = self.savelist.PostList![indexpath].PortfolioImageList[0].PortfolioImageLink as String!
                    let url1 = URL(string: imgURL1!)
                    cell.img1.kf.indicatorType = .activity
                    cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    return cell
                    
                }
                    
                else if cvimgcnt == 2{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! DashBoardTv2Cell
                    cell.lbltitle.text = self.savelist.PostList![indexpath].UserFullName as String!
                    cell.lbldate.text = "\(self.savelist.PostList![indexpath].Date) at \(self.savelist.PostList![indexpath].Time)-\(self.savelist.PostList![indexpath].Location )"
                    cell.lblhtml.text = self.savelist.PostList![indexpath].Description as String!
                    
                    let imgURL = self.savelist.PostList![indexpath].ProfileImageLink as String!
                    let url = URL(string: imgURL!)
                    cell.imguser.kf.indicatorType = .activity
                    cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                    
                    cell.btnfav!.tag=indexpath
                    cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)

                        cell.btnfav.isSelected = true

                    let imgURL1 = self.savelist.PostList![indexpath].PortfolioImageList[0].PortfolioImageLink as String!
                    let url1 = URL(string: imgURL1!)
                    cell.img1.kf.indicatorType = .activity
                    cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    let imgURL2 = self.savelist.PostList![indexpath].PortfolioImageList[1].PortfolioImageLink as String!
                    let url2 = URL(string: imgURL2!)
                    cell.img2.kf.indicatorType = .activity
                    cell.img2.kf.setImage(with: url2, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    
                    return cell
                }
                else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! DashBoardTv3Cell
                    cell.lbltitle.text = self.savelist.PostList![indexpath].UserFullName as String!
                    cell.lbldate.text = "\(self.savelist.PostList![indexpath].Date) at \(self.savelist.PostList![indexpath].Time )-\(self.savelist.PostList![indexpath].Location )"
                    cell.lblhtml.text = self.savelist.PostList![indexpath].Description as String!
                    
                    let imgURL = self.savelist.PostList![indexpath].ProfileImageLink as String!
                    let url = URL(string: imgURL!)
                    cell.imguser.kf.indicatorType = .activity
                    cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    cell.btnfav!.tag=indexpath
                    cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)
                        cell.btnfav.isSelected = true

                    let imgURL1 = self.savelist.PostList![indexpath].PortfolioImageList[0].PortfolioImageLink as String!
                    let url1 = URL(string: imgURL1!)
                    cell.img1.kf.indicatorType = .activity
                    cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    let imgURL2 = self.savelist.PostList![indexpath].PortfolioImageList[1].PortfolioImageLink as String!
                    let url2 = URL(string: imgURL2!)
                    cell.img2.kf.indicatorType = .activity
                    cell.img2.kf.setImage(with: url2, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    let imgURL3 = self.savelist.PostList![indexpath].PortfolioImageList[2].PortfolioImageLink as String!
                    let url3 = URL(string: imgURL3!)
                    cell.img3.kf.indicatorType = .activity
                    cell.img3.kf.setImage(with: url3, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    return cell
                    
                }
            }
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!))
            {
                indexpath = indexPath.row - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! ProfileFeedCell
                
                cell.lblcity.text = self.savelist.JobList![indexpath].CityName as String!
                cell.lblcompany.text = self.savelist.JobList![indexpath].Description as String!
                cell.lblstart.text = self.savelist.JobList![indexpath].StartOn as String!
                cell.lblfinish.text = self.savelist.JobList![indexpath].EndOn as String!
                cell.lblexperience.text = self.savelist.JobList![indexpath].Title as String!
                cell.lblwork.text = self.savelist.JobList![indexpath].TradeCategoryName as String!
                cell.btnfav!.tag=indexpath
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavJobs(btn:)), for: UIControlEvents.touchUpInside)
                    cell.btnfav.isSelected = true

                //  cell.lbldatetime = self.
                let imgURL = self.savelist.JobList![indexpath].ProfileImageLink as String!
                
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                return cell
 
            }
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!)+(self.savelist.OfferList?.count)!)
            {
                indexpath = indexPath.row - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!)
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! SpecialOfferCell
                cell.lblCompanyDescription.text = self.savelist.OfferList![indexpath].Description as String!
                cell.lblWork.text = self.savelist.OfferList![indexpath].Title as String!
                // cell.lblCompanyName.text = self.sharedManager.selectedCompany.CompanyName
                cell.btnfav!.tag=indexpath
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavSpecialOffer(btn:)), for: UIControlEvents.touchUpInside)
                    cell.btnfav.isSelected = true

                
                let imgURL = self.savelist.OfferList![indexpath].ProfileImageLink as String!
                
                let url = URL(string: imgURL!)
                
                cell.ImgProfilepic.kf.indicatorType = .activity
                cell.ImgProfilepic.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                let imgURL1 = self.savelist.OfferList![indexpath].OfferImageLink as String!
                let url1 = URL(string: imgURL1!)
                cell.ImgCompanyPic.kf.indicatorType = .activity
                cell.ImgCompanyPic.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                return cell
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DashBoardTv1Cell
                
                
                return cell
            }
        }
        else if strType == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectionCell
            cell.lbltitle.text = self.savelist.CompanieList![indexPath.row].UserFullName as String!
            cell.lbldate.text = self.savelist.CompanieList![indexPath.row].CityName
            cell.lblTitle1.text = self.savelist.CompanieList![indexPath.row].CompanyName
            cell.lblhtml.text = self.savelist.CompanieList![indexPath.row].Description
            
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavCompny(btn:)), for: UIControlEvents.touchUpInside)
                cell.btnfav.isSelected = true

            let imgURL = self.savelist.CompanieList![indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
            
        }
            
        else if strType == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ConnectionCell
            cell.lbllocatn.text = self.savelist.ContractorList![indexPath.row].CityName as String!
            cell.lblcompany.text = self.savelist.ContractorList![indexPath.row].CompanyName as String!
            cell.lblwork.text = self.savelist.ContractorList![indexPath.row].TradeCategoryName as String!
            
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavContractore(btn:)), for: UIControlEvents.touchUpInside)
                cell.btnfav.isSelected = true

            let imgURL = self.savelist.ContractorList![indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
        }
        else if strType == 3{
            
            let cvimgcnt : Int = (self.savelist.PostList![indexPath.row].PortfolioImageList.count)
            if cvimgcnt == 0{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DashBoardTvCell
                
                cell.lbltitle.text = self.savelist.PostList![indexPath.row].UserFullName as String!
                cell.lbldate.text = "\(self.savelist.PostList![indexPath.row].Date ) at \(self.savelist.PostList![indexPath.row].Time )-\(self.savelist.PostList![indexPath.row].Location )"
                cell.lblhtml.text = self.savelist.PostList![indexPath.row].Description as String!
                
                let imgURL = self.savelist.PostList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)

                    cell.btnfav.isSelected = true

                return cell
                
            }
                
            else if cvimgcnt == 1{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DashBoardTv1Cell
                cell.lbltitle.text = self.savelist.PostList![indexPath.row].UserFullName as String!
                cell.lbldate.text = "\(self.savelist.PostList![indexPath.row].Date) at \(self.savelist.PostList![indexPath.row].Time )-\(self.savelist.PostList![indexPath.row].Location)"
                cell.lblhtml.text = self.savelist.PostList![indexPath.row].Description as String!
                
                let imgURL = self.savelist.PostList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                

                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)

                    cell.btnfav.isSelected = true
   
                
                let imgURL1 = self.savelist.PostList![indexPath.row].PortfolioImageList[0].PortfolioImageLink as String!
                let url1 = URL(string: imgURL1!)
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                return cell
                
            }
                
            else if cvimgcnt == 2{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! DashBoardTv2Cell
                cell.lbltitle.text = self.savelist.PostList![indexPath.row].UserFullName as String!
                cell.lbldate.text = "\(self.savelist.PostList![indexPath.row].Date) at \(self.savelist.PostList![indexPath.row].Time)-\(self.savelist.PostList![indexPath.row].Location)"
                cell.lblhtml.text = self.savelist.PostList![indexPath.row].Description as String!
                
                let imgURL = self.savelist.PostList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)
                    cell.btnfav.isSelected = true
                    
                let imgURL1 = self.savelist.PostList![indexPath.row].PortfolioImageList[0].PortfolioImageLink as String!
                let url1 = URL(string: imgURL1!)
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                let imgURL2 = self.savelist.PostList![indexPath.row].PortfolioImageList[1].PortfolioImageLink as String!
                let url2 = URL(string: imgURL2!)
                cell.img2.kf.indicatorType = .activity
                cell.img2.kf.setImage(with: url2, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                
                return cell
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! DashBoardTv3Cell
                cell.lbltitle.text = self.savelist.PostList![indexPath.row].UserFullName as String!
                cell.lbldate.text = "\(self.savelist.PostList![indexPath.row].Date ) at \(self.savelist.PostList![indexPath.row].Time )-\(self.savelist.PostList![indexPath.row].Location)"
                cell.lblhtml.text = self.savelist.PostList![indexPath.row].Description as String!
                
                let imgURL = self.savelist.PostList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                

                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)
                cell.btnfav.isSelected = true
                    
                let imgURL1 = self.savelist.PostList![indexPath.row].PortfolioImageList[0].PortfolioImageLink as String!
                let url1 = URL(string: imgURL1!)
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                let imgURL2 = self.savelist.PostList![indexPath.row].PortfolioImageList[1].PortfolioImageLink as String!
                let url2 = URL(string: imgURL2!)
                cell.img2.kf.indicatorType = .activity
                cell.img2.kf.setImage(with: url2, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                let imgURL3 = self.savelist.PostList![indexPath.row].PortfolioImageList[2].PortfolioImageLink as String!
                let url3 = URL(string: imgURL3!)
                cell.img3.kf.indicatorType = .activity
                cell.img3.kf.setImage(with: url3, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                return cell
                
            }
        }
        else if strType == 4{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! ProfileFeedCell
            
            cell.lblcity.text = self.savelist.JobList![indexPath.row].CityName as String!
            cell.lblcompany.text = self.savelist.JobList![indexPath.row].Description as String!
            cell.lblstart.text = self.savelist.JobList![indexPath.row].StartOn as String!
            cell.lblfinish.text = self.savelist.JobList![indexPath.row].EndOn as String!
            cell.lblexperience.text = self.savelist.JobList![indexPath.row].Title as String!
            cell.lblwork.text = self.savelist.JobList![indexPath.row].TradeCategoryName as String!
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavJobs(btn:)), for: UIControlEvents.touchUpInside)
                cell.btnfav.isSelected = true
            
            
            //  cell.lbldatetime = self.
            let imgURL = self.savelist.JobList![indexPath.row].ProfileImageLink as String!
            
            let url = URL(string: imgURL!)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            return cell
        }
        else if strType == 5{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! SpecialOfferCell
            cell.lblCompanyDescription.text = self.savelist.OfferList![indexPath.row].Description as String!
            cell.lblWork.text = self.savelist.OfferList![indexPath.row].Title as String!
           // cell.lblCompanyName.text = self.sharedManager.selectedCompany.CompanyName
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavSpecialOffer(btn:)), for: UIControlEvents.touchUpInside)
           
            cell.btnfav.isSelected = true
        
            let imgURL = self.savelist.OfferList![indexPath.row].ProfileImageLink as String!
            
            let url = URL(string: imgURL!)
            
            cell.ImgProfilepic.kf.indicatorType = .activity
            cell.ImgProfilepic.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            let imgURL1 = self.savelist.OfferList![indexPath.row].OfferImageLink as String!
            let url1 = URL(string: imgURL1!)
            cell.ImgCompanyPic.kf.indicatorType = .activity
            cell.ImgCompanyPic.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DashBoardTv3Cell

            
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if strType == 0
        {
            var indexpath:Int = 0
            if(indexPath.row < (self.savelist.CompanieList?.count)!)
            {
                indexpath = indexPath.row
                
                let obj : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                obj.companyId = (self.savelist.CompanieList?[indexpath].PrimaryID)!
                self.navigationController?.pushViewController(obj, animated: true)
                
            }
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!))
            {
                indexpath = indexPath.row - (self.savelist.CompanieList?.count)!
                
                let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                obj.contractorId = (self.savelist.ContractorList?[indexpath].PrimaryID)!
                obj.isPortFolio = false
                self.navigationController?.pushViewController(obj, animated: true)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                
                let imgURLImg2 = (self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList[1].ImageLink)
                let urlProImg2 = URL(string: imgURLImg2)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouceImg2 = ImageResource(downloadURL: urlProImg2!, cacheKey: imgURLImg2)
                let optionInfoImg2: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.img2.kf.indicatorType = .activity
                cell.img2.kf.setImage(with: tmpResouceImg2, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg2, progressBlock: nil, completionHandler: nil)
                
                let imgURLImg3 = (self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList[2].ImageLink)
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
<<<<<<< HEAD
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard03Cell", for: indexPath) as! DashBoard03Cell
                cell.likeHeight.constant = 0
                cell.lblTitle.text = self.savedPageList.Result[indexPath.row].PortfolioView.CompanyName + " - " + self.savedPageList.Result[indexPath.row].PortfolioView.TradeName
                 cell.lblDate.text = self.savedPageList.Result[indexPath.row].PortfolioView.TimeCaption
                cell.lblDis.text = self.savedPageList.Result[indexPath.row].PortfolioView.Description
                
                cell.btnFav.tag = indexPath.row
                cell.btnProfile.tag = indexPath.row
                cell.btnView.tag = indexPath.row
                cell.btnSave.tag = indexPath.row
                cell.btnLike.tag = indexPath.row
                
                cell.btnFav.isSelected = true
                cell.btnSave.isSelected = true
                
                cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                
                let imgURL = (self.savedPageList.Result[indexPath.row].PortfolioView.ProfileImageLink)
                let urlPro = URL(string: imgURL)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.imgUser.kf.indicatorType = .activity
                cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                
                let imgURLImg1 = (self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                let urlProImg1 = URL(string: imgURLImg1)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                let optionInfoImg1: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
                
                let imgURLImg2 = (self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList[1].ImageLink)
                let urlProImg2 = URL(string: imgURLImg2)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouceImg2 = ImageResource(downloadURL: urlProImg2!, cacheKey: imgURLImg2)
                let optionInfoImg2: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.img2.kf.indicatorType = .activity
                cell.img2.kf.setImage(with: tmpResouceImg2, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg2, progressBlock: nil, completionHandler: nil)
                
                let imgURLImg3 = (self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList[2].ImageLink)
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
                cell.lblPhotoCount.text = "+ \(self.savedPageList.Result[indexPath.row].PortfolioView.PortfolioImageList.count - 3)\nView All"
                
                return cell
            }
        }
        else if(self.savedPageList.Result[indexPath.row].PageType == 4)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardJobCell", for: indexPath) as! DashBoardJobCell
            cell.likeHeight.constant = 0
            cell.lblTitle.text = self.savedPageList.Result[indexPath.row].JobView.JobRoleName + " - " + self.savedPageList.Result[indexPath.row].JobView.JobTradeName
            cell.lblCompanyname.text = self.savedPageList.Result[indexPath.row].JobView.CompanyName
            cell.lblDis.text = self.savedPageList.Result[indexPath.row].JobView.Description
            cell.lblDate.text = self.savedPageList.Result[indexPath.row].JobView.CityName
            
            if(self.savedPageList.Result[indexPath.row].JobView.DistanceAwayText != "")
            {
                cell.lblDate.text = cell.lblDate.text! + "-" + self.savedPageList.Result[indexPath.row].JobView.DistanceAwayText
            }
            cell.btnFav.tag = indexPath.row
            cell.btnProfile.tag = indexPath.row
            cell.btnView.tag = indexPath.row
            cell.btnSave.tag = indexPath.row
            cell.btnLike.tag = indexPath.row
            
            cell.btnFav.isSelected = true
            cell.btnSave.isSelected = true
            
            cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
            cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
            cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
            cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
            cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
            
            if(self.savedPageList.Result[indexPath.row].JobView.ProfileImageLink != "")
            {
                let imgURL = self.savedPageList.Result[indexPath.row].JobView.ProfileImageLink
                let urlPro = URL(string: imgURL)
                cell.imgUser.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                cell.imgUser.kf.indicatorType = .activity
                cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
            }
        
            return cell
        }
        else if(self.savedPageList.Result[indexPath.row].PageType == 5)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardTextCell", for: indexPath) as! DashBoardTextCell
            cell.likeHeight.constant = 0
            cell.lblTitle.text = self.savedPageList.Result[indexPath.row].PostView.Name + " - " + self.savedPageList.Result[indexPath.row].PostView.TradeName
            cell.lblDis.text = self.savedPageList.Result[indexPath.row].PostView.StatusText
            cell.lblDate.text = self.savedPageList.Result[indexPath.row].PostView.TimeCaption
            
            cell.btnFav.tag = indexPath.row
            cell.btnProfile.tag = indexPath.row
            cell.btnSave.tag = indexPath.row
            cell.btnLike.tag = indexPath.row
            
            cell.btnFav.isSelected = true
            cell.btnSave.isSelected = true
            
            cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
            cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
            cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
            cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
            
            let imgURL = (self.savedPageList.Result[indexPath.row].PostView.ProfileImageLink)
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
=======
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!))
            {
                indexpath = indexPath.row - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!)
                
                let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                obj.contractorId = (self.savelist.ContractorList?[indexpath].PrimaryID)!
                obj.isPortFolio = false
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!))
            {
                indexpath = indexPath.row - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
                vc.jobDetail = self.savelist.JobList![indexpath]
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!)+(self.savelist.OfferList?.count)!)
            {
                indexpath = indexPath.row - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
                vc.isNotification  = true
                vc.OfferId = self.savelist.OfferList![indexpath].PrimaryID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if strType == 1
        {
            let obj : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
            obj.companyId = (self.savelist.CompanieList?[indexPath.row].PrimaryID)!
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if strType == 2
        {
            let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            obj.contractorId = (self.savelist.ContractorList?[indexPath.row].PrimaryID)!
            obj.isPortFolio = false
            self.navigationController?.pushViewController(obj, animated: true)
        }

        else if strType == 3
        {
            let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            obj.contractorId = (self.savelist.ContractorList?[indexPath.row].PrimaryID)!
            obj.isPortFolio = true
            self.navigationController?.pushViewController(obj, animated: true)
        }

        else if strType == 4
        {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
//            vc.jobDetail = self.savelist.JobList![indexPath.row]
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if strType == 5
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.isNotification  = true
            vc.OfferId = self.savelist.OfferList![indexPath.row].PrimaryID
            self.navigationController?.pushViewController(vc, animated: true)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        }
    }
    func lblNamedTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
<<<<<<< HEAD
        let lbl = tapGestureRecognizer.view as! UILabel
        if(UIApplication.shared.openURL(URL(string: (self.savedPageList.Result[lbl.tag].OfferView.Website))!))
        {
            let openLink = NSURL(string : (self.savedPageList.Result[lbl.tag].OfferView.Website))
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: openLink! as URL)
                present(svc, animated: true, completion: nil)
            } else {
                let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                port.strUrl = (self.savedPageList.Result[lbl.tag].OfferView.Website)
                self.navigationController?.pushViewController(port, animated: true)
            }
        }
        else
        {
            return
        }
    }
    func lblImagheProfile(tapGestureRecognizer:UIGestureRecognizer)
    {
        OpenDetailPage(index: (tapGestureRecognizer.view?.tag)!)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        OpenDetailPageUsingPageType(index: indexPath.row)
    }
    func btnProfile (_ sender : UIButton)
    {
        OpenDetailPage(index: sender.tag)
    }
    func btnPortfolio (_ sender : UIButton)
    {
        OpenDetailPageUsingPageType(index: sender.tag)
    }
    func onLoadDetail()
    {
        self.isCallWebService = true
        if(self.currentPage != 1)
        {
            self.tvdashb.tableFooterView = activityIndicator
        }
        else
        {
            self.startAnimating()
        }
        var param = [:] as [String : Any]
        param["PageType"] = strType
        param["PageIndex"] = currentPage
=======
        let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
       // obj.contractorId = (self.savelist[btn.tag].ContractorID)!
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    func btnPortfolio (btn : UIButton) {
        let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
      //  obj.contractorId = (self.savelist[btn.tag].ContractorID)!
        obj.isPortFolio = true
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    func onLoadDetail(){
        
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.GetSavePageList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.savedPageList = Mapper<SavedPageList>().map(JSONObject: JSONResponse.rawValue)
            
            // self.sharedManager.savepageAlllist = Mapper<savepageAlllist>().map(JSONObject: JSONResponse.rawValue)

            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {       // self.vwnolist?.isHidden = true
                    
                    self.savelist = self.sharedManager.savedPageList
                    
                    self.TotalCount = 0
                    self.TotalCount = self.TotalCount + (self.savelist.CompanieList?.count)!
                    self.TotalCount = self.TotalCount + (self.savelist.ContractorList?.count)!
                    self.TotalCount = self.TotalCount + (self.savelist.PostList?.count)!
                    self.TotalCount = self.TotalCount + (self.savelist.JobList?.count)!
                    self.TotalCount = self.TotalCount + (self.savelist.OfferList?.count)!
                    self.tvdashb.reloadData()
                }
                else
                {
                    
                  //  self.vwnolist?.isHidden = false
                    
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
    func btnfavSpecialOffer(btn : UIButton)  {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.savelist.OfferList?[btn.tag].PrimaryID,
                     "PageType":"5"] as [String : Any]
        
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
<<<<<<< HEAD
=======
            
            
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            self.stopAnimating()

            print(JSONResponse["Status"].rawValue)
            self.isCallWebService = false
            self.tvdashb.tableFooterView = UIView()
            if JSONResponse["Status"].int == 1
            {
                if(self.currentPage == 1)
                {
                    self.savedPageList.Result =  []
                }
                let temp = Mapper<GetSavedItemList>().map(JSONObject: JSONResponse.rawValue)!
                if(temp.Result.count == 0)
                {
                    self.isFull = true
                }
                for temp1 in temp.Result
                {
                    self.savedPageList.Result.append(temp1)
                }
                
                self.currentPage = self.currentPage + 1
                self.isCallWebService = false
                self.tvdashb.reloadData()
                
                if(self.savedPageList.Result.count == 0)
                {
<<<<<<< HEAD
                     AppDelegate.sharedInstance().addNoDataView(view: self.view, frame: self.tvdashb.frame, viewController: self, strMsg:"There are no saved items.")
=======
                    self.savelist.OfferList?.remove(at: btn.tag)
                    self.tvdashb.reloadData()
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
    func btnfavJobs(btn : UIButton)  {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.savelist.JobList?[btn.tag].PrimaryID ?? "",
                     "PageType":"4"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.savelist.JobList?.remove(at: btn.tag)
                    self.tvdashb.reloadData()
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                }
                else
                {
                    AppDelegate.sharedInstance().removeNoDataView()
                }
            }
            else
            {
                AppDelegate.sharedInstance().addNoDataView(view: self.view, frame: self.tvdashb.frame, viewController: self, strMsg:JSONResponse["Message"].rawString()!)
            }
            
        }) {
            (error) -> Void in
            self.tvdashb.tableFooterView = UIView()
            self.isCallWebService = false
            self.stopAnimating()
           // self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
<<<<<<< HEAD
    func RetrybuttonTaped()
    {
        isFull = false
        isCallWebService = false
        currentPage = 1
        onLoadDetail()
    }
    func btnLikeAction(_ sender : UIButton)
=======
    func btnfavCompny(btn : UIButton)
    {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.savelist.CompanieList?[btn.tag].PrimaryID ?? "",
                     "PageType": "1"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.savelist.CompanieList?.remove(at: btn.tag)
                    self.tvdashb.reloadData()
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
    func btnfavContractore(btn : UIButton)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    {
        
    }
    func btnViewAction(_ sender : UIButton)
    {
        OpenDetailPageUsingPageType(index: sender.tag)
    }
    func btnSaveStatus(_ sender : UIButton)
    {
        self.startAnimating()
<<<<<<< HEAD
        let param = ["TablePrimaryID":self.savedPageList.Result[sender.tag].PrimaryID,
                     "PageType":self.savedPageList.Result[sender.tag].PageType] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                self.savedPageList.Result.remove(at: sender.tag)
                self.tvdashb.reloadData()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
=======
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.savelist.ContractorList?[btn.tag].PrimaryID ?? "",
                     "PageType":"2"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.savelist.ContractorList?.remove(at: btn.tag)
                    self.tvdashb.reloadData()
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
    func btnfavPostList(btn : UIButton)
    {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.savelist.PostList?[btn.tag].PrimaryID ?? "",
                     "PageType":"6"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.savelist.PostList?.remove(at: btn.tag)
                    self.tvdashb.reloadData()
                }
                else
                {
                    
                }
                
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
            
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
    func OpenDetailPage(index:Int)
    {
        if(self.savedPageList.Result[index].Role == 0)
        {
            print("Admin")
        }
        else if(self.savedPageList.Result[index].Role == 1)
        {
            print("Contractor")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
            vc.userId = self.savedPageList.Result[index].UserID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.savedPageList.Result[index].Role == 2)
        {
            print("Company")
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            companyVC.userId = self.savedPageList.Result[index].UserID
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else if(self.savedPageList.Result[index].Role == 3)
        {
            print("Supplier")
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
            vc.userId = self.savedPageList.Result[index].UserID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func OpenDetailPageUsingPageType(index:Int)
    {
        if(self.savedPageList.Result[index].PageType == 0)
        {
            print("Admin")
        }
        else if(self.savedPageList.Result[index].PageType == 1)
        {
            print("Contractor")
            if(self.savedPageList.Result[index].IsMe)
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContractorProfileView") as! ContractorProfileView
                vc.userId = self.savedPageList.Result[index].UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                vc.userId = self.savedPageList.Result[index].UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(self.savedPageList.Result[index].PageType == 2)
        {
            print("Offer")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.OfferDetail = self.savedPageList.Result[index].OfferView
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.savedPageList.Result[index].PageType == 3)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortfolioDetails") as! PortfolioDetails
            vc.portfolio = self.savedPageList.Result[index].PortfolioView
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.savedPageList.Result[index].PageType == 4)
        {
            if(self.savedPageList.Result[index].IsMe == true)
            {
                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "MyJodDetailViewController") as! MyJodDetailViewController
                vc.JobId = self.savedPageList.Result[index].JobView.JobID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewOtherJodDetailViewController") as! NewOtherJodDetailViewController
                vc.jobDetail = self.savedPageList.Result[index].JobView
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(self.savedPageList.Result[index].PageType == 5)
        {
           OpenDetailPage(index: index)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if !self.isCallWebService{
            if(scrollView == self.tvdashb)
            {
                if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height))
                {
                    if(!isFull)
                    {
                        onLoadDetail()
                    }
                }
            }
        }
    }
}
