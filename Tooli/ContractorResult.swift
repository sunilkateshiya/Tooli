//
//  ContractorResult.swift
//  Tooli
//
//  Created by Impero IT on 15/02/2017.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import Kingfisher
import ActionSheetPicker_3_0
import ObjectMapper
import NVActivityIndicatorView
import GooglePlaces
import Toast_Swift
import Alamofire

class ContractorResult: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable,RetryButtonDeleget
{
    
    @IBOutlet var vwnolist : UIView?
    @IBOutlet var tvconnections : UITableView!
 
    var connectionList : GetFilterListConntractorM = GetFilterListConntractorM()
    var TradeIdList:[Int] = []
    var CertificateIdList : [Int] = []
    var SectorIdList : [Int] = []
    var postcode : String = ""
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var currentPage = 1
    var isFirstTime : Bool = true
    var isFull : Bool = false
    var refreshControl:UIRefreshControl!
    var isCallService:Bool = false
    var activityIndicator = UIActivityIndicatorView()
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.startAnimating()
        
        onLoadDetail()
        
        tvconnections.delegate = self
        tvconnections.dataSource = self
        tvconnections.rowHeight = UITableViewAutomaticDimension
        tvconnections.estimatedRowHeight = 100
        tvconnections.tableFooterView = UIView()
        
        self.vwnolist?.isHidden = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage), for: UIControlEvents.valueChanged)
        tvconnections.addSubview(refreshControl)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.startAnimating()
        
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }
    func refreshPage()
    {
        isFirstTime = true
        isFull = false
        isCallService = false
        self.connectionList.Result = []
        currentPage = 1
        onLoadDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Contractor Result Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func onLoadDetail()
    {
        if(isCallService)
        {
            return
        }
        else
        {
            isCallService = true
        }
        self.tvconnections.tableFooterView = activityIndicator
        var param:[String : Any] = [:]
        param["Location"] = postcode
        param["Latitude"] = coordinate.latitude
        param["Longitude"] = coordinate.longitude
        param["TradeIdList"] = TradeIdList
        param["CertificateIdList"] = CertificateIdList
        param["SectorIdList"] = SectorIdList
        param["PageIndex"] = currentPage
    
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorSearch, params :param as [String : AnyObject]? ,headers : nil  ,  success:
            {
            (JSONResponse) -> Void in
            
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            print(JSONResponse["Status"].rawValue)
            
            self.tvconnections.tableFooterView = UIView()
            if JSONResponse["Status"].int == 1
            {
                self.vwnolist?.isHidden = false
                self.tvconnections.isHidden = false
                self.stopAnimating()
                print(JSONResponse)
                
                if self.isFirstTime
                {
                    self.connectionList  = GetFilterListConntractorM()
                    self.connectionList = Mapper<GetFilterListConntractorM>().map(JSONObject: JSONResponse.rawValue)!
                    self.isFirstTime = false;
                    self.currentPage = self.currentPage + 1
                }
                else
                {
                    let tmpList : GetFilterListConntractorM = Mapper<GetFilterListConntractorM>().map(JSONObject: JSONResponse.rawValue)!
                    if(tmpList.Result.count == 0)
                    {
                        self.isFull = true
                    }
                    for tmpNotifcation in tmpList.Result
                    {
                        self.connectionList.Result.append(tmpNotifcation)
                    }
                    self.currentPage = self.currentPage + 1
                }
                if(self.connectionList.Result.count == 0)
                {
                    let viewBlur:PopupView = PopupView(frame:self.tvconnections.frame)
                    viewBlur.frame = self.tvconnections.frame
                    viewBlur.delegate = self
                    self.view.addSubview(viewBlur)
                    viewBlur.lblTitle.text = " No contractor found"
                }
                
                self.tvconnections.reloadData()
                self.isCallService = false
            }
            else
            {
                if(self.connectionList.Result.count == 0)
                {
                    self.tvconnections.isHidden = true
                }
                else
                {
                    self.tvconnections.isHidden = false
                }
                self.stopAnimating()
                self.isFull = true
                self.isFirstTime = false;
                self.isCallService = false
                
                let viewBlur:PopupView = PopupView(frame:self.tvconnections.frame)
                viewBlur.frame = self.tvconnections.frame
                viewBlur.delegate = self
                self.view.addSubview(viewBlur)
                viewBlur.lblTitle.text = JSONResponse["Message"].rawString()!
                
            }
            
        }) {
            (error) -> Void in
            
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func RetrybuttonTaped()
    {
        refreshPage()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if !self.isCallService{
            if(scrollView == self.tvconnections)
            {
                if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height))
                {
                    if(!isFull)
                    {
                        onLoadDetail()
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.connectionList.Result.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectionNewCell
        cell.lblName.text = self.connectionList.Result[indexPath.row].FullName
        
        cell.lblAway.text = self.connectionList.Result[indexPath.row].DistanceAwayText
        if(cell.lblAway.text != "")
        {
            cell.lblAway.text = cell.lblAway.text! +  "\n"
        }
        cell.lblAway.text = cell.lblAway.text! + "\(self.connectionList.Result[indexPath.row].JobRoleName) - \(self.connectionList.Result[indexPath.row].CityName)"
        
        cell.lblDis.text =  self.connectionList.Result[indexPath.row].Description as String!
        
        
        cell.btnFav.tag=indexPath.row
        cell.btnSave.tag=indexPath.row
        cell.btnView.tag=indexPath.row
        
        cell.btnFav.addTarget(self, action: #selector(btnSaveUser(_:)), for: UIControlEvents.touchUpInside)
        cell.btnSave.addTarget(self, action: #selector(btnSaveUser(_:)), for: UIControlEvents.touchUpInside)
        cell.btnView.addTarget(self, action: #selector(btnView(_:)), for: UIControlEvents.touchUpInside)
        if self.connectionList.Result[indexPath.row].IsSaved == true
        {
            cell.btnFav.isSelected = true
            cell.btnSave.isSelected = true
        }
        else{
            cell.btnFav.isSelected = false
            cell.btnSave.isSelected = false
        }
        let imgURL = self.connectionList.Result[indexPath.row].ProfileImageLink as String!
        let url = URL(string: imgURL!)
        cell.imgUser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        openUserProfile(index:indexPath.row)
    }
    
    func btnView(_ sender : UIButton)
    {
        openUserProfile(index:sender.tag)
    }
    func btnSaveUser(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":self.connectionList.Result[sender.tag].UserID,
                     "PageType":1] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                if sender.isSelected == false
                {
                    self.connectionList.Result[sender.tag].IsSaved = true
                }
                else
                {
                    self.connectionList.Result[sender.tag].IsSaved = false
                }
                self.tvconnections.reloadData()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func openUserProfile(index:Int)
    {
        let companyVC = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
        companyVC.userId = self.connectionList.Result[index].UserID
        self.navigationController?.pushViewController(companyVC, animated: true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
