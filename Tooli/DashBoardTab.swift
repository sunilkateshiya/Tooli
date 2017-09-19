//
//  DashBoardTab.swift
//  Tooli
//
//  Created by impero on 10/01/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher

<<<<<<< HEAD
class DashBoardTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable,UISearchBarDelegate,UITextViewDelegate, UIScrollViewDelegate
=======
class DashBoardTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable,UISearchBarDelegate,UITextViewDelegate
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
{
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnAgain: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    
    @IBOutlet weak var lblNoList: UILabel!
    @IBAction func btnAgainErrorAction(_ sender: UIButton)
    {
        self.imgError.isHidden = true
        self.btnAgain.isHidden = true
        self.lblError.isHidden = true
         onLoadDetail()
    }
    @IBOutlet weak var SearchbarView: UISearchBar!
    @IBOutlet var tvdashb : UITableView!
<<<<<<< HEAD

    var AllDashBoradData:DashBoradAllData = DashBoradAllData()
    
    var contractorList : SuggestionUserList?
=======
    var sharedManager : Globals = Globals.sharedInstance
    var dashlist : [DashBoardM]? = []
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    @IBOutlet var vwnolist : UIView?
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var refreshControl:UIRefreshControl!
<<<<<<< HEAD
    var Searchdashlist : [SerachDashBoardM] = []
    var placeholderLabel:UILabel!
    @IBOutlet var txtabout : UITextView!
    @IBOutlet weak var ivimage: UIImageView!
    var isFull : Bool = false
    var isFirstTime : Bool = true
    var isCallWebService : Bool = true

    var currentPage = 1
    var activityIndicator = UIActivityIndicatorView()
=======
    var Searchdashlist : [SerachDashBoardM]?
    var placeholderLabel:UILabel!
    @IBOutlet var txtabout : UITextView!
    
    var isFull : Bool = false
    var isFirstTime : Bool = true
    var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.object(forKey: Constants.KEYS.ISINITSIGNALR) != nil)
        {
            if(UserDefaults.standard.object(forKey: Constants.KEYS.ISINITSIGNALR) as! Bool == false)
            {
                self.dashlist = []
                UserDefaults.standard.set(true, forKey: Constants.KEYS.ISINITSIGNALR)
                UserDefaults.standard.set(true, forKey: Constants.KEYS.LOGINKEY)
                AppDelegate.sharedInstance().initSignalR();
            }
        }
        txtabout.delegate = self
        SearchbarView.delegate = self
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    
    fileprivate let formatter1: DateFormatter = {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd/MM/yyyy"
        return formatter1
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        txtabout.delegate = self
        SearchbarView.delegate = self
        
        tvdashb.delegate = self
        tvdashb.dataSource = self
        tvdashb.rowHeight = UITableViewAutomaticDimension
        tvdashb.estimatedRowHeight = 100
        tvdashb.tableFooterView = UIView()
        self.vwnolist?.isHidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(DashBoardTab.refreshPage), for: UIControlEvents.valueChanged)
        tvdashb.addSubview(refreshControl)
<<<<<<< HEAD
        AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)

       // onLoadDetail()
       // self.startAnimating()
        self.viewError.isHidden = false
=======
        
        AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)

        onLoadDetail(index: "\(currentPage)")
        
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(DashBoardTab.tapTableView(_:)))
        tvdashb.addGestureRecognizer(tapGesture)
