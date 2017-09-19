//
//  JobCenter.swift
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

class JobCenter: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable,UISearchBarDelegate,RetryButtonDeleget {
    @IBOutlet var tvjobs : UITableView!
    @IBOutlet var btnSortby : UIButton!
    var FilterOption : Int = 0
    var sharedManager : Globals = Globals.sharedInstance
    var joblist : JobListData = JobListData()
    
    var currentPage = 1
    var isFirstTime : Bool = true
    var refreshControl:UIRefreshControl!
    var popover = Popover()
    var isFull:Bool =  false
    
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var Searchdashlist : [SerachDashBoardM] = []
    @IBOutlet weak var SearchbarView: UISearchBar!
    
    override func viewDidLoad()
    {
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
        
        FilterOption = 0
        //onLoadDetail(withfilter: FilterOption, page: self.currentPage)

        btnSortby.setTitle("Sort Jobs by : Default", for: .normal)
        
        TBLSearchView.delegate = self
        TBLSearchView.dataSource = self
        
        AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)
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
                     "Option":FilterOption] as [String : Any]
        
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
                        let viewBlur:PopupView = PopupView(frame:self.tvjobs.frame)
                        viewBlur.frame = self.tvjobs.frame
                        viewBlur.delegate = self
                        self.view.insertSubview(viewBlur, belowSubview: self.viewSearch)
                        viewBlur.lblTitle.text = "No job found."
                    }
                    else
                    {
                        if(self.view.viewWithTag(9898) != nil)
                        {
                            self.view.viewWithTag(9898)?.removeFromSuperview()
                        }
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
                let viewBlur:PopupView = PopupView(frame:self.tvjobs.frame)
                viewBlur.frame = self.tvjobs.frame
                viewBlur.delegate = self
                self.view.insertSubview(viewBlur, belowSubview: self.viewSearch)
                viewBlur.lblTitle.text = JSONResponse["Message"].rawString()!
                
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
    @IBAction func btnMenu(button: AnyObject)
    {
        toggleSideMenuView()
    }
    func popOver()
    {
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
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func press(button: UIButton) {
      //  Nearest
        if button.tag == 1 {
            FilterOption = 1
            btnSortby.setTitle("Sort Jobs by : Recently Added", for: .normal)

        }else{
            FilterOption = 2
            btnSortby.setTitle("Sort Jobs by : Nearest", for: .normal)
        }
        isFirstTime = true
        isFull = false
        currentPage = 1
        onLoadDetail()
        popover.dismiss()

    }
    @IBAction func btnBack(_ sender: Any)
    {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.moveToDashboard()
    }

    @IBAction func btnSortBy(_ sender: Any)
    {
        popOver()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == TBLSearchView)
        {
            return  self.Searchdashlist.count
        }
        else
        {
            return  self.joblist.Result.count;
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JobCell
            cell.likeHeight.constant = 0
            cell.lblCityName.text = self.joblist.Result[indexPath.row].CityName as String!
            cell.lblDis.text = self.joblist.Result[indexPath.row].CompanyName as String!
            cell.lblDateTime.text = self.joblist.Result[indexPath.row].TimeCaption as String!
            cell.lblCompany.text = self.joblist.Result[indexPath.row].JobRoleName as String!
        
            if(self.joblist.Result[indexPath.row].StartDate as String! != "")
            {
                cell.lblStartDate.text = self.joblist.Result[indexPath.row].StartDate
            }
            else
            {
                 cell.Height.constant = 0
            }
            if(self.joblist.Result[indexPath.row].EndDate as String! != "")
            {
                cell.lblFinishDate.text = self.joblist.Result[indexPath.row].EndDate
            }
            else
            {
                 cell.Height.constant = 0
            }
            
            cell.lblTradename.text = self.joblist.Result[indexPath.row].JobTradeName as String!
            cell.btnFav.tag=indexPath.row
            cell.btnFav.addTarget(self, action: #selector(btnSaveAsFavorites(_:)), for: UIControlEvents.touchUpInside)
            if self.joblist.Result[indexPath.row].IsSaved == true {
                cell.btnFav.isSelected = true
                cell.btnSave.isSelected = true
            }
            else{
                cell.btnSave.isSelected = false
                cell.btnFav.isSelected = false
            }
            
            cell.lblCompany.tag  = indexPath.row
            let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblImagheProfile(tapGestureRecognizer:)))
            cell.lblCompany.isUserInteractionEnabled = true
            cell.lblCompany.addGestureRecognizer(tapGestureRecognizer1)
            
            cell.imgUser.tag = indexPath.row
            let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(lblImagheProfile(tapGestureRecognizer:)))
            cell.imgUser.isUserInteractionEnabled = true
            cell.imgUser.addGestureRecognizer(tapGestureRecognizer2)
            
            
            let imgURL = self.joblist.Result[indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imgUser.kf.indicatorType = .activity
            cell.imgUser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
  
            cell.btnProfile.tag = indexPath.row
            cell.btnView.tag = indexPath.row
            cell.btnSave.tag = indexPath.row
            cell.btnLike.tag = indexPath.row
            
            cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
            cell.btnSave.addTarget(self, action: #selector(btnSaveAsFavorites(_:)), for: UIControlEvents.touchUpInside)
            cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
            cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
            
            return cell
        }

    }
    func btnLikeAction(_ sender : UIButton)
    {
       
    }
    func btnProfile(_ sender : UIButton)
    {
        if(self.joblist.Result[sender.tag].Role == 1)
        {
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "ContractorProfileView") as! ContractorProfileView
            companyVC.userId = self.joblist.Result[sender.tag].UserID
            self.navigationController?.pushViewController(companyVC, animated: true)
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
        let vc : JodDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
         vc.jobDetail = self.joblist.Result[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func lblImagheProfile(tapGestureRecognizer:UIGestureRecognizer)
    {
//        let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
//        companyVC.userId = self.joblist.Result[(tapGestureRecognizer.view?.tag)!].UserID
//        self.navigationController?.pushViewController(companyVC, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            let vc : JodDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
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
