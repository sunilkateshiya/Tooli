//
//  JobListVC.swift
//  Tooli
//
//  Created by impero on 11/01/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import Popover
import ENSwiftSideMenu
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher

class JobListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable,RetryButtonDeleget {
    @IBOutlet var tvjobs : UITableView!
    
    var sharedManager : Globals = Globals.sharedInstance
    var joblist : JobListData = JobListData()
    
    var userid:String = ""
    var username:String = ""
    
    var currentPage = 1
    var isFirstTime : Bool = true
    var refreshControl:UIRefreshControl!
    var popover = Popover()
    var isFull:Bool =  false

    @IBOutlet var lblTitle:UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tvjobs.delegate = self
        tvjobs.dataSource = self
        tvjobs.rowHeight = UITableViewAutomaticDimension
        tvjobs.estimatedRowHeight = 100
        tvjobs.tableFooterView = UIView()
     
        lblTitle.text = "\(username) Jobs"
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage) , for: UIControlEvents.valueChanged)
        tvjobs.addSubview(refreshControl)
    }
    func refreshPage()
    {
        isFirstTime = true
        isFull = false
        currentPage = 1
        onLoadDetail()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.startAnimating()
        isFirstTime = true
        isFull = false
        currentPage = 1
        
        onLoadDetail()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Job Center Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func onLoadDetail()
    {
        if self.isFirstTime
        {
            
        }
        else
        {
            let view : UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: 80))
            let activity : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            activity.startAnimating()
            view.addSubview(activity)
            self.tvjobs.tableFooterView = view
        }
        let param = ["PageIndex":currentPage,
                     "Option":1] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.JobList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in

            self.stopAnimating()
            self.refreshControl.endRefreshing()
            print(JSONResponse["Status"].rawValue)
            self.refreshControl.endRefreshing()
            
            if JSONResponse["Status"].int == 1
            {
                print(JSONResponse.rawValue)
                self.stopAnimating()
                if self.isFirstTime
                {
                   self.joblist = Mapper<JobListData>().map(JSONObject: JSONResponse.rawValue)!
                    if(self.joblist.Result.count == 0)
                    {
                         AppDelegate.sharedInstance().addNoDataView(view: self.view, frame: self.tvjobs.frame, viewController: self, strMsg:"No job found.")
                    }
                    else
                    {
                       AppDelegate.sharedInstance().removeNoDataView()
                    }
                   self.isFirstTime = false;
                }
                else
                {
                    let temp = Mapper<JobListData>().map(JSONObject: JSONResponse.rawValue)!
                    for tmpJobs in temp.Result
                    {
                        self.joblist.Result.append(tmpJobs)
                    }
                }
                self.currentPage = self.currentPage + 1
                self.tvjobs.reloadData()
            }
            else
            {
                AppDelegate.sharedInstance().addNoDataView(view: self.view, frame: self.tvjobs.frame, viewController: self, strMsg:"No job found.")
                
                self.stopAnimating()
                self.isFirstTime = false;
                self.isFull = true
            }
            
        }) {
            (error) -> Void in
            
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            
         //   self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func RetrybuttonTaped()
    {
        refreshPage()
    }
    @IBAction func btnMenu(button: AnyObject)
    {
        toggleSideMenuView()
    }
        override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
       self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  self.joblist.Result.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewJobCell", for: indexPath) as! NewJobCell
        
        cell.lblJobRole.text = self.joblist.Result[indexPath.row].JobRoleName
        cell.lblDis.text = self.joblist.Result[indexPath.row].CompanyName as String!
        cell.lblTradename.text = self.joblist.Result[indexPath.row].JobTradeName
    
        cell.btnFav.tag=indexPath.row
        cell.btnFav.addTarget(self, action: #selector(btnSaveAsFavorites(_:)), for: UIControlEvents.touchUpInside)
        if self.joblist.Result[indexPath.row].IsSaved == true {
            cell.btnFav.isSelected = true
        }
        else{
            cell.btnFav.isSelected = false
        }
        let imgURL = self.joblist.Result[indexPath.row].ProfileImageLink as String!
        let url = URL(string: imgURL!)
        cell.imgUser.kf.indicatorType = .activity
        cell.imgUser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        cell.btnProfile.tag = indexPath.row
        cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
        
        return cell


    }
    func btnLikeAction(_ sender : UIButton)
    {
       
    }
    func btnProfile(_ sender : UIButton)
    {
        if(self.joblist.Result[sender.tag].Role == 1)
        {
            if(self.joblist.Result[sender.tag].IsMe == true)
            {
                let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "ContractorProfileView") as! ContractorProfileView
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
            else
            {
                let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                companyVC.userId = self.joblist.Result[sender.tag].UserID
                self.navigationController?.pushViewController(companyVC, animated: true)
            }
        }
        else
        {
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            companyVC.userId = self.joblist.Result[sender.tag].UserID
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
    }
    func btnViewAction(_ sender : UIButton)
    {
        if(self.joblist.Result[sender.tag].IsMe == true)
        {
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "MyJodDetailViewController") as! MyJodDetailViewController
            vc.JobId = self.joblist.Result[sender.tag].JobID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "NewOtherJodDetailViewController") as! NewOtherJodDetailViewController
            vc.jobDetail = self.joblist.Result[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(self.joblist.Result[indexPath.row].IsMe == true)
        {
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "MyJodDetailViewController") as! MyJodDetailViewController
            vc.JobId = self.joblist.Result[indexPath.row].JobID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewOtherJodDetailViewController") as! NewOtherJodDetailViewController
            vc.jobDetail = self.joblist.Result[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func btnSaveAsFavorites(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":"\(self.joblist.Result[sender.tag].JobID)",
            "PageType":4] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                if sender.isSelected == true
                {
                    self.joblist.Result[sender.tag].IsSaved = false
                }
                else{
                    self.joblist.Result[sender.tag].IsSaved = true
                }
                self.tvjobs.reloadData()
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
}
