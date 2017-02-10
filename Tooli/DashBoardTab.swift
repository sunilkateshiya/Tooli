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

class DashBoardTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable{

    @IBOutlet var tvdashb : UITableView!
    var sharedManager : Globals = Globals.sharedInstance
    var dashlist : [DashBoardM]?
    @IBOutlet var vwnolist : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        tvdashb.delegate = self
        tvdashb.dataSource = self
        tvdashb.rowHeight = UITableViewAutomaticDimension
        tvdashb.estimatedRowHeight = 100
        tvdashb.tableFooterView = UIView()
        self.vwnolist?.isHidden = true
        onLoadDetail()
        // Do any additional setup after loading the view.
    }
    
    func onLoadDetail(){
        
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorDashboard, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.dashBoard = Mapper<ContractorDashBoard>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {        self.vwnolist?.isHidden = true
                    self.dashlist = self.sharedManager.dashBoard.DataList
                    self.tvdashb.reloadData()
                   }
                else
                {
                    self.vwnolist?.isHidden = false

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        guard  ((sharedManager.dashBoard) != nil) else {
            
            return 0
        }
        if  (self.dashlist == nil){
            self.dashlist = sharedManager.dashBoard.DataList
            return  (self.dashlist?.count)!;
        }
        return  (self.dashlist?.count)!;
    }
    
    @IBAction func btnMenu(button: AnyObject)
    {
        toggleSideMenuView()
    }
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashBoardTvCell
        cell.lbltitle.text = self.dashlist?[indexPath.row].Title as String!
        cell.lbldate.text = self.dashlist?[indexPath.row].TitleCaption as String!
        cell.lblhtml.text = self.dashlist?[indexPath.row].JobTitle as String!
        
        let imgURL = self.dashlist?[indexPath.row].ProfileImageLink as String!
        let url = URL(string: imgURL!)
        cell.imguser.kf.indicatorType = .activity
        cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        cell.cvimgcnt = self.dashlist?[indexPath.row].PortfolioImageList?.count
        cell.portimgs = self.dashlist?[indexPath.row].PortfolioImageList
        
        cell.btnProfile!.tag=indexPath.row
        cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
        
        cell.btnPortfolio!.tag=indexPath.row
        cell.btnPortfolio?.addTarget(self, action: #selector(btnPortfolio(btn:)), for: UIControlEvents.touchUpInside)
        
        cell.btnfav!.tag=indexPath.row
        cell.btnfav?.addTarget(self, action: #selector(JobCenter.btnfav(btn:)), for: UIControlEvents.touchUpInside)
        
        if self.dashlist?[indexPath.row].IsSaved == true {
            cell.btnfav.isSelected = true
        }
        else{
            cell.btnfav.isSelected = false

        }
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width - 46
        screenHeight = screenSize.height
        
        let cvimgcnt : Int = (self.dashlist?[indexPath.row].PortfolioImageList?.count)!
        if cvimgcnt == 0 {
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: (Constants.ScreenSize.SCREEN_WIDTH-46)/3, height: (Constants.ScreenSize.SCREEN_WIDTH-46)/3)
//            layout.minimumInteritemSpacing = 5
//            layout.minimumLineSpacing = 2
//            layout.scrollDirection = .vertical
            cell.cvheightconst.constant = 0
           // cell.cvport!.collectionViewLayout = layout
            
        }
            
        else if cvimgcnt == 1{
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: (Constants.ScreenSize.SCREEN_WIDTH-46)/2, height: (Constants.ScreenSize.SCREEN_WIDTH-46)/2)
//            layout.minimumInteritemSpacing = 5
//            layout.minimumLineSpacing = 2
//            layout.scrollDirection = .vertical
            cell.cvheightconst.constant = (Constants.ScreenSize.SCREEN_WIDTH-46)
            //cell.cvport!.collectionViewLayout = layout
            
        }
            
        else if cvimgcnt == 2{
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: (Constants.ScreenSize.SCREEN_WIDTH-46)/2, height: screenWidth/2)
//            layout.minimumInteritemSpacing = 5
//            layout.minimumLineSpacing = 2
//            layout.scrollDirection = .vertical
            cell.cvheightconst.constant = (Constants.ScreenSize.SCREEN_WIDTH-46)/2
            //cell.cvport!.collectionViewLayout = layout
            
            
        }
        else if cvimgcnt == 3{
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: (Constants.ScreenSize.SCREEN_WIDTH-46)/3, height: (Constants.ScreenSize.SCREEN_WIDTH-46)/3)
//            layout.minimumInteritemSpacing = 5
//            layout.minimumLineSpacing = 2
//            layout.scrollDirection = .vertical
            cell.cvheightconst.constant = (Constants.ScreenSize.SCREEN_WIDTH-46)/3
            //cell.cvport!.collectionViewLayout = layout
            
        }

        
 cell.cvport.reloadData()
        return cell
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
        
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.dashlist?[btn.tag].PrimaryID ?? "",
                     "PageType":1] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.jobList = Mapper<JobList>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.tvdashb.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let obj : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
//        obj.ContractorID = 
//        self.navigationController?.pushViewController(obj, animated: true)
        
        
    }
}

