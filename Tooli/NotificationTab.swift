//
//  NotificationTab.swift
//  Tooli
//
//  Created by Moin Shirazi on 10/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.

import UIKit
import ENSwiftSideMenu
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
import Kingfisher
import TTTAttributedLabel

class NotificationTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable, TTTAttributedLabelDelegate,UISearchBarDelegate {
   
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
        getNotifications(page: self.currentPage);
    }
    
    @IBOutlet var tvnoti : UITableView!
    var sharedManager : Globals = Globals.sharedInstance
    var currentPage = 1
    var notificationList : AppNotificationsList = AppNotificationsList();
    var isFull : Bool = false
    var isFirstTime : Bool = true
    var refreshControl:UIRefreshControl!
    @IBOutlet weak var SearchbarView: UISearchBar!
    
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var Searchdashlist : [SerachDashBoardM]?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
         self.startAnimating()
         self.viewError.isHidden = false
        getNotifications(page: self.currentPage);
        
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
        getNotifications(page : currentPage)
    }
    func onSerach(str:String)
    {
        self.startAnimating()
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
                    }
                    
                }
                else
                {
                    
                }
               
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func getNotifications(page : Int){
    
        if self.isFirstTime {
            
        }
        else {
            let view : UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: 80))
            let activity : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            activity.startAnimating()
            view.addSubview(activity)
            self.tvnoti.tableFooterView = view
        }
        var param = [:] as [String : Any]
        param["ContractorID"] = sharedManager.currentUser.ContractorID
       // param["ContractorID"] = "1"
        param["PageIndex"] = page
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.NotificationList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            

            print(JSONResponse["status"].rawValue as! String)
            self.refreshControl.endRefreshing()
            if JSONResponse != nil {
                
                self.viewError.isHidden = true
                self.imgError.isHidden = true
                self.btnAgain.isHidden = true
                self.lblError.isHidden = true
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    if self.isFirstTime {
                        self.notificationList  = AppNotificationsList();
                        self.notificationList = Mapper<AppNotificationsList>().map(JSONObject: JSONResponse.rawValue)!
                        self.isFirstTime = false;
                        
                        self.sharedManager.unreadNotification = 0
                        UIApplication.shared.applicationIconBadgeNumber =  self.sharedManager.unreadSpecialOffer + self.sharedManager.unreadNotification + self.sharedManager.unreadMessage
                         NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
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
                }
                else
                {
                    self.stopAnimating()
                    self.isFull = true
                    self.isFirstTime = false;
                    
                    if(self.notificationList.DataList.count == 0)
                    {
                        self.lblError.text = "No notification available."
                        self.viewError.isHidden = false
                        self.imgError.isHidden = false
                        self.btnAgain.isHidden = false
                        self.lblError.isHidden = false
                    }
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
             
             self.refreshControl.endRefreshing()
            self.viewError.isHidden = false
            self.imgError.isHidden = false
            self.btnAgain.isHidden = false
            self.lblError.isHidden = false
            
           // self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenu(button: AnyObject)
    {
        SearchbarView.resignFirstResponder()
        toggleSideMenuView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        if(tableView == TBLSearchView)
        {
            guard  ((sharedManager.SearchdashBoard) != nil) else {
                
                return 0
            }
            if  (self.Searchdashlist == nil){
                self.Searchdashlist = sharedManager.SearchdashBoard.DataList
                return  (self.Searchdashlist?.count)!;
            }
            return  (self.Searchdashlist?.count)!;
        }
        else
        {
            guard notificationList != nil else {
                return 0
            }
            return  notificationList.DataList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if(tableView == TBLSearchView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = self.Searchdashlist?[indexPath.row].displayvalue
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            return cell
        }
        else
        {
            if indexPath.row == notificationList.DataList.count-1  {
                self.getNotifications(page: currentPage)
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTabCell
            
            let name : String = notificationList.DataList[indexPath.row].FullName;
            
            //let range : NSRange = NSMakeRange(0, name.length)
            //print(range);
            cell.lbltitle.text = notificationList.DataList[indexPath.row].FullName + " " + notificationList.DataList[indexPath.row].NotificationText
            
            cell.lbldate.text = notificationList.DataList[indexPath.row].DateTimeCaption
            cell.lbltitle.delegate = self
        
            var statusMessage = ""
            
            switch notificationList.DataList[indexPath.row].NotificationStatusID {
            case 1:
                statusMessage = " sent you new message"
                break;
            case 2:
                statusMessage = " applied to your \(notificationList.DataList[indexPath.row].JobTitle) job"
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
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: resource)
            cell.imguser.clipsToBounds = true
            
            return cell

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Check for Message 
        if(tableView == TBLSearchView)
        {
            if(self.Searchdashlist?[indexPath.row].IsContractor == false)
            {
                let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
                companyVC.companyId = self.Searchdashlist![indexPath.row].PrimaryID
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
            else
            {
                let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                companyVC.contractorId = self.Searchdashlist![indexPath.row].PrimaryID
                self.navigationController?.pushViewController(companyVC, animated: true)
                
            }
            SearchbarView.text = ""
            SearchbarView.resignFirstResponder()
            viewSearch.isHidden = true

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
        }
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let tblheight = self.notificationList.DataList.count * 80
        
        if scrollView.contentOffset.y > CGFloat(tblheight) {
            self.getNotifications(page: currentPage )
        }
        
        
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print(url)
        if url.absoluteString.contains("action://users/") {
            let userId = url.absoluteString.replacingOccurrences(of: "action://users/", with: "")
            print(userId)
            
            let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            companyVC.contractorId = Int(userId)!
            self.navigationController?.pushViewController(companyVC, animated: true)
            
        }
        else if url.absoluteString.contains("action://company/") {
            let userId = url.absoluteString.replacingOccurrences(of: "action://company/", with: "")
            print(userId)
            let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
            companyVC.companyId = Int(userId)!
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
    }
}
