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
    var sharedManager : Globals = Globals.sharedInstance
    var jobDetail:JobListM!
    
    @IBOutlet weak var txtViewContantSize: NSLayoutConstraint!
    @IBOutlet weak var secondViewContranit: NSLayoutConstraint!
    @IBOutlet var  tagListView:TagListView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     //  txtViewContantSize.constant = 0
     //   secondViewContranit.constant = 0
        lblcity.text = self.jobDetail.CityName as String!
        lblcompany.text = self.sharedManager.selectedCompany.CompanyName as String!
        lblstart.text = self.jobDetail.StartOn as String!
        lblfinish.text = self.jobDetail.EndOn as String!
        lblwork.text = self.sharedManager.selectedCompany.TradeCategoryName as String!
        lblCatagory.text = self.jobDetail.Title
        //  cell.lbldatetime = self.
        let imgURL = self.sharedManager.selectedCompany.ProfileImageLink as String!
        
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        txtJobDetail.text = self.jobDetail.Description
        
        for (index,i) in (self.jobDetail.ServiceList?.enumerated())!
        {
            print(index)
            let color:UIColor!
             color = UIColor.lightGray
          tagListView.addTag((self.jobDetail.ServiceList?[index].Service)!, target: self, tapAction: "tap:", longPressAction: "longPress:",backgroundColor: color,textColor: UIColor.white)
        }
       // print(self.jobDetail.ServiceList)
        txtJobDetail.sizeToFit()
        txtViewContantSize.constant = txtJobDetail.frame.height
        secondViewContranit.constant = lblcity.frame.origin.y + lblcity.frame.height + 20
    }
    func tap(_ sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        print("tap from \(label.text!)")
    }
    func longPress(_ sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        print("long press from \(label.text!)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
