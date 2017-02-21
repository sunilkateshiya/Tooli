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

    @IBOutlet var tvmsg : UITableView!
    @IBOutlet weak var SearchbarView: UISearchBar!
    @IBOutlet var noMessageView : UIView!
    let sharedManager : Globals = Globals.sharedInstance
    var selectedSenderId = 0
    var app : AppDelegate!

    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var Searchdashlist : [SerachDashBoardM]?
     var refreshControl:UIRefreshControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadTable),
            name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED),
            object: nil)
        app = UIApplication.shared.delegate! as! AppDelegate
        tvmsg.delegate = self
        tvmsg.dataSource = self
        tvmsg.rowHeight = UITableViewAutomaticDimension
        tvmsg.estimatedRowHeight = 450
        tvmsg.tableFooterView = UIView()
        self.noMessageView.isHidden = false;
        if app.buddyList != nil {
            if  app.buddyList.Users.count > 0 {
                self.noMessageView.isHidden = true;
                self.tvmsg.reloadData();
            }
        }
         SearchbarView.delegate = self
         AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)
        
        if  selectedSenderId != 0  {
            self.navigateUser()
            
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MessageTab.refreshPage), for: UIControlEvents.valueChanged)
        tvmsg.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }
    func refreshPage()
    {
        refreshControl.endRefreshing()
        if(app.isActiveChat && app.persistentConnection.state == .connected) {
            app.persistentConnection.send(Command.buddyListCommand())
        }
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        var strUpdated:NSString =  searchBar.text! as NSString
        strUpdated = strUpdated.replacingCharacters(in: range, with: text) as NSString
        onSerach(str: strUpdated as String)
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
                
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        SearchbarView.resignFirstResponder()
        SearchbarView.text = ""
        viewSearch.isHidden = true
    }

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
        if app.buddyList != nil {
            if  app.buddyList.Users.count > 0 {
                self.noMessageView.isHidden = true;
                self.tvmsg.reloadData();
                
//                if  selectedSenderId != 0  {
//                    self.navigateUser()
//                    
//                }
            }
        }
        self.tvmsg.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenu(button: AnyObject)
    {
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
            cell.lbltime.text = self.app.buddyList.Users[indexPath.row].LastOnlineDate
            cell.lblmsg.text = self.app.buddyList.Users[indexPath.row].LastMessageText
            
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
            app.persistentConnection.send(Command.chatHistoryCommand(friendId: String(self.app.buddyList.Users[indexPath.row].ChatUserID)))
            
            self.navigationController?.pushViewController(chatDetail, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
