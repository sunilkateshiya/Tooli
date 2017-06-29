//
//  SlidingMenu.swift
//  AgilisCustomer
//
//  Created by Impero-Moin on 07/10/16.
//  Copyright © 2016 Impero IT. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher
import SafariServices

class SlidingMenu: UIViewController, UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable {
     @IBOutlet var tableview : UITableView?
     @IBOutlet var ivimage : UIImageView?
    
     var sharedManager : Globals = Globals.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshPage),
            name: NSNotification.Name(rawValue: "RefreshSideMenu"),
            object: nil)
        
        tableview?.tableFooterView = UIView()
        tableview?.tableHeaderView = UIView()
        if (self.sharedManager.currentUser != nil) {
        if self.sharedManager.currentUser.ProfileImageLink != "" {
            let imgURL = self.sharedManager.currentUser.ProfileImageLink as String
            let urlPro = URL(string: imgURL)
            ivimage?.kf.indicatorType = .activity
           
            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.sharedManager.currentUser.ProfileImageLink)
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1)),
                .forceRefresh
            ]
            
            ivimage?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
            
            ivimage?.clipsToBounds = true
            ivimage?.cornerRadius = (ivimage?.frame.size.width)! / 2
        }
        }
//        let url = URL(string: "http://domain.com/image.png")!
//        ivimage?.kf.setImage(with: url,
//                             placeholder: UIImage(named:"ic_Logo"),
//                              options: [.transition(.fade(1))],
//                              progressBlock: nil,
//                              completionHandler: nil)
//        
    
     
        // Do any additional setup after loading the view.
    }
    func refreshPage()
    {
        self.stopAnimating()
       tableview?.reloadData()
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "SlidingMenu Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
    
      func numberOfSectionsInTableView(tableView: UITableView) -> Int {
          // Return the number of sections.
          return 1
     }
     
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          // Return the number of rows in the section.
          return 13
     }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
          
          if (cell == nil) {
               cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CELL")
               cell!.backgroundColor = UIColor.clear
               cell!.textLabel?.textColor = UIColor.white
               let selectedBackgroundView = UIView(frame:CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
               selectedBackgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
               cell!.selectedBackgroundView = selectedBackgroundView
          }
        var lblCount:UILabel = UILabel()
        lblCount.frame = CGRect(x: 0,y: 0, width: 25, height: 25)
        lblCount.backgroundColor = UIColor.black
        lblCount.layer.cornerRadius = 12.5
        lblCount.clipsToBounds = true
        lblCount.textColor = UIColor.white
        lblCount.textAlignment = .center
        lblCount.font = UIFont.boldSystemFont(ofSize: 15)
        for view in (cell?.textLabel?.subviews)!
        {
            view.removeFromSuperview()
        }
        if(indexPath.row == 1)
        {
            if(sharedManager.unreadMessage != 0)
            {
                lblCount.text = "\(sharedManager.unreadMessage)"
               
                cell?.textLabel?.addSubview(lblCount)
                lblCount.center = CGPoint(x: 25 , y: (cell?.textLabel?.center.y)!)
            }
        }
        
        if(indexPath.row == 3)
        {
            if(sharedManager.unreadSpecialOffer != 0)
            {
                lblCount.text = "\(sharedManager.unreadSpecialOffer)"
                cell?.textLabel?.addSubview(lblCount)
                lblCount.center = CGPoint(x: 25 , y: (cell?.textLabel?.center.y)!)
            }
        }
    
        cell!.textLabel?.textAlignment = .right
        cell?.selectionStyle = .none
        let imgView:UIImageView = UIImageView()
        imgView.frame = CGRect(x: 0, y: ((cell?.frame.height)!/2)-10, width: 25, height: 20)
       
        cell?.accessoryView = imgView
        
          if indexPath.row == 0 {
               cell!.textLabel?.text = "   Profile "
               imgView.image = #imageLiteral(resourceName: "NProfile")
          }
          else if indexPath.row == 1 {
            cell!.textLabel?.text = "   Messages"
            imgView.image = #imageLiteral(resourceName: "NMessage")
          }
          else if indexPath.row == 2 {
             cell!.textLabel?.text = "   Job Centre"
             imgView.image = #imageLiteral(resourceName: "NSettings")
          }
            else if indexPath.row == 3
          {
            cell!.textLabel?.text = "   Special Offers"
            imgView.image = #imageLiteral(resourceName: "NSpecialOffer")
            }
          else if indexPath.row == 4 {
             cell!.textLabel?.text = "   Contractor Search"
             imgView.image = #imageLiteral(resourceName: "NContractor")
          }
          else if indexPath.row == 5 {
             cell!.textLabel?.text = "   Saved"
             imgView.image = #imageLiteral(resourceName: "NSaved")
          }
          
          else if indexPath.row == 6 {
            cell!.textLabel?.text = "   Your Connections"
            imgView.image = #imageLiteral(resourceName: "Nconnections")
          }
          else if indexPath.row == 7 {
             cell!.textLabel?.text = "   Referral"
             imgView.image = #imageLiteral(resourceName: "Nconnections")
            }
          else if indexPath.row == 8 {
            cell!.textLabel?.text = "   Statistics"
            imgView.image = #imageLiteral(resourceName: "NStatistics")
          }
          else if indexPath.row == 9 {
            cell!.textLabel?.text = "   T & C"
            imgView.image = #imageLiteral(resourceName: "NTerms")
          }
          else if indexPath.row == 10 {
            cell!.textLabel?.text = "   Privacy Policy"
            imgView.image = #imageLiteral(resourceName: "NPrivacy")
          }
          else if indexPath.row == 11 {
             cell!.textLabel?.text = ""
             imgView.image = nil
        }
          else if indexPath.row == 12 {
            cell!.textLabel?.text = "   Log out"
            imgView.image = #imageLiteral(resourceName: "logout (1)")
        }
       
          return cell!
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 50.0
     }
     
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          //Present new view controller
        
        if(indexPath.row==11)
        {
            return
        }
        
          let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
          var destViewController : UIViewController
          switch (indexPath.row) {
          case 0:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfileFeed")
               break
          case 1:
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "MessageTab")
                break
          case 2:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "JobCenter")
               break
          case 3:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SpecialOfferList")
            break
          case 4:

             destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ContractorSearch")
            break
          case 5:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SavedView")
               
               break
          case 6:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Connections")
            break
            
          case 7:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Referrals")
            break
          case 8:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Statistics")
            break
          case 9:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "PDFViewer")
            let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
            port.strUrl = "https://www.tooli.co.uk/Files/Document/Terms_Condition.pdf"
            AppDelegate.sharedInstance().navigationController?.pushViewController(port, animated: true)
            toggleSideMenuView()
            break
          case 10:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "PDFViewer")
            let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
            port.strUrl = "https://www.tooli.co.uk/Files/Document/Privacy_Policy.pdf"
            AppDelegate.sharedInstance().navigationController?.pushViewController(port, animated: true)
            toggleSideMenuView()
            break
          case 11:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Referrals")
            break
          case 12:
               callWSSignOut()
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Login")
               break
          default:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController4")
               break
          }
       
        if(indexPath.row == 1)
        {
            let tabView:CustomTabBarC = mainStoryboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! CustomTabBarC
            tabView.selectedIndex = 4
            AppDelegate.sharedInstance().navigationController?.viewControllers = [tabView]
             toggleSideMenuView()
        }
        else if(indexPath.row == 2)
        {
            let tabView:CustomTabBarC = mainStoryboard.instantiateViewController(withIdentifier: "CustomTabBarC") as! CustomTabBarC
            tabView.selectedIndex = 1
            AppDelegate.sharedInstance().navigationController?.viewControllers = [tabView]
            toggleSideMenuView()
        }
        if indexPath.row != 9 && indexPath.row != 10 && indexPath.row != 11 && indexPath.row != 12 && indexPath.row != 1 && indexPath.row != 2 {
            self.navigationController?.pushViewController(destViewController, animated: true)
            sideMenuController()?.setContentViewController(destViewController)
        }
     }
     func callWSSignOut()
     {
        self.startAnimating()
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorSignOut, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["status"].rawValue as! String)
            if JSONResponse != nil{
                if JSONResponse["status"].rawString()! == "1"
                {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(false, forKey: Constants.KEYS.LOGINKEY)
                    userDefaults.set(false, forKey: Constants.KEYS.ISINITSIGNALR)
                    userDefaults.synchronize()
                    
                    let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    app.disconnectSignalR()
                    app.moveToLogin()
    
                }
                else
                {
                    
                }
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
     }
}
