//
//  JodDetailViewController.swift
//  Tooli
//
//  Created by Impero IT on 13/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class JodDetailViewController: UIViewController
{
    @IBOutlet weak var lblCatagory: UILabel!
    @IBOutlet var lblcompany: UILabel!
    @IBOutlet var lblwork: UILabel!
    @IBOutlet var lblstart: UILabel!
    @IBOutlet var lblfinish: UILabel!
    @IBOutlet var imguser: UIImageView!
    @IBOutlet var lblcity: UILabel!
    
    @IBOutlet weak var txtJobDetail: UITextView!
    @IBOutlet weak var ScrollView: UIScrollView!

    var jobDetail:JobListM!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblcity.text = self.jobDetail.CityName as String!
        lblcompany.text = self.jobDetail.Title as String!
        lblstart.text = self.jobDetail.StartOn as String!
        lblfinish.text = self.jobDetail.EndOn as String!
        lblwork.text = self.jobDetail.TradeCategoryName as String!
        lblCatagory.text = self.jobDetail.TradeCategoryName
        //  cell.lbldatetime = self.
        let imgURL = self.jobDetail.ProfileImageLink as String!
        
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        txtJobDetail.text = self.jobDetail.Description
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
