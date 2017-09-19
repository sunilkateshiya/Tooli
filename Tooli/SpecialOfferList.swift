//
//  SpecialOfferList.swift
//  Tooli
//
//  Created by Impero IT on 9/03/2017.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import Popover
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher
import SafariServices

class SpecialOfferList: UIViewController,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable,RetryButtonDeleget
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
    var speciallist : SpecialOfferListGetAll = SpecialOfferListGetAll()
    @IBOutlet weak var TBLSpecialOffer: UITableView!
    var refreshControl:UIRefreshControl!
    
    var isFull : Bool = false
    var isCallWebService : Bool = true
    var currentPage = 1
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        TBLSpecialOffer.delegate = self
        TBLSpecialOffer.dataSource = self
        TBLSpecialOffer.rowHeight = UITableViewAutomaticDimension
        TBLSpecialOffer.estimatedRowHeight = 450
        TBLSpecialOffer.tableFooterView = UIView()
        onLoadDetail()
         self.viewError.isHidden = true
        self.startAnimating()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage), for: UIControlEvents.valueChanged)
        TBLSpecialOffer.addSubview(refreshControl)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.startAnimating()
        
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        
        // Do any additional setup after loading the view.
    }
    func refreshPage()
    {
        currentPage = 1
        isFull = false
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  self.speciallist.Result.count
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "SpecialOfferList Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialOfferListCell", for: indexPath) as! SpecialOfferListCell
        cell.likeHeight.constant = 0
        cell.lblTitle.text = self.speciallist.Result[indexPath.row].CompanyName
        cell.lblDate.text = "\(self.speciallist.Result[indexPath.row].Title)-\(self.speciallist.Result[indexPath.row].PriceTag)"
        cell.lblDis.text = self.speciallist.Result[indexPath.row].Description
            cell.btnFav.tag=indexPath.row
            cell.btnFav.addTarget(self, action: #selector(btnfavSpecialOffer(_:)), for: UIControlEvents.touchUpInside)
            if self.speciallist.Result[indexPath.row].IsSaved == true {
                cell.btnFav.isSelected = true
                cell.btnSave.isSelected = true
            }
            else{
                cell.btnFav.isSelected = false
                cell.btnSave.isSelected = false
            }
            
            let imgURL = self.speciallist.Result[indexPath.row].ProfileImageLink as String!
            let url = URL(string: imgURL!)
            cell.imgUser.kf.indicatorType = .activity
            cell.imgUser.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        cell.lblDate.tag  = indexPath.row
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(lblImagheProfile(tapGestureRecognizer:)))
        cell.lblDate.isUserInteractionEnabled = true
        cell.lblDate.addGestureRecognizer(tapGestureRecognizer1)
        
        cell.imgUser.tag = indexPath.row
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(lblImagheProfile(tapGestureRecognizer:)))
        cell.imgUser.isUserInteractionEnabled = true
        cell.imgUser.addGestureRecognizer(tapGestureRecognizer2)
        
        let imgURL1 = self.speciallist.Result[indexPath.row].ProfileImageLink as String!
        let url1 = URL(string: imgURL1!)
        cell.imgUser.kf.setImage(with: url1, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in

        })
        let imgURL2 = self.speciallist.Result[indexPath.row].ImageLink as String!
        let url2 = URL(string: imgURL2!)
        
        cell.img1.kf.setImage(with: url2, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image:Image?, error:NSError?, cache:CacheType, url:URL?) in
            if(image != nil)
            {
                cell.setCustomImage(image : image!)
            }
        })

        cell.btnSave.tag = indexPath.row
        cell.btnSave.addTarget(self, action: #selector(btnfavSpecialOffer(_:)), for: UIControlEvents.touchUpInside)
        
        cell.btnProfile.tag = indexPath.row
        cell.btnProfile.addTarget(self, action: #selector(btnProfileAction(_:)), for: UIControlEvents.touchUpInside)
        
        cell.btnLike.tag = indexPath.row

        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action: #selector(btnViewAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
    }
    func lblImagheProfile(tapGestureRecognizer:UIGestureRecognizer)
    {
        OpenDetailPage(index: (tapGestureRecognizer.view?.tag)!)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.OfferDetail = self.speciallist.Result[indexPath.row]
            vc.isNotification = false
            self.navigationController?.pushViewController(vc, animated: true)
    }
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    func btnProfileAction(_ sender:UIButton)
    {
        OpenDetailPage(index: sender.tag)
    }
    func btnViewAction(_ sender:UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
        vc.OfferDetail = self.speciallist.Result[sender.tag]
        vc.isNotification = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func OpenDetailPage(index:Int)
    {
        if(self.speciallist.Result[index].Role == 0)
        {
            print("Admin")
        }
        else if(self.speciallist.Result[index].Role == 1)
        {
            print("Contractor")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
            vc.userId = self.speciallist.Result[index].UserID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.speciallist.Result[index].Role == 2)
        {
            print("Company")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            vc.userId = self.speciallist.Result[index].UserID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(self.speciallist.Result[index].Role == 3)
        {
            print("Supplier")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
            vc.userId = self.speciallist.Result[index].UserID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func openImageLink(_ sender:UIButton)
    {
         let openLink = NSURL(string : (self.speciallist.Result[sender.tag].Website))
        if((self.speciallist.Result[sender.tag].Website) != "")
        {
            if(UIApplication.shared.canOpenURL(URL(string: "tel://\(removeSpecialCharsFromString(text: (self.speciallist.Result[sender.tag].Website)))")!))
            {
                if #available(iOS 9.0, *) {
                    let svc = SFSafariViewController(url: openLink! as URL)
                    present(svc, animated: true, completion: nil)
                } else {
                    let port : PDFViewer = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                    port.strUrl = (self.speciallist.Result[sender.tag].Website)
                    self.navigationController?.pushViewController(port, animated: true)
                    
                }
            }
            else
            {
                self.view.makeToast("RedirectWebsitelink not valid.", duration: 3, position: .bottom)
            }
        }
    }
    func onLoadDetail()
    {
        let param = ["PageIndex":currentPage] as [String : Any]
        if(currentPage != 1)
        {
            self.TBLSpecialOffer.tableFooterView = activityIndicator
        }
        print(param)
        self.isCallWebService = true
        AFWrapper.requestPOSTURL(Constants.URLS.OfferList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
    
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            print(JSONResponse["Status"].rawValue)
            self.TBLSpecialOffer.tableFooterView = UIView()
            if JSONResponse["Status"].int == 1
            {
                if(self.currentPage == 1)
                {
                    self.speciallist.Result =  []
                }
                AppDelegate.sharedInstance().GetNotificationCount()
                
                self.isCallWebService = false
                let temp = Mapper<SpecialOfferListGetAll>().map(JSONObject: JSONResponse.rawValue)!
                if(temp.Result.count == 0)
                {
                    self.isFull = true
                }
                for temp1 in temp.Result
                {
                    self.speciallist.Result.append(temp1)
                }
                if(self.speciallist.Result.count == 0)
                {
                     AppDelegate.sharedInstance().addNoDataView(view: self.view, frame: self.TBLSpecialOffer.frame, viewController: self, strMsg:"There are no special offers listed.")
                }
                self.currentPage = self.currentPage + 1
                self.isCallWebService = false
                self.TBLSpecialOffer.reloadData()
            }
            else
            {
                self.TBLSpecialOffer.reloadData()
                self.isFull = true
                self.isCallWebService = false
                AppDelegate.sharedInstance().addNoDataView(view: self.view, frame: self.TBLSpecialOffer.frame, viewController: self, strMsg:JSONResponse["Message"].rawString()!)
            }
            
        }) {
            (error) -> Void in
            self.isCallWebService = false
            self.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    func RetrybuttonTaped()
    {
        refreshPage()
    }
    func btnfavSpecialOffer(_ sender : UIButton)
    {
        self.startAnimating()
        let param = ["TablePrimaryID":"\(self.speciallist.Result[sender.tag].OfferID)",
                     "PageType":2] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.SaveToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                if sender.isSelected == true
                {
                    self.speciallist.Result[sender.tag].IsSaved = false
                }
                else
                {
                    self.speciallist.Result[sender.tag].IsSaved = true
                }
                self.TBLSpecialOffer.reloadData()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if !self.isCallWebService{
            if(scrollView == self.TBLSpecialOffer)
            {
                if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height))
                {
                    if(!isFull)
                    {
                        onLoadDetail()
                    }
                }
            }
        }
    }
}
