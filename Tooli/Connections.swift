//
//  Connections.swift
//  Tooli
//
//  Created by Moin Shirazi on 12/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher

class Connections: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable  {

    @IBOutlet var tvconnections : UITableView!
    @IBOutlet var btncompany : UIButton!
    @IBOutlet var btncontractor : UIButton!
    @IBOutlet var btnfollowing : UIButton!
    @IBOutlet var btnfollower : UIButton!
    
    var sharedManager : Globals = Globals.sharedInstance
    var refreshControl:UIRefreshControl!
    var connlist : [FollowerModel]?
    var templist : [FollowerModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btncontractor.isSelected = true
        btnfollowing.isSelected = true
        
        onLoadDetail()
        
        
        if self.sharedManager.connectionList != nil{
            
            self.templist = self.sharedManager.connectionList.FollowingList
            self.connlist = self.sharedManager.connectionList.FollowingList
            
        }
        tvconnections.delegate = self
        tvconnections.dataSource = self
        tvconnections.rowHeight = UITableViewAutomaticDimension
        tvconnections.estimatedRowHeight = 100
        tvconnections.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(Connections.refreshPage) , for: UIControlEvents.valueChanged)
        tvconnections.addSubview(refreshControl)

        
        // Do any additional setup after loading the view.
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func refreshPage()
    {
        onLoadDetail()
    }

     override func viewWillAppear(_ animated: Bool) {

    }
    
    func onLoadDetail(){
        
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ConnectionList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.connectionList = Mapper<ConnectionList>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            self.refreshControl.endRefreshing()
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    
                    self.templist = self.sharedManager.connectionList.FollowingList
                    self.connlist = []
                    for i in (0..<self.templist!.count)
                    {
                        if (self.templist?[i].IsContractor == true)
                        {
                            self.connlist?.append((self.templist?[i])!)
                        }
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
    

    
    @IBAction func btnBack(_ sender: Any) {
        
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.moveToDashboard()
    }
   
    @IBAction func btnFollowing(_ sender: Any) {
        
        btnfollowing.isSelected = true
        btnfollower.isSelected = false
        
        guard  ((sharedManager.connectionList) != nil) else {
            return
        }
        templist = self.sharedManager.connectionList.FollowingList
            
        
        self.connlist = []
        
        if self.btncompany.isSelected == true {
            
            for i in (0..<templist!.count)
            {
                if (templist?[i].IsContractor == false)
                {
                    self.connlist?.append((templist?[i])!)
                }
            }
        }
        else{
            for i in (0..<templist!.count)
            {
                if (templist?[i].IsContractor == true)
                {
                    self.connlist?.append((templist?[i])!)
                }
            }
        }

        //  self.connlist = self.sharedManager.connectionList.FollowingList
        tvconnections.reloadData()

    }
   
    @IBAction func btnFollowers(_ sender: Any) {
        
        btnfollowing.isSelected = false
        btnfollower.isSelected = true
        
        guard  ((sharedManager.connectionList) != nil) else {
            return
        }
        templist = self.sharedManager.connectionList.FollowerList
      
        self.connlist = []
        
        if self.btncompany.isSelected == true {
            
            for i in (0..<templist!.count)
            {
                if (templist?[i].IsContractor == false)
                {
                    self.connlist?.append((templist?[i])!)
                }
            }
        }
        else{
            for i in (0..<templist!.count)
            {
                if (templist?[i].IsContractor == true)
                {
                    self.connlist?.append((templist?[i])!)
                }
            }
        }

        tvconnections.reloadData()

    }
    
    @IBAction func btnContractor(_ sender: Any) {
        
        btncontractor.isSelected = true
        btncompany.isSelected = false
        
        guard  ((sharedManager.connectionList) != nil) else {
            return
        }
        if btnfollower.isSelected == true {
            templist = self.sharedManager.connectionList.FollowerList
        }
        else{
            templist = self.sharedManager.connectionList.FollowingList
            
        }
        self.connlist = []
        for i in (0..<templist!.count)
        {
            if (templist?[i].IsContractor == true)
            {
                self.connlist?.append((templist?[i])!)
            }
        }
        self.tvconnections.reloadData()
    }
    
    @IBAction func btnCompany(_ sender: Any) {
        
        btncontractor.isSelected = false
        btncompany.isSelected = true
        
        guard  ((sharedManager.connectionList) != nil) else {
            return
        }
        if btnfollower.isSelected == true {
             templist = self.sharedManager.connectionList.FollowerList
        }
        else{
             templist = self.sharedManager.connectionList.FollowingList

        }
        self.connlist = []
        for i in (0..<templist!.count)
        {
            if (templist?[i].IsContractor == false)
            {
                self.connlist?.append((templist?[i])!)
            }
        }
        self.tvconnections.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        guard  ((sharedManager.connectionList) != nil) else {
            return 0
        }
        return  (self.connlist?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectionCell
        cell.lbllocatn.text = self.connlist?[indexPath.row].CityName as String!
        cell.lblcompany.text = self.connlist?[indexPath.row].CompanyName as String!
        cell.lblwork.text = self.connlist?[indexPath.row].TradeCategoryName as String!
        
        cell.btnfav!.tag=indexPath.row
        cell.btnfav?.addTarget(self, action: #selector(JobCenter.btnfav(btn:)), for: UIControlEvents.touchUpInside)
        if self.connlist?[indexPath.row].IsSaved == true {
            cell.btnfav.isSelected = true
        }
        else{
            cell.btnfav.isSelected = false
        }
        let imgURL = self.connlist?[indexPath.row].ProfileImageLink as String!
        let url = URL(string: imgURL!)
        cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.connlist?[indexPath.row].IsContractor == true {
            
            let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            obj.contractorId = (self.connlist?[indexPath.row].PrimaryID)!
            obj.isPortFolio = false
            self.navigationController?.pushViewController(obj, animated: true)
            
        }
        else{
            let obj : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
            obj.companyId = (self.connlist?[indexPath.row].PrimaryID)!
            self.navigationController?.pushViewController(obj, animated: true)
        }
        
    }
    
    func btnfav(btn : UIButton)
    {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.connlist?[btn.tag].PrimaryID ?? "",
                     "PageType":self.btncompany.isSelected == true ? "1" : "2"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    if btn.isSelected == true{
                        self.connlist?[btn.tag].IsSaved = false
                    }
                    else{
                        self.connlist?[btn.tag].IsSaved = true
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
