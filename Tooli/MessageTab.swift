//
//  MessageTab.swift
//  Tooli
//
//  Created by Moin Shirazi on 10/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//


import UIKit
import ENSwiftSideMenu

class MessageTab: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate   {

    @IBOutlet var tvmsg : UITableView!
    @IBOutlet weak var SearchbarView: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        tvmsg.delegate = self
        tvmsg.dataSource = self
        tvmsg.rowHeight = UITableViewAutomaticDimension
        tvmsg.estimatedRowHeight = 450
        tvmsg.tableFooterView = UIView()
        
         AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)
        // Do any additional setup after loading the view.
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
        
        return  10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTabCell
        cell.lblname.text = "Colin Surname"
        cell.lbltime.text = "Just Now"
        cell.lblmsg.text = "This is just demo text message."
        
        cell.imguser.image = UIImage(named: "image")
        return cell
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
