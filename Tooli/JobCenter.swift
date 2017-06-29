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

class JobCenter: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable,UISearchBarDelegate {

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
       onLoadDetail(withfilter: FilterOption, page: currentPage)  
    }

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
    
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var Searchdashlist : [SerachDashBoardM]?
     @IBOutlet weak var SearchbarView: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchbarView.delegate = self
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
        
        TBLSearchView.delegate = self
        TBLSearchView.dataSource = self
        
        AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)
    }
    func refreshPage()
    {
        isFirstTime = true
        isFull = false
        currentPage = 1
        onLoadDetail(withfilter: FilterOption, page: currentPage)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.startAnimating()
        self.viewError.isHidden = false
        isFirstTime = true
        isFull = false
        currentPage = 1
        
        onLoadDetail(withfilter: FilterOption, page: currentPage)
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Job Center Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func onLoadDetail(withfilter: NSString, page: Int){
        
        if self.isFirstTime {
            
            
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
            self.refreshControl.endRefreshing()
            print(JSONResponse["status"].rawValue as! String)
            self.refreshControl.endRefreshing()
            if JSONResponse != nil{
                self.viewError.isHidden = true
                self.imgError.isHidden = true
                self.btnAgain.isHidden = true
                self.lblError.isHidden = true
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    print(JSONResponse.rawValue)
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
                    if(self.joblist == nil)
                    {
                        self.lblError.text  =  "No Jobs found."
                        self.viewError.isHidden = false
                        self.imgError.isHidden = false
                        self.btnAgain.isHidden = false
                        self.lblError.isHidden = false
                    }
                    
                }
                if(self.joblist?.count == 0 && self.isFirstTime)
                {
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
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
            
         //   self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
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
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        SearchbarView.text = ""
        SearchbarView.resignFirstResponder()
        viewSearch.isHidden = true
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
            btnSortby.setTitle("Sort Jobs by : Recently Added", for: .normal)

        }else{
            FilterOption = "Nearest"
            btnSortby.setTitle("Sort Jobs by : Nearest", for: .normal)

        }
        isFirstTime = true
        isFull = false
        currentPage = 1
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
            guard  ((sharedManager.jobList) != nil) else {
                return 0
            }
            if self.joblist == nil {
                self.joblist = sharedManager.jobList.DataList
            }
            tableView.SetTableViewBlankLable(count: (self.joblist?.count)!, str: "No job found.")
            return  (self.joblist?.count)!;
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
            if indexPath.row == (joblist?.count)!-1
            {
                if(!isFull)
                {
                    self.onLoadDetail(withfilter: FilterOption, page: currentPage)
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileFeedCell
            
            cell.lblcity.text = self.joblist?[indexPath.row].CityName as String!
            cell.lblcompany.text = self.joblist?[indexPath.row].Title as String!
            cell.lbldatetime.text = self.joblist?[indexPath.row].DistanceText as String!
            
            if(self.joblist?[indexPath.row].StartOn as String! != "")
            {
                cell.lblstart.attributedText = DisPlayCountInLabel(strTitle:"Start Date:", value: (self.joblist?[indexPath.row].StartOn)!)
            }
            if(self.joblist?[indexPath.row].EndOn as String! != "")
            {
                cell.lblfinish.attributedText = DisPlayCountInLabel(strTitle:"Finish Date:", value: (self.joblist?[indexPath.row].EndOn)!)
            }
            
            cell.lblexperience.text = self.joblist?[indexPath.row].Description as String!
            cell.lblwork.text = self.joblist?[indexPath.row].TradeCategoryName as String!
            
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(JobCenter.btnfav(btn:)), for: UIControlEvents.touchUpInside)
            if self.joblist?[indexPath.row].IsSaved == true {
                cell.btnfav.isSelected = true
            }
            else{
                cell.btnfav.isSelected = false
            }
            
            cell.lblcompany.tag  = indexPath.row
            let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblImagheProfile(tapGestureRecognizer:)))
            cell.lblcompany.isUserInteractionEnabled = true
            cell.lblcompany.addGestureRecognizer(tapGestureRecognizer1)
            
            cell.imguser.tag = indexPath.row
            let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(lblImagheProfile(tapGestureRecognizer:)))
            cell.imguser.isUserInteractionEnabled = true
            cell.imguser.addGestureRecognizer(tapGestureRecognizer2)
            
            
            let imgURL = self.joblist?[indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell  
        }

    }
    func lblImagheProfile(tapGestureRecognizer:UIGestureRecognizer)
    {
        let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
        companyVC.companyId = (self.joblist?[(tapGestureRecognizer.view?.tag)!].CompanyID)!
        self.navigationController?.pushViewController(companyVC, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            let obj : JodDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
            let joblisttmp : JobListM = JobListM();
            joblisttmp.CityName=(self.joblist?[indexPath.row].CityName)!
            joblisttmp.Description=(self.joblist?[indexPath.row].Description)!
            joblisttmp.EndOn=(self.joblist?[indexPath.row].EndOn)!
            joblisttmp.StartOn=(self.joblist?[indexPath.row].StartOn)!
            joblisttmp.IsApplied=(self.joblist?[indexPath.row].IsApplied)!
            joblisttmp.Location=(self.joblist?[indexPath.row].Location)!
            joblisttmp.PageTypeID=(self.joblist?[indexPath.row].PageTypeID)!
            joblisttmp.PrimaryID=(self.joblist?[indexPath.row].PrimaryID)!
            joblisttmp.CompanyName=(self.joblist?[indexPath.row].CompanyName)!
            joblisttmp.TradeCategoryName=(self.joblist?[indexPath.row].TradeCategoryName)!
            joblisttmp.ProfileImageLink=(self.joblist?[indexPath.row].ProfileImageLink)!
            joblisttmp.ServiceList=(self.joblist?[indexPath.row].ServiceList)!
            obj.jobDetail = joblisttmp
            obj.JobId = (self.joblist?[indexPath.row].PrimaryID)!
            self.navigationController?.pushViewController(obj, animated: true)
        }
       
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
