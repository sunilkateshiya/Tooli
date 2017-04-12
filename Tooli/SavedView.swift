//
//  SavedView.swift
//  Tooli
//
//  Created by Impero IT on 15/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
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

class SavedView: UIViewController, NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource {

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
    var savelist : SavedPageList!
    var strType  = 0
    var allDic : [String:Any] = [:]
    
    @IBOutlet var tvdashb : UITableView!
    var TotalCount:Int = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tvdashb.delegate = self
        tvdashb.dataSource = self
        tvdashb.rowHeight = UITableViewAutomaticDimension
        tvdashb.estimatedRowHeight = 100
        //tvdashb.tableFooterView = UIView()
        self.viewError.isHidden = false
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
    func popOver() {
        
        
        let width = self.view.frame.size.width
        let aView = UIView(frame: CGRect(x: 10, y: 25, width: width, height: 240))
    
        let Share = UIButton(frame: CGRect(x: 10, y: 0, width: width - 30, height: 40))
        Share.setTitle("All", for: .normal)
        Share.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Share.contentHorizontalAlignment = .left
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
        Companie.setTitle("Company", for: .normal)
        Companie.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Companie.setTitleColor(UIColor.darkGray, for: .normal)
        Companie.contentHorizontalAlignment = .left
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
        Contractor.setTitle("Contractor", for: .normal)
        Contractor.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Contractor.setTitleColor(UIColor.darkGray, for: .normal)
        Contractor.contentHorizontalAlignment = .left
        Contractor.tag = 30002
        Contractor.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        let borderDelete1 = CALayer()
        borderDelete1.borderColor = UIColor.lightGray.cgColor
        borderDelete1.frame = CGRect(x: 0, y: Contractor.frame.size.height - width1, width:  Contractor.frame.size.width, height: Contractor.frame.size.height)
        
        borderDelete1.borderWidth = widthDelete
        Contractor.layer.addSublayer(borderDelete1)
        Contractor.layer.masksToBounds = true
        
        
        let Posts = UIButton(frame: CGRect(x: 10, y: 120, width: width - 30, height: 40))
        Posts.setTitle("Posts", for: .normal)
        Posts.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Posts.setTitleColor(UIColor.darkGray, for: .normal)
        Posts.contentHorizontalAlignment = .left
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
        Jobs.contentHorizontalAlignment = .left
        Jobs.tag = 30004
        Jobs.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        let borderDelete3 = CALayer()
        borderDelete3.borderColor = UIColor.lightGray.cgColor
        borderDelete3.frame = CGRect(x: 0, y: Jobs.frame.size.height - width1, width:  Jobs.frame.size.width, height: Jobs.frame.size.height)
        
        borderDelete3.borderWidth = widthDelete
        Jobs.layer.addSublayer(borderDelete3)
        Jobs.layer.masksToBounds = true
        
        
        let Offers = UIButton(frame: CGRect(x: 10, y: 200, width: width - 30, height: 40))
        Offers.setTitle("Offers", for: .normal)
        Offers.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Offers.setTitleColor(UIColor.darkGray, for: .normal)
        Offers.contentHorizontalAlignment = .left
        Offers.tag = 30005
        Offers.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        

        
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
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Saved View Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard  ((self.savelist) != nil) else
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
            tableView.SetTableViewBlankLable(count: TotalCount, str: "No data found.")
            return TotalCount
        }
        else if(strType == 1)
        {
            tableView.SetTableViewBlankLable(count: self.savelist.CompanieList!.count, str: "No data found.")
            return (self.savelist.CompanieList!.count)
        }
        else if(strType == 2)
        {
            tableView.SetTableViewBlankLable(count: self.savelist.ContractorList!.count, str: "No data found.")
            return (self.savelist.ContractorList!.count)
        }
        else if(strType == 3)
        {
            tableView.SetTableViewBlankLable(count: self.savelist.PostList!.count, str: "No data found.")
            return (self.savelist.PostList!.count)
        }
        else if(strType == 4)
        {
            tableView.SetTableViewBlankLable(count: self.savelist.JobList!.count, str: "No data found.")
           return (self.savelist.JobList!.count)
        }
        else if(strType == 5)
        {
            tableView.SetTableViewBlankLable(count: self.savelist.OfferList!.count, str: "No data found.")
            return (self.savelist.OfferList!.count)
        }
        else
        {
            
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        if strType == 0
        {
            var indexpath:Int = 0
            if(indexPath.row < (self.savelist.CompanieList?.count)!)
            {
                indexpath = indexPath.row
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectionCell
                cell.lbltitle.text = self.savelist.CompanieList![indexpath].CompanyName as String!
                cell.lbldate.text = self.savelist.CompanieList![indexpath].CityName as! String
                cell.lblTitle1.text = ""
                cell.lblhtml.text = self.savelist.CompanieList![indexpath].Description
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
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
                cell.lblcompany.text = self.savelist.ContractorList![indexpath].Name as String!
                cell.lblwork.text = self.savelist.ContractorList![indexpath].TradeCategoryName as String!
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
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
                    cell.lbldate.text = "\(self.savelist.PostList![indexpath].DateTimeCaption)-\(self.savelist.PostList![indexpath].Location )"
                    cell.lblhtml.text = self.savelist.PostList![indexpath].Description as String!
                    
                    let imgURL = self.savelist.PostList![indexpath].ProfileImageLink as String!
                    let url = URL(string: imgURL!)
                    cell.imguser.kf.indicatorType = .activity
                    cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    cell.btnProfile!.tag=indexPath.row
                    cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                    
                    
                    cell.btnfav!.tag=indexpath
                    cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)
                    
                    cell.btnfav.isSelected = true
                    return cell
                    
                }
                    
                else if cvimgcnt == 1{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DashBoardTv1Cell
                    cell.lbltitle.text = self.savelist.PostList![indexpath].UserFullName as String!
                    cell.lbldate.text = "\(self.savelist.PostList![indexpath].DateTimeCaption)-\(self.savelist.PostList![indexpath].Location )"
                    cell.lblhtml.text = self.savelist.PostList![indexpath].Description as String!
                    
                    let imgURL = self.savelist.PostList![indexpath].ProfileImageLink as String!
                    let url = URL(string: imgURL!)
                    cell.imguser.kf.indicatorType = .activity
                    cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    cell.btnProfile!.tag=indexPath.row
                    cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                   
                    cell.btnPortfolio!.tag=indexpath
                    cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                    
                    cell.btnfav!.tag=indexpath
                    cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)

                    cell.btnfav.isSelected = true

                    
                    let imgURL1 = self.savelist.PostList![indexpath].PortfolioImageList[0].PortfolioImageLink as String!
                    let url1 = URL(string: imgURL1!)
                    cell.img1.kf.indicatorType = .activity
                    cell.img1.kf.setImage(with: url1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                        if(image != nil)
                        {
                            cell.setCustomImage(image : image!)
                            if(cell.isReload)
                            {
                                cell.isReload = false
                                tableView.reloadData()
                            }
                        }
                    })
                    
