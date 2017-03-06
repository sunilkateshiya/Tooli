//
//  ContractorResult.swift
//  Tooli
//
//  Created by Impero IT on 15/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Kingfisher
import ActionSheetPicker_3_0
import ObjectMapper
import NVActivityIndicatorView
import GooglePlaces
import Toast_Swift
import Alamofire

class ContractorResult: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable  
{
    
        @IBOutlet var vwnolist : UIView?
    
    @IBOutlet var tvconnections : UITableView!
    let sharedManager : Globals = Globals.sharedInstance
    var connlist : FilterContractoreList = FilterContractoreList()

    var selectedTrade = 0;
    var selectedSkills : [String] = [];
    var selectedCertificate : [String] = [];
    var postcode : String = ""
    var currentPage = 1
    var isFirstTime : Bool = true
     var isFull : Bool = false
    //var notificationList : FollowerModel = FollowerModel();
     var refreshControl:UIRefreshControl!
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
        onLoadDetail(page: currentPage)
        
        tvconnections.delegate = self
        tvconnections.dataSource = self
        tvconnections.rowHeight = UITableViewAutomaticDimension
        tvconnections.estimatedRowHeight = 100
        tvconnections.tableFooterView = UIView()
        
         self.vwnolist?.isHidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ContractorResult.refreshPage), for: UIControlEvents.valueChanged)
        tvconnections.addSubview(refreshControl)

        
        // Do any additional setup after loading the view.
    }
    func refreshPage()
    {
        isFirstTime = true
        isFull = false
        
        currentPage = 1
        onLoadDetail(page : currentPage)
    }
    func onLoadDetail(page : Int){
        
        if self.isFirstTime {
            self.startAnimating()
        }
        else {
            let view : UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: 80))
            let activity : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            activity.startAnimating()
            view.addSubview(activity)
            self.tvconnections.tableFooterView = view
        }
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,"TradeCategoryID":selectedTrade,"GroupServiceID":selectedSkills.joined(separator: ","),"GroupCertificateCategoryID":selectedCertificate.joined(separator: ","),"Zipcode":postcode,"PageIndex":page] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.connectionList = Mapper<ConnectionList>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                     self.vwnolist?.isHidden = false
                     self.tvconnections.isHidden = false
                     self.stopAnimating()
                    print(JSONResponse)
                    if self.isFirstTime {
                        self.connlist  = FilterContractoreList()
                        self.connlist = Mapper<FilterContractoreList>().map(JSONObject: JSONResponse.rawValue)!
                        self.isFirstTime = false;
                    }
                    else {
                        let tmpList : FilterContractoreList = Mapper<FilterContractoreList>().map(JSONObject: JSONResponse.rawValue)!
                        for tmpNotifcation in tmpList.DataList {
                            self.connlist.DataList.append(tmpNotifcation)
                        }
                        self.currentPage = self.currentPage + 1
                    }
                    self.tvconnections.reloadData()
                }
                else
                {
                    if(self.connlist.DataList.count == 0)
                    {
                        self.tvconnections.isHidden = true
                         self.vwnolist?.isHidden = false
                    }
                    else
                    {
                        self.tvconnections.isHidden = false
                         self.vwnolist?.isHidden = true
                    }
                    self.stopAnimating()
                    self.isFull = true
                    self.isFirstTime = false;
                    //self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        guard  ((sharedManager.connectionList) != nil) else {
            return 0
        }
        return  (self.connlist.DataList.count);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectionCell
        cell.lbllocatn.text = self.connlist.DataList[indexPath.row].CityName as String!
        cell.lblcompany.text = self.connlist.DataList[indexPath.row].Name as String!
        cell.lblwork.text = self.connlist.DataList[indexPath.row].TradeCategoryName as String!
        
        cell.btnfav!.tag=indexPath.row
        cell.btnfav?.addTarget(self, action: #selector(JobCenter.btnfav(btn:)), for: UIControlEvents.touchUpInside)
        if self.connlist.DataList[indexPath.row].IsSaved == true
        {
            cell.btnfav.isSelected = true
        }
        else{
            cell.btnfav.isSelected = false
        }
        let imgURL = self.connlist.DataList[indexPath.row].ProfileImageLink as String!
        let url = URL(string: imgURL!)
        cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
        obj.contractorId = (self.connlist.DataList[indexPath.row].PrimaryID)
        obj.isPortFolio = false
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func btnfav(btn : UIButton)  {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.connlist.DataList[btn.tag].PrimaryID,
                     "PageType": "2"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    if btn.isSelected == true{
                        self.connlist.DataList[btn.tag].IsSaved = false
                    }
                    else{
                        self.connlist.DataList[btn.tag].IsSaved = true
                    }
                    self.tvconnections.reloadData()
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
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let tblheight = self.connlist.DataList.count * 70
        
        if scrollView.contentOffset.y > CGFloat(tblheight)
        {
            if(!isFull)
            {
                self.onLoadDetail(page: currentPage )
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
