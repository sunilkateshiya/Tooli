//
//  SpecialOfferList.swift
//  Tooli
//
//  Created by Impero IT on 9/03/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Popover
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher
import SafariServices

class SpecialOfferList: UIViewController,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable
{
    
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnAgain: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    
    @IBAction func btnAgainErrorAction(_ sender: UIButton)
    {
        self.imgError.isHidden = true
        self.btnAgain.isHidden = true
        self.lblError.isHidden = true
         onLoadDetail()
    }
    
    var sharedManager : Globals = Globals.sharedInstance
    var speciallist : SpecialOfferListM!
    @IBOutlet weak var TBLSpecialOffer: UITableView!
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        TBLSpecialOffer.delegate = self
        TBLSpecialOffer.dataSource = self
        TBLSpecialOffer.rowHeight = UITableViewAutomaticDimension
        TBLSpecialOffer.estimatedRowHeight = 450
        TBLSpecialOffer.tableFooterView = UIView()
        onLoadDetail()
         self.viewError.isHidden = false
        self.startAnimating()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SpecialOfferList.refreshPage), for: UIControlEvents.valueChanged)
        TBLSpecialOffer.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }
    func refreshPage()
    {
        onLoadDetail()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.moveToDashboard()
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.speciallist == nil {
                return 0
            }
            return  (self.speciallist?.OfferList!.count)!;
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "SpecialOfferList Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpecialOfferCell
            cell.lblCompanyDescription.text = self.speciallist?.OfferList![indexPath.row].Description as String!
         //   cell.lblWork.text = self.speciallist?.OfferList![indexPath.row].Title as String!
        
        
        let myString = "\(self.speciallist!.OfferList![indexPath.row].Title)-\(self.speciallist!.OfferList![indexPath.row].PriceTag)-\(self.speciallist!.OfferList![indexPath.row].AddedOn)"
        let myRange = NSRange(location:((self.speciallist!.OfferList![indexPath.row].Title)).length, length: (("-\(self.speciallist!.OfferList![indexPath.row].PriceTag)-\(self.speciallist!.OfferList![indexPath.row].AddedOn)").length))
        let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.lightGray]
        
        let myAttrString = NSMutableAttributedString(string: myString)
        myAttrString.addAttributes(anotherAttribute, range: myRange)
        cell.lblWork.attributedText = myAttrString
        
            cell.lblCompanyName.text = self.speciallist?.OfferList![indexPath.row].CompanyName
            cell.btnfav!.tag=indexPath.row
            cell.btnfav?.addTarget(self, action: #selector(SpecialOfferList.btnfavSpecialOffer(btn:)), for: UIControlEvents.touchUpInside)
            if self.speciallist?.OfferList![indexPath.row].IsSaved == true {
                cell.btnfav.isSelected = true
            }
            else{
                cell.btnfav.isSelected = false
            }
            
            let imgURL = self.speciallist?.OfferList![indexPath.row].ProfileImageLink as String!
            cell.lblRedirectLink.text = self.speciallist?.OfferList![indexPath.row].RedirectWebsitelink
            let url = URL(string: imgURL!)
            cell.ImgProfilepic.kf.indicatorType = .activity
            cell.ImgProfilepic.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        
        cell.lblCompanyName.tag  = indexPath.row
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblImagheProfile(tapGestureRecognizer:)))
        cell.lblCompanyName.isUserInteractionEnabled = true
        cell.lblCompanyName.addGestureRecognizer(tapGestureRecognizer1)
        
        cell.ImgProfilepic.tag = indexPath.row
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(lblImagheProfile(tapGestureRecognizer:)))
        cell.ImgProfilepic.isUserInteractionEnabled = true
        cell.ImgProfilepic.addGestureRecognizer(tapGestureRecognizer2)
        
        
        
        let imgURL1 = self.speciallist?.OfferList![indexPath.row].OfferImageLink as String!
            
        let url1 = URL(string: imgURL1!)

        
        cell.ImgCompanyPic.kf.setImage(with: url1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
            if(image != nil)
            {
                cell.setCustomImage(image : image!)
                if(cell.isReload)
                {
                    cell.isReload = false
                    tableView.reloadData()
                }
            }
           
        })

            cell.btnRedirectUrl.tag = indexPath.row
            cell.btnRedirectUrl.addTarget(self, action: #selector(SpecialOfferList.openImageLink(_:)), for: UIControlEvents.touchUpInside)
            return cell
        
    }
    func lblImagheProfile(tapGestureRecognizer:UIGestureRecognizer)
    {
        let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
        companyVC.companyId = (self.speciallist?.OfferList![(tapGestureRecognizer.view?.tag)!].CompanyID)!
        self.navigationController?.pushViewController(companyVC, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.OfferId = (self.speciallist?.OfferList![indexPath.row].PrimaryID)!
            vc.isNotification = true
            self.navigationController?.pushViewController(vc, animated: true)
    }
    func openImageLink(_ sender:UIButton)
    {
        let openLink = NSURL(string : (self.speciallist?.OfferList![sender.tag].RedirectWebsitelink)!)
        
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(url: openLink as! URL)
            present(svc, animated: true, completion: nil)
        } else {
            let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
            port.strUrl = (self.speciallist?.OfferList![sender.tag].RedirectWebsitelink)!
            self.navigationController?.pushViewController(port, animated: true)
            
        }
    }
    func onLoadDetail(){

        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,"PageIndex":"0"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SpecialOfferLst, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.speciallist = Mapper<SpecialOfferListM>().map(JSONObject: JSONResponse.rawValue)
            
            self.stopAnimating()
              self.refreshControl.endRefreshing()
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                self.viewError.isHidden = true
                self.imgError.isHidden = true
                self.btnAgain.isHidden = true
                self.lblError.isHidden = true
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.TBLSpecialOffer.reloadData()
                    self.sharedManager.unreadSpecialOffer = 0
                     UIApplication.shared.applicationIconBadgeNumber =  self.sharedManager.unreadSpecialOffer + self.sharedManager.unreadNotification + self.sharedManager.unreadMessage
                    NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "RefreshSideMenu"), object: nil) as Notification)
                }
                else
                {
                   // self.speciallist = self.sharedManager.OfferList
                    self.TBLSpecialOffer.reloadData()
                    self.lblError.text = "There are no special offers listed."
                    self.viewError.isHidden = false
                    self.imgError.isHidden = false
                    self.btnAgain.isHidden = false
                    self.lblError.isHidden = false
                    
                    //self.view.makeToast("There are no new special offers.", duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
              self.refreshControl.endRefreshing()
            self.viewError.isHidden = false
            self.imgError.isHidden = false
            self.btnAgain.isHidden = false
            self.lblError.isHidden = false
          //  self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
        
    }
    func btnfavSpecialOffer(btn : UIButton)  {
        
        self.startAnimating()
        
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "PrimaryID":self.speciallist?.OfferList?[btn.tag].PrimaryID ?? "",
                     "PageType":"5"] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PageSaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    if btn.isSelected == true{
                        self.speciallist?.OfferList?[btn.tag].IsSaved = false
                    }
                    else{
                       self.speciallist?.OfferList?[btn.tag].IsSaved = true
                    }
                    self.TBLSpecialOffer.reloadData()
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
}
