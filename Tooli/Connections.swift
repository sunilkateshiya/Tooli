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

    var connlist : [FollowerModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvconnections.delegate = self
        tvconnections.dataSource = self
        tvconnections.rowHeight = UITableViewAutomaticDimension
        tvconnections.estimatedRowHeight = 100
        tvconnections.tableFooterView = UIView()
        
        btncontractor.isSelected = true
        btnfollowing.isSelected = true
        
        onLoadDetail()
        // Do any additional setup after loading the view.
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
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    
                    self.connlist = self.sharedManager.connectionList.FollowingList
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
        self.connlist = self.sharedManager.connectionList.FollowingList
        tvconnections.reloadData()

    }
   
    @IBAction func btnFollowers(_ sender: Any) {
        self.connlist = self.sharedManager.connectionList.FollowerList
        tvconnections.reloadData()

    }
    
    @IBAction func btnContractor(_ sender: Any) {
        
    }
    
    @IBAction func btnCompany(_ sender: Any) {
        
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
    
    func btnfav(btn : UIButton)  {
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.connlist?[btn.tag].PrimaryID ?? "",
                     "PageType":"job"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
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
