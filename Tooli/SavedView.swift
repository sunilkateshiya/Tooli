//
//  SavedView.swift
//  Tooli
//
//  Created by Impero IT on 15/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Popover
import Kingfisher
import ActionSheetPicker_3_0
import ObjectMapper
import NVActivityIndicatorView
import GooglePlaces
import Toast_Swift
import Alamofire

class SavedView: UIViewController, NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var BtnType: UIButton!
    var popover = Popover()
    let sharedManager : Globals = Globals.sharedInstance
    var dashlist : [DashBoardM]?
    
    @IBOutlet var tvdashb : UITableView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tvdashb.delegate = self
        tvdashb.dataSource = self
        tvdashb.rowHeight = UITableViewAutomaticDimension
        tvdashb.estimatedRowHeight = 100
        tvdashb.tableFooterView = UIView()
        
      //  onLoadDetail()
        // Do any additional setup after loading the view.
    }
   
    @IBAction func BtnTypeTapped(_ sender: UIButton) {
        
        self .popOver()
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func popOver() {
        
        
        let width = self.view.frame.size.width
        let aView = UIView(frame: CGRect(x: 10, y: 25, width: width, height: 180))
    
        let Share = UIButton(frame: CGRect(x: 10, y: 0, width: width - 30, height: 40))
        Share.setTitle("All", for: .normal)
        Share.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Share.contentHorizontalAlignment = .left
        Share.setTitleColor(UIColor.darkGray, for: .normal)
        Share.tag = 30001
        Share.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        
        let border = CALayer()
        let width1 = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: Share.frame.size.height - width1, width:  Share.frame.size.width, height: Share.frame.size.height)
        
        border.borderWidth = width1
        Share.layer.addSublayer(border)
        Share.layer.masksToBounds = true
        
        
        let Companie = UIButton(frame: CGRect(x: 10, y: 40, width: width - 30, height: 40))
        Companie.setTitle("Companie", for: .normal)
        Companie.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Companie.setTitleColor(UIColor.darkGray, for: .normal)
        Companie.contentHorizontalAlignment = .left
        Companie.tag = 30002
        Companie.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        let borderDelete = CALayer()
        let widthDelete = CGFloat(1.0)
        borderDelete.borderColor = UIColor.lightGray.cgColor
        borderDelete.frame = CGRect(x: 0, y: Companie.frame.size.height - width1, width:  Companie.frame.size.width, height: Companie.frame.size.height)
        
        borderDelete.borderWidth = widthDelete
        Companie.layer.addSublayer(borderDelete)
        Companie.layer.masksToBounds = true
        
    
        
        let Contractor = UIButton(frame: CGRect(x: 10, y: 80, width: width - 30, height: 40))
        Contractor.setTitle("Contractor", for: .normal)
        Contractor.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Contractor.setTitleColor(UIColor.darkGray, for: .normal)
        Contractor.contentHorizontalAlignment = .left
        Contractor.tag = 30003
        Contractor.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        let Posts = UIButton(frame: CGRect(x: 10, y: 120, width: width - 30, height: 40))
        Posts.setTitle("Posts", for: .normal)
        Posts.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Posts.setTitleColor(UIColor.darkGray, for: .normal)
        Posts.contentHorizontalAlignment = .left
        Posts.tag = 30004
        Posts.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        let Jobs = UIButton(frame: CGRect(x: 10, y: 160, width: width - 30, height: 40))
        Jobs.setTitle("Jobs", for: .normal)
        Jobs.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Jobs.setTitleColor(UIColor.darkGray, for: .normal)
        Jobs.contentHorizontalAlignment = .left
        Jobs.tag = 30005
        Jobs.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        let Offers = UIButton(frame: CGRect(x: 10, y: 180, width: width - 30, height: 40))
        Offers.setTitle("Offers", for: .normal)
        Offers.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
        Offers.setTitleColor(UIColor.darkGray, for: .normal)
        Offers.contentHorizontalAlignment = .left
        Offers.tag = 30006
        Offers.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        
        
        aView.addSubview(Share)
        aView.addSubview(Companie)
        aView.addSubview(Contractor)
        aView.addSubview(Posts)
        aView.addSubview(Jobs)
        aView.addSubview(Offers)
        
        
        let options = [
            .type(.down),
            .cornerRadius(4)
            ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(aView, fromView:BtnType)
        
    }
    func press(button: UIButton) {
        
        self.startAnimating()
        let param = ["AvailableStatusID": button.tag - 20000,
                     "ContractorID": self.sharedManager.currentUser.ContractorID,] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorChangeStatus, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            // self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    self.popover.dismiss()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                    
                }
                else
                {
                    self.stopAnimating()
                    self.popover.dismiss()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.popover.dismiss()
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cvimgcnt : Int = 1
       // let cvimgcnt : Int = (self.dashlist?[indexPath.row].PortfolioImageList?.count)!
        if cvimgcnt == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashBoardTvCell
            cell.lbltitle.text = self.dashlist?[indexPath.row].Title as String!
            cell.lbldate.text = self.dashlist?[indexPath.row].TitleCaption as String!
            cell.lblhtml.text = self.dashlist?[indexPath.row].JobTitle as String!
            
            let imgURL = self.dashlist?[indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            cell.btnProfile!.tag=indexPath.row
            cell.btnProfile?.addTarget(self, action: #selector(btnProfile(btn:)), for: UIControlEvents.touchUpInside)
            
            
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(JobCenter.btnfav(btn:)), for: UIControlEvents.touchUpInside)
            
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
            cell.lbltitle.text = self.dashlist?[indexPath.row].Title as String!
            cell.lbldate.text = self.dashlist?[indexPath.row].TitleCaption as String!
            cell.lblhtml.text = self.dashlist?[indexPath.row].JobTitle as String!
            
            let imgURL = self.dashlist?[indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
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
            
            let imgURL1 = self.dashlist?[indexPath.row].PortfolioImageList?[0].PortfolioImageLink as String!
            let url1 = URL(string: imgURL1!)
            cell.img1.kf.indicatorType = .activity
            cell.img1.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            return cell
            
        }
            
        else if cvimgcnt == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DashBoardTv2Cell
            cell.lbltitle.text = self.dashlist?[indexPath.row].Title as String!
            cell.lbldate.text = self.dashlist?[indexPath.row].TitleCaption as String!
            cell.lblhtml.text = self.dashlist?[indexPath.row].JobTitle as String!
            
            let imgURL = self.dashlist?[indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
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
            cell.lbltitle.text = self.dashlist?[indexPath.row].Title as String!
            cell.lbldate.text = self.dashlist?[indexPath.row].TitleCaption as String!
            cell.lblhtml.text = self.dashlist?[indexPath.row].JobTitle as String!
            
            let imgURL = self.dashlist?[indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imguser.kf.indicatorType = .activity
            cell.imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
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
    func btnProfile (btn : UIButton)
    {
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
            
            self.sharedManager.jobList = Mapper<JobList>().map(JSONObject: JSONResponse.rawValue)
            
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
                
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
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
                {       // self.vwnolist?.isHidden = true
                    
                    self.dashlist = self.sharedManager.dashBoard.DataList
                    self.tvdashb.reloadData()
                }
                else
                {
                  //  self.vwnolist?.isHidden = false
                    
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

}
