//
//  Connections.swift
//  Tooli
//
//  Created by impero on 12/01/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher

class Connections: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable  {

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var tabViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnAgain: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewError: UIView!
    @IBAction func btnAgainErrorAction(_ sender: UIButton)
    {
        self.imgError.isHidden = true
        self.btnAgain.isHidden = true
        self.lblError.isHidden = true
        onLoadDetail() 
    }
    @IBOutlet var tvconnections : UITableView!
    @IBOutlet var btncompany : UIButton!
    @IBOutlet var btncontractor : UIButton!
    @IBOutlet weak var btnSupplier: UIButton!
    
    @IBOutlet var btnfollowing : UIButton!
    @IBOutlet var btnfollower : UIButton!
    
    var sharedManager : Globals = Globals.sharedInstance
    var refreshControl:UIRefreshControl!
    
    var connectionList : GetYourConnectionList = GetYourConnectionList()
    
    var pageIndex:Int =  1
    var isFull : Bool = false
    var isFirstTime : Bool = true
    var isCallWebService : Bool = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btncontractor.isSelected = true
        btnfollowing.isSelected = true
        self.startAnimating()
        onLoadDetail()
        self.viewError.isHidden = false
        
        tvconnections.delegate = self
        tvconnections.dataSource = self
        tvconnections.rowHeight = UITableViewAutomaticDimension
        tvconnections.estimatedRowHeight = 500
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage) , for: UIControlEvents.valueChanged)
        scroll.addSubview(refreshControl)

        // Do any additional setup after loading the view.
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func refreshPage()
    {
        pageIndex = 1
        onLoadDetail()
    }

     override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Connections Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func onLoadDetail()
    {
        var UserType:Int = 0
        var IsFollowing:Int = 0
        if(btncontractor.isSelected)
        {
             UserType = 1
        }
        else if(btncompany.isSelected)
        {
            UserType = 2
        }
        else if(btnSupplier.isSelected)
        {
            UserType = 3
        }
        if(btnfollower.isSelected)
        {
            IsFollowing = 0
        }
        else if(btnfollowing.isSelected)
        {
            IsFollowing = 1
        }
        if(pageIndex == 1)
        {
            self.startAnimating()
        }
        let param = ["UserType":UserType,"IsFollowing":IsFollowing,"PageIndex":pageIndex] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ConnectionList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            print(JSONResponse["Status"].rawValue)
            
            self.viewError.isHidden = true
            self.imgError.isHidden = true
            self.btnAgain.isHidden = true
            self.lblError.isHidden = true
            if JSONResponse["Status"].int == 1
            {
                if(self.pageIndex == 1)
                {
                    self.connectionList.Result = []
                }
                let temp:GetYourConnectionList = Mapper<GetYourConnectionList>().map(JSONObject: JSONResponse.rawValue)!
                
                for tempM in temp.Result
                {
                    self.connectionList.Result.append(tempM)
                }
                self.tvconnections.reloadData()
                DispatchQueue.main.async {
                    self.tabViewHeightConstraint.constant = self.tvconnections.contentSize.height
                    self.scroll.contentSize = CGSize(width: self.scroll.frame.width, height: self.tvconnections.frame.origin.y+self.tabViewHeightConstraint.constant+10)
                }
            }
            else
            {
                _ = self.navigationController?.popViewController(animated: true)
                AppDelegate.sharedInstance().window?.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
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
    
    @IBAction func btnBack(_ sender: Any)
    {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.moveToDashboard()
    }
   
    @IBAction func btnFollowing(_ sender: Any)
    {
        btnfollowing.isSelected = true
        btnfollower.isSelected = false
        pageIndex = 1
        self.onLoadDetail()
    }
   
    @IBAction func btnFollowers(_ sender: Any)
    {
        btnfollowing.isSelected = false
        btnfollower.isSelected = true
        pageIndex = 1
        self.onLoadDetail()
    }
    
    @IBAction func btnContractor(_ sender: Any)
    {
        btncontractor.isSelected = true
        btncompany.isSelected = false
        btnSupplier.isSelected = false
        pageIndex = 1
        self.onLoadDetail()
    }
    
    @IBAction func btnCompany(_ sender: Any)
    {
        btncontractor.isSelected = false
        btncompany.isSelected = true
        btnSupplier.isSelected = false
        pageIndex = 1
        self.onLoadDetail()
    }
    
    @IBAction func btnSupplierAction(_ sender: UIButton)
    {
        btncontractor.isSelected = false
        btncompany.isSelected = false
        btnSupplier.isSelected = true
        pageIndex = 1
        self.onLoadDetail()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        DispatchQueue.main.async {
            self.tabViewHeightConstraint.constant = self.tvconnections.contentSize.height
            self.scroll.contentSize = CGSize(width: self.scroll.frame.width, height: self.tvconnections.frame.origin.y+self.tabViewHeightConstraint.constant+10)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        tableView.SetTableViewBlankLable(count: self.connectionList.Result.count, str: "Connection list empty.")
        return self.connectionList.Result.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectionNewCell
        cell.lblName.text = self.connectionList.Result[indexPath.row].Name as String!
        cell.lblDis.text =  self.connectionList.Result[indexPath.row].Description as String!

        cell.lblAway.text = "\(self.connectionList.Result[indexPath.row].CityName) - \(self.connectionList.Result[indexPath.row].DistanceAwayText)"
        
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
                     "PageType":self.connectionList.Result[sender.tag].PageType] as [String : Any]
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
        if(self.connectionList.Result[index].Role == 0)
        {
            print("Admin")
        }
        else if(self.connectionList.Result[index].Role == 1)
        {
            print("Contractor")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
            vc.userId = self.connectionList.Result[index].UserID
            self.navigationController?.pushViewController(vc, animated: true)
                        
        }
        else if(self.connectionList.Result[index].Role == 2)
        {
            print("Company")
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            companyVC.userId = self.connectionList.Result[index].UserID
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else if(self.connectionList.Result[index].Role == 3)
        {
            print("Supplier")
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
            companyVC.userId = self.connectionList.Result[index].UserID
            self.navigationController?.pushViewController(companyVC, animated: true)
            
        }
    }
}
