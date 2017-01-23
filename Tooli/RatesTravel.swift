//
//  RatesTravel.swift
//  Tooli
//
//  Created by Moin Shirazi on 19/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class RatesTravel: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var txtfrom : UITextField!
    @IBOutlet var txtuntil : UITextField!
    
    @IBOutlet var tvtrades : UITableView!
    
    @IBOutlet var btntrades : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvtrades.delegate = self
        tvtrades.dataSource = self
        tvtrades.rowHeight = UITableViewAutomaticDimension
        tvtrades.estimatedRowHeight = 450
        tvtrades.tableFooterView = UIView()
        
        tvtrades.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btntrades(_ sender: Any) {
        
        if btntrades.isSelected {
            tvtrades.isHidden = true
            btntrades.isSelected = false
        }
        else{
            btntrades.isSelected = true
            tvtrades.isHidden = false

            tvtrades.reloadData()
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
