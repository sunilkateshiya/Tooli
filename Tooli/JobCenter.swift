//
//  JobCenter.swift
//  Tooli
//
//  Created by Moin Shirazi on 11/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Popover
import ENSwiftSideMenu
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher

class JobCenter: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable {

    @IBOutlet var tvjobs : UITableView!
    @IBOutlet var btnSortby : UIButton!
    var FilterOption : NSString!
    var sharedManager : Globals = Globals.sharedInstance
    var joblist : [JobCenterM]?
    
    var currentPage = 1
    var isFirstTime : Bool = true
    var refreshControl:UIRefreshControl!
    var popover = Popover()
    var isFull:Bool =  false
    override func viewDidLoad() {
        super.viewDidLoad()

        tvjobs.delegate = self
        tvjobs.dataSource = self
        tvjobs.rowHeight = UITableViewAutomaticDimension
        tvjobs.estimatedRowHeight = 100
        tvjobs.tableFooterView = UIView()
     
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(JobCenter.refreshPage) , for: UIControlEvents.valueChanged)
        tvjobs.addSubview(refreshControl)
        
        FilterOption = "Default"
        //onLoadDetail(withfilter: FilterOption, page: self.currentPage)

        btnSortby.setTitle("Sort by : Default", for: .normal)
    }
    func refreshPage()
    {
        isFirstTime = true
        isFull = false
        currentPage = 1
        onLoadDetail(withfilter: FilterOption, page: currentPage)
    }
    override func viewWillAppear(_ animated: Bool) {
        onLoadDetail(withfilter: FilterOption, page: currentPage)

    }


    func onLoadDetail(withfilter: NSString, page: Int){
        
        if self.isFirstTime {
            self.startAnimating()
        }
        else {
            let view : UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: 80))
            let activity : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            activity.startAnimating()
            view.addSubview(activity)
            self.tvjobs.tableFooterView = view
        }
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PageIndex":page,
                     "FilterOption":FilterOption] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.JobList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.jobList = Mapper<JobList>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            self.refreshControl.endRefreshing()
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    if self.isFirstTime {
                        self.joblist = self.sharedManager.jobList.DataList
                        self.isFirstTime = false;
                    }
                    else {

                        for tmpJobs in self.sharedManager.jobList.DataList! {
                            self.joblist?.append(tmpJobs)
                        }
                    }
                    self.currentPage = self.currentPage + 1
                    self.tvjobs.reloadData()
                    //self.setValues()
                }
                else
                {
                    self.stopAnimating()
                    self.isFirstTime = false;
                    self.isFull = true
                }
                if(self.joblist?.count == 0 && self.isFirstTime)
                {
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
                }
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    
    @IBAction func btnMenu(button: AnyObject)
    {
        toggleSideMenuView()
    }
    

    func popOver() {
        
        
            let width = self.btnSortby.frame.width
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 80))
        
            let Share = UIButton(frame: CGRect(x: 15, y: 0, width: width - 30, height: 40))
            Share.setTitle("Recently Added", for: .normal)
            Share.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
            Share.contentHorizontalAlignment = .left
            Share.setTitleColor(UIColor.darkGray, for: .normal)
        Share.tag = 1
            Share.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        let border = CALayer()
        let width1 = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: Share.frame.size.height - width1, width:  Share.frame.size.width, height: Share.frame.size.height)
        
        border.borderWidth = width1
        Share.layer.addSublayer(border)
        Share.layer.masksToBounds = true
        
            
            let Delete = UIButton(frame: CGRect(x: 15, y: 40, width: width - 30, height: 40))
            Delete.setTitle("Nearest", for: .normal)
            Delete.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
            Delete.setTitleColor(UIColor.darkGray, for: .normal)
            Delete.contentHorizontalAlignment = .left
            Delete.tag = 2
            Delete.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
            aView.addSubview(Delete)
            aView.addSubview(Share)
            
       
        let options = [
            .type(.down),
            .cornerRadius(4)
            ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(aView, fromView:btnSortby)
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func press(button: UIButton) {
      //  Nearest
        if button.tag == 1 {
            FilterOption = "RecentlyAdded"
            btnSortby.setTitle("Sort by : Recently Added", for: .normal)

        }else{
            FilterOption = "Nearest"
            btnSortby.setTitle("Sort by : Nearest", for: .normal)

        }
        onLoadDetail(withfilter: FilterOption, page: currentPage)
        popover.dismiss()

    }
    @IBAction func btnBack(_ sender: Any) {
        
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.moveToDashboard()
    }

    @IBAction func btnSortBy(_ sender: Any) {
        
        popOver()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        guard  ((sharedManager.jobList) != nil) else {
            return 0
        }
        if self.joblist == nil {
            self.joblist = sharedManager.jobList.DataList
        }
        return  (self.joblist?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.row == (joblist?.count)!-1
        {
            if(!isFull)
            {
                self.onLoadDetail(withfilter: FilterOption, page: currentPage)
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileFeedCell
        
        cell.lblcity.text = self.joblist?[indexPath.row].CityName as String!
        cell.lblcompany.text = self.joblist?[indexPath.row].Description as String!
        cell.lblstart.text = self.joblist?[indexPath.row].StartOn as String!
        cell.lblfinish.text = self.joblist?[indexPath.row].EndOn as String!
        cell.lblexperience.text = self.joblist?[indexPath.row].Title as String!
        cell.lblwork.text = self.joblist?[indexPath.row].TradeCategoryName as String!

        cell.btnfav!.tag=indexPath.row
        cell.btnfav?.addTarget(self, action: #selector(JobCenter.btnfav(btn:)), for: UIControlEvents.touchUpInside)
        if self.joblist?[indexPath.row].IsSaved == true {
            cell.btnfav.isSelected = true
        }
        else{
            cell.btnfav.isSelected = false
        }
        let imgURL = self.joblist?[indexPath.row].ProfileImageLink as String!
        let url = URL(string: imgURL!)
        cell.imguser.kf.indicatorType = .activity
        cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func btnfav(btn : UIButton)  {
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.joblist?[btn.tag].PrimaryID ?? "",
                     "PageType":"4"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    
                    if btn.isSelected == true{
                        self.joblist?[btn.tag].IsSaved = false
                      //  self.sharedManager.jobList.DataList?[btn.tag].IsSaved = false
                    }
                    else{
                        self.joblist?[btn.tag].IsSaved = true
                    //    self.sharedManager.jobList.DataList?[btn.tag].IsSaved = true
                    }
                    self.tvjobs.reloadData()
                    
                }
                else
                {
                    
                }
                
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }

}
