//
//  MessageTab.swift
//  Tooli
//
//  Created by impero on 10/01/17.
//  Copyright © 2017 impero. All rights reserved.
//


import UIKit
import ENSwiftSideMenu
import Kingfisher
import NVActivityIndicatorView
import ObjectMapper

<<<<<<< HEAD
class MessageTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate,UISearchBarDelegate,NVActivityIndicatorViewable,RetryButtonDeleget
    
{

    @IBOutlet var tvmsg : UITableView!
    @IBOutlet weak var SearchbarView: UISearchBar!
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var Searchdashlist : [SerachDashBoardM] = []
    var refreshControl:UIRefreshControl!
=======
class MessageTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate,UISearchBarDelegate,NVActivityIndicatorViewable   {

    @IBOutlet var tvmsg : UITableView!
    @IBOutlet weak var SearchbarView: UISearchBar!
    @IBOutlet var noMessageView : UIView!
    let sharedManager : Globals = Globals.sharedInstance
    var selectedSenderId = 0
    var app : AppDelegate!
    var isNext:Bool = false
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var Searchdashlist : [SerachDashBoardM]?
     var refreshControl:UIRefreshControl!
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
<<<<<<< HEAD
=======
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadTable),
            name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED),
            object: nil)
        app = UIApplication.shared.delegate! as! AppDelegate
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        tvmsg.delegate = self
        tvmsg.dataSource = self
        tvmsg.rowHeight = UITableViewAutomaticDimension
        tvmsg.estimatedRowHeight = 450
        tvmsg.tableFooterView = UIView()
<<<<<<< HEAD
        SearchbarView.delegate = self
        AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshPage),
            name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED),
            object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(GetBuddyList), for: UIControlEvents.valueChanged)
=======
        self.noMessageView.isHidden = false;
        if app.buddyList != nil {
            if  app.buddyList.Users.count > 0 {
                self.noMessageView.isHidden = true;
                self.tvmsg.reloadData();
            }
        }
         SearchbarView.delegate = self
         AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)
        
//        if  selectedSenderId != 0  {
//            self.navigateUser()
//            
//        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MessageTab.refreshPage), for: UIControlEvents.valueChanged)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        tvmsg.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }
<<<<<<< HEAD
    
    func refreshPage()
    {
        self.stopAnimating()
        refreshControl.endRefreshing()
        tvmsg.reloadData()
        
        if(AppDelegate.sharedInstance().buddyList.Result.count == 0)
        {
            let viewBlur:PopupView = PopupView(frame:self.tvmsg.frame)
            viewBlur.frame = self.tvmsg.frame
            viewBlur.delegate = self
            self.view.addSubview(viewBlur)
            viewBlur.lblTitle.text = "No Messages available."
        }
        else
        {
            let temp = self.view.viewWithTag(9898)
            if(temp != nil)
            {
                temp?.removeFromSuperview()
            }
=======
    func refreshPage()
    {
        refreshControl.endRefreshing()
        if(app.isActiveChat && app.persistentConnection.state == .connected) {
            app.persistentConnection.send(Command.buddyListCommand())
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        }
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
                    }
                }
                else
                {
                    
                }
                
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
            
        }) {
            (error) -> Void in
<<<<<<< HEAD
            
            self.stopAnimating()
=======
            print(error.localizedDescription)
            self.stopAnimating()
            
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        SearchbarView.resignFirstResponder()
        SearchbarView.text = ""
        viewSearch.isHidden = true
    }
