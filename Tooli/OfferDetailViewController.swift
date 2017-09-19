//
//  JodDetailViewController.swift
//  Tooli
//
//  Created by Impero IT on 13/02/2017.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ObjectMapper
import SafariServices

class OfferDetailViewController: UIViewController,NVActivityIndicatorViewable
{
    @IBOutlet weak var btnOpenOffer: UIButton!
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
    var OfferDetail:OfferViewM = OfferViewM()
    var OfferId = 0
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgOffer: UIImageView!
    
    var isNotification:Bool =  false
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
        OfferId = self.OfferDetail.OfferID
        lblcompany.text = self.OfferDetail.CompanyName as String!
        lblstart.text = self.OfferDetail.PriceTag as String!
        lblfinish.text = self.OfferDetail.TimeCaption
        lblwork.text = "\(self.OfferDetail.TradeName)"
        lblCatagory.text = self.OfferDetail.Title as String!
        //        //  cell.lbldatetime = self.
        let imgURL = self.OfferDetail.ProfileImageLink as String!
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
    
        let imgURL1 = self.OfferDetail.ImageLink as String!
        let url1 = URL(string: imgURL1!)
        imgOffer.kf.indicatorType = .activity
        imgOffer.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        if(self.OfferDetail.IsSaved)
        {
            btnSave.isSelected = true
        }
        else
        {
            btnSave.isSelected = false
        }
        lblDiscription.text = self.OfferDetail.Description

        if(self.OfferDetail.Website != "")
        {
             btnOpenOffer.isHidden = false
        }
    }
    func lblNamedTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {

    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "OfferDetail Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
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
        let param = ["OfferID":OfferId] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.OfferDetail, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
        
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                self.OfferDetail = Mapper<OfferViewM>().map(JSONObject: JSONResponse["Result"].rawValue)!
                self.fillDatatoConttrollerFromApi()
            }
            else
            {
                _ = self.navigationController?.popViewController(animated: true)
                AppDelegate.sharedInstance().window?.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
            }
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    
    @IBAction func btnVisitAction(_ sender: UIButton)
    {
        if(isNotification)
        {
            guard let  url = URL(string: (self.OfferDetail.Website)) else
            {
                self.view.makeToast("Offer link is not available, for more details please contact \(self.OfferDetail.CompanyName)", duration: 3, position: .bottom)
                return
            }
            if(UIApplication.shared.canOpenURL(url))
            {
                if #available(iOS 9.0, *) {
                    let svc = SFSafariViewController(url: url)
                    present(svc, animated: true, completion: nil)
                } else {
                    let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                    port.strUrl = (self.OfferDetail.Website)
                    self.navigationController?.pushViewController(port, animated: true)
                }
            }
            else
            {
                self.view.makeToast("Offer link is not available, for more details please contact \(self.OfferDetail.CompanyName)", duration: 3, position: .bottom)
            }
        }
        else
        {
            guard let  url = URL(string: (self.OfferDetail.ReferralLink)) else
            {
                self.view.makeToast("Offer link is not available, for more details please contact \(self.OfferDetail.CompanyName)", duration: 3, position: .bottom)
                return
            }
            if(UIApplication.shared.canOpenURL(url))
            {
                if #available(iOS 9.0, *) {
                    let svc = SFSafariViewController(url: url)
                    present(svc, animated: true, completion: nil)
                } else {
                    let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                    port.strUrl = (self.OfferDetail.ReferralLink)
                    self.navigationController?.pushViewController(port, animated: true)
                }
            }
            else
            {
                self.view.makeToast("Offer link is not available, for more details please contact \(self.OfferDetail.CompanyName)", duration: 3, position: .bottom)
            }
        }
    }
    
    @IBAction func btnSaveAsFavorites(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":"\(OfferId)",
            "PageType":2] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                sender.isSelected = !sender.isSelected
            }
            self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }

    func fillDatatoConttrollerFromApi()
    {
        OfferId = self.OfferDetail.OfferID
        lblcompany.text = self.OfferDetail.CompanyName as String!
        lblstart.text = self.OfferDetail.PriceTag as String!
     //   lblfinish.text = self.OfferDetail.AddedOn as String!
        lblwork.text = self.OfferDetail.OfferTradeName as String!
        lblCatagory.text = self.OfferDetail.Title as String!
        //        //  cell.lbldatetime = self.
        
        let imgURL = self.OfferDetail.ProfileImageLink as String!
        
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        
        let imgURL1 = self.OfferDetail.ImageLink as String!
        let url1 = URL(string: imgURL1!)
        imgOffer.kf.indicatorType = .activity
        imgOffer.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        if(self.OfferDetail.IsSaved)
        {
            btnSave.isSelected = true
        }
        else
        {
            btnSave.isSelected = false
        }
        lblDiscription.text = self.OfferDetail.Description
        
        guard let url10 = URL(string: (self.OfferDetail.Website)) else
        {
            btnOpenOffer.isHidden = true
            return
        }
        if(UIApplication.shared.canOpenURL(url10))
        {
            btnOpenOffer.isHidden = false
        }
        else
        {
            btnOpenOffer.isHidden = true
        }
    }
    func lblNamedTaped1(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UILabel
        if(UIApplication.shared.canOpenURL(URL(string: (self.OfferDetail.Website))!))
        {
            let openLink = NSURL(string : (self.OfferDetail.Website))
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: openLink! as URL)
                present(svc, animated: true, completion: nil)
            } else {
                let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                port.strUrl = (self.OfferDetail.Website)
                self.navigationController?.pushViewController(port, animated: true)
            }
        }
        else
        {
            return
        }
    }
}
