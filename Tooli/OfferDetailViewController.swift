//
//  JodDetailViewController.swift
//  Tooli
//
//  Created by Impero IT on 13/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class OfferDetailViewController: UIViewController
{
    @IBOutlet weak var lblCatagory: UILabel!
    @IBOutlet weak var ViewWidthConstrain: NSLayoutConstraint!
    @IBOutlet var lblcompany: UILabel!
    @IBOutlet var lblwork: UILabel!
    @IBOutlet var lblstart: UILabel!
    @IBOutlet var lblfinish: UILabel!
    @IBOutlet var imguser: UIImageView!
    
    @IBOutlet weak var txtJobDetail: UITextView!
    @IBOutlet weak var ScrollView: UIScrollView!

    var OfferDetail:OfferListM!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.ViewWidthConstrain.constant = self.view.frame.width
        
        lblcompany.text = self.OfferDetail.Title as String!
        lblstart.text = self.OfferDetail.PriceTag as String!
        lblfinish.text = self.OfferDetail.AddedOn as String!
//        lblwork.text = self.OfferDetail.TradeCategoryName as String!
        lblCatagory.text = self.OfferDetail.TradeCategoryName as String!
//        //  cell.lbldatetime = self.
        
        let imgURL = self.OfferDetail.ProfileImageLink as String!
        
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        txtJobDetail.text = self.OfferDetail.Description
        
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
