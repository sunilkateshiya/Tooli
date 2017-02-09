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
import TTTAttributedLabel
class NotificationTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable, TTTAttributedLabelDelegate  {

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
        
        let name : String = notificationList.DataList[indexPath.row].FullName;

        //let range : NSRange = NSMakeRange(0, name.length)
        //print(range);
            cell.lbltitle.text = notificationList.DataList[indexPath.row].FullName + " " + notificationList.DataList[indexPath.row].NotificationText

            cell.lbldate.text = notificationList.DataList[indexPath.row].AddedOn
        
        
        
        
        cell.lbltitle.delegate = self
        
        
        var statusMessage = ""
        
        switch notificationList.DataList[indexPath.row].NotificationStatusID {
        case 1:
            statusMessage = " sent you new message"
            break;
        case 2:
            statusMessage = " applied to your \(notificationList.DataList[indexPath.row].JobTitle) job"
            break;
        case 3:
            statusMessage = " started following you"
            break;
        case 4:
            statusMessage = " followed you via your share link"
            break;
        case 5:
            statusMessage = " company has posted new offer"
            break;
        default:
            statusMessage = " "
            break;
        }
        
        let finalText = name + statusMessage;
        
        let string = finalText
        let nsString = string as NSString
        let range = nsString.range(of: name)
        let range1 = nsString.range(of: "message")
        let range3 = nsString.range(of: notificationList.DataList[indexPath.row].JobTitle);
        let range4 = nsString.range(of: "offer");
        let keyID = notificationList.DataList[indexPath.row].IsContractor ? notificationList.DataList[indexPath.row].ContractorID : notificationList.DataList[indexPath.row].CompanyID
        
        cell.lbltitle.setText(finalText) { (mutableAttributedString) -> NSMutableAttributedString? in
            var boldSystemFont : UIFont = UIFont.boldSystemFont(ofSize: 16)
            if Constants.DeviceType.IS_IPHONE_5 {
                boldSystemFont=UIFont(name: (boldSystemFont.fontName), size: (boldSystemFont.pointSize)-1)!
            }
            if Constants.DeviceType.IS_IPHONE_6P {
                boldSystemFont=UIFont(name: (boldSystemFont.fontName), size: (boldSystemFont.pointSize)+4)!
            }
            if Constants.DeviceType.IS_IPAD {
                boldSystemFont=UIFont(name: (boldSystemFont.fontName), size: (boldSystemFont.pointSize)+7)!
            }
            
            mutableAttributedString?.addAttribute(String(kCTFontAttributeName), value: boldSystemFont, range: range)
            mutableAttributedString?.addAttribute(String(kCTFontAttributeName), value: boldSystemFont, range: range1)
            
            return mutableAttributedString;
        }
        let url1 = NSURL(string: "action://users/\(keyID)")!
        let url2 = NSURL(string: "action://message/\(notificationList.DataList[indexPath.row].PrimaryID)")!
        cell.lbltitle.addLink(to: url1 as URL!, with: range)
        cell.lbltitle.addLink(to: url2 as URL!, with: range1)
        cell.lbltitle.addLink(to: url2 as URL!, with: range3)
        cell.lbltitle.addLink(to: url2 as URL!, with: range4)
        
            let url = URL(string: notificationList.DataList[indexPath.row].ProfileImageLink)!
            let resource = ImageResource(downloadURL: url, cacheKey: notificationList.DataList[indexPath.row].ProfileImageLink)
            cell.imguser.kf.indicatorType = .activity
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
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print(url)
        
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
