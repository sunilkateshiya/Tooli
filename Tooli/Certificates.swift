//
//  Certificates.swift
//  Tooli
//
//  Created by Moin Shirazi on 19/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class Certificates: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet var tvcerts : UITableView!
    
    @IBOutlet var btncerts : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvcerts.delegate = self
        tvcerts.dataSource = self
        tvcerts.rowHeight = UITableViewAutomaticDimension
        tvcerts.estimatedRowHeight = 450
        tvcerts.tableFooterView = UIView()
        
        tvcerts.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btncerts(_ sender: Any) {
        
        if btncerts.isSelected {
            tvcerts.isHidden = true
            btncerts.isSelected = false
        }
        else{
            btncerts.isSelected = true
            tvcerts.isHidden = false
            
            tvcerts.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        
        return  10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Trades " +  "\(indexPath.row)"
        return cell
        
        
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
    }
    
    @IBAction func btnSkip(_ sender: Any) {
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
