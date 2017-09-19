//
//  NotificationTab.swift
//  Tooli
//
//  Created by impero on 10/01/17.
//  Copyright © 2017 impero. All rights reserved.

import UIKit
import ENSwiftSideMenu
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
import Kingfisher
import TTTAttributedLabel

class NotificationTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable, TTTAttributedLabelDelegate,UISearchBarDelegate,RetryButtonDeleget {
   
    @IBOutlet weak var btnAgain: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewError: UIView!
    @IBAction func btnAgainErrorAction(_ sender: UIButton)
    {
        self.imgError.isHidden = true
        self.btnAgain.isHidden = true
        self.lblError.isHidden = true
        self.startAnimating()
        getNotifications();
    }
    
    @IBOutlet var tvnoti : UITableView!
    var sharedManager : Globals = Globals.sharedInstance
    var currentPage = 1
    var notificationList : GetAllNotificationList = GetAllNotificationList();
    
    var isFull : Bool = false
    var isFirstTime : Bool = true
    var refreshControl:UIRefreshControl!
    var isCallWebService : Bool = true
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var SearchbarView: UISearchBar!
    
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var Searchdashlist : [SerachDashBoardM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchbarView.delegate = self
        tvnoti.delegate = self
        tvnoti.dataSource = self
        tvnoti.rowHeight = UITableViewAutomaticDimension
        tvnoti.estimatedRowHeight = 450
        tvnoti.tableFooterView = UIView()
        
        TBLSearchView.delegate = self
        TBLSearchView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NotificationTab.refreshPage), for: UIControlEvents.valueChanged)
        tvnoti.addSubview(refreshControl)
        
        AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.startAnimating()
        
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.startAnimating()
        // Do any additional setup after loading the view.
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        var strUpdated:NSString =  searchBar.text! as NSString
        strUpdated = strUpdated.replacingCharacters(in: range, with: text) as NSString
        if(Reachability.isConnectedToNetwork())
        {
            onSerach(str: strUpdated as String)
        }
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        SearchbarView.text = ""
        SearchbarView.resignFirstResponder()
        viewSearch.isHidden = true
    }
    @IBAction func btnHomeScreenAction(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(searchBar.text == "")
        {
            SearchbarView.resignFirstResponder()
            viewSearch.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        SearchbarView.resignFirstResponder()
        SearchbarView.text = ""
        viewSearch.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool)
    {
         self.startAnimating()
        refreshPage()
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Notification Tab Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func refreshPage()
    {
        isFirstTime = true
        isFull = false

        currentPage = 1
        getNotifications()
    }
    func onSerach(str:String)
    {
        self.startAnimating()
        let param = ["QueryText":str] as [String : Any]
        
        AFWrapper.requestPOSTURL(Constants.URLS.AccountSearchUser, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                let temp:SearchContractoreList =  Mapper<SearchContractoreList>().map(JSONObject: JSONResponse.rawValue)!
                self.Searchdashlist = temp.DataList
                if(self.Searchdashlist.count > 0)
                {
                    self.viewSearch.isHidden = false
                    self.TBLSearchView.reloadData()
                }
                else
                {
                    self.viewSearch.isHidden = true
                }
            }
            else
            {
                
            }
            
        }) {
            (error) -> Void in
            
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func getNotifications()
    {
        self.isCallWebService = true
        if(currentPage != 1)
        {
          self.tvnoti.tableFooterView = activityIndicator
        }
        var param = [:] as [String : Any]
        param["PageIndex"] = currentPage
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.NotificationList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
        
            print(JSONResponse["Status"].rawValue)
            self.refreshControl.endRefreshing()
            self.viewError.isHidden = true
            self.imgError.isHidden = true
            self.btnAgain.isHidden = true
            self.lblError.isHidden = true
            self.isCallWebService = false
            self.tvnoti.tableFooterView = UIView()
            if JSONResponse["Status"].int == 1
            {
                self.stopAnimating()
                if self.isFirstTime {
                    self.notificationList  = GetAllNotificationList();
                    self.notificationList = Mapper<GetAllNotificationList>().map(JSONObject: JSONResponse.rawValue)!
                    self.isFirstTime = false;
                    NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
                }
                else
                {
                    let tmpList : GetAllNotificationList = Mapper<GetAllNotificationList>().map(JSONObject: JSONResponse.rawValue)!
                    if(tmpList.Result.count == 0)
                    {
                        self.isFull = true
                        self.isFirstTime = false;
                    }
                    for tmpNotifcation in tmpList.Result
                    {
                        self.notificationList.Result.append(tmpNotifcation)
                    }
                }
                if(self.notificationList.Result.count == 0)
                {
                    let viewBlur:PopupView = PopupView(frame:self.tvnoti.frame)
                    viewBlur.frame = self.tvnoti.frame
                    viewBlur.delegate = self
                    self.view.addSubview(viewBlur)
                    viewBlur.lblTitle.text = "No notification available."
                }
                self.currentPage = self.currentPage + 1
                self.tvnoti.reloadData()
                //self.setValues()
            }
            else
            {
                self.stopAnimating()
                self.isFull = true
                self.isFirstTime = false;
                
                if(self.notificationList.Result.count == 0)
                {
                    let viewBlur:PopupView = PopupView(frame:self.tvnoti.frame)
                    viewBlur.frame = self.tvnoti.frame
                    viewBlur.delegate = self
                    self.view.insertSubview(viewBlur, belowSubview: self.viewSearch)
                    viewBlur.lblTitle.text = JSONResponse["Message"].rawString()!
                }
                else
                {
                    if(self.view.viewWithTag(9898) != nil)
                    {
                        self.view.viewWithTag(9898)?.removeFromSuperview()
                    }
                }
            }
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.isCallWebService = true
            self.isFull = true
            self.isFirstTime = false;
            self.tvnoti.tableFooterView = UIView()
            self.refreshControl.endRefreshing()
            
           // self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func RetrybuttonTaped()
    {
        refreshPage()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenu(button: AnyObject)
    {
        SearchbarView.resignFirstResponder()
        toggleSideMenuView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == TBLSearchView)
        {
            return  self.Searchdashlist.count
        }
        else
        {
            return  notificationList.Result.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if(tableView == TBLSearchView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = self.Searchdashlist[indexPath.row].Name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTabCell
            let name : String = notificationList.Result[indexPath.row].Name;
            cell.lbltitle.text = notificationList.Result[indexPath.row].Name + " " + notificationList.Result[indexPath.row].NotificationText
            
            cell.lbldate.text = notificationList.Result[indexPath.row].TimeCaption
            cell.lbltitle.delegate = self
        
            if(notificationList.Result[indexPath.row].IsRead)
            {
                cell.viewBack.backgroundColor = UIColor.white
            }
            else
            {
                cell.viewBack.backgroundColor = UIColor(red: 255/255.0, green: 111/255.0, blue: 111/255.0, alpha: 0.4)
            }
            
            var statusMessage = ""
            
            switch notificationList.Result[indexPath.row].NotificationStatus
            {
            case 1:
                statusMessage = " sent you new message"
                break;
            case 2:
                statusMessage = " applied to your \(notificationList.Result[indexPath.row].TimeCaption) job"
                break;
            case 3:
                statusMessage = " started following you"
                break;
            case 4:
                statusMessage = " company has posted new offer"
                
                break;
            case 5:
                statusMessage = " followed you via your share link"
                break;
            default:
                statusMessage = " "
                break;
            }
            
            let finalText = name + statusMessage;
            
            let string = finalText
            let nsString = string as NSString
            let range = nsString.range(of: name)
            let range1 = nsString.range(of: "message")
            let range3 = nsString.range(of: notificationList.Result[indexPath.row].NotificationText);
            let range4 = nsString.range(of: "offer");
            var keyID : String = ""
            if(notificationList.Result[indexPath.row].Role == 1)
            {
                keyID = "action://contactor/" + String(notificationList.Result[indexPath.row].UserID)
            }
            else if(notificationList.Result[indexPath.row].Role == 2)
            {
                keyID = "action://company/" + String(notificationList.Result[indexPath.row].UserID)
            }
            else if (notificationList.Result[indexPath.row].Role == 3)
            {
                keyID = "action://supplier/" + String(notificationList.Result[indexPath.row].UserID)
            }

            
            cell.lbltitle.setText(finalText) { (mutableAttributedString) -> NSMutableAttributedString? in
                var boldSystemFont : UIFont = UIFont.boldSystemFont(ofSize: 16)
                if Constants.DeviceType.IS_IPHONE_5 {
                    boldSystemFont=UIFont(name: (boldSystemFont.fontName), size: (boldSystemFont.pointSize)-1)!
                }
                if Constants.DeviceType.IS_IPHONE_6P {
                    boldSystemFont=UIFont(name: (boldSystemFont.fontName), size: (boldSystemFont.pointSize)+4)!
                }
                if Constants.DeviceType.IS_IPAD {
                    boldSystemFont=UIFont(name: (boldSystemFont.fontName), size: (boldSystemFont.pointSize)+7)!
                }
                
                mutableAttributedString?.addAttribute(String(kCTFontAttributeName), value: boldSystemFont, range: range)
                mutableAttributedString?.addAttribute(String(kCTFontAttributeName), value: boldSystemFont, range: range1)
                
                return mutableAttributedString;
            }
            let url1 = NSURL(string: keyID)!
            let url2 = NSURL(string: "action://message/\(notificationList.Result[indexPath.row].TablePrimaryID)")!
            cell.lbltitle.addLink(to: url1 as URL!, with: range)
            cell.lbltitle.addLink(to: url2 as URL!, with: range1)
            cell.lbltitle.addLink(to: url2 as URL!, with: range3)
            cell.lbltitle.addLink(to: url2 as URL!, with: range4)
            
            let url = URL(string: notificationList.Result[indexPath.row].ProfileImageLink)!
            let resource = ImageResource(downloadURL: url, cacheKey: notificationList.Result[indexPath.row].ProfileImageLink)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: resource)
            cell.imguser.clipsToBounds = true
            
            return cell
        }
    }
    
    func OnReadNotification(NotificationID:Int)
    {
        let param = ["NotificationID":notificationList.Result[NotificationID].NotificationID] as [String : Any]
        AFWrapper.requestPOSTURL(Constants.URLS.AccountNotification, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.notificationList.Result[NotificationID].IsRead = true
            self.tvnoti.reloadData()
            AppDelegate.sharedInstance().GetNotificationCount()
        }) {
            (error) -> Void in
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Check for Message 
        if(tableView == TBLSearchView)
        {
            if(self.Searchdashlist[indexPath.row].Role == 0)
            {
                print("Admin")
            }
            else if(self.Searchdashlist[indexPath.row].Role == 1)
            {
                print("Contractor")
                if(self.Searchdashlist[indexPath.row].IsMe)
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContractorProfileView") as! ContractorProfileView
                    vc.userId = self.Searchdashlist[indexPath.row].UserID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                    vc.userId = self.Searchdashlist[indexPath.row].UserID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if(self.Searchdashlist[indexPath.row].Role == 2)
            {
                print("Company")
                let companyVC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
                companyVC.userId = self.Searchdashlist[indexPath.row].UserID
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
            else if(self.Searchdashlist[indexPath.row].Role == 3)
            {
                print("Supplier")
                let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
                companyVC.userId = self.Searchdashlist[indexPath.row].UserID
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
            SearchbarView.text = ""
            SearchbarView.resignFirstResponder()
            viewSearch.isHidden = true
        }
        else
        {
            OnReadNotification(NotificationID: indexPath.row)
             if (notificationList.Result[indexPath.row].NotificationStatus == 1)
            {
                let currentBuddy:BuddyM = BuddyM()
                currentBuddy.ChatUserID = notificationList.Result[indexPath.row].UserID
                currentBuddy.Name = notificationList.Result[indexPath.row].Name
                currentBuddy.IsReadLastMessage = true
                currentBuddy.Role = 1
                currentBuddy.ProfileImageLink = notificationList.Result[indexPath.row].ProfileImageLink
                
                let chatDetail  = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageDetails") as! MessageDetails
                chatDetail.currentBuddy = currentBuddy
                self.navigationController?.pushViewController(chatDetail, animated: true)
                
            }
            else if (notificationList.Result[indexPath.row].NotificationStatus == 2)
            {
                // Redirect to Job Screen
            }
            else if (notificationList.Result[indexPath.row].NotificationStatus == 4)
            {
                let companyVC : OfferDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
                companyVC.OfferId = Int(notificationList.Result[indexPath.row].TablePrimaryID)!
                companyVC.isNotification = true
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
            else if (notificationList.Result[indexPath.row].NotificationStatus != 1 && notificationList.Result[indexPath.row].NotificationStatus != 2 )
             {
                if(notificationList.Result[indexPath.row].Role == 1)
                {
                    let companyVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                    companyVC.userId = notificationList.Result[indexPath.row].UserID
                    self.navigationController?.pushViewController(companyVC, animated: true)
                }
                else if (notificationList.Result[indexPath.row].Role == 2)
                {
                    let companyVC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
                    companyVC.userId = notificationList.Result[indexPath.row].UserID
                    self.navigationController?.pushViewController(companyVC, animated: true)

                }
                else
                {
                    let companyVC = self.storyboard?.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
                    companyVC.userId = notificationList.Result[indexPath.row].UserID
                    self.navigationController?.pushViewController(companyVC, animated: true)
                }
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if !self.isCallWebService
        {
            if(scrollView == self.tvnoti)
            {
                if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height))
                {
                    if(!isFull)
                    {
                        getNotifications()
                    }
                }
            }
        }
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!)
    {
        print(url)
        if url.absoluteString.contains("action://contactor/")
        {
            let userId = url.absoluteString.replacingOccurrences(of: "action://contactor/", with: "")
            print(userId)
            
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
            companyVC.userId = "\(userId)"
            self.navigationController?.pushViewController(companyVC, animated: true)
            
        }
        else if url.absoluteString.contains("action://company/")
        {
            let userId = url.absoluteString.replacingOccurrences(of: "action://company/", with: "")
            print(userId)
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            companyVC.userId = "\(userId)"
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else if url.absoluteString.contains("action://supplier/")
        {
            let userId = url.absoluteString.replacingOccurrences(of: "action://supplier/", with: "")
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
            vc.userId = "\(userId)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
