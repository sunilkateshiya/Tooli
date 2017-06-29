//
//  MessageTab.swift
//  Tooli
//
//  Created by Moin Shirazi on 10/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//


import UIKit
import ENSwiftSideMenu
import Kingfisher
import NVActivityIndicatorView
import ObjectMapper

class MessageTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate,UISearchBarDelegate,NVActivityIndicatorViewable   {

    @IBOutlet weak var btnAgain: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewError: UIView!
    @IBAction func btnAgainErrorAction(_ sender: UIButton)
    {
        self.imgError.isHidden = true
        self.btnAgain.isHidden = true
        self.lblError.isHidden = true
        if(app.isActiveChat || app.persistentConnection.state == .connected) {
            app.persistentConnection.send(Command.buddyListCommand())
        }
    }

    
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadDataOnly),
            name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED),
            object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(refreshPage), name: NSNotification.Name(rawValue: Constants.Notifications.MESSAGERECEIVED), object: nil)
        
        app = UIApplication.shared.delegate! as! AppDelegate
        tvmsg.delegate = self
        tvmsg.dataSource = self
        tvmsg.rowHeight = UITableViewAutomaticDimension
        tvmsg.estimatedRowHeight = 450
        tvmsg.tableFooterView = UIView()
        self.noMessageView.isHidden = true;
        if app.buddyList != nil {
            if  app.buddyList.Users.count > 0 {
                self.noMessageView.isHidden = true;
                self.tvmsg.reloadData();
            }
        }
         SearchbarView.delegate = self
         AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage), for: UIControlEvents.valueChanged)
        tvmsg.addSubview(refreshControl)
       
        // Do any additional setup after loading the view.
    }
    func refreshPage()
    {
        refreshControl.endRefreshing()
        if(app.isActiveChat || app.persistentConnection.state == .connected) {
            app.persistentConnection.send(Command.buddyListCommand())
        }
        else
        {
            app.initSignalR()
        }
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
            
         //   self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        SearchbarView.resignFirstResponder()
        SearchbarView.text = ""
        viewSearch.isHidden = true
    }

    func navigateUser(){
        self.stopAnimating()
        for buddy in self.app.buddyList.Users {
            
            if buddy.ChatUserID == selectedSenderId {
                
                let chatDetail : MessageDetails = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageDetails") as! MessageDetails
                chatDetail.currentBuddy = buddy
                
                chatDetail.senderId = String(sharedManager.currentUser.UserID)
                self.navigationController?.pushViewController(chatDetail, animated: false)
            }
        }
    }
    func StopLoading()
    {
       self.viewError.isHidden = false
        self.imgError.isHidden = false
        self.btnAgain.isHidden = false
        self.lblError.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.startAnimating()
        if(AppDelegate.sharedInstance().currentHistory != nil)
        {
            AppDelegate.sharedInstance().currentHistory.DataList = []
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(StopLoading),
            name: NSNotification.Name(rawValue: "networkConnection"),
            object: nil)
        UIApplication.shared.applicationIconBadgeNumber =  self.sharedManager.unreadSpecialOffer + self.sharedManager.unreadNotification + self.sharedManager.unreadMessage
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadDataOnly),
            name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED),
            object: nil)
        if(app.isActiveChat || app.persistentConnection.state == .connected) {
            app.persistentConnection.send(Command.buddyListCommand())
        }
        else
        {
            app.initSignalR()
        }
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Message Tab Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func reloadDataOnly()
    {
        self.imgError.isHidden = true
        self.btnAgain.isHidden = true
        self.lblError.isHidden = true
        self.viewError.isHidden = true
        
        self.stopAnimating()
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
        if app.buddyList != nil {
            if  app.buddyList.Users.count > 0 {
                self.noMessageView.isHidden = true;
                self.tvmsg.reloadData();
                
                if(isNext == true)
                {
                    isNext = false
                    DispatchQueue.main.async {
                        self.navigateUser()
                    }
                }
            }
            else
            {
                 self.noMessageView.isHidden = false;
            }
        }
        self.tvmsg.reloadData()
    }
    func reloadTable(){
        self.stopAnimating()
        refreshPage()
        reloadDataOnly()
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
    
    @IBAction func btnHomeScreenAction(_ sender: UIButton)
    {
       AppDelegate.sharedInstance().moveToDashboard()
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
            if app.buddyList == nil {
                return 0
            }
            return  self.app.buddyList.Users.count
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTabCell
            cell.lblname.text = self.app.buddyList.Users[indexPath.row].Name
            cell.lbltime.text = self.app.buddyList.Users[indexPath.row].LastMessageOn
            cell.lblmsg.text = self.app.buddyList.Users[indexPath.row].LastMessageText
            if(self.app.buddyList.Users[indexPath.row].IsReadLastMsg)
            {
               cell.viewBack.backgroundColor = UIColor.white
            }
            else
            {
                
               cell.viewBack.backgroundColor = UIColor(red: 255/255.0, green: 111/255.0, blue: 111/255.0, alpha: 0.6)
            }
            // Set Image :
            
            if self.app.buddyList.Users[indexPath.row].ProfileImageLink != "" {
                let imgURL = self.app.buddyList.Users[indexPath.row].ProfileImageLink as String
                let urlPro = URL(string: imgURL)
                cell.imguser?.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.app.buddyList.Users[indexPath.row].ProfileImageLink)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    ]
                
                cell.imguser?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                
            }
            
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
            self.navigationController?.pushViewController(chatDetail, animated: true)
        }
    }
}
