//
//  SlidingMenu.swift
//  AgilisCustomer
//
//  Created by Impero-Moin on 07/10/16.
//  Copyright © 2016 Impero IT. All rights reserved.
//

import UIKit
import Kingfisher
import Toast_Swift
class SlidingMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {
     @IBOutlet var tableview : UITableView?
     @IBOutlet var ivimage : UIImageView?
    
     var sharedManager : Globals = Globals.sharedInstance
     
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
    
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
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
          return 8
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
        
        cell!.textLabel?.textAlignment = .right
        cell?.selectionStyle = .none
        let imgView:UIImageView = UIImageView()
        imgView.frame = CGRect(x: 0, y: ((cell?.frame.height)!/2)-10, width: 25, height: 20)
       
        cell?.accessoryView = imgView
        
          if indexPath.row == 0 {
               cell!.textLabel?.text = "   PROFILE "
               imgView.image = #imageLiteral(resourceName: "NProfile")
          }
          else if indexPath.row == 1 {
            cell!.textLabel?.text = "   MESSAGES"
            imgView.image = #imageLiteral(resourceName: "NMessage")
          }
          else if indexPath.row == 2 {
             cell!.textLabel?.text = "   JOBS"
             imgView.image = #imageLiteral(resourceName: "NSettings")
          }
          else if indexPath.row == 3 {
             cell!.textLabel?.text = "   CONTRACTOR SEARCH"
             imgView.image = #imageLiteral(resourceName: "NContractor")
          }
          else if indexPath.row == 4 {
             cell!.textLabel?.text = "   SAVED"
             imgView.image = #imageLiteral(resourceName: "NSaved")
          }
          
          else if indexPath.row == 5 {
            cell!.textLabel?.text = "   CONNECTIONS"
            imgView.image = #imageLiteral(resourceName: "Nconnections")
          }
          else if indexPath.row == 6 {
             cell!.textLabel?.text = "   REFERRAL"
             imgView.image = #imageLiteral(resourceName: "Nconnections")
            }
          else if indexPath.row == 7 {
             cell!.textLabel?.text = "   LOGOUT"
             imgView.image = #imageLiteral(resourceName: "Nconnections")
        }
       
          return cell!
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 50.0
     }
     
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          //Present new view controller
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
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ContractorSearch")
            break
          case 4:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SavedView")
               
               break
          case 5:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Connections")
            break
            
          case 6:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Referrals")
            break
          case 7:
               callWSSignOut()
               
               let userDefaults = UserDefaults.standard
               userDefaults.set(false, forKey: Constants.KEYS.LOGINKEY)
               userDefaults.set(false, forKey: Constants.KEYS.ISINITSIGNALR)
               userDefaults.synchronize()
               let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
               app.moveToLogin()
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Login")
               break
          default:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController4")
               break
          }
        if indexPath.row != 7{
            self.navigationController?.pushViewController(destViewController, animated: true)
            sideMenuController()?.setContentViewController(destViewController)
        }
     }
     

     func callWSSignOut()
     {
        
     }
   
}
