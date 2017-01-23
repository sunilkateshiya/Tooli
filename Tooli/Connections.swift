//
//  Connections.swift
//  Tooli
//
//  Created by Moin Shirazi on 12/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class Connections: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet var tvconnections : UITableView!
    @IBOutlet var btncompany : UIButton!
    @IBOutlet var btncontractor : UIButton!
    @IBOutlet var btnfollowing : UIButton!
    @IBOutlet var btnfollower : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvconnections.delegate = self
        tvconnections.dataSource = self
        tvconnections.rowHeight = UITableViewAutomaticDimension
        tvconnections.estimatedRowHeight = 100
        tvconnections.tableFooterView = UIView()
        
        btncompany.isSelected = true
        btnfollower.isSelected = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnFollowing(_ sender: Any) {
        
    }
   
    @IBAction func btnFollowers(_ sender: Any) {
        
    }
    
    
    @IBAction func btnContractor(_ sender: Any) {
        
    }
    
    @IBAction func btnCompany(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        return  5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectionCell
        cell.lblcompany.text = "JLE Electricals"
        cell.lblwork.text = "Electrical work"
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
