//
//  DashBoardTab.swift
//  Tooli
//
//  Created by Moin Shirazi on 10/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher

class DashBoardTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable,UISearchBarDelegate,UITextViewDelegate, UIScrollViewDelegate
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
         onLoadDetail(index: "\(currentPage)")
    }
    @IBOutlet weak var SearchbarView: UISearchBar!
    @IBOutlet var tvdashb : UITableView!
    var sharedManager : Globals = Globals.sharedInstance
    var dashlist : [DashBoardM]? = []
    var contractorList : SuggestionUserList?
    @IBOutlet var vwnolist : UIView?
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var refreshControl:UIRefreshControl!
    var Searchdashlist : [SerachDashBoardM]?
    var placeholderLabel:UILabel!
    @IBOutlet var txtabout : UITextView!
    @IBOutlet weak var ivimage: UIImageView!
    var isFull : Bool = false
    var isFirstTime : Bool = true
    var LastDate:String = ""
    var MinDate:String = ""
    var currentPage = 1
    
    fileprivate let formatter1: DateFormatter = {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd/MM/yyyy"
        return formatter1
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LastDate = formatter1.string(from: Date())
        if(UserDefaults.standard.object(forKey: Constants.KEYS.ISINITSIGNALR) != nil)
        {
            if(UserDefaults.standard.object(forKey: Constants.KEYS.ISINITSIGNALR) as! Bool == false)
            {
                self.dashlist = []
                UserDefaults.standard.set(true, forKey: Constants.KEYS.ISINITSIGNALR)
                UserDefaults.standard.set(true, forKey: Constants.KEYS.LOGINKEY)
            }
        }
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
        AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)

        onLoadDetail(index: "\(currentPage)")
        self.startAnimating()
        self.viewError.isHidden = false
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(DashBoardTab.tapTableView(_:)))
        tvdashb.addGestureRecognizer(tapGesture)
       
        
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "What are you working on today?"
        //     placeholderLabel.font = UIFont(name: "BabasNeue", size: 106)
        placeholderLabel.font = UIFont.systemFont(ofSize: (txtabout.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtabout.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtabout.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtabout.text.isEmpty
        
        
        if (self.sharedManager.currentUser != nil) {
            if self.sharedManager.currentUser.ProfileImageLink != "" {
                let imgURL = self.sharedManager.currentUser.ProfileImageLink as String
                let urlPro = URL(string: imgURL)
                ivimage?.kf.indicatorType = .activity
                
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.sharedManager.currentUser.ProfileImageLink)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1))
                ]
                
                ivimage?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
                
                ivimage?.clipsToBounds = true
            }
        }
        // Do any additional setup after loading the view.
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
        
    }
    override func viewDidAppear(_ animated: Bool) {
         getSuggetionList()
    }
    @IBAction func btnSendTodayPostAction(_ sender: UIButton)
    {
        if(txtabout.text != "")
        {
            AddStatus()
        }
        else
        {
         self.view.makeToast("Status can not be empty.", duration: 3, position: .center)
        }
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func refreshPage()
    {
        isFirstTime = true
        currentPage = 1
        onLoadDetail(index: "\(currentPage)")
    }
    func textViewDidChange(_ textView: UITextView) {
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
        
        if(scrollView == self.tvdashb)
        {
            if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height-50))
            {
                if(!isFull)
                {
                    onLoadDetail(index: "\(currentPage)")
                }
            }
        }
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
    func onLoadDetail(index:String){
        
        var param = ["ContractorID": self.sharedManager.currentUser.ContractorID,"PageIndex":index] as [String : Any]
        param["LastDate"] = "\(LastDate)"
        param["MinDate"] = "\(MinDate)"
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorDashboard_new, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
 
            self.refreshControl.endRefreshing()
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                self.viewError.isHidden = true
                self.imgError.isHidden = true
                self.btnAgain.isHidden = true
                self.lblError.isHidden = true
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    AppDelegate.sharedInstance().isFirstTime = true
                    if(self.isFirstTime)
                    {
                        self.isFirstTime = false
                        
                        self.sharedManager.dashBoard = Mapper<ContractorDashBoard>().map(JSONObject: JSONResponse.rawValue)
                        self.sharedManager.unreadSpecialOffer = self.sharedManager.dashBoard.UnreadOfferNotificationCount
                        self.sharedManager.unreadNotification = self.sharedManager.dashBoard.UnreadNotificationCount
                         self.sharedManager.unreadMessage = self.sharedManager.dashBoard.UnreadMessageNotificationCount
                        UIApplication.shared.applicationIconBadgeNumber =  self.sharedManager.unreadSpecialOffer + self.sharedManager.unreadNotification + self.sharedManager.unreadMessage
                        
                         NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
                        
                        self.dashlist = self.sharedManager.dashBoard.DataList
                        self.MinDate = self.sharedManager.dashBoard.MinDate
                        self.LastDate = self.sharedManager.dashBoard.LastDate
                    }
                    else
                    {
                        let tmpList : ContractorDashBoard = Mapper<ContractorDashBoard>().map(JSONObject: JSONResponse.rawValue)!
                        self.MinDate = tmpList.MinDate
                        self.LastDate = tmpList.LastDate
                        for tmpDashborad in tmpList.DataList! {
                            self.dashlist?.append(tmpDashborad)
                        }
                    }
                    
                    self.tvdashb.reloadData()
                    self.currentPage = self.currentPage + 1
                    self.vwnolist?.isHidden = true
                   }
                else
                {
                    if(self.isFirstTime)
                    {
                        
                    }
                    if(self.dashlist?.count == 0)
                    {
                           self.vwnolist?.isHidden = false
                    }
                    self.lblNoList.text =  JSONResponse["message"].rawString()!
                    self.isFull = true
                    self.isFirstTime = false
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
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        DispatchQueue.main.async {
         //   self.tblHeightConstraint.constant = 0
            
         //   self.tblHeightConstraint.constant = self.tvdashb.contentSize.height
         //   self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.tblHeightConstraint.constant + self.viewHedarHeightConstraint.constant)
        }
    }

    override func didReceiveMemoryWarning() {
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
        print(sender.tag)
        if(self.contractorList!.DataList?[sender.tag].IsContractor == false)
        {
            let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
            companyVC.companyId = (self.contractorList!.DataList?[sender.tag].CompanyID)!
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else
        {
            let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            companyVC.contractorId = (self.contractorList!.DataList?[sender.tag].ContractorID)!
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            if(section == 0)
            {
                return 1
            }
            else
            {
                guard  ((sharedManager.dashBoard) != nil) else {
                    
                    return 0
                }
                if  (self.dashlist == nil){
                    self.dashlist = sharedManager.dashBoard.DataList
                    return  (self.dashlist?.count)!;
                }
                return  (self.dashlist?.count)!;
            }
        }
    }
    
    @IBAction func btnMenu(button: AnyObject)
    {
        SearchbarView.resignFirstResponder()
        txtabout.resignFirstResponder()
        toggleSideMenuView()
    }
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if(!isFull)
        {
            if(indexPath.row == (self.dashlist?.count)!-2)
            {
               // onLoadDetail(index: "\(currentPage)")
            }  
        }
            if(tableView == TBLSearchView)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = self.Searchdashlist?[indexPath.row].displayvalue
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                return cell
            }
            else
            {
                if(indexPath.section == 0)
                {
                    if(self.contractorList != nil)
                    {
                        if((self.contractorList?.DataList?.count)! > 0)
                        {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "suggetion", for: indexPath) as! SuggestionViewCell
                            cell.viewcontroller = self
                            cell.collection.dataSource = cell
                            cell.collection.delegate = cell
                            return cell
                        }
                        else
                        {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell", for: indexPath)
                
                            return cell
                        }
                    }
                    else
                    {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell", for: indexPath)
                        
                        return cell
                    }
                    
                }
                else
                {
                    //  else
                    if(self.dashlist?[indexPath.row].isStatus == true)
                    {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashBoardTvCell
                        
                        let myString = "\(self.dashlist![indexPath.row].Title)-\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)"
                        let myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: "\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)".length)
                        let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                        
                        cell.lbltitle.tag = indexPath.row
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                        cell.lbltitle.isUserInteractionEnabled = true
                        cell.lbltitle.addGestureRecognizer(tapGestureRecognizer)
                        
                        
                        cell.lblhtml.tag = indexPath.row
                        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblJobTaped(tapGestureRecognizer:)))
                        cell.lblhtml.isUserInteractionEnabled = true
                        cell.lblhtml.addGestureRecognizer(tapGestureRecognizer1)
                        
                        let myAttrString = NSMutableAttributedString(string: myString)
                        let anotherAttribute1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: (cell.lbltitle.font?.pointSize)!)]
                        var myRange1 = NSRange(location:0, length: ((self.dashlist![indexPath.row].Title)).length)
                        myAttrString.addAttributes(anotherAttribute1, range: myRange1)
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
                        cell.btnfav.isHidden = true
                        return cell
                    }
                    else if(self.dashlist?[indexPath.row].IsAdminPost == true)
                    {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashBoardTvCell
                        let myString = "\(self.dashlist![indexPath.row].Title)-\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)"
                        var myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: "\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)".length)
                        let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                        
                        cell.lbltitle.tag = indexPath.row
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                        cell.lbltitle.isUserInteractionEnabled = true
                        cell.lbltitle.addGestureRecognizer(tapGestureRecognizer)
                        
                        
                        cell.lblhtml.tag = indexPath.row
                        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblJobTaped(tapGestureRecognizer:)))
                        cell.lblhtml.isUserInteractionEnabled = true
                        cell.lblhtml.addGestureRecognizer(tapGestureRecognizer1)
                        
                        
                        let myAttrString = NSMutableAttributedString(string: myString)
                        let anotherAttribute1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: (cell.lbltitle.font?.pointSize)!)]
                        var myRange1 = NSRange(location:0, length: ((self.dashlist![indexPath.row].Title)).length)
                        myAttrString.addAttributes(anotherAttribute1, range: myRange1)
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
                        cell.btnfav?.addTarget(self, action: #selector(btnSaveAdminPost(btn:)), for: UIControlEvents.touchUpInside)
                        
                        if self.dashlist?[indexPath.row].IsSaved == true {
                            cell.btnfav.isSelected = true
                        }
                        else{
                            cell.btnfav.isSelected = false
                        }
                        cell.btnfav.isHidden = true
                        return cell
                    }
                    else
                    {
                        let cvimgcnt : Int = (self.dashlist?[indexPath.row].PortfolioImageList?.count)!
                        
                        if cvimgcnt == 0{
                            
                            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashBoardTvCell
                            
                            
                            let myString = "\(self.dashlist![indexPath.row].Title)-\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)"
                            var myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: "\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)".length)
                            let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                            
                            let myAttrString = NSMutableAttributedString(string: myString)
                            let anotherAttribute1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: (cell.lbltitle.font?.pointSize)!)]
                            var myRange1 = NSRange(location:0, length: ((self.dashlist![indexPath.row].Title)).length)
                            myAttrString.addAttributes(anotherAttribute1, range: myRange1)
                            myAttrString.addAttributes(anotherAttribute, range: myRange)
                            cell.lbltitle.attributedText = myAttrString
                            
                            cell.lbltitle.tag = indexPath.row
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                            cell.lbltitle.isUserInteractionEnabled = true
                            cell.lbltitle.addGestureRecognizer(tapGestureRecognizer)
                            
                            cell.lbldate.text = self.dashlist?[indexPath.row].DatetimeCaption as String!
                            cell.lblhtml.text = self.dashlist?[indexPath.row].Description as String!
                            
                            cell.lblhtml.tag = indexPath.row
                            let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblJobTaped(tapGestureRecognizer:)))
                            cell.lblhtml.isUserInteractionEnabled = true
                            cell.lblhtml.addGestureRecognizer(tapGestureRecognizer1)
                            
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
                        }
                            
                        else if cvimgcnt == 1{
                            
                            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! DashBoardTv1Cell
                            let myString = "\(self.dashlist![indexPath.row].Title)-\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)"
                            var myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: "\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)".length)
                            let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                            
                            let myAttrString = NSMutableAttributedString(string: myString)
                            myAttrString.addAttributes(anotherAttribute, range: myRange)
                            let anotherAttribute1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: (cell.lbltitle.font?.pointSize)!)]
                            var myRange1 = NSRange(location:0, length: ((self.dashlist![indexPath.row].Title)).length)
                            myAttrString.addAttributes(anotherAttribute1, range: myRange1)
                            cell.lbltitle.attributedText = myAttrString
                            
                            cell.lbltitle.tag = indexPath.row
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                            cell.lbltitle.isUserInteractionEnabled = true
                            cell.lbltitle.addGestureRecognizer(tapGestureRecognizer)
                            
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
                            }
                            else{
                                cell.btnfav.isSelected = false
                                
                            }
                            
                            let imgURL1 = self.dashlist?[indexPath.row].PortfolioImageList?[0].PortfolioImageLink as String!
                            let url1 = URL(string: imgURL1!)
                            cell.img1.kf.indicatorType = .activity
                            cell.img1.kf.setImage(with: url1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
                                if(image != nil)
                                {
                                    cell.setCustomImage(image : image!)
                                    if(cell.isReload)
                                    {
                                        cell.isReload = false
                                        tableView.reloadData()
                                    }
                                }
                            })
                            return cell
                        }
                            
                        else if cvimgcnt == 2{
                            
                            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DashBoardTv2Cell
                            let myString = "\(self.dashlist![indexPath.row].Title)-\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)"
                            var myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: "\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)".length)
                            let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                            
                            let myAttrString = NSMutableAttributedString(string: myString)
                            myAttrString.addAttributes(anotherAttribute, range: myRange)
                            let anotherAttribute1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: (cell.lbltitle.font?.pointSize)!)]
                            var myRange1 = NSRange(location:0, length: ((self.dashlist![indexPath.row].Title)).length)
                            myAttrString.addAttributes(anotherAttribute1, range: myRange1)
                            cell.lbltitle.attributedText = myAttrString
                            
                            cell.lbltitle.tag = indexPath.row
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                            cell.lbltitle.isUserInteractionEnabled = true
                            cell.lbltitle.addGestureRecognizer(tapGestureRecognizer)
                            
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
                            }
                            else{
                                cell.btnfav.isSelected = false
                                
                            }
                            
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
                            let myString = "\(self.dashlist![indexPath.row].Title)-\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)"
                            var myRange = NSRange(location:((self.dashlist![indexPath.row].Title)).length+1, length: "\(self.dashlist![indexPath.row].TradeCategoryName) \(self.dashlist![indexPath.row].TitleCaption)".length)
                            let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
                            
                            let myAttrString = NSMutableAttributedString(string: myString)
                            myAttrString.addAttributes(anotherAttribute, range: myRange)
                            let anotherAttribute1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: (cell.lbltitle.font?.pointSize)!)]
                            var myRange1 = NSRange(location:0, length: ((self.dashlist![indexPath.row].Title)).length)
                            myAttrString.addAttributes(anotherAttribute1, range: myRange1)
                            cell.lbltitle.attributedText = myAttrString
                            
                            cell.lbltitle.tag = indexPath.row
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
                            cell.lbltitle.isUserInteractionEnabled = true
                            cell.lbltitle.addGestureRecognizer(tapGestureRecognizer)
                            
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
                            }
                            else{
                                cell.btnfav.isSelected = false
                                
                            }
                            
                            let imgURL1 = self.dashlist?[indexPath.row].PortfolioImageList?[0].PortfolioImageLink as String!
                            let url1 = URL(string: imgURL1!)
                            cell.img1.kf.indicatorType = .activity
                            cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                            
                            let imgURL2 = self.dashlist?[indexPath.row].PortfolioImageList?[1].PortfolioImageLink as String!
                            let url2 = URL(string: imgURL2!)
                            cell.img2.kf.indicatorType = .activity
                            cell.img2.kf.setImage(with: url2, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                            
                            let imgURL3 = self.dashlist?[indexPath.row].PortfolioImageList?[2].PortfolioImageLink as String!
                            let url3 = URL(string: imgURL3!)
                            cell.img3.kf.indicatorType = .activity
                            cell.img3.kf.setImage(with: url3, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                            cell.overlayView.isHidden = true
                            if(cvimgcnt > 3)
                            {
                                cell.overlayView.isHidden = false
                                cell.lblPhotoCount.text = "+\(cvimgcnt - 3)\nView All"
                            }
                            return cell
                        }
                    }
                }
            }
    }
    func lblNamedTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
          let lbl = tapGestureRecognizer.view as! UILabel
        if(self.dashlist?[lbl.tag].IsContractor == false)
        {
            let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
            companyVC.companyId = self.dashlist![lbl.tag].CompanyID
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else
        {
            let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            companyVC.contractorId = self.dashlist![lbl.tag].ContractorID
            self.navigationController?.pushViewController(companyVC, animated: true)
            
        }
    }
    func lblJobTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let lbl = tapGestureRecognizer.view as! UILabel
        if(self.dashlist![lbl.tag].IsJob)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
            vc.JobId = self.dashlist![lbl.tag].PrimaryID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func btnProfile (btn : UIButton)
    {
        if(self.dashlist?[btn.tag].IsContractor == false)
        {
            let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
            companyVC.companyId = self.dashlist![btn.tag].CompanyID
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else
        {
            let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            companyVC.contractorId = self.dashlist![btn.tag].ContractorID
            self.navigationController?.pushViewController(companyVC, animated: true)
            
        }
    }
    
    func btnPortfolio (btn : UIButton) {
        
        let obj : PortfolioDetails = self.storyboard?.instantiateViewController(withIdentifier: "PortfolioDetails") as! PortfolioDetails
        obj.portfolioId = (self.dashlist?[btn.tag].PrimaryID)!
        self.navigationController?.pushViewController(obj, animated: true)

    }
    
    func btnfav(btn : UIButton)  {
        
        var pagetype = 4
        if self.dashlist?[btn.tag].IsPortfolio == true {
            pagetype = 6
        }
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.dashlist?[btn.tag].PrimaryID ?? "-1",
                     "PageType":pagetype] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            

            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    if self.dashlist![btn.tag].IsSaved{
                        self.dashlist?[btn.tag].IsSaved = false
                    }
                    else{
                        self.dashlist?[btn.tag].IsSaved = true
                    }
                    self.tvdashb.reloadData()
                    self.stopAnimating()
                }
                else
                {
                  self.stopAnimating()
                }
                
              //  self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
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
            searchBar.resignFirstResponder()
            viewSearch.isHidden = true
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.TBLSearchView {
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
            if(self.dashlist![indexPath.row].IsJob)
            {
                let obj : JodDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "JodDetailViewController") as! JodDetailViewController
                obj.JobId = self.dashlist![indexPath.row].PrimaryID
                self.navigationController?.pushViewController(obj, animated: true)
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
                
            //    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
             
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
                
               // self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func btnSaveAdminPost(btn : UIButton)  {
        
        var pagetype = 0
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
                
                // self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
            
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func getSuggetionList()
    {
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID] as [String : Any]
        AFWrapper.requestPOSTURL(Constants.URLS.GetSuggestionUserList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.contractorList = Mapper<SuggestionUserList>().map(JSONObject: JSONResponse.rawValue)
                    self.tvdashb.reloadData()
                }
                else
                {
                     self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
                }
            }
            
        }) {
            (error) -> Void in
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func FollowUnfollowTapped(_ sender: UIButton) {
        self.startAnimating()
        var strUrlTogaling = ""
        
        var param = [:] as! [String:Any]
       
        if(self.contractorList?.DataList![sender.tag].IsContractor)!
        {
            strUrlTogaling = Constants.URLS.FollowContractorToggle
            param = ["FollowContractorID": self.contractorList?.DataList![sender.tag].ContractorID ?? 0,
                     "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
        }
        else
        {
            strUrlTogaling = Constants.URLS.FollowCompanyToggle
            param = ["FollowCompanyID": self.contractorList?.DataList![sender.tag].CompanyID ?? 0,
                     "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
        }

        print(param)
        AFWrapper.requestPOSTURL(strUrlTogaling, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
             self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
              
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.contractorList?.DataList?.remove(at: sender.tag)
                     self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
                }
                else
                {
                    self.stopAnimating()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.tvdashb.tableHeaderView = UIView()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func btnDeleteTapped(_ sender: UIButton) {
        self.startAnimating()
        var strUrlTogaling = ""
        var param = [:] as! [String:Any]
        strUrlTogaling = Constants.URLS.RemoveFromSuggestionUserList
        param = ["RemoveUserID": self.contractorList?.DataList![sender.tag].UserID ?? 0,
                 "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
        print(param)

        
        AFWrapper.requestPOSTURL(strUrlTogaling, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.contractorList?.DataList?.remove(at: sender.tag)
                     self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
                }
                else
                {
                    self.stopAnimating()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.tvdashb.tableHeaderView = UIView()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
}

