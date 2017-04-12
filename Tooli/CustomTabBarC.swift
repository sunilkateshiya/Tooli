//
//  CustomTabBarC.swift
//  SMUJ
//
//  Created by Moin Shirazi on 07/12/16.
//  Copyright © 2016 Moin Shirazi. All rights reserved.
//

import UIKit

class CustomTabBarC: UITabBarController {
    
@IBOutlet weak var myTabBar: UITabBar?
     let sharedManager : Globals = Globals.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setTabBarItems),
            name: NSNotification.Name(rawValue: "RefreshSideMenu"),
            object: nil)

        setTabBarItems()
       
        // Do any additional setup after loading the view.
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    override func viewWillAppear(_ animated: Bool) {
     
    }
    func setTabBarItems(){
    
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "Ic_Home")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem1.tag = 123456
        myTabBarItem1.selectedImage = UIImage(named: "Ic_Home")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem1.title = ""
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "ic_Jobs")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "ic_Jobs")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem2.title = ""
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        
        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.image = UIImage(named: "ic_AddButton")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem3.selectedImage = UIImage(named: "ic_AddButton")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem3.title = ""
        myTabBarItem3.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: 0)
        
        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        myTabBarItem4.image = UIImage(named: "Ic_NotificationBell")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem4.selectedImage = UIImage(named: "Ic_NotificationBell")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem4.title = ""
        myTabBarItem4.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        
        if(sharedManager.unreadNotification != 0)
        {
            myTabBarItem4.badgeValue = "\(sharedManager.unreadNotification)"
            if #available(iOS 10.0, *) {
                myTabBarItem4.badgeColor = UIColor.black
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
           myTabBarItem4.badgeValue = nil
        }
      
        let myTabBarItem5 = (self.tabBar.items?[4])! as UITabBarItem
        myTabBarItem5.image = UIImage(named: "Ic_Message")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem5.selectedImage = UIImage(named: "Ic_Message")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem5.title = ""
        myTabBarItem5.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        if(sharedManager.unreadMessage != 0)
        {
            myTabBarItem5.badgeValue = "\(sharedManager.unreadMessage)"
            if #available(iOS 10.0, *) {
                myTabBarItem5.badgeColor = UIColor.black
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            myTabBarItem5.badgeValue = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 123456)
        {
            AppDelegate.sharedInstance().moveToDashboard()
        }
    }

}
