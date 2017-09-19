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

<<<<<<< HEAD
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
    
=======
class NotificationTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable, TTTAttributedLabelDelegate,UISearchBarDelegate {
   
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    @IBOutlet var tvnoti : UITableView!
    var sharedManager : Globals = Globals.sharedInstance
    var currentPage = 1
    var notificationList : GetAllNotificationList = GetAllNotificationList();
    
    var isFull : Bool = false
    var isFirstTime : Bool = true
    var refreshControl:UIRefreshControl!
<<<<<<< HEAD
    var isCallWebService : Bool = true
    var activityIndicator = UIActivityIndicatorView()
    
=======
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    @IBOutlet weak var SearchbarView: UISearchBar!
    
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
<<<<<<< HEAD
    var Searchdashlist : [SerachDashBoardM] = []
=======
    var Searchdashlist : [SerachDashBoardM]?
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    
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
<<<<<<< HEAD
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.startAnimating()
        
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        self.startAnimating()
=======
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        // Do any additional setup after loading the view.
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        var strUpdated:NSString =  searchBar.text! as NSString
        strUpdated = strUpdated.replacingCharacters(in: range, with: text) as NSString
<<<<<<< HEAD
        if(Reachability.isConnectedToNetwork())
        {
            onSerach(str: strUpdated as String)
        }
=======
        onSerach(str: strUpdated as String)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        SearchbarView.text = ""
        SearchbarView.resignFirstResponder()
        viewSearch.isHidden = true
    }
<<<<<<< HEAD
    @IBAction func btnHomeScreenAction(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }

=======
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(searchBar.text == "")
        {
            SearchbarView.resignFirstResponder()
            viewSearch.isHidden = true
        }