<<<<<<< HEAD
    override func viewWillAppear(_ animated: Bool)
    {
        self.GetBuddyList()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Message Tab Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])

    }
    override func viewWillDisappear(_ animated: Bool)
    {
        
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    func reloadDataOnly()
    {
        self.stopAnimating()
        self.tvmsg.reloadData()
        
        if(AppDelegate.sharedInstance().buddyList.Result.count == 0)
        {
            let viewBlur:PopupView = PopupView(frame:self.tvmsg.frame)
            viewBlur.frame = self.tvmsg.frame
            viewBlur.delegate = self
            self.view.insertSubview(viewBlur, belowSubview: self.viewSearch)
            viewBlur.lblTitle.text = "No Message available."
        }
        else
        {
            if(self.view.viewWithTag(9898) != nil)
            {
                self.view.viewWithTag(9898)?.removeFromSuperview()
            }
        }
    }
    override func didReceiveMemoryWarning()
    {
=======

    func navigateUser(){
        for buddy in self.app.buddyList.Users {
            
            if buddy.ChatUserID == selectedSenderId {
                
                let chatDetail : MessageDetails = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageDetails") as! MessageDetails
                chatDetail.currentBuddy = buddy
                chatDetail.senderId = String(sharedManager.currentUser.UserID)
                app.persistentConnection.send(Command.chatHistoryCommand(friendId: String(buddy.ChatUserID)))
                
                self.navigationController?.pushViewController(chatDetail, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadTable),
            name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED),
            object: nil)
        if(app.isActiveChat && app.persistentConnection.state == .connected) {
            app.persistentConnection.send(Command.buddyListCommand())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)

    }
    
    func reloadTable(){
        refreshPage()
        if app.buddyList != nil {
            if  app.buddyList.Users.count > 0 {
                self.noMessageView.isHidden = true;
                self.tvmsg.reloadData();
                
                if(isNext == true)
                {
                    isNext = false
                    self.navigateUser()
                }
            }
        }
        self.tvmsg.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenu(button: AnyObject)
    {
        SearchbarView.resignFirstResponder()
        toggleSideMenuView()
    }
    
<<<<<<< HEAD
    @IBAction func btnHomeScreenAction(_ sender: UIButton)
    {
       AppDelegate.sharedInstance().moveToDashboard()
=======
    
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
            if app.buddyList == nil {
                return 0
            }
            return  self.app.buddyList.Users.count
        }
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == TBLSearchView)
        {
            return  self.Searchdashlist.count
        }
        else
        {

            return  AppDelegate.sharedInstance().buddyList.Result.count
        }
    }
    func RetrybuttonTaped()
    {
        GetBuddyList()
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
            AppDelegate.sharedInstance().GetNotificationCount()
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTabCell
            cell.lblname.text = AppDelegate.sharedInstance().buddyList.Result[indexPath.row].Name
            cell.lbltime.text = AppDelegate.sharedInstance().buddyList.Result[indexPath.row].LastMessageTimeCaption
            cell.lblmsg.text = AppDelegate.sharedInstance().buddyList.Result[indexPath.row].LastMessageText
            if(AppDelegate.sharedInstance().buddyList.Result[indexPath.row].IsReadLastMessage)
            {
               cell.viewBack.backgroundColor = UIColor.white
            }
            else
            {
                
               cell.viewBack.backgroundColor = UIColor(red: 255/255.0, green: 111/255.0, blue: 111/255.0, alpha: 0.6)
            }
            // Set Image :
            
            if AppDelegate.sharedInstance().buddyList.Result[indexPath.row].ProfileImageLink != "" {
                let imgURL = AppDelegate.sharedInstance().buddyList.Result[indexPath.row].ProfileImageLink as String
                let urlPro = URL(string: imgURL)
                cell.imguser?.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: AppDelegate.sharedInstance().buddyList.Result[indexPath.row].ProfileImageLink)
=======
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTabCell
            cell.lblname.text = self.app.buddyList.Users[indexPath.row].Name
            cell.lbltime.text = self.app.buddyList.Users[indexPath.row].LastOnlineDate
            cell.lblmsg.text = self.app.buddyList.Users[indexPath.row].LastMessageText
            
            // Set Image :
            
            if self.app.buddyList.Users[indexPath.row].ProfileImageLink != "" {
                let imgURL = self.app.buddyList.Users[indexPath.row].ProfileImageLink as String
                let urlPro = URL(string: imgURL)
                cell.imguser?.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.app.buddyList.Users[indexPath.row].ProfileImageLink)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    ]
                
                cell.imguser?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                
            }
<<<<<<< HEAD
            return cell
        }
=======
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.TBLSearchView
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
            let chatDetail : MessageDetails = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageDetails") as! MessageDetails
            chatDetail.currentBuddy = self.app.buddyList.Users[indexPath.row]
            chatDetail.senderId = String(sharedManager.currentUser.UserID)
            app.persistentConnection.send(Command.chatHistoryCommand(friendId: String(self.app.buddyList.Users[indexPath.row].ChatUserID)))
            
            self.navigationController?.pushViewController(chatDetail, animated: true)
        }
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.TBLSearchView
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
            let chatDetail : MessageDetails = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageDetails") as! MessageDetails
            chatDetail.currentBuddy = AppDelegate.sharedInstance().buddyList.Result[indexPath.row]
            self.navigationController?.pushViewController(chatDetail, animated: true)
        }
    }
    func GetBuddyList()
    {
        do
        {
            try AppDelegate.sharedInstance().simpleHub.invoke("GetBuddyList", arguments: [])
        }
        catch
        {
            print(error)
        }
    }
}
