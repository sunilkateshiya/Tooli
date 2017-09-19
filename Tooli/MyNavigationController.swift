//
//  MyNavigationController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 30.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
class MyNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
         let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlidingMenu") as! SlidingMenu
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: viewcontroller, menuPosition:.right)
        //sideMenu?.delegate = self //optional
     sideMenu?.allowLeftSwipe = false;
     sideMenu?.allowRightSwipe = false;
     sideMenu?.menuWidth = 270.0 // optional, default is 160
        //sideMenu?.bouncingEnabled = false
        //sideMenu?.allowPanGesture = false
        // make navigation bar showing over side menu
     self.navigationBar.isHidden = true
        view.bringSubview(toFront: navigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
