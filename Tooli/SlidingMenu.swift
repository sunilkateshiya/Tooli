//
//  SlidingMenu.swift
//  AgilisCustomer
//
//  Created by Impero-Moin on 07/10/16.
//  Copyright © 2016 Impero IT. All rights reserved.
//

import UIKit
import Kingfisher

class SlidingMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {
     @IBOutlet var tableview : UITableView?
     @IBOutlet var ivimage : UIImageView?
    
     var sharedManager : Globals = Globals.sharedInstance
     
    override func viewDidLoad() {
        super.viewDidLoad()
     
     tableview?.tableFooterView = UIView()
     tableview?.tableHeaderView = UIView()
     
        
//        let url = URL(string: "http://domain.com/image.png")!
//        ivimage?.kf.setImage(with: url,
//                             placeholder: UIImage(named:"ic_Logo"),
//                              options: [.transition(.fade(1))],
//                              progressBlock: nil,
//                              completionHandler: nil)
//        
    
     
        // Do any additional setup after loading the view.
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
          return 5
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
          if indexPath.row == 0 {
               cell!.textLabel?.text = "   PROFILE"
          }
          else if indexPath.row == 1 {
               cell!.textLabel?.text = "   CONNECTIONS"
          }
          else if indexPath.row == 2 {
               cell!.textLabel?.text = "   JOBS"
          }
          else if indexPath.row == 3 {
               cell!.textLabel?.text = "   SAVED"
          }
          else if indexPath.row == 4 {
               cell!.textLabel?.text = "   MESSAGES"
          }
       
          return cell!
     }
     
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
          return 50.0
     }
     
      func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
          //Present new view controller
          let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
          var destViewController : UIViewController
          switch (indexPath.row) {
          case 0:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashBoard")
               break
          case 1:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "TrackList")
               break
          case 2:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Rides")
               break
          case 3:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "PaymentCard")
               break
          case 4:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "Settings")
               break
          case 5:
               callWSSignOut()
               let userDefaults = UserDefaults.standard
               userDefaults.set(false, forKey: Constants.KEYS.LOGINKEY)
               userDefaults.synchronize()
               destViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
               break
          default:
               destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController4")
               break
          }
          sideMenuController()?.setContentViewController(destViewController)
     }
     

     func callWSSignOut()
     {
        
     }
   
}