//
//  JobCenter.swift
//  Tooli
//
//  Created by Moin Shirazi on 11/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Popover
import ENSwiftSideMenu

class JobCenter: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate{

    @IBOutlet var tvjobs : UITableView!
    @IBOutlet var btnSortby : UIButton!

    var popover = Popover()

    override func viewDidLoad() {
        super.viewDidLoad()

        tvjobs.delegate = self
        tvjobs.dataSource = self
        tvjobs.rowHeight = UITableViewAutomaticDimension
        tvjobs.estimatedRowHeight = 100
        tvjobs.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnMenu(button: AnyObject)
    {
        toggleSideMenuView()
    }
    

    func popOver() {
        
        
            let width = self.btnSortby.frame.width
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 80))
        
            let Share = UIButton(frame: CGRect(x: 15, y: 0, width: width - 30, height: 40))
            Share.setTitle("Recently Added", for: .normal)
            Share.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
            Share.contentHorizontalAlignment = .left
            Share.setTitleColor(UIColor.darkGray, for: .normal)
            Share.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        let border = CALayer()
        let width1 = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: Share.frame.size.height - width1, width:  Share.frame.size.width, height: Share.frame.size.height)
        
        border.borderWidth = width1
        Share.layer.addSublayer(border)
        Share.layer.masksToBounds = true
        
            
            let Delete = UIButton(frame: CGRect(x: 15, y: 40, width: width - 30, height: 40))
            Delete.setTitle("Nearest", for: .normal)
            Delete.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
            Delete.setTitleColor(UIColor.darkGray, for: .normal)
            Delete.contentHorizontalAlignment = .left
            Delete.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
        
        
            aView.addSubview(Delete)
            aView.addSubview(Share)
            
       
        let options = [
            .type(.down),
            .cornerRadius(4)
            ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(aView, fromView:btnSortby)
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func press(button: UIButton) {
        
        popover.dismiss()

    }
    @IBAction func btnBack(_ sender: Any) {
        
       _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSortBy(_ sender: Any) {
        
        popOver()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        return  5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JobCenterCell
        cell.lblcompany.text = "JLE Electricals"
        cell.lblwork.text = "Electrical work"
        cell.lblexperience.text = "Experienced Worker"
        cell.lblstartfinish.text = "Start : 15/1/2016 Finish : 2/2/2016"
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
