//
//  NotificationTab.swift
//  Tooli
//
//  Created by Moin Shirazi on 10/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.

import UIKit
import ENSwiftSideMenu
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
import Kingfisher
class NotificationTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable  {

    @IBOutlet var tvnoti : UITableView!
    var sharedManager : Globals = Globals.sharedInstance
    var currentPage = 1
    var notificationList : AppNotificationsList = AppNotificationsList();
    var isFull : Bool = false
    var isFirstTime : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        tvnoti.delegate = self
        tvnoti.dataSource = self
        tvnoti.rowHeight = UITableViewAutomaticDimension
        tvnoti.estimatedRowHeight = 450
        tvnoti.tableFooterView = UIView()
        
       
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        getNotifications(page: self.currentPage);
    }
    
    func getNotifications(page : Int){
        if self.isFirstTime {
            self.startAnimating()
        }
        else {
            let view : UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: 80))
            let activity : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            activity.startAnimating()
            view.addSubview(activity)
            self.tvnoti.tableFooterView = view
        }
        var param = [:] as [String : Any]
        param["ContractorID"] = sharedManager.currentUser.ContractorID
        param["ContractorID"] = "1"
        param["PageIndex"] = page
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.NotificationList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            

            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil {
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    if self.isFirstTime {
                        self.notificationList = Mapper<AppNotificationsList>().map(JSONObject: JSONResponse.rawValue)!
                        self.isFirstTime = false;
                    }
                    else {
                        let tmpList : AppNotificationsList = Mapper<AppNotificationsList>().map(JSONObject: JSONResponse.rawValue)!
                        for tmpNotifcation in tmpList.DataList {
                            self.notificationList.DataList.append(tmpNotifcation)
                        }
                        self.currentPage = self.currentPage + 1
                    }
                    self.tvnoti.reloadData()
                    //self.setValues()
                }
                else
                {
                    self.stopAnimating()
                    self.isFull = true
                    self.isFirstTime = false;
                    //self.currentPage = 1
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                    //self.tvnoti.reloadData()
                }
                
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenu(button: AnyObject)
    {
        toggleSideMenuView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
       
        guard notificationList != nil else {
            return 0
        }
        
        return  notificationList.DataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == notificationList.DataList.count-1  {
            self.getNotifications(page: currentPage)
        }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTabCell
            cell.lbltitle.text = notificationList.DataList[indexPath.row].NotificationText
            cell.lbldate.text = notificationList.DataList[indexPath.row].AddedOn
            

            
            let url = URL(string: notificationList.DataList[indexPath.row].ProfileImageLink)!
            let resource = ImageResource(downloadURL: url, cacheKey: notificationList.DataList[indexPath.row].ProfileImageLink)

             cell.imguser.kf.setImage(with: resource)
            cell.imguser.clipsToBounds = true
            cell.imguser.cornerRadius = cell.imguser.frame.width / 2
            
            return cell
     
        
       
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let tblheight = self.notificationList.DataList.count * 80
        
        if scrollView.contentOffset.y > CGFloat(tblheight) {
            self.getNotifications(page: currentPage )
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