                    return cell
                    
                }
                    
                else if cvimgcnt == 2{
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! DashBoardTv2Cell
                    cell.lbltitle.text = self.savelist.PostList![indexpath].UserFullName as String!
                    cell.lbldate.text = "\(self.savelist.PostList![indexpath].DateTimeCaption)-\(self.savelist.PostList![indexpath].Location )"
                    cell.lblhtml.text = self.savelist.PostList![indexpath].Description as String!
                    
                    let imgURL = self.savelist.PostList![indexpath].ProfileImageLink as String!
                    let url = URL(string: imgURL!)
                    cell.imguser.kf.indicatorType = .activity
                    cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                    cell.btnProfile!.tag=indexPath.row
                    cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                    
                    cell.btnPortfolio!.tag=indexpath
                    cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                    
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
                     cell.lbldate.text = "\(self.savelist.PostList![indexpath].DateTimeCaption)-\(self.savelist.PostList![indexpath].Location )"
                    cell.lblhtml.text = self.savelist.PostList![indexpath].Description as String!
                    
                    cell.btnPortfolio!.tag=indexpath
                    cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                    
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
                    
                    cell.btnProfile!.tag=indexPath.row
                    cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                    
                    let imgURL2 = self.savelist.PostList![indexpath].PortfolioImageList[1].PortfolioImageLink as String!
                    let url2 = URL(string: imgURL2!)
                    cell.img2.kf.indicatorType = .activity
                    cell.img2.kf.setImage(with: url2, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                    
                    let imgURL3 = self.savelist.PostList![indexpath].PortfolioImageList[2].PortfolioImageLink as String!
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
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!))
            {
                indexpath = indexPath.row - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! ProfileFeedCell
                
                cell.lblcity.text = self.savelist.JobList![indexpath].CityName as String!
                cell.lblcompany.text = self.savelist.JobList![indexpath].Title as String!
                if(self.savelist.JobList![indexpath].StartOn as String! != "")
                {
                    cell.lblstart.attributedText = DisPlayCountInLabel(strTitle:"Start Date:", value: (self.savelist.JobList![indexpath].StartOn))
                }
                if(self.savelist.JobList![indexpath].EndOn as String! != "")
                {
                    cell.lblfinish.attributedText = DisPlayCountInLabel(strTitle:"Finish Date:", value: (self.savelist.JobList![indexpath].EndOn))
                }
                cell.lblexperience.text = self.savelist.JobList![indexpath].Description as String!
                cell.lblwork.text = self.savelist.JobList![indexpath].TradeCategoryName as String!
                cell.lbldatetime.text = self.savelist.JobList![indexpath].DistanceText as String!
                cell.btnfav!.tag=indexpath
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavJobs(btn:)), for: UIControlEvents.touchUpInside)
                    cell.btnfav.isSelected = true

                //  cell.lbldatetime = self.
                let imgURL = self.savelist.JobList![indexpath].ProfileImageLink as String!
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                return cell
 
            }
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!)+(self.savelist.OfferList?.count)!)
            {
                indexpath = indexPath.row - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!)
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! SpecialOfferCell
                cell.lblCompanyDescription.text = "\(self.savelist.OfferList![indexpath].Description)\n\(self.savelist.OfferList![indexpath].RedirectLink)"
                if(self.savelist.OfferList![indexpath].RedirectLink != "")
                {
                    cell.lblCompanyDescription.tag = indexpath
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                    cell.lblCompanyDescription.isUserInteractionEnabled = true
                    cell.lblCompanyDescription.addGestureRecognizer(tapGestureRecognizer)
                }
                
                cell.lblWork.text = self.savelist.OfferList![indexpath].Title as String!
                cell.lblCompanyName.text = self.savelist.OfferList![indexpath].CompanyName
                cell.btnfav!.tag=indexpath
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavSpecialOffer(btn:)), for: UIControlEvents.touchUpInside)
                    cell.btnfav.isSelected = true
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
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
            cell.lbltitle.text = self.savelist.CompanieList![indexPath.row].CompanyName as String!
            cell.lbldate.text = self.savelist.CompanieList![indexPath.row].CityName
            cell.lblTitle1.text = ""
            cell.lblhtml.text = self.savelist.CompanieList![indexPath.row].Description
            
            cell.btnProfile!.tag=indexPath.row
            cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)            
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
            cell.lblcompany.text = self.savelist.ContractorList![indexPath.row].Name as String!
            cell.lblwork.text = self.savelist.ContractorList![indexPath.row].TradeCategoryName as String!
            
            cell.btnProfile!.tag=indexPath.row
            cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
            
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
                cell.lbldate.text = "\(self.savelist.PostList![indexPath.row].DateTimeCaption)-\(self.savelist.PostList![indexPath.row].Location )"
                cell.lblhtml.text = self.savelist.PostList![indexPath.row].Description as String!
                
                let imgURL = self.savelist.PostList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)

                    cell.btnfav.isSelected = true

                return cell
                
            }
                
            else if cvimgcnt == 1{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DashBoardTv1Cell
                cell.lbltitle.text = self.savelist.PostList![indexPath.row].UserFullName as String!
                  cell.lbldate.text = "\(self.savelist.PostList![indexPath.row].DateTimeCaption)-\(self.savelist.PostList![indexPath.row].Location )"
                cell.lblhtml.text = self.savelist.PostList![indexPath.row].Description as String!
                
                let imgURL = self.savelist.PostList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnPortfolio!.tag=indexPath.row
                cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavPostList(btn:)), for: UIControlEvents.touchUpInside)

                    cell.btnfav.isSelected = true
   
                
                let imgURL1 = self.savelist.PostList![indexPath.row].PortfolioImageList[0].PortfolioImageLink as String!
                let url1 = URL(string: imgURL1!)
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: url1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                    cell.setCustomImage(image : image!)
                    if(cell.isReload)
                    {
                        cell.isReload = false
                        tableView.reloadData()
                    }
                })
                
                return cell
                
            }
                
            else if cvimgcnt == 2{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! DashBoardTv2Cell
                cell.lbltitle.text = self.savelist.PostList![indexPath.row].UserFullName as String!
                cell.lbldate.text = "\(self.savelist.PostList![indexPath.row].DateTimeCaption)-\(self.savelist.PostList![indexPath.row].Location )"
                cell.lblhtml.text = self.savelist.PostList![indexPath.row].Description as String!
                
                let imgURL = self.savelist.PostList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnPortfolio!.tag=indexPath.row
                cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                
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
                 cell.lbldate.text = "\(self.savelist.PostList![indexPath.row].DateTimeCaption)-\(self.savelist.PostList![indexPath.row].Location )"
                cell.lblhtml.text = self.savelist.PostList![indexPath.row].Description as String!
                
                let imgURL = self.savelist.PostList![indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
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
                cell.overlayView.isHidden = true
                if(cvimgcnt > 3)
                {
                    cell.overlayView.isHidden = false
                    cell.lblPhotoCount.text = "+\(cvimgcnt - 3)\nView All"
                }
                return cell
            }
        }
        else if strType == 4{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! ProfileFeedCell
            
            cell.lblcity.text = self.savelist.JobList![indexPath.row].CityName as String!
            cell.lblcompany.text = self.savelist.JobList![indexPath.row].Title as String!
            if(self.savelist.JobList![indexPath.row].StartOn as String! != "")
            {
                cell.lblstart.attributedText = DisPlayCountInLabel(strTitle:"Start Date:", value: (self.savelist.JobList![indexPath.row].StartOn))
            }
            if(self.savelist.JobList![indexPath.row].EndOn as String! != "")
            {
                cell.lblfinish.attributedText = DisPlayCountInLabel(strTitle:"Finish Date:", value: (self.savelist.JobList![indexPath.row].EndOn))
            }
            cell.lblexperience.text = self.savelist.JobList![indexPath.row].Description as String!
            cell.lblwork.text = self.savelist.JobList![indexPath.row].TradeCategoryName as String!
            cell.lbldatetime.text = self.savelist.JobList![indexPath.row].DistanceText as String!
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavJobs(btn:)), for: UIControlEvents.touchUpInside)
                cell.btnfav.isSelected = true
            
            cell.btnProfile!.tag=indexPath.row
            cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
            
            //  cell.lbldatetime = self.
            let imgURL = self.savelist.JobList![indexPath.row].ProfileImageLink as String!
            
            let url = URL(string: imgURL!)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            return cell
        }
        else if strType == 5{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! SpecialOfferCell
            
            cell.lblCompanyDescription.text = "\(self.savelist.OfferList![indexPath.row].Description)\n\(self.savelist.OfferList![indexPath.row].RedirectLink)"
            if(self.savelist.OfferList![indexPath.row].RedirectLink != "")
            {
                cell.lblCompanyDescription.tag = indexPath.row
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                cell.lblCompanyDescription.isUserInteractionEnabled = true
                cell.lblCompanyDescription.addGestureRecognizer(tapGestureRecognizer)
            }
            cell.lblWork.text = self.savelist.OfferList![indexPath.row].Title as String!
           cell.lblCompanyName.text = self.savelist.OfferList![indexPath.row].CompanyName
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(SavedView.btnfavSpecialOffer(btn:)), for: UIControlEvents.touchUpInside)
           
            cell.btnProfile!.tag=indexPath.row
            cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
            
            cell.btnfav.isSelected = true
        
            let imgURL = self.savelist.OfferList![indexPath.row].ProfileImageLink as String!
            
            let url = URL(string: imgURL!)
            
            cell.ImgProfilepic.kf.indicatorType = .activity
            cell.ImgProfilepic.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            let imgURL1 = self.savelist.OfferList![indexPath.row].OfferImageLink as String!
            let url1 = URL(string: imgURL1!)
            cell.ImgCompanyPic.kf.indicatorType = .activity
            cell.ImgCompanyPic.kf.setImage(with: url1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                cell.setCustomImage(image : image!)
                if(cell.isReload)
                {
                    cell.isReload = false
                    tableView.reloadData()
                }
            })
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DashBoardTv3Cell

            
            return cell
        }
    }
    func lblNamedTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let lbl = tapGestureRecognizer.view as! UILabel
        if(UIApplication.shared.openURL(URL(string: (self.savelist.OfferList![lbl.tag].RedirectLink))!))
        {
            let openLink = NSURL(string : (self.savelist.OfferList![lbl.tag].RedirectLink))
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: openLink as! URL)
                present(svc, animated: true, completion: nil)
            } else {
                let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                port.strUrl = (self.savelist.OfferList![lbl.tag].RedirectLink)
                self.navigationController?.pushViewController(port, animated: true)
                
            }
        }
        else
        {
            return
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
                
            }
            else if(indexPath.row < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!))
            {
                indexpath = indexPath.row - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!)
                
                let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                obj.contractorId = (self.savelist.PostList?[indexpath].ContractorID)!
                obj.isPortFolio = true
                obj.protfolioId = (self.savelist.PostList?[indexpath].PrimaryID)!
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
            obj.contractorId = (self.savelist.PostList?[indexPath.row].ContractorID)!
            obj.isPortFolio = true
            obj.protfolioId = (self.savelist.PostList?[indexPath.row].PrimaryID)!
            self.navigationController?.pushViewController(obj, animated: true)
        }

        else if strType == 4
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
            vc.jobDetail = self.savelist.JobList![indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if strType == 5
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.isNotification  = true
            vc.OfferId = self.savelist.OfferList![indexPath.row].PrimaryID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func btnProfile (btn : UIButton)
    {
        if strType == 0
        {
            var indexpath:Int = 0
            if(btn.tag < (self.savelist.CompanieList?.count)!)
            {
                indexpath = btn.tag
                
                let obj : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                obj.companyId = (self.savelist.CompanieList?[indexpath].PrimaryID)!
                self.navigationController?.pushViewController(obj, animated: true)
                
            }
            else if(btn.tag < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!))
            {
                indexpath = btn.tag - (self.savelist.CompanieList?.count)!
                
                let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                obj.contractorId = (self.savelist.ContractorList?[indexpath].PrimaryID)!
                obj.isPortFolio = false
                self.navigationController?.pushViewController(obj, animated: true)
                
            }
            else if(btn.tag < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!))
            {
                indexpath = btn.tag - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!)
                
                let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                obj.contractorId = (self.savelist.PostList?[indexpath].ContractorID)!
                obj.isPortFolio = false
                self.navigationController?.pushViewController(obj, animated: true)
            }
            else if(btn.tag < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!))
            {
                indexpath = btn.tag - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
                vc.jobDetail = self.savelist.JobList![indexpath]
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if(btn.tag < ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!)+(self.savelist.OfferList?.count)!)
            {
                indexpath = btn.tag - ((self.savelist.ContractorList?.count)!+(self.savelist.CompanieList?.count)!+(self.savelist.PostList?.count)!+(self.savelist.JobList?.count)!)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
                vc.isNotification  = true
                vc.OfferId = self.savelist.OfferList![indexpath].PrimaryID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if strType == 1
        {
            let obj : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
            obj.companyId = (self.savelist.CompanieList?[btn.tag].PrimaryID)!
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if strType == 2
        {
            let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            obj.contractorId = (self.savelist.ContractorList?[btn.tag].PrimaryID)!
            obj.isPortFolio = false
            self.navigationController?.pushViewController(obj, animated: true)
        }
            
        else if strType == 3
        {
            let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            obj.contractorId = (self.savelist.PostList?[btn.tag].ContractorID)!
            obj.isPortFolio = false
            obj.protfolioId = (self.savelist.PostList?[btn.tag].PrimaryID)!
            self.navigationController?.pushViewController(obj, animated: true)
        }
            
        else if strType == 4
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
            vc.jobDetail = self.savelist.JobList![btn.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if strType == 5
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.isNotification  = true
            vc.OfferId = self.savelist.OfferList![btn.tag].PrimaryID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func btnPortfolio (btn : UIButton)
    {
        let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
        obj.contractorId = (self.savelist.PostList?[btn.tag].ContractorID)!
        obj.isPortFolio = true
        obj.protfolioId = (self.savelist.PostList?[btn.tag].PrimaryID)!
        self.navigationController?.pushViewController(obj, animated: true)
    }
    func onLoadDetail(){
        
       
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.GetSavePageList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            
            guard JSONResponse.rawValue != nil else {
                return;
            }
            
            if  JSONResponse != nil {
                self.savelist = nil
                self.savelist = Mapper<SavedPageList>().map(JSONObject: JSONResponse.rawValue)
            
                            self.stopAnimating()
                
                            print(JSONResponse["status"].rawValue as! String)
                
                            if JSONResponse != nil{
                                self.viewError.isHidden = true
                                self.imgError.isHidden = true
                                self.btnAgain.isHidden = true
                                self.lblError.isHidden = true
                                if JSONResponse["status"].rawString()! == "1"
                                {       // self.vwnolist?.isHidden = true
                
                                    //self.savelist = self.sharedManager.savedPageList
                
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
                                    
                                    _ = self.navigationController?.popViewController(animated: true)
                                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                                    
                                }
                            }
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
    func btnfavSpecialOffer(btn : UIButton)  {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.savelist.OfferList?[btn.tag].PrimaryID,
                     "PageType":"5"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                   self.onLoadDetail()
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
                    self.onLoadDetail()
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
                    self.onLoadDetail()
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
    func btnfavContractore(btn : UIButton)
    {
        
        self.startAnimating()
        
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
                    self.onLoadDetail()
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
                    self.onLoadDetail()
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
