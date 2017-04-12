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
import SafariServices

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
    
    @IBOutlet weak var lblOfferLink: UILabel!
     @IBOutlet weak var btnSave: UIButton!
    
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
         OfferId = self.OfferDetail.PrimaryID
        lblcompany.text = self.OfferDetail.CompanyName as String!
        lblstart.text = self.OfferDetail.PriceTag as String!
        lblfinish.text = self.OfferDetail.AddedOn as String!
        lblwork.text = "\(self.OfferDetail.CompanyTradeCategoryName)"
        lblCatagory.text = self.OfferDetail.Title as String!
        //        //  cell.lbldatetime = self.
        
        let imgURL = self.OfferDetail.ProfileImageLink as String!
        
        let url = URL(string: imgURL!)
        imguser.kf.indicatorType = .activity
        imguser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        
        let imgURL1 = self.OfferDetail.OfferImageLink as String!
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
        lblOfferLink.text = self.OfferDetail.RedirectLink
        lblDiscription.text = self.OfferDetail.Description
        if(self.OfferDetail.RedirectLink != "")
        {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
            lblOfferLink.isUserInteractionEnabled = true
            lblOfferLink.addGestureRecognizer(tapGestureRecognizer)
        }
    
    }
    func lblNamedTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let lbl = tapGestureRecognizer.view as! UILabel
        if(UIApplication.shared.canOpenURL(URL(string: (self.OfferDetail.RedirectLink))!))
        {
            let openLink = NSURL(string : (self.OfferDetail.RedirectLink))
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: openLink as! URL)
                present(svc, animated: true, completion: nil)
            } else {
                let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                port.strUrl = (self.OfferDetail.RedirectLink)
                self.navigationController?.pushViewController(port, animated: true)
                
            }
        }
        else
        {
            return
        }
    }
    override func didReceiveMemoryWarning() {
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
                    self.OfferDetail1 = self.sharedManager.OfferDetail1
                   self.fillDatatoConttrollerFromApi()
                }
                else
                {
                     _ = self.navigationController?.popViewController(animated: true)
                    AppDelegate.sharedInstance().window?.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    @IBAction func btnfavSpecialOffer(btn : UIButton)  {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":OfferId ?? "",
                     "PageType":"5"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                     btn.isSelected = !btn.isSelected
                }
                else
                {
                    
                }
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func fillDatatoConttrollerFromApi()
    {
        OfferId = self.OfferDetail1.PrimaryID
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
        
        
        let imgURL1 = self.OfferDetail1.OfferImageLink as String!
        let url1 = URL(string: imgURL1!)
        imgOffer.kf.indicatorType = .activity
        imgOffer.kf.setImage(with: url1, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        if(self.OfferDetail1.IsSaved)
        {
            btnSave.isSelected = true
        }
        else
        {
            btnSave.isSelected = false
        }
        lblDiscription.text = self.OfferDetail1.Description
         lblOfferLink.text = self.OfferDetail1.RedirectLink
        if(self.OfferDetail1.RedirectLink != "")
        {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped1(tapGestureRecognizer:)))
            lblOfferLink.isUserInteractionEnabled = true
            lblOfferLink.addGestureRecognizer(tapGestureRecognizer)
        }
        
    }
    func lblNamedTaped1(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let lbl = tapGestureRecognizer.view as! UILabel
        if(UIApplication.shared.canOpenURL(URL(string: (self.OfferDetail1.RedirectLink))!))
        {
            let openLink = NSURL(string : (self.OfferDetail1.RedirectLink))
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: openLink as! URL)
                present(svc, animated: true, completion: nil)
            } else {
                let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                port.strUrl = (self.OfferDetail1.RedirectLink)
                self.navigationController?.pushViewController(port, animated: true)
                
            }
        }
        else
        {
            return
        }
    }
}