<<<<<<< HEAD
    
        placeholderLabel = UILabel()
        placeholderLabel.text = "What are you working on today?"
        placeholderLabel.numberOfLines = 0
        //     placeholderLabel.font = UIFont(name: "BabasNeue", size: 106)
        placeholderLabel.font = UIFont.systemFont(ofSize: (txtabout.font?.pointSize)!)
         placeholderLabel.frame = CGRect(x: 5, y: (txtabout.font?.pointSize)! / 2, width: txtabout.frame.size.width-10, height: 20)
        placeholderLabel.sizeToFit()
        txtabout.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtabout.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtabout.text.isEmpty
    
        SetImageInpostView()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.startAnimating()
        
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
=======
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "What are you working on today?"
        //     placeholderLabel.font = UIFont(name: "BabasNeue", size: 106)
        placeholderLabel.font = UIFont.systemFont(ofSize: (txtabout.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtabout.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtabout.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtabout.text.isEmpty

        // Do any additional setup after loading the view.
    }
<<<<<<< HEAD
    func SetImageInpostView()
    {
        if(AppDelegate.sharedInstance().sharedManager.currentUser.ProfileImageLink !=  "")
        {
             placeholderLabel.text = "\(AppDelegate.sharedInstance().sharedManager.currentUser.Name), What are you working on today?"
             placeholderLabel.frame = CGRect(x: 5, y: (txtabout.font?.pointSize)! / 2, width: txtabout.frame.size.width-10, height: 20)
            
             placeholderLabel.sizeToFit()
            let imgURL = AppDelegate.sharedInstance().sharedManager.currentUser.ProfileImageLink as String
            let urlPro = URL(string: imgURL)
            ivimage?.kf.indicatorType = .activity
            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: AppDelegate.sharedInstance().sharedManager.currentUser.ProfileImageLink)
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1))
            ]
            ivimage?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
            ivimage?.clipsToBounds = true
        }
        
    }
    func tapTableView(_ sender:UITapGestureRecognizer)
    {
        SearchbarView.resignFirstResponder()
        txtabout.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = false
        self.sideMenuController()?.sideMenu?.allowPanGesture = true
        self.sideMenuController()?.sideMenu?.allowRightSwipe = true

        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "DashBorad Data Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        self.startAnimating()
        self.refreshPage()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
         //getSuggetionList()
=======
    func tapTableView(_ sender:UITapGestureRecognizer)
    {
        SearchbarView.resignFirstResponder()
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    }
    @IBAction func btnSendTodayPostAction(_ sender: UIButton)
    {
        if(txtabout.text != "")
        {
            AddStatus()
        }
        else
        {
<<<<<<< HEAD
            self.view.makeToast("Please enter status.", duration: 3, position: .center)
=======
         self.view.makeToast("Status can not be empty.", duration: 3, position: .center)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        }
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
<<<<<<< HEAD
=======
       
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func refreshPage()
    {
<<<<<<< HEAD
        isFull = false
        isFirstTime = true
        currentPage = 1
        onLoadDetail()
    }
    func textViewDidChange(_ textView: UITextView)
    {
=======
        isFirstTime = true
        currentPage = 1
        onLoadDetail(index: "\(currentPage)")
    }
    func textViewDidChange(_ textView: UITextView) {
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        placeholderLabel.isHidden = !textView.text.isEmpty
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
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let tblheight = self.tvdashb.contentSize.height-50
        
        if scrollView.contentOffset.y > CGFloat(tblheight) {
          // onLoadDetail(index: "\(currentPage)")
        }
        
        
    }

    func onSerach(str:String)
    {
        self.startAnimating()
        let param = ["QueryText":str] as [String : Any]
        
        AFWrapper.requestPOSTURL(Constants.URLS.AccountSearchUser, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
<<<<<<< HEAD
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                let temp:SearchContractoreList =  Mapper<SearchContractoreList>().map(JSONObject: JSONResponse.rawValue)!
                self.Searchdashlist = temp.DataList
                self.TBLSearchView.reloadData()
                if(self.Searchdashlist.count > 0)
                {
                    self.viewSearch.isHidden = false
                    
                }
                else
                {
                    self.viewSearch.isHidden = true
=======
           
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
                    
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                }
            }
            else
            {
                
<<<<<<< HEAD
=======
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
            
        }) {
            (error) -> Void in
            
<<<<<<< HEAD
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func onLoadDetail()
    {
        if(currentPage != 1)
        {
            self.tvdashb.tableFooterView = activityIndicator
        }
        let param = ["PageIndex":currentPage] as [String : Any]
=======
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func onLoadDetail(index:String){
        
        if(isFirstTime)
        {
            self.startAnimating()
        }
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,"PageIndex":index] as [String : Any]
        
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.Dashboard, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
<<<<<<< HEAD
            self.refreshControl.endRefreshing()
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            
            self.viewError.isHidden = true
            self.imgError.isHidden = true
            self.btnAgain.isHidden = true
            self.lblError.isHidden = true
            self.lblNoList.isHidden = true
           
            if JSONResponse["Status"].int == 1
            {
                self.tvdashb.tableFooterView = UIView()
                if(self.isFirstTime)
                {
                    self.isFirstTime = false
                    self.AllDashBoradData = Mapper<DashBoradAllData>().map(JSONObject: JSONResponse.rawValue)!
                    
                    AppDelegate.sharedInstance().sharedManager.currentUser = self.AllDashBoradData.Result.UserData
                    let serializedUser1 = Mapper().toJSON(AppDelegate.sharedInstance().sharedManager.currentUser)
                    print(serializedUser1)
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(serializedUser1, forKey: Constants.KEYS.USERINFO)
                    userDefaults.synchronize()
                    self.SetImageInpostView()
                    
                    if(self.AllDashBoradData.Result.DashboardList.count == 0)
                    {
                        self.isFull = true
                        self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3.0, position: .center)
                        self.lblNoList.isHidden = false
                    }
                    self.tvdashb.tableFooterView = UIView()
                }
                else
                {
                    let tmpList : DashBoradAllData = Mapper<DashBoradAllData>().map(JSONObject: JSONResponse.rawValue)!
                    if(tmpList.Result.DashboardList.count == 0)
                    {
                        self.isFull = true
                    }
                    for tmpDashborad in tmpList.Result.DashboardList
                    {
                        self.AllDashBoradData.Result.DashboardList.append(tmpDashborad)
                    }
                }
                self.tvdashb.reloadData()
                self.currentPage = self.currentPage + 1
                self.vwnolist?.isHidden = true
                self.isCallWebService = false
            }
            else
            {
                self.tvdashb.tableFooterView = UIView()
                self.vwnolist?.isHidden = true
                self.AllDashBoradData = Mapper<DashBoradAllData>().map(JSONObject: JSONResponse.rawValue)!
                self.tvdashb.reloadData()
                if(self.isFirstTime)
                {
                    
                }
                
                self.lblNoList.text =  JSONResponse["Message"].rawString()!
                self.isFull = true
                self.isFirstTime = false
                self.isCallWebService = false
            }
            
            if(AppDelegate.sharedInstance().hubConnection != nil)
            {
                if( AppDelegate.sharedInstance().hubConnection.state != .connected)
                {
                    AppDelegate.sharedInstance().hubConnection.start()
                }
                else
                {
                    print("Already connected.")
                }
            }
            else
            {
                AppDelegate.sharedInstance().initSignalR()
=======
           
            
            self.stopAnimating()
             self.refreshControl.endRefreshing()
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    if(self.isFirstTime)
                    {
                        self.isFirstTime = false
                        self.sharedManager.dashBoard = Mapper<ContractorDashBoard>().map(JSONObject: JSONResponse.rawValue)
                        self.dashlist = self.sharedManager.dashBoard.DataList
                    }
                    else
                    {
                        let tmpList : ContractorDashBoard = Mapper<ContractorDashBoard>().map(JSONObject: JSONResponse.rawValue)!
                        for tmpDashborad in tmpList.DataList! {
                            self.dashlist?.append(tmpDashborad)
                        }
                    }
                    self.currentPage = self.currentPage + 1
                    self.vwnolist?.isHidden = true
                    self.tvdashb.reloadData()
                   }
                else
                {
                    if(self.isFirstTime)
                    {
                         self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
                    }
                    if(self.dashlist?.count == 0)
                    {
                           self.vwnolist?.isHidden = false
                    }
                    self.isFull = true
                    self.isFirstTime = false
                }
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
            
        }) {
            (error) -> Void in
            self.tvdashb.tableFooterView = UIView()
            self.stopAnimating()
<<<<<<< HEAD
            self.refreshControl.endRefreshing()
            self.viewError.isHidden = false
            self.imgError.isHidden = false
            self.btnAgain.isHidden = false
            self.lblError.isHidden = false
            self.isCallWebService = false
=======

            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if self.isCallWebService == false
        {
            if(scrollView == self.tvdashb)
            {
                if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height))
                {
                    if(!isFull)
                    {
                        self.isCallWebService = true
                        onLoadDetail()
                    }
                }
            }
        }
        
    }
    func setHeightBasedOnWidht(sourceImage: UIImage, scaledToWidth i_width: Float) -> UIImage
    {
        let oldWidth: Float = Float(sourceImage.size.width)
        let scaleFactor: Float = i_width / oldWidth
        let newHeight: Float = Float(sourceImage.size.height) * scaleFactor
        let newWidth: Float = oldWidth * scaleFactor
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        SearchbarView.resignFirstResponder()
        SearchbarView.text = ""
        viewSearch.isHidden = true
    }
    func UserImageTaped(_ sender:UIButton)
    {
        OpenDetailPage(index: sender.tag)
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if(tableView == TBLSearchView)
        {
            return 1
        }
        else
        {
           return 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == TBLSearchView)
        {
            return  self.Searchdashlist.count;
        }
        else
        {
            if(section == 0)
            {
                return 1
            }
            else
            {
                 return self.AllDashBoradData.Result.DashboardList.count
            }
        }
    }
    
    @IBAction func btnMenu(button: AnyObject)
    {
        SearchbarView.resignFirstResponder()
        txtabout.resignFirstResponder()
        
        toggleSideMenuView()
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
    }
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
<<<<<<< HEAD
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            if(tableView == TBLSearchView)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = self.Searchdashlist[indexPath.row].Name
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                return cell
            }
            else
            {
                if(indexPath.section == 0)
                { 
                    if(self.AllDashBoradData.Result.UserSuggestionList.count > 0)
                    {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "suggetion", for: indexPath) as! SuggestionViewCell
                        cell.viewcontroller = self
                        cell.collection.dataSource = cell
                        cell.collection.delegate = cell
                        cell.collection.reloadData()
                        return cell
                    }
                    else
                    {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell", for: indexPath)
                        return UITableViewCell()
                    }
                }
                else
                {
                    if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PageType == 2)
                    {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardSpecialOffer", for: indexPath) as! DashBoardSpecialOffer
                        cell.likeHeight.constant = 0
                        cell.lblTitle.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].OfferView.CompanyName
                        cell.lblDate.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].OfferView.Title + " - " + self.AllDashBoradData.Result.DashboardList[indexPath.row].OfferView.PriceTag
                        
                        cell.lblDis.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].OfferView.Description
                        cell.btnFav.tag = indexPath.row
                        cell.btnProfile.tag = indexPath.row
                        cell.btnView.tag = indexPath.row
                        cell.btnSave.tag = indexPath.row
                        cell.btnLike.tag = indexPath.row
                        
                        if(self.AllDashBoradData.Result.DashboardList[indexPath.row].OfferView.IsSaved == true)
                        {
                            cell.btnFav.isSelected = true
                            cell.btnSave.isSelected = true
                        }
                        else
                        {
                            cell.btnFav.isSelected = false
                            cell.btnSave.isSelected = false
                        }
                        
                        cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                        
                        cell.lblTitle.tag = indexPath.row
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                        cell.lblTitle.isUserInteractionEnabled = true
                        cell.lblTitle.addGestureRecognizer(tapGestureRecognizer)
                        
                        
                        let imgURL = (self.AllDashBoradData.Result.DashboardList[indexPath.row].OfferView.ProfileImageLink)
                        let urlPro = URL(string: imgURL)
                        cell.imgUser.kf.indicatorType = .activity
                        let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                        let optionInfo: KingfisherOptionsInfo = [
                            .downloadPriority(0.5),
                            .transition(ImageTransition.fade(1))
                        ]
                        cell.imgUser.kf.indicatorType = .activity
                        cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                        
                        
                        let imgURLImg1 = (self.AllDashBoradData.Result.DashboardList[indexPath.row].OfferView.ImageLink)
                        let urlProImg1 = URL(string: imgURLImg1)
                        cell.imgUser.kf.indicatorType = .activity
                        let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                        let optionInfoImg1: KingfisherOptionsInfo = [
                            .downloadPriority(0.5),
                            .transition(ImageTransition.fade(1))
                        ]
                        cell.img1.kf.indicatorType = .activity
                        
                        cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                            if(image != nil)
                            {
                                cell.setCustomImage(image : image!)
                            }
                        })
                        return cell
                    }
                    else if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PageType == 3)
                    {
                        if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList.count == 0)
                        {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardTextCell", for: indexPath) as! DashBoardTextCell
                            cell.likeHeight.constant = 0
                            cell.lblTitle.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Name + " - " + self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TradeName
                            cell.lblDis.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Description
                            cell.lblDate.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TitleCaption + "\n" + self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Location + self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TimeCaption
                            
                            cell.lblTitle.tag = indexPath.row
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                            cell.lblTitle.isUserInteractionEnabled = true
                            cell.lblTitle.addGestureRecognizer(tapGestureRecognizer)
                            
                            cell.btnFav.tag = indexPath.row
                            cell.btnProfile.tag = indexPath.row
                            cell.btnSave.tag = indexPath.row
                            cell.btnLike.tag = indexPath.row
                            if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.IsSaved == true)
                            {
                            cell.btnFav.isSelected = true
                            cell.btnSave.isSelected = true
                        }
                        else
                        {
                            cell.btnFav.isSelected = false
                            cell.btnSave.isSelected = false
                        }
                            
                            cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                            
                            let imgURL = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.ProfileImageLink)
                            let urlPro = URL(string: imgURL)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                            let optionInfo: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.imgUser.kf.indicatorType = .activity
                            cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                            
                            return cell
                        }
                        else if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList.count == 1)
                        {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard01Cell", for: indexPath) as! DashBoard01Cell
                            cell.lblTitle.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Name + " - " + self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TradeName
                            cell.likeHeight.constant = 0
                            cell.lblDate.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TimeCaption
                            cell.lblDis.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Description
                            cell.btnFav.tag = indexPath.row
                            cell.btnProfile.tag = indexPath.row
                            cell.btnView.tag = indexPath.row
                            cell.btnSave.tag = indexPath.row
                            cell.btnLike.tag = indexPath.row
                             cell.btnPortfolio.tag = indexPath.row
                            if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.IsSaved == true)
                            {
                                cell.btnFav.isSelected = true
                                cell.btnSave.isSelected = true
                            }
                            else
                            {
                                cell.btnFav.isSelected = false
                                cell.btnSave.isSelected = false
                            }
                            
                            cell.lblTitle.tag = indexPath.row
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                            cell.lblTitle.isUserInteractionEnabled = true
                            cell.lblTitle.addGestureRecognizer(tapGestureRecognizer)
                            
                            cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnPortfolio.addTarget(self, action: #selector(btnPortfolio(_:)), for: UIControlEvents.touchUpInside)
                            
                            let imgURL = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.ProfileImageLink)
                            let urlPro = URL(string: imgURL)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                            let optionInfo: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.imgUser.kf.indicatorType = .activity
                            cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                            
                            
                            let imgURLImg1 = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                            let urlProImg1 = URL(string: imgURLImg1)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                            let optionInfoImg1: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.img1.kf.indicatorType = .activity
                            cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
                            
                            cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                                if(image != nil)
                                {
                                     cell.setCustomImage(image : image!)
                                }
                            })

                            
                            return cell
                        }
                        else if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList.count == 2)
                        {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard02Cell", for: indexPath) as! DashBoard02Cell
                            cell.likeHeight.constant = 0
                            cell.lblTitle.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Name + " - " + self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TradeName
                            cell.lblDate.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TimeCaption
                            cell.lblDis.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Description
                            cell.btnFav.tag = indexPath.row
                            cell.btnProfile.tag = indexPath.row
                            cell.btnView.tag = indexPath.row
                            cell.btnSave.tag = indexPath.row
                            cell.btnLike.tag = indexPath.row
                             cell.btnPortfolio.tag = indexPath.row
                            if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.IsSaved == true)
                            {
                            cell.btnFav.isSelected = true
                            cell.btnSave.isSelected = true
                        }
                        else
                        {
                            cell.btnFav.isSelected = false
                            cell.btnSave.isSelected = false
                        }
                            
                            cell.lblTitle.tag = indexPath.row
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                            cell.lblTitle.isUserInteractionEnabled = true
                            cell.lblTitle.addGestureRecognizer(tapGestureRecognizer)
                            
                            cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnPortfolio.addTarget(self, action: #selector(btnPortfolio(_:)), for: UIControlEvents.touchUpInside)
                            
                            let imgURL = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.ProfileImageLink)
                            let urlPro = URL(string: imgURL)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                            let optionInfo: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.imgUser.kf.indicatorType = .activity
                            cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                            
                            let imgURLImg1 = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                            let urlProImg1 = URL(string: imgURLImg1)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                            let optionInfoImg1: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.img1.kf.indicatorType = .activity
                            cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
                            
                            let imgURLImg2 = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList[1].ImageLink)
                            let urlProImg2 = URL(string: imgURLImg2)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouceImg2 = ImageResource(downloadURL: urlProImg2!, cacheKey: imgURLImg2)
                            let optionInfoImg2: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.img2.kf.indicatorType = .activity
                            cell.img2.kf.setImage(with: tmpResouceImg2, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg2, progressBlock: nil, completionHandler: nil)
                            
                            return cell
                        }
                        else if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList.count == 3)
                        {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard03Cell", for: indexPath) as! DashBoard03Cell
                            cell.likeHeight.constant = 0
                            cell.lblTitle.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Name + " - " + self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TradeName
                            cell.lblDate.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TimeCaption
                            cell.lblDis.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Description
                            
                            cell.btnFav.tag = indexPath.row
                            cell.btnProfile.tag = indexPath.row
                            cell.btnView.tag = indexPath.row
                            cell.btnSave.tag = indexPath.row
                            cell.btnLike.tag = indexPath.row
                             cell.btnPortfolio.tag = indexPath.row
                            if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.IsSaved == true)
                            {
                            cell.btnFav.isSelected = true
                            cell.btnSave.isSelected = true
                        }
                        else
                        {
                            cell.btnFav.isSelected = false
                            cell.btnSave.isSelected = false
                        }
                            
                            cell.lblTitle.tag = indexPath.row
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                            cell.lblTitle.isUserInteractionEnabled = true
                            cell.lblTitle.addGestureRecognizer(tapGestureRecognizer)
                            
                            cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                            
                            let imgURL = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.ProfileImageLink)
                            let urlPro = URL(string: imgURL)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                            let optionInfo: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.imgUser.kf.indicatorType = .activity
                            cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                            
                            let imgURLImg1 = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                            let urlProImg1 = URL(string: imgURLImg1)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                            let optionInfoImg1: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.img1.kf.indicatorType = .activity
                            cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
                            
                            let imgURLImg2 = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList[1].ImageLink)
                            let urlProImg2 = URL(string: imgURLImg2)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouceImg2 = ImageResource(downloadURL: urlProImg2!, cacheKey: imgURLImg2)
                            let optionInfoImg2: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.img2.kf.indicatorType = .activity
                            cell.img2.kf.setImage(with: tmpResouceImg2, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg2, progressBlock: nil, completionHandler: nil)
                            
                            let imgURLImg3 = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList[2].ImageLink)
                            let urlProImg3 = URL(string: imgURLImg3)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouceImg3 = ImageResource(downloadURL: urlProImg3!, cacheKey: imgURLImg3)
                            let optionInfoImg3: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.img3.kf.indicatorType = .activity
                            cell.img3.kf.setImage(with: tmpResouceImg3, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg3, progressBlock: nil, completionHandler: nil)
                            
                            cell.overlayView.isHidden = true
                            
                            return cell
                        }
                        else
                        {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard03Cell", for: indexPath) as! DashBoard03Cell
                            cell.likeHeight.constant = 0
                            cell.lblTitle.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Name + " - " + self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TradeName
                            cell.lblDate.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.TimeCaption
                            cell.lblDis.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.Description
                            
                            cell.btnFav.tag = indexPath.row
                            cell.btnProfile.tag = indexPath.row
                            cell.btnView.tag = indexPath.row
                            cell.btnSave.tag = indexPath.row
                            cell.btnLike.tag = indexPath.row
                            cell.btnPortfolio.tag = indexPath.row
                            if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.IsSaved == true)
                            {
                            cell.btnFav.isSelected = true
                            cell.btnSave.isSelected = true
                        }
                        else
                        {
                            cell.btnFav.isSelected = false
                            cell.btnSave.isSelected = false
                        }
                            
                            cell.lblTitle.tag = indexPath.row
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                            cell.lblTitle.isUserInteractionEnabled = true
                            cell.lblTitle.addGestureRecognizer(tapGestureRecognizer)
                            
                            cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                            cell.btnPortfolio.addTarget(self, action: #selector(btnPortfolio(_:)), for: UIControlEvents.touchUpInside)
                            
                            let imgURL = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.ProfileImageLink)
                            let urlPro = URL(string: imgURL)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                            let optionInfo: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.imgUser.kf.indicatorType = .activity
                            cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                            
                            let imgURLImg1 = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList[0].ImageLink)
                            let urlProImg1 = URL(string: imgURLImg1)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouceImg1 = ImageResource(downloadURL: urlProImg1!, cacheKey: imgURLImg1)
                            let optionInfoImg1: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.img1.kf.indicatorType = .activity
                            cell.img1.kf.setImage(with: tmpResouceImg1, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg1, progressBlock: nil, completionHandler: nil)
                            
                            let imgURLImg2 = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList[1].ImageLink)
                            let urlProImg2 = URL(string: imgURLImg2)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouceImg2 = ImageResource(downloadURL: urlProImg2!, cacheKey: imgURLImg2)
                            let optionInfoImg2: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.img2.kf.indicatorType = .activity
                            cell.img2.kf.setImage(with: tmpResouceImg2, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg2, progressBlock: nil, completionHandler: nil)
                            
                            let imgURLImg3 = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList[2].ImageLink)
                            let urlProImg3 = URL(string: imgURLImg3)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouceImg3 = ImageResource(downloadURL: urlProImg3!, cacheKey: imgURLImg3)
                            let optionInfoImg3: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.img3.kf.indicatorType = .activity
                            cell.img3.kf.setImage(with: tmpResouceImg3, placeholder: UIImage(named: "ic_placeholder"), options: optionInfoImg3, progressBlock: nil, completionHandler: nil)
                            
                            cell.overlayView.isHidden = false
                            cell.lblPhotoCount.text = "+ \(self.AllDashBoradData.Result.DashboardList[indexPath.row].PortfolioView.PortfolioImageList.count - 3)\nView All"
                            
                            return cell
                        }
                    }
                    else if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PageType == 4)
                    {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardJobCell", for: indexPath) as! DashBoardJobCell
                        cell.likeHeight.constant = 0
                        cell.lblTitle.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.JobRoleName + " - " + self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.JobTradeName
                        cell.lblCompanyname.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.CompanyName
                        cell.lblDate.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.CityName
                        if(self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.DistanceAwayText != "")
                        {
                            cell.lblDate.text = cell.lblDate.text! + "-" + self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.DistanceAwayText
                        }
                        cell.lblDis.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.Description
                        cell.btnFav.tag = indexPath.row
                        cell.btnProfile.tag = indexPath.row
                        cell.btnView.tag = indexPath.row
                        cell.btnSave.tag = indexPath.row
                        cell.btnLike.tag = indexPath.row
                         cell.btnProfile.tag = indexPath.row
                        if(self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.IsSaved == true)
                        {
                            cell.btnFav.isSelected = true
                            cell.btnSave.isSelected = true
                        }
                        else
                        {
                            cell.btnFav.isSelected = false
                            cell.btnSave.isSelected = false
                        }
                        cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                        
                        cell.lblTitle.tag = indexPath.row
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                        cell.lblTitle.isUserInteractionEnabled = true
                        cell.lblTitle.addGestureRecognizer(tapGestureRecognizer)
                        
                        if(self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.ProfileImageLink != "")
                        {
                            let imgURL = (self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.ProfileImageLink)
                            let urlPro = URL(string: imgURL)
                            cell.imgUser.kf.indicatorType = .activity
                            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                            let optionInfo: KingfisherOptionsInfo = [
                                .downloadPriority(0.5),
                                .transition(ImageTransition.fade(1))
                            ]
                            cell.imgUser.kf.indicatorType = .activity
                            cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                        }
                        
                        return cell
                    }
                    else if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PageType == 5)
                    {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardTextCell", for: indexPath) as! DashBoardTextCell
                        cell.likeHeight.constant = 0
                        cell.lblTitle.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PostView.Name
                        cell.lblDis.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PostView.StatusText
                        cell.lblDate.text = self.AllDashBoradData.Result.DashboardList[indexPath.row].PostView.TimeCaption
                        
                        cell.btnFav.tag = indexPath.row
                        cell.btnProfile.tag = indexPath.row
                        cell.btnSave.tag = indexPath.row
                        cell.btnLike.tag = indexPath.row
                        cell.btnProfile.tag = indexPath.row
                        if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PostView.IsSaved == true)
                        {
                            cell.btnFav.isSelected = true
                            cell.btnSave.isSelected = true
                        }
                        else
                        {
                            cell.btnFav.isSelected = false
                            cell.btnSave.isSelected = false
                        }
                        
                        cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnSave.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnFav.addTarget(self, action: #selector(btnSaveStatus(_:)), for: UIControlEvents.touchUpInside)
                        cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControlEvents.touchUpInside)
                        
                        cell.lblTitle.tag = indexPath.row
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                        cell.lblTitle.isUserInteractionEnabled = true
                        cell.lblTitle.addGestureRecognizer(tapGestureRecognizer)
                        
                        let imgURL = (self.AllDashBoradData.Result.DashboardList[indexPath.row].PostView.ProfileImageLink)
                        let urlPro = URL(string: imgURL)
                        cell.imgUser.kf.indicatorType = .activity
                        let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
                        let optionInfo: KingfisherOptionsInfo = [
                            .downloadPriority(0.5),
                            .transition(ImageTransition.fade(1))
                        ]
                        cell.imgUser.kf.indicatorType = .activity
                        cell.imgUser.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "ic_placeholder"), options: optionInfo, progressBlock: nil, completionHandler: nil)
                        
                        return cell
                    }
                    else
                    {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoard03Cell", for: indexPath) as! DashBoard03Cell
                        
                        return cell
                    }
                }
            }
    }
    func lblNamedTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let sender = tapGestureRecognizer.view as! UILabel
        OpenDetailPage(index: sender.tag)
    }
    func btnProfile (_ sender : UIButton)
    {
         OpenDetailPage(index: sender.tag)
    }
    func btnPortfolio (_ sender : UIButton)
    {
        OpenDetailPageUsingPageType(index: sender.tag)
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
=======
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if(!isFull)
        {
            if(indexPath.row == (self.dashlist?.count)!-2)
            {
                onLoadDetail(index: "\(currentPage)")
            }  
        }
       
        if(tableView == TBLSearchView)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        {
            searchBar.resignFirstResponder()
            viewSearch.isHidden = true
        }
<<<<<<< HEAD
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        txtabout.resignFirstResponder()
        if tableView == self.TBLSearchView
        {
            if(self.Searchdashlist[indexPath.row].Role == 0)
            {
                print("Admin")
=======
        else if(self.dashlist?[indexPath.row].isStatus == true)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashBoardTvCell
            
            
            let myString = "\(self.dashlist![indexPath.row].Title) \(self.dashlist![indexPath.row].TitleCaption)"
            var myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: ((self.dashlist![indexPath.row].TitleCaption)).length)
            let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
            
            let myAttrString = NSMutableAttributedString(string: myString)
            myAttrString.addAttributes(anotherAttribute, range: myRange)
            cell.lbltitle.attributedText = myAttrString
            
            cell.lbldate.text = self.dashlist?[indexPath.row].DatetimeCaption as String!
            cell.lblhtml.text = self.dashlist?[indexPath.row].Description as String!
            
            let imgURL = self.dashlist?[indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            cell.btnProfile!.tag=indexPath.row
            cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
            
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(DashBoardTab.btnSaveStatus(btn:)), for: UIControlEvents.touchUpInside)
            
            if self.dashlist?[indexPath.row].IsSaved == true {
                cell.btnfav.isSelected = true
            }
            else{
                cell.btnfav.isSelected = false
                
            }
            return cell
        }
        else
        {
            let cvimgcnt : Int = (self.dashlist?[indexPath.row].PortfolioImageList?.count)!
            if cvimgcnt == 0{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashBoardTvCell

                
                let myString = "\(self.dashlist![indexPath.row].Title) \(self.dashlist![indexPath.row].TitleCaption)"
                var myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: ((self.dashlist![indexPath.row].TitleCaption)).length)
                let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                
                let myAttrString = NSMutableAttributedString(string: myString)
                myAttrString.addAttributes(anotherAttribute, range: myRange)
                cell.lbltitle.attributedText = myAttrString
                
                cell.lbldate.text = self.dashlist?[indexPath.row].DatetimeCaption as String!
                cell.lblhtml.text = self.dashlist?[indexPath.row].Description as String!
                
                let imgURL = self.dashlist?[indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(DashBoardTab.btnfav(btn:)), for: UIControlEvents.touchUpInside)
                
                if self.dashlist?[indexPath.row].IsSaved == true {
                    cell.btnfav.isSelected = true
                }
                else{
                    cell.btnfav.isSelected = false
                    
                }
                return cell
                
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
            else if(self.Searchdashlist[indexPath.row].Role == 1)
            {
                print("Contractor")
                
<<<<<<< HEAD
                if(self.Searchdashlist[indexPath.row].IsMe)
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContractorProfileView") as! ContractorProfileView
                    vc.userId = self.Searchdashlist[indexPath.row].UserID
                    self.navigationController?.pushViewController(vc, animated: true)
=======
            else if cvimgcnt == 1{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! DashBoardTv1Cell
                let myString = "\(self.dashlist![indexPath.row].Title) \(self.dashlist![indexPath.row].TitleCaption)"
                var myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: ((self.dashlist![indexPath.row].TitleCaption)).length)
                let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                
                let myAttrString = NSMutableAttributedString(string: myString)
                myAttrString.addAttributes(anotherAttribute, range: myRange)
                cell.lbltitle.attributedText = myAttrString
                cell.lbldate.text = self.dashlist?[indexPath.row].DatetimeCaption as String!
                cell.lblhtml.text = self.dashlist?[indexPath.row].Description as String!
                
                let imgURL = self.dashlist?[indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnPortfolio!.tag=indexPath.row
                cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(DashBoardTab.btnfav(btn:)), for: UIControlEvents.touchUpInside)
                
                if self.dashlist?[indexPath.row].IsSaved == true {
                    cell.btnfav.isSelected = true
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                }
                else
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                    vc.userId = self.Searchdashlist[indexPath.row].UserID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
<<<<<<< HEAD
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
            if(indexPath.section == 0)
            {
            
            }
            else
            {
                if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PageType == 4)
                {
                    
=======
                
            else if cvimgcnt == 2{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DashBoardTv2Cell
                let myString = "\(self.dashlist![indexPath.row].Title) \(self.dashlist![indexPath.row].TitleCaption)"
                var myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: ((self.dashlist![indexPath.row].TitleCaption)).length)
                let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                
                let myAttrString = NSMutableAttributedString(string: myString)
                myAttrString.addAttributes(anotherAttribute, range: myRange)
                cell.lbltitle.attributedText = myAttrString
                cell.lbldate.text = self.dashlist?[indexPath.row].DatetimeCaption as String!
                cell.lblhtml.text = self.dashlist?[indexPath.row].Description as String!
                
                let imgURL = self.dashlist?[indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnPortfolio!.tag=indexPath.row
                cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(DashBoardTab.btnfav(btn:)), for: UIControlEvents.touchUpInside)
                
                if self.dashlist?[indexPath.row].IsSaved == true {
                    cell.btnfav.isSelected = true
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                }
                else if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PageType == 5)
                {
                    
                }
<<<<<<< HEAD
                else if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PageType == 6)
                {
                    if(self.AllDashBoradData.Result.DashboardList[indexPath.row].IsMe == true)
                    {
                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "MyJodDetailViewController") as! MyJodDetailViewController
                        vc.JobId = self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView.JobID
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewOtherJodDetailViewController") as! NewOtherJodDetailViewController
                        vc.jobDetail = self.AllDashBoradData.Result.DashboardList[indexPath.row].JobView
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
=======
                
                
                let imgURL1 = self.dashlist?[indexPath.row].PortfolioImageList?[0].PortfolioImageLink as String!
                let url1 = URL(string: imgURL1!)
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                let imgURL2 = self.dashlist?[indexPath.row].PortfolioImageList?[1].PortfolioImageLink as String!
                let url2 = URL(string: imgURL2!)
                cell.img2.kf.indicatorType = .activity
                cell.img2.kf.setImage(with: url2, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                
                return cell
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DashBoardTv3Cell
                let myString = "\(self.dashlist![indexPath.row].Title) \(self.dashlist![indexPath.row].TitleCaption)"
                var myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: ((self.dashlist![indexPath.row].TitleCaption)).length)
                let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                
                let myAttrString = NSMutableAttributedString(string: myString)
                myAttrString.addAttributes(anotherAttribute, range: myRange)
                cell.lbltitle.attributedText = myAttrString
                cell.lbldate.text = self.dashlist?[indexPath.row].DatetimeCaption as String!
                cell.lblhtml.text = self.dashlist?[indexPath.row].Description as String!
                
                let imgURL = self.dashlist?[indexPath.row].ProfileImageLink as String!
                let url = URL(string: imgURL!)
                cell.imguser.kf.indicatorType = .activity
                cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                cell.btnProfile!.tag=indexPath.row
                cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnPortfolio!.tag=indexPath.row
                cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
                
                cell.btnfav!.tag=indexPath.row
                cell.btnfav?.addTarget(self, action: #selector(DashBoardTab.btnfav(btn:)), for: UIControlEvents.touchUpInside)
                
                if self.dashlist?[indexPath.row].IsSaved == true {
                    cell.btnfav.isSelected = true
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                }
                else if(self.AllDashBoradData.Result.DashboardList[indexPath.row].PageType == 7)
                {
                    
                }
            }
        }
    }
    @IBAction func btnHomeScreenAction(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func AddStatus()
    {
        txtabout.resignFirstResponder()
        self.startAnimating()
        let param = ["StatusText":"\(txtabout.text!)"] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PostAdd, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            print(JSONResponse["Status"].rawValue)
            self.stopAnimating()
            if JSONResponse["Status"].int == 1
            {
                self.txtabout.text = ""
                self.placeholderLabel.isHidden = false
                self.refreshPage()
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
    func btnLikeAction(_ sender : UIButton)
    {
        
    }
    func btnViewAction(_ sender : UIButton)
    {
        OpenDetailPageUsingPageType(index: sender.tag)
    }
    func btnSaveStatus(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":self.AllDashBoradData.Result.DashboardList[sender.tag].PrimaryID,
                     "PageType":self.AllDashBoradData.Result.DashboardList[sender.tag].PageType] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
<<<<<<< HEAD
=======
            
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                if sender.isSelected == true
                {
<<<<<<< HEAD
                    if(self.AllDashBoradData.Result.DashboardList[sender.tag].PageType == 2)
                    {
                        self.AllDashBoradData.Result.DashboardList[sender.tag].OfferView.IsSaved = false
=======
                    if btn.isSelected == true{
                        self.dashlist?[btn.tag].IsSaved = false
                        self.sharedManager.dashBoard.DataList?[btn.tag].IsSaved = false
                       // btn.isSelected = false
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                    }
                    else if(self.AllDashBoradData.Result.DashboardList[sender.tag].PageType == 3)
                    {
                        self.AllDashBoradData.Result.DashboardList[sender.tag].PortfolioView.IsSaved = false
                    }
                    else if(self.AllDashBoradData.Result.DashboardList[sender.tag].PageType == 4)
                    {
                        self.AllDashBoradData.Result.DashboardList[sender.tag].JobView.IsSaved = false
                    }
                    else if(self.AllDashBoradData.Result.DashboardList[sender.tag].PageType == 5)
                    {
                        self.AllDashBoradData.Result.DashboardList[sender.tag].PostView.IsSaved = false
                    }
                }
                else
                {
                    if(self.AllDashBoradData.Result.DashboardList[sender.tag].PageType == 2)
                    {
                        self.AllDashBoradData.Result.DashboardList[sender.tag].OfferView.IsSaved = true
                    }
                    else if(self.AllDashBoradData.Result.DashboardList[sender.tag].PageType == 3)
                    {
                        self.AllDashBoradData.Result.DashboardList[sender.tag].PortfolioView.IsSaved = true
                    }
                    else if(self.AllDashBoradData.Result.DashboardList[sender.tag].PageType == 4)
                    {
                        self.AllDashBoradData.Result.DashboardList[sender.tag].JobView.IsSaved = true
                    }
                    else if(self.AllDashBoradData.Result.DashboardList[sender.tag].PageType == 5)
                    {
                        self.AllDashBoradData.Result.DashboardList[sender.tag].PostView.IsSaved = true
                    }
                }
<<<<<<< HEAD
                self.tvdashb.reloadData()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
=======
                
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
<<<<<<< HEAD
=======
            
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }

    func getSuggetionList()
    {
        let param = [:] as [String : Any]
        AFWrapper.requestPOSTURL(Constants.URLS.GetSuggestionUsers, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                self.contractorList = Mapper<SuggestionUserList>().map(JSONObject: JSONResponse.rawValue)
                self.tvdashb.reloadData()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func OpenDetailPage(index:Int)
    {
        txtabout.resignFirstResponder()
        if(self.AllDashBoradData.Result.DashboardList[index].Role == 0)
        {
<<<<<<< HEAD
            print("Admin")
        }
        else if(self.AllDashBoradData.Result.DashboardList[index].Role == 1)
        {
            if(self.AllDashBoradData.Result.DashboardList[index].IsMe)
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContractorProfileView") as! ContractorProfileView
                vc.userId = self.AllDashBoradData.Result.DashboardList[index].UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                vc.userId = self.AllDashBoradData.Result.DashboardList[index].UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(self.AllDashBoradData.Result.DashboardList[index].Role == 2)
        {
            print("Company")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            vc.userId = self.AllDashBoradData.Result.DashboardList[index].UserID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.AllDashBoradData.Result.DashboardList[index].Role == 3)
        {
            print("Supplier")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
            vc.userId = self.AllDashBoradData.Result.DashboardList[index].UserID
            self.navigationController?.pushViewController(vc, animated: true)
=======
            searchBar.resignFirstResponder()
            viewSearch.isHidden = true
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        }
    }
    func OpenDetailPageUsingPageType(index:Int)
    {
        txtabout.resignFirstResponder()
        if(self.AllDashBoradData.Result.DashboardList[index].PageType == 0)
        {
            print("Admin")
        }
        else if(self.AllDashBoradData.Result.DashboardList[index].PageType == 1)
        {
            print("Contractor")
            if(self.AllDashBoradData.Result.DashboardList[index].IsMe)
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContractorProfileView") as! ContractorProfileView
                vc.userId = self.AllDashBoradData.Result.DashboardList[index].UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
<<<<<<< HEAD
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                vc.userId = self.AllDashBoradData.Result.DashboardList[index].UserID
                self.navigationController?.pushViewController(vc, animated: true)
=======
                let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
                companyVC.contractorId = self.Searchdashlist![indexPath.row].PrimaryID
                self.navigationController?.pushViewController(companyVC, animated: true)
                
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
            SearchbarView.text = ""
            SearchbarView.resignFirstResponder()
            viewSearch.isHidden = true

        }
        else if(self.AllDashBoradData.Result.DashboardList[index].PageType == 2)
        {
            print("Offer")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.OfferDetail = self.AllDashBoradData.Result.DashboardList[index].OfferView
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.AllDashBoradData.Result.DashboardList[index].PageType == 3)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortfolioDetails") as! PortfolioDetails
            vc.portfolio = self.AllDashBoradData.Result.DashboardList[index].PortfolioView
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.AllDashBoradData.Result.DashboardList[index].PageType == 4)
        {
            if(self.AllDashBoradData.Result.DashboardList[index].IsMe == true)
            {
                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "MyJodDetailViewController") as! MyJodDetailViewController
                vc.JobId = self.AllDashBoradData.Result.DashboardList[index].JobView.JobID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewOtherJodDetailViewController") as! NewOtherJodDetailViewController
                vc.jobDetail = self.AllDashBoradData.Result.DashboardList[index].JobView
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(self.AllDashBoradData.Result.DashboardList[index].PageType == 5)
        {
            
        }
    }
    func AddStatus()
    {
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "StatusText":"\(txtabout.text!)"] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ConctractorUpdateStatus, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.jobList = Mapper<JobList>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.txtabout.text = ""
                    self.placeholderLabel.isHidden = false
                    self.refreshPage()
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
    func btnSaveStatus(btn : UIButton)  {
        
        var pagetype = 3
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.dashlist?[btn.tag].PrimaryID ?? "-1",
                     "PageType":pagetype] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    if btn.isSelected == true{
                        self.dashlist?[btn.tag].IsSaved = false
                        self.sharedManager.dashBoard.DataList?[btn.tag].IsSaved = false
                        // btn.isSelected = false
                    }
                    else{
                        self.dashlist?[btn.tag].IsSaved = true
                        self.sharedManager.dashBoard.DataList?[btn.tag].IsSaved = true
                        
                        //  btn.isSelected = true
                    }
                    self.tvdashb.reloadData()
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
