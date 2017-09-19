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

class MessageTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate,UISearchBarDelegate,NVActivityIndicatorViewable,RetryButtonDeleget
    
{

    @IBOutlet var tvmsg : UITableView!
    @IBOutlet weak var SearchbarView: UISearchBar!
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var Searchdashlist : [SerachDashBoardM] = []
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tvmsg.delegate = self
        tvmsg.dataSource = self
        tvmsg.rowHeight = UITableViewAutomaticDimension
        tvmsg.estimatedRowHeight = 450
        tvmsg.tableFooterView = UIView()
        SearchbarView.delegate = self
        AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshPage),
            name: NSNotification.Name(rawValue: Constants.Notifications.BUDDYLISTREFRESHED),
            object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(GetBuddyList), for: UIControlEvents.valueChanged)
        tvmsg.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }
    
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        SearchbarView.resignFirstResponder()
        SearchbarView.text = ""
        viewSearch.isHidden = true
    }
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
            cell.textLabel?.text = self.Searchdashlist[indexPath.row].Name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            return cell
        }
        else
        {
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
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    ]
                
                cell.imguser?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                
            }
            return cell
        }
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
