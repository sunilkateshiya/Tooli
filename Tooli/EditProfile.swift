//
//  EditProfile.swift
//  Tooli
//
//  Created by Impero-Moin on 19/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class EditProfile: UIViewController, UITableViewDataSource, UITableViewDelegate{

     
     
     @IBOutlet weak var TblSelectSkill: UITableView!
     @IBOutlet weak var SkillHeightConstraints: NSLayoutConstraint!
     @IBOutlet weak var BtnSkill: UIButton!

     
     @IBOutlet weak var TblSelectTrade: UITableView!
     @IBOutlet weak var TradeHeightConstraints: NSLayoutConstraint!
     @IBOutlet weak var BtnTrade: UIButton!

     
     @IBOutlet weak var ImgProfilePic: UIImageView!
     @IBOutlet weak var TxtName: UITextField!
     @IBOutlet weak var TxtSurname: UITextField!
     @IBOutlet weak var TxtDOB: UITextField!
     @IBOutlet weak var TxtViewAboutme: UITextView!
     @IBOutlet weak var TxtReferalCode: UITextField!
     @IBOutlet weak var TxtMiles: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
     
     TradeHeightConstraints.constant = 0
     SkillHeightConstraints.constant = 0
     
     
     TblSelectTrade.delegate = self
     TblSelectTrade.dataSource = self
     TblSelectTrade.rowHeight = UITableViewAutomaticDimension
     TblSelectTrade.estimatedRowHeight = 450
     TblSelectTrade.tableFooterView = UIView()
     
     TblSelectSkill.delegate = self
     TblSelectSkill.dataSource = self
     TblSelectSkill.rowHeight = UITableViewAutomaticDimension
     TblSelectSkill.estimatedRowHeight = 450
     TblSelectSkill.tableFooterView = UIView()
     

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
     @IBAction func BtnBackTapped(_ sender: Any) {
     }
     @IBAction func BtnEditProfileTapped(_ sender: Any) {
     }
     @IBAction func BtnTradeTapped(_ sender: Any) {
        
          if BtnTrade.isSelected {
               TradeHeightConstraints.constant = 0
               BtnTrade.isSelected = false
          }
          else{
               BtnTrade.isSelected = true
               TradeHeightConstraints.constant = 44 * 10
               
               TblSelectTrade.reloadData()
          }

     }
     @IBAction func BtnSkillTapped(_ sender: Any) {
          if BtnSkill.isSelected {
               SkillHeightConstraints.constant = 0
               BtnSkill.isSelected = false
          }
          else{
               BtnSkill.isSelected = true
               SkillHeightConstraints.constant = 44 * 10
               
               TblSelectSkill.reloadData()
          }
     }
     @IBAction func BtnUpdateProfileTapped(_ sender: Any) {
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
          //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
          
          return  10
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
          
          if tableView == self.TblSelectTrade {
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

     
     
     
}
