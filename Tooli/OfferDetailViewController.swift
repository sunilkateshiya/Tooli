//
//  JodDetailViewController.swift
//  Tooli
//
//  Created by Impero IT on 13/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ObjectMapper


class OfferDetailViewController: UIViewController,NVActivityIndicatorViewable
{
    @IBOutlet weak var buttomConstraints: NSLayoutConstraint!
    @IBOutlet weak var lblCatagory: UILabel!
    @IBOutlet weak var ViewWidthConstrain: NSLayoutConstraint!
    @IBOutlet var lblcompany: UILabel!
    @IBOutlet var lblwork: UILabel!
    @IBOutlet var lblstart: UILabel!
    @IBOutlet var lblfinish: UILabel!
    @IBOutlet var imguser: UIImageView!

    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var ScrollView: UIScrollView!
    var sharedManager : Globals = Globals.sharedInstance
    var OfferDetail:OfferListM!
    var OfferId = 0
    @IBOutlet weak var imgOffer: UIImageView!

    
    var isNotification:Bool =  false
    
    var OfferDetail1:OfferDetailM!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.ViewWidthConstrain.constant = self.view.frame.width
        
        if(isNotification)
        {
            getSpecialOfferDetail()
        }
        else
        {
             fillDatatoConttroller()
        }
        buttomConstraints.constant = 10
        // Do any additional setup after loading the view.
    }

    func fillDatatoConttroller()
    {
        lblcompany.text = self.sharedManager.selectedCompany.CompanyName as String!
        lblstart.text = self.OfferDetail.PriceTag as String!
        lblfinish.text = self.OfferDetail.AddedOn as String!
        lblwork.text = self.sharedManager.selectedCompany.TradeCategoryName as String!
        lblCatagory.text = self.OfferDetail.Title as String!
        //        //  cell.lbldatetime = self.
        
        let imgURL = self.sharedManager.selectedCompany.ProfileImageLink as String!
        
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        
        let imgURL1 = self.OfferDetail.OfferImageLink as String!
        let url1 = URL(string: imgURL1!)
        imgOffer.kf.indicatorType = .activity
        imgOffer.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        lblDiscription.text = self.OfferDetail.Description
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnBackToMainMenuAction(_ sender: UIButton)
    {
       AppDelegate.sharedInstance().moveToDashboard()
    }
    func getSpecialOfferDetail()
    {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "OfferID":OfferId] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.OfferInfo, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
        
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
             self.sharedManager.OfferDetail1 = Mapper<OfferDetailM>().map(JSONObject: JSONResponse.rawValue)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                   self.fillDatatoConttrollerFromApi()
                }
                else
                {
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            print(error.localizedDescription)
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func fillDatatoConttrollerFromApi()
    {
        lblcompany.text = self.OfferDetail1.CompanyName as String!
        lblstart.text = self.OfferDetail1.PriceTag as String!
        lblfinish.text = self.OfferDetail1.AddedOn as String!
        lblwork.text = self.OfferDetail1.CompanyTradeCategoryName as String!
        lblCatagory.text = self.OfferDetail1.Title as String!
        //        //  cell.lbldatetime = self.
        
        let imgURL = self.OfferDetail1.CompanyImageLink as String!
        
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        
        let imgURL1 = self.OfferDetail1.CompanyImageLink as String!
        let url1 = URL(string: imgURL1!)
        imgOffer.kf.indicatorType = .activity
        imgOffer.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        lblDiscription.text = self.OfferDetail1.Description
    }
}
