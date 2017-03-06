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

class DashBoardTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable,UISearchBarDelegate,UITextViewDelegate
{
    @IBOutlet weak var SearchbarView: UISearchBar!
    @IBOutlet var tvdashb : UITableView!
    var sharedManager : Globals = Globals.sharedInstance
    var dashlist : [DashBoardM]? = []
    @IBOutlet var vwnolist : UIView?
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var refreshControl:UIRefreshControl!
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
    
        
        tvdashb.delegate = self
        tvdashb.dataSource = self
        tvdashb.rowHeight = UITableViewAutomaticDimension
        tvdashb.estimatedRowHeight = 100
        tvdashb.tableFooterView = UIView()
        self.vwnolist?.isHidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(DashBoardTab.refreshPage), for: UIControlEvents.valueChanged)
        tvdashb.addSubview(refreshControl)
        
        AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)

        onLoadDetail(index: "\(currentPage)")
        
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

        // Do any additional setup after loading the view.
    }
    func tapTableView(_ sender:UITapGestureRecognizer)
    {
        SearchbarView.resignFirstResponder()
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
        onSerach(str: strUpdated as String)
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
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func onLoadDetail(index:String){
        
        if(isFirstTime)
        {
            self.startAnimating()
        }
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,"PageIndex":index] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorDashboard, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
           
            
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
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.stopAnimating()

            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
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
    
    @IBAction func btnMenu(button: AnyObject)
    {
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
                onLoadDetail(index: "\(currentPage)")
            }  
        }
       
        if(tableView == TBLSearchView)
        {
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = self.Searchdashlist?[indexPath.row].displayvalue
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            return cell
        }
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
                
            }
                
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
                }
                else{
                    cell.btnfav.isSelected = false
                    
                }
                
                let imgURL1 = self.dashlist?[indexPath.row].PortfolioImageList?[0].PortfolioImageLink as String!
                let url1 = URL(string: imgURL1!)
                cell.img1.kf.indicatorType = .activity
                cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
                
                return cell
                
            }
                
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
                
                return cell
                
            }
        }
    }
    
    func btnProfile (btn : UIButton) {
        
        
        let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
        obj.contractorId = (self.dashlist?[btn.tag].ContractorID)!
        self.navigationController?.pushViewController(obj, animated: true)

    }
    
    func btnPortfolio (btn : UIButton) {
        let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
        obj.contractorId = (self.dashlist?[btn.tag].ContractorID)!
        obj.isPortFolio = true
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
//        let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
//        obj.ContractorID = 
//        self.navigationController?.pushViewController(obj, animated: true)
        
        
    }
    func AddStatus()
    {
        self.startAnimating()
        let param = ["UserID": self.sharedManager.currentUser.ContractorID,
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