<<<<<<< HEAD
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
=======
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        SearchbarView.resignFirstResponder()
        SearchbarView.text = ""
        viewSearch.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotifications(page: self.currentPage);
    }
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    func refreshPage()
    {
        isFirstTime = true
        isFull = false

        currentPage = 1
<<<<<<< HEAD
        getNotifications()
=======
        getNotifications(page : currentPage)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    }
    func onSerach(str:String)
    {
        self.startAnimating()
<<<<<<< HEAD
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
                
=======
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,"SearchQuery":str] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.GetUserSearchByQuery, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.SearchdashBoard = Mapper<SearchContractoreList>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.Searchdashlist = self.sharedManager.SearchdashBoard.DataList
                    if(self.Searchdashlist!.count > 0)
                    {
                        self.viewSearch.isHidden = false
                        self.TBLSearchView.reloadData()
                    }
                    else
                    {
                        self.viewSearch.isHidden = true
                        self.view.makeToast("You have no new notifications.", duration: 3, position: .center)
                    }
                    
                }
                else
                {
                    
                }
                
               
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
            
        }) {
            (error) -> Void in
<<<<<<< HEAD
            
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
=======
            print(error.localizedDescription)
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func getNotifications(page : Int){
    
        if self.isFirstTime {
            self.startAnimating()
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
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
<<<<<<< HEAD
        
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
=======
            

            print(JSONResponse["status"].rawValue as! String)
            self.refreshControl.endRefreshing()
            if JSONResponse != nil {
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    if self.isFirstTime {
                        self.notificationList  = AppNotificationsList();
                        self.notificationList = Mapper<AppNotificationsList>().map(JSONObject: JSONResponse.rawValue)!
                        self.isFirstTime = false;
                    }
                    else {
                        let tmpList : AppNotificationsList = Mapper<AppNotificationsList>().map(JSONObject: JSONResponse.rawValue)!
                        for tmpNotifcation in tmpList.DataList {
                            self.notificationList.DataList.append(tmpNotifcation)
                        }
                    }
                    self.currentPage = self.currentPage + 1
                    self.tvnoti.reloadData()
                    //self.setValues()
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                }
                if(self.notificationList.Result.count == 0)
                {
<<<<<<< HEAD
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
=======
                    self.stopAnimating()
                    self.isFull = true
                    self.isFirstTime = false;
                    //self.currentPage = 1
                    self.view.makeToast("You have no new notifications.", duration: 3, position: .center)
                    //self.tvnoti.reloadData()
                }
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
        }) {
            (error) -> Void in
            self.stopAnimating()
<<<<<<< HEAD
            self.isCallWebService = true
            self.isFull = true
            self.isFirstTime = false;
            self.tvnoti.tableFooterView = UIView()
            self.refreshControl.endRefreshing()
            
           // self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
=======
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
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
<<<<<<< HEAD
            cell.textLabel?.text = self.Searchdashlist[indexPath.row].Name
=======
            cell.textLabel?.text = self.Searchdashlist?[indexPath.row].displayvalue
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            return cell
        }
        else
        {
<<<<<<< HEAD
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
=======
            if indexPath.row == notificationList.DataList.count-1  {
                self.getNotifications(page: currentPage)
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTabCell
            
            let name : String = notificationList.DataList[indexPath.row].FullName;
            
            //let range : NSRange = NSMakeRange(0, name.length)
            //print(range);
            cell.lbltitle.text = notificationList.DataList[indexPath.row].FullName + " " + notificationList.DataList[indexPath.row].NotificationText
            
            cell.lbldate.text = notificationList.DataList[indexPath.row].AddedOn
            
            
            
            
            cell.lbltitle.delegate = self
            
            
            var statusMessage = ""
            
            switch notificationList.DataList[indexPath.row].NotificationStatusID {
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            case 1:
                statusMessage = " sent you new message"
                break;
            case 2:
<<<<<<< HEAD
                statusMessage = " applied to your \(notificationList.Result[indexPath.row].TimeCaption) job"
=======
                statusMessage = " applied to your \(notificationList.DataList[indexPath.row].JobTitle) job"
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                break;
            case 3:
                statusMessage = " started following you"
                break;
            case 4:
<<<<<<< HEAD
                statusMessage = " company has posted new offer"
                
                break;
            case 5:
                statusMessage = " followed you via your share link"
=======
                statusMessage = " followed you via your share link"
                break;
            case 5:
                statusMessage = " company has posted new offer"
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                break;
            default:
                statusMessage = " "
                break;
            }
            
            let finalText = name + statusMessage;
<<<<<<< HEAD
            
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
=======
            
            let string = finalText
            let nsString = string as NSString
            let range = nsString.range(of: name)
            let range1 = nsString.range(of: "message")
            let range3 = nsString.range(of: notificationList.DataList[indexPath.row].JobTitle);
            let range4 = nsString.range(of: "offer");
            let keyID : String = notificationList.DataList[indexPath.row].IsContractor ? ("action://users/" + String(notificationList.DataList[indexPath.row].ContractorID)) : ("action://company/" + String(notificationList.DataList[indexPath.row].CompanyID))
            
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
            let url2 = NSURL(string: "action://message/\(notificationList.DataList[indexPath.row].PrimaryID)")!
            cell.lbltitle.addLink(to: url1 as URL!, with: range)
            cell.lbltitle.addLink(to: url2 as URL!, with: range1)
            cell.lbltitle.addLink(to: url2 as URL!, with: range3)
            cell.lbltitle.addLink(to: url2 as URL!, with: range4)
            
            let url = URL(string: notificationList.DataList[indexPath.row].ProfileImageLink)!
            let resource = ImageResource(downloadURL: url, cacheKey: notificationList.DataList[indexPath.row].ProfileImageLink)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: resource)
            cell.imguser.clipsToBounds = true
            
            return cell
<<<<<<< HEAD
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
=======

>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Check for Message 
        if(tableView == TBLSearchView)
        {
<<<<<<< HEAD
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
=======
            if(self.Searchdashlist?[indexPath.row].IsContractor == false)
            {
                let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                companyVC.companyId = self.Searchdashlist![indexPath.row].PrimaryID
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
            else if(self.Searchdashlist[indexPath.row].Role == 3)
            {
<<<<<<< HEAD
                print("Supplier")
                let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
                companyVC.userId = self.Searchdashlist[indexPath.row].UserID
=======
                let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                companyVC.contractorId = self.Searchdashlist![indexPath.row].PrimaryID
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                self.navigationController?.pushViewController(companyVC, animated: true)
                
            }
            SearchbarView.text = ""
            SearchbarView.resignFirstResponder()
            viewSearch.isHidden = true
<<<<<<< HEAD
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
=======

        }
        else
        {
            if (notificationList.DataList[indexPath.row].NotificationStatusID != 1 && notificationList.DataList[indexPath.row].NotificationStatusID != 2 ) {
                
                if(notificationList.DataList[indexPath.row].IsContractor == false)
                {
                    let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                    companyVC.companyId = notificationList.DataList[indexPath.row].CompanyID
                    self.navigationController?.pushViewController(companyVC, animated: true)
                }
                else
                {
                    let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                    companyVC.contractorId = notificationList.DataList[indexPath.row].ContractorID
                    self.navigationController?.pushViewController(companyVC, animated: true)
                }
            }
            else if (notificationList.DataList[indexPath.row].NotificationStatusID == 1) {
                // Redirect to Message Screen
                
                
                var userId = notificationList.DataList[indexPath.row].PrimaryID
                
                let msgVC : MessageTab = self.storyboard?.instantiateViewController(withIdentifier: "MessageTab") as! MessageTab
                msgVC.selectedSenderId = userId
                msgVC.isNext = true
                self.navigationController?.pushViewController(msgVC, animated: true)
                
            }
            else if (notificationList.DataList[indexPath.row].NotificationStatusID == 2) {
                // Redirect to Job Screen
            }
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
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
