//
//  companyView.swift
//  TooliDemo
//
//  Created by Azharhussain on 22/08/17.
//  Copyright © 2017 Impero IT. All rights reserved.
//

import UIKit
import Popover
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher
import SafariServices
import SKPhotoBrowser

class SupplierView: UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate,
NVActivityIndicatorViewable,SKPhotoBrowserDelegate
{
    
    @IBOutlet var nodataView:UIView!
    
     //--------------------------------------
     // MARK: - Global Declaration
     //--------------------------------------
     var ObjCompanyProfileModel : CompanyProfileModel = CompanyProfileModel()
     var Btnisselected : Bool = false
     var userId:String = ""
     //--------------------------------------
     // MARK: - Dynamic NSLayoutConstraint
     //--------------------------------------
     
     @IBOutlet weak var ConstraintsTradeHeight: NSLayoutConstraint!
     @IBOutlet weak var ConstraintsSkillHeight: NSLayoutConstraint!
     @IBOutlet weak var AboutUsheight: NSLayoutConstraint!
     @IBOutlet weak var SpecialOfferHeight: NSLayoutConstraint!

     //--------------------------------------
     // MARK: - UIScrollView
     //--------------------------------------
     @IBOutlet weak var ObjScrollView: UIScrollView!
     
     //--------------------------------------
     // MARK: - UITableView
     //--------------------------------------
     @IBOutlet weak var tblTrades: UITableView!
     @IBOutlet weak var tblSkill: UITableView!
     @IBOutlet weak var tblSpecialOffer: UITableView!
    
        @IBOutlet weak var ImgAvailableProfile : UIImageView!
     //--------------------------------------
     // MARK: - UILabelOutlets
     //--------------------------------------
     @IBOutlet weak var lblCompanyName: UILabel!
     @IBOutlet weak var lblTradeName: UILabel!
     @IBOutlet weak var lblCityName: UILabel!
     @IBOutlet weak var lblAboutCompanyName: UILabel!
     @IBOutlet weak var lblCompanyDescription: UILabel!
     @IBOutlet weak var lblWebsite: UILabel!
     @IBOutlet weak var lblTel: UILabel!
     @IBOutlet weak var lblMob: UILabel!
     @IBOutlet weak var lblEmail: UILabel!
     
     //--------------------------------------
     // MARK: - UIViewOutlets
     //--------------------------------------
     @IBOutlet weak var viewAboutUs: UIView!
     @IBOutlet weak var imgProfilePic: UIImageView!

     //--------------------------------------
     // MARK: - UIButton
     //--------------------------------------
     @IBOutlet weak var btnFollowing: UIButton!
     @IBOutlet weak var btnFav: UIButton!
     @IBOutlet weak var btnAbout: UIButton!
     @IBOutlet weak var btnSpecialOffer: UIButton!
     
     //--------------------------------------
     // MARK: - viewDidLoad
     //--------------------------------------
     override func viewDidLoad()
     {
          super.viewDidLoad()
        ImgAvailableProfile.isHidden = true
          self.ObjScrollView.delegate = self
          self.tblTrades.separatorStyle = .none
          self.tblSkill.separatorStyle = .none
          self.tblSkill.tableFooterView = UIView()
          self.tblTrades.tableFooterView = UIView()
          self.tblSpecialOffer.separatorStyle = .none
          self.tblSpecialOffer.rowHeight = UITableViewAutomaticDimension
          self.tblSpecialOffer.estimatedRowHeight = 450
          self.tblSpecialOffer.tableFooterView = UIView()
     }
     
     //--------------------------------------
     // MARK: - viewWillAppear
     //--------------------------------------
     override func viewWillAppear(_ animated: Bool)
     {
          CompanyViewApi()
     }
    @IBAction func btnBack(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func homePage(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    
     override func didReceiveMemoryWarning()
     {
          super.didReceiveMemoryWarning()
     }
     
     //--------------------------------------
     // MARK: - btnUserFollowingTapped
     //--------------------------------------


     //--------------------------------------
     // MARK: - btnMessageTapped
     //--------------------------------------
     @IBAction func btnMessageTapped(_ sender: UIButton)
     {
        
     }
    
     
     //--------------------------------------
     // MARK: - btnAboutTapped
     //--------------------------------------
     @IBAction func btnAboutTapped(_ sender: Any)
     {
            self.nodataView.isHidden = true
        
          self.btnAbout.isSelected = true
          self.btnSpecialOffer.isSelected = false
          self.viewAboutUs.isHidden = false
          self.tblSpecialOffer.isHidden = true
          self.AboutUsheight.constant = 1200
          self.SpecialOfferHeight.constant = 1200
          setLayout()
     }
     
     //--------------------------------------
     // MARK: - btnSpecialOffersTapped
     //--------------------------------------
     @IBAction func btnSpecialOffersTapped(_ sender: UIButton)
     {
          self.btnSpecialOffer.isSelected = true
          self.btnAbout.isSelected = false
          self.viewAboutUs.isHidden = true
          self.tblSpecialOffer.isHidden = false
          self.AboutUsheight.constant = self.tblSpecialOffer.contentSize.height
          self.SpecialOfferHeight.constant = self.tblSpecialOffer.contentSize.height
          setLayout()
        
        if(self.ObjCompanyProfileModel.Result.OfferList.count == 0)
        {
            self.nodataView.isHidden = false
        }
        else
        {
            self.nodataView.isHidden = true
        }
        
     }
     
     //--------------------------------------
     // MARK: - UITableViewDataSource
     //--------------------------------------
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if tableView == tblTrades
          {
               return self.ObjCompanyProfileModel.Result.TradeNameList.count
          }
          else if tableView == tblSkill
          {
               return self.ObjCompanyProfileModel.Result.ServiceNameList.count
          }
          else
          {
               return self.ObjCompanyProfileModel.Result.OfferList.count
          }
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
          if tableView == tblTrades {
               let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! SelctionCell
               cell.lblName.text = self.ObjCompanyProfileModel.Result.TradeNameList[indexPath.row]
               cell.selectionStyle = .none
               return cell
          }
          else if tableView == tblSkill
          {
               let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! SelctionCell
               cell.lblName.text = self.ObjCompanyProfileModel.Result.ServiceNameList[indexPath.row]
               cell.selectionStyle = .none
               return cell
          }
          else
          {
               let cell = tableView.dequeueReusableCell(withIdentifier: "CompanySpecialOfferCell", for: indexPath) as! CompanySpecialOfferCell
                cell.likeHeight.constant = 0
               if self.ObjCompanyProfileModel.Result.OfferList[indexPath.row].ProfileImageLink != ""
               {
                    let imgURL = self.ObjCompanyProfileModel.Result.OfferList[indexPath.row].ProfileImageLink as String
                    let urlPro = URL(string: imgURL)
                    cell.imgUser?.kf.indicatorType = .activity
                    let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.ObjCompanyProfileModel.Result.OfferList[indexPath.row].ProfileImageLink + "Main")
                    let optionInfo: KingfisherOptionsInfo = [
                         .downloadPriority(0.5),
                         .transition(ImageTransition.fade(1)),
                         
                         ]
                    cell.imgUser?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
               }
               if self.ObjCompanyProfileModel.Result.OfferList[indexPath.row].ImageLink != ""
               {
                    let imgURL = self.ObjCompanyProfileModel.Result.OfferList[indexPath.row].ImageLink as String
                    let urlPro = URL(string: imgURL)
                    cell.img1?.kf.indicatorType = .activity
                    let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.ObjCompanyProfileModel.Result.OfferList[indexPath.row].ImageLink + "Main")
                    let optionInfo: KingfisherOptionsInfo = [
                         .downloadPriority(0.5),
                         .transition(ImageTransition.fade(1)),
                         
                         ]
                    
                cell.img1.kf.setImage(with: tmpResouce, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                    if(image != nil)
                    {
                        cell.setCustomImage(image : image!)
                    }
                })
               }
               cell.lblTitle.text = self.ObjCompanyProfileModel.Result.OfferList[indexPath.row].Title
               cell.lblDis.text = self.ObjCompanyProfileModel.Result.OfferList[indexPath.row].Description
               cell.lblDate.text = self.ObjCompanyProfileModel.Result.OfferList[indexPath.row].TimeCaption
            
            cell.btnSave.tag = indexPath.row
            cell.btnSave.addTarget(self, action: #selector(btnfavSpecialOffer(_:)), for: UIControlEvents.touchUpInside)
            
            cell.btnProfile.tag = indexPath.row
            cell.btnProfile.addTarget(self, action: #selector(btnProfileAction(_:)), for: UIControlEvents.touchUpInside)
            
            cell.btnLike.tag = indexPath.row
            
            cell.btnView.tag = indexPath.row
            cell.btnView.addTarget(self, action: #selector(OpenOfferDetailPage(_:)), for: UIControlEvents.touchUpInside)
            
               return cell
          }
     }

    func btnfavSpecialOffer(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":"\(self.ObjCompanyProfileModel.Result.OfferList[sender.tag].OfferID)",
            "PageType":2] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                if(sender.isSelected)
                {
                    self.ObjCompanyProfileModel.Result.OfferList[sender.tag].IsSaved = false
                }
                else
                {
                    self.ObjCompanyProfileModel.Result.OfferList[sender.tag].IsSaved = true
                }
                self.tblSpecialOffer.reloadData()
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
    func btnProfileAction(_ sender:UIButton)
    {
        
    }
    func OpenOfferDetailPage(_ sender:UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
        vc.OfferDetail = self.ObjCompanyProfileModel.Result.OfferList[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func OpenJobDetailPage(_ sender:UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
        vc.jobDetail = self.ObjCompanyProfileModel.Result.JobList[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
     //--------------------------------------
     // MARK: - CompanyViewApi
     //--------------------------------------
     func CompanyViewApi()
     {
            self.nodataView.isHidden = true
          self.startAnimating()
          let param = ["UserID":userId] as [String : Any]
          
          AFWrapper.requestPOSTURL(Constants.URLS.CompanyProfileView, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
               (JSONResponse) -> Void in
               self.stopAnimating()
               self.ObjCompanyProfileModel = Mapper<CompanyProfileModel>().map(JSONObject: JSONResponse.rawValue)!
               if JSONResponse["Status"].int == 1
               {
                    self.setTableHeight()
                    self.setCompanyData()
                    self.setAboutUsData()
                    self.tblSpecialOffer.reloadData()
                    self.tblSkill.reloadData()
                    self.tblTrades.reloadData()
                
                    self.btnAboutTapped(self)
               }
               else
               {
                    self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
               }
          })
          {
               (error) -> Void in
               self.stopAnimating()
               self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
          }
     }
     
     //--------------------------------------
     // MARK: - setCompanyData
     //--------------------------------------
     func setCompanyData()
     {
          self.lblCompanyName.text = self.ObjCompanyProfileModel.Result.CompanyName
          self.lblTradeName.text = self.ObjCompanyProfileModel.Result.TradeName
          self.lblCityName.text = self.ObjCompanyProfileModel.Result.CityName
          if self.ObjCompanyProfileModel.Result.ProfileImageLink != ""
          {
               let imgURL = self.ObjCompanyProfileModel.Result.ProfileImageLink as String
               let urlPro = URL(string: imgURL)
               self.imgProfilePic?.kf.indicatorType = .activity
               let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.ObjCompanyProfileModel.Result.ProfileImageLink + "Main")
               let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    ]
               imgProfilePic?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
          }
          if self.ObjCompanyProfileModel.Result.IsSaved
          {
               self.btnFav.isSelected = true
          }
          else
          {
               self.btnFav.isSelected = false
          }
        if self.ObjCompanyProfileModel.Result.IsFollow
        {
            self.btnFollowing.setTitle("FOLLOWING", for: .normal)
            self.btnFollowing.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1/255.0, alpha: 1)
        }
        else
        {
            self.btnFollowing.setTitle("FOLLOW", for: .normal)
            self.btnFollowing.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
        }
     }
     
     //--------------------------------------
     // MARK: - setAboutUsData
     //--------------------------------------
     func setAboutUsData()
     {
          self.lblAboutCompanyName.text = "About " + self.ObjCompanyProfileModel.Result.CompanyName
          self.lblCompanyDescription.text = self.ObjCompanyProfileModel.Result.Description
          if self.ObjCompanyProfileModel.Result.IsEmailPublic
          {
               self.lblEmail.setUnderLineToLabel(strText: self.ObjCompanyProfileModel.Result.CompanyEmailID)
            let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(lblEmailTaped(tapGestureRecognizer:)))
            lblEmail.isUserInteractionEnabled = true
            lblEmail.addGestureRecognizer(tapGestureRecognizer2)
            
          }
          else
          {
               self.lblEmail.text = "xxxxxxxxxxxxx"
          }
          if self.ObjCompanyProfileModel.Result.IsPhonePublic
          {
               self.lblTel.setUnderLineToLabel(strText: self.ObjCompanyProfileModel.Result.PhoneNumber)
            let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblTelTaped(tapGestureRecognizer:)))
            lblTel.isUserInteractionEnabled = true
            lblTel.addGestureRecognizer(tapGestureRecognizer1)
          }
          else
          {
               self.lblTel.text = "xxxxxxxxxxxxx"
               
          }
          if self.ObjCompanyProfileModel.Result.IsMobilePublic
          {
               self.lblMob.setUnderLineToLabel(strText: self.ObjCompanyProfileModel.Result.MobileNumber)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblModTaped(tapGestureRecognizer:)))
            lblMob.isUserInteractionEnabled = true
            lblMob.addGestureRecognizer(tapGestureRecognizer)
            
          }
          else
          {
               self.lblMob.text = "xxxxxxxxxxxxx"
          }
          self.lblWebsite.setUnderLineToLabel(strText: self.ObjCompanyProfileModel.Result.Website)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblWebsiteTaped(tapGestureRecognizer:)))
        lblWebsite.isUserInteractionEnabled = true
        lblWebsite.addGestureRecognizer(tapGestureRecognizer)
    
     }
    func lblWebsiteTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        if(lblWebsite.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "\( lblWebsite.text!)")!))
            {
                UIApplication.shared.openURL(URL(string: "\(lblWebsite.text!)")!)
            }
            else
            {
                self.view.makeToast("Website url not valid.", duration: 3, position: .bottom)
            }
        }
    }
    func lblModTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        if(lblMob.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblMob.text!))")!))
            {
                UIApplication.shared.openURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblMob.text!))")!)
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
        if(lblTel.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblTel.text!))")!))
            {
                UIApplication.shared.openURL(URL(string: "tel://\(removeSpecialCharsFromString(text: lblTel.text!))")!)
            }
            else
            {
                self.view.makeToast("Number not valid.", duration: 3, position: .bottom)
            }
        }
    }
    func lblEmailTaped(tapGestureRecognizer:UIGestureRecognizer)
    {
        if(lblEmail.text! != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "mailto://\(lblEmail.text!)")!))
            {
                UIApplication.shared.openURL(URL(string: "mailto://\(lblEmail.text!)")!)
            }
            else
            {
                self.view.makeToast("Email not valid.", duration: 3, position: .bottom)
            }
        }
    }
     //--------------------------------------
     // MARK: - setTableHeight
     //--------------------------------------
     func setTableHeight()
     {
          if self.ObjCompanyProfileModel.Result.TradeNameList.count > 5
          {
               self.ConstraintsTradeHeight.constant = 0
               self.ConstraintsTradeHeight.constant = CGFloat(5 * 35) + 44
               self.tblTrades.isScrollEnabled = true
          }
          else
          {
            self.ConstraintsTradeHeight.constant = 0
            if(self.ObjCompanyProfileModel.Result.TradeNameList.count == 0)
            {
            
            }
            else
            {
                self.ConstraintsTradeHeight.constant = CGFloat(self.ObjCompanyProfileModel.Result.TradeNameList.count * 35) + 44
                self.tblTrades.isScrollEnabled = false
            }
            
          }
          if self.ObjCompanyProfileModel.Result.ServiceNameList.count > 5
          {
               self.ConstraintsSkillHeight.constant = 0
               self.ConstraintsSkillHeight.constant = CGFloat(5 * 35) + 44
               self.tblSkill.isScrollEnabled = true
          }
          else
          {
               self.ConstraintsSkillHeight.constant = 0
            if(self.ObjCompanyProfileModel.Result.ServiceNameList.count == 0)
            {
            
            }
            else
            {
                self.ConstraintsSkillHeight.constant = CGFloat(self.ObjCompanyProfileModel.Result.ServiceNameList.count * 35) + 44
                self.tblSkill.isScrollEnabled = false
            }
          }
     }
     
     //--------------------------------------
     // MARK: - scrollViewDidScroll
     //--------------------------------------
     func scrollViewDidScroll(_ scrollView: UIScrollView)
     {
          setLayout()
     }
     func setLayout()
     {
          DispatchQueue.main.async {
               if self.btnAbout.isSelected
               {
                    self.ObjScrollView.contentSize.height = self.tblSpecialOffer.frame.origin.y + self.tblSkill.frame.origin.y + self.tblSkill.frame.height + 28
               }
               else
               {
                    self.ObjScrollView.contentSize.height =
                         self.tblSpecialOffer.frame.origin.y +  self.tblSpecialOffer.contentSize.height + 28
               }
          }
     }
    @IBAction func btnUserFollowingTapped(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["FollowingUserID":userId] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.AccountFollowToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                if self.btnFollowing.titleLabel!.text == "FOLLOW"
                {
                    self.btnFollowing.setTitle("FOLLOWING", for: .normal)
                    self.btnFollowing.backgroundColor = UIColor(red: 192.0/255.0, green: 129.0/255.0, blue: 1/255.0, alpha: 1)
                }
                else
                {
                    self.btnFollowing.setTitle("FOLLOW", for: .normal)
                    self.btnFollowing.backgroundColor = UIColor(red: 236.0/255.0, green: 169.0/255.0, blue: 8.0/255.0, alpha: 1)
                }
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
    @IBAction func btnFavTapped(_ sender : UIButton)
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
}
