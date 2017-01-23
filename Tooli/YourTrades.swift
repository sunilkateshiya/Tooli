//
//  YourTrades.swift
//  Tooli
//
//  Created by Moin Shirazi on 09/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class YourTrades: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var vwhide : UIView!
    @IBOutlet var vwhideheight : NSLayoutConstraint!
    
    @IBOutlet var tvtrades : UITableView!
    @IBOutlet var tvtradesheight : NSLayoutConstraint!
  
    @IBOutlet var tvskills : UITableView!
    @IBOutlet var tvskillsheight : NSLayoutConstraint!
    
    @IBOutlet var btnskills : UIButton!
    @IBOutlet var btntrades : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

       // vwhide.isHidden = true
        vwhideheight.constant = 0
        tvtradesheight.constant = 0
        tvskillsheight.constant = 0
        
        tvtrades.delegate = self
        tvtrades.dataSource = self
        tvtrades.rowHeight = UITableViewAutomaticDimension
        tvtrades.estimatedRowHeight = 450
        tvtrades.tableFooterView = UIView()
       
        tvskills.delegate = self
        tvskills.dataSource = self
        tvskills.rowHeight = UITableViewAutomaticDimension
        tvskills.estimatedRowHeight = 450
        tvskills.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btntrades(_ sender: Any) {
  
        if btntrades.isSelected {
            tvtradesheight.constant = 0
            btntrades.isSelected = false
        }
        else{
            btntrades.isSelected = true
            tvtradesheight.constant = 44 * 10

            tvtrades.reloadData()
        }
    }
   
    @IBAction func btnskills(_ sender: Any) {
        
        if btnskills.isSelected {
            tvskillsheight.constant = 0
            btnskills.isSelected = false
        }
        else{
            btnskills.isSelected = true
            tvskillsheight.constant = 44 * 10
            
            tvskills.reloadData()
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        
        return  10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == self.tvtrades {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = "Trades " +  "\(indexPath.row)"
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
            cell.textLabel?.text = "Skills " +  "\(indexPath.row)"
            return cell
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
