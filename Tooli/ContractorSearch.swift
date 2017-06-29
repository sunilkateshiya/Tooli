//
//  ContractorSearch.swift
//  Tooli
//
//  Created by Impero IT on 15/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Kingfisher
import ActionSheetPicker_3_0
import ObjectMapper
import NVActivityIndicatorView
import GooglePlaces
import Toast_Swift
import Alamofire

class ContractorSearch: UIViewController, UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate, NVActivityIndicatorViewable
{
    @IBOutlet weak var btnAgain: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewError: UIView!
    @IBAction func btnAgainErrorAction(_ sender: UIButton)
    {
        self.imgError.isHidden = true
        self.btnAgain.isHidden = true
        self.lblError.isHidden = true
        getMasters() 
    }

    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let sharedManager : Globals = Globals.sharedInstance
    var isTradeSelected : Bool = false;
    var selectedTrade = -1;
    var selectedTradeIndex = -1;
    var selectedSkills : [String] = [];
    var selectedCertificate : [String] = [];
    var integerCount = NSInteger()
    var integerCountCertificate = NSInteger()
    var postcode : String = ""
    @IBOutlet var txtPostCode:UITextField!
    @IBOutlet weak var TblSelectSkill: UITableView!
    @IBOutlet weak var TblSelectCertificate: UITableView!
    @IBOutlet weak var SkillHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var CertificateHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var BtnSkill: UIButton!
    @IBOutlet weak var BtnCertificate: UIButton!
    @IBOutlet weak var BtnTrade: UIButton!
    
    var isVisible : Bool = false;
      var isVisible1 : Bool = false;
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getMasters()
        self.TblSelectSkill.allowsMultipleSelection = true
        self.TblSelectCertificate.allowsMultipleSelection = true
        
        self.BtnSkill.isUserInteractionEnabled = false
        
        self.BtnCertificate.isUserInteractionEnabled = false
        
        SkillHeightConstraints.constant = 0
        CertificateHeightConstraints.constant = 0
        bottomConstraint.constant = 20
        
        TblSelectSkill.delegate = self
        TblSelectSkill.dataSource = self
        TblSelectSkill.tableFooterView = UIView()
        
        TblSelectCertificate.delegate = self
        TblSelectCertificate.dataSource = self
        TblSelectCertificate.tableFooterView = UIView()
        
        self.BtnTrade.setTitle("Select a trade" as String,for: .normal)
        
        selectedSkills = []
        selectedCertificate = []
        
        for skill in sharedManager.currentUser.ServiceList! {
            selectedSkills.append(String(skill.ServiceID))
        }
        for Certificate in sharedManager.currentUser.CertificateFileList!
        {
            selectedCertificate.append(String(Certificate.CertificateCategoryID))
        }
        
//        self.BtnTrade.setTitleColor(Color.black, for: .normal)
        
        self.BtnSkill.setTitle("Skills ", for: .normal);
        self.BtnSkill.setTitleColor(Color.black, for: .normal)
        
        self.BtnCertificate.setTitle("Certificate ", for: .normal);
        self.BtnCertificate.setTitleColor(Color.black, for: .normal)

        
        // Do any additional setup after loading the view.
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
    @IBAction func btnAddressSelection(_ sender: UIButton)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.tintColor = UIColor.red
        let header : UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: 60))
        header.backgroundColor=UIColor.red
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        autocompleteController.view.addSubview(header)
        
        let filter = GMSAutocompleteFilter()
        filter.country = "UK"
        autocompleteController.autocompleteFilter = filter
    
        autocompleteController.navigationController?.setToolbarHidden(false, animated: true)
        present(autocompleteController, animated: true, completion: nil)
    }
    @IBAction func btnApplyFilterAction(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContractorResult") as! ContractorResult
        vc.selectedCertificate = selectedCertificate
        vc.selectedSkills = selectedSkills
        vc.selectedTrade = self.selectedTrade
        vc.postcode = txtPostCode.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Contractor Search Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func getMasters(){
        // Z_MasterDataList
        
         self.viewError.isHidden = false
        self.startAnimating()
        let param = [:] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.Z_MasterDataList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.masters = Mapper<Masters>().map(JSONObject: JSONResponse.rawValue)
            
        
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil {
                self.viewError.isHidden = true
                self.imgError.isHidden = true
                self.btnAgain.isHidden = true
                self.lblError.isHidden = true
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    // Setting Trade Button
                    var i = 0;
                    var index = 0;
                    if (self.sharedManager.masters != nil) {
                        for trades in self.sharedManager.masters.DataList! {
                            if trades.PrimaryID == self.sharedManager.currentUser.TradeCategoryID {
                                index = i
                            }
                            i = i + 1;
                        }
                    }
                    if self.isVisible == true
                    {
                        self.integerCount = (self.sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList?.count)! as NSInteger
                        let One = self.integerCount * 44 as NSInteger
                        self.SkillHeightConstraints.constant = CGFloat(One)
                    }
                    if self.isVisible1 == true
                    {
                        self.integerCountCertificate = (self.sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList?.count)! as NSInteger
                        let Two = self.integerCountCertificate * 44 as NSInteger
                        self.CertificateHeightConstraints.constant = CGFloat(Two)
                    }
                    
                    self.selectedSkills = []
                    self.selectedCertificate = []
                    self.TblSelectSkill.reloadData()
                    self.TblSelectCertificate.reloadData()
                }
                else
                {
                    self.stopAnimating()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
                
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
             
            self.viewError.isHidden = false
            self.imgError.isHidden = false
            self.btnAgain.isHidden = false
            self.lblError.isHidden = false
           // self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    @IBAction func BtnTradeTapped(_ sender: UIButton) {
    
        var trades : [String] = []
        trades.append("")
        for trade in  sharedManager.masters.DataList! {
            trades.append(trade.TradeCategoryName)
        }
        
        
        ActionSheetStringPicker.show(withTitle: "Select Trade", rows: trades, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            self.selectedTradeIndex = value-1
            if(self.selectedTradeIndex != -1)
            {
                self.selectedTrade = self.sharedManager.masters.DataList![self.selectedTradeIndex].PrimaryID
                // Reload table
                self.BtnSkill.isUserInteractionEnabled = true
                self.BtnCertificate.isUserInteractionEnabled = true
                if self.isVisible == true
                {
                    self.integerCount = (self.sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList?.count)! as NSInteger
                    let One = self.integerCount * 44 as NSInteger
                    self.SkillHeightConstraints.constant = CGFloat(One)
                }
                if self.isVisible1 == true
                {
                    self.integerCountCertificate = (self.sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList?.count)! as NSInteger
                    let Two = self.integerCountCertificate * 44 as NSInteger
                    self.CertificateHeightConstraints.constant = CGFloat(Two)
                }
                self.BtnTrade.setTitle(String(describing: index!), for: UIControlState.normal)
                self.BtnTrade.setTitleColor(Color.black, for: .normal)
            }
            else
            {
                 self.selectedTrade = -1
                self.BtnTrade.setTitle("Select a trade" as String,for: .normal)
                self.BtnTrade.setTitleColor(Color.lightGray, for: .normal)
                
                 self.SkillHeightConstraints.constant = CGFloat(0)
                self.CertificateHeightConstraints.constant = CGFloat(0)
                self.selectedSkills = []
                self.selectedCertificate = []
            }

            self.TblSelectSkill.reloadData()
            self.TblSelectCertificate.reloadData()
            
           
            print("index = \(index!)")
            print("picker = \(picker)")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)

    }
    @IBAction func BtnSkillTapped(_ sender: UIButton)
    {
        if isVisible == true {
            self.SkillHeightConstraints.constant = 0
            isVisible = false
        }
        else
        {
            self.CertificateHeightConstraints.constant = 0
            isVisible1 = false
            if(self.selectedTradeIndex != -1)
            {
                self.integerCount = (self.sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList?.count)! as NSInteger
                let One = self.integerCount * 44 as NSInteger
                self.SkillHeightConstraints.constant = CGFloat(One)
                isVisible = true
            }
        }
        
    }
    @IBAction func BtnCertificateTapped(_ sender: UIButton)
    {
    
        if isVisible1 == true {
            self.CertificateHeightConstraints.constant = 0
            isVisible1 = false
        }
        else
        {
            self.SkillHeightConstraints.constant = 0
            isVisible = false
            if(self.selectedTradeIndex != -1)
            {
                self.integerCountCertificate = (self.sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList?.count)! as NSInteger
                let Two = self.integerCountCertificate * 44 as NSInteger
                self.CertificateHeightConstraints.constant = CGFloat(Two)
                isVisible1 = true
            }
            
        }
        
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.selectedTradeIndex != -1)
        {
            if(tableView  == TblSelectSkill)
            {
                guard ((sharedManager.masters) != nil) else {
                    return 0
                }
                
                return  (sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList?.count)!
            }
            else
            {
                guard ((sharedManager.masters) != nil) else {
                    return 0
                }
                
                return  (sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList?.count)!
            }
        }
        else
        {
         return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if(tableView  == TblSelectSkill)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SkillCell
            
            cell.lblSkillName?.text = "\(sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList![indexPath.row].ServiceName)"
            if  selectedSkills .contains(String(sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList![indexPath.row].ServiceID)) {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
            }
            else {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
            }
            
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            cell.selectionStyle = .none // to prevent cells from being "highlighted"
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SkillCell
            
            cell.lblSkillName?.text = "\(sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList![indexPath.row].CertificateCategoryName)"
            if  selectedCertificate .contains(String(sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList![indexPath.row].CertificateCategoryID)) {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
            }
            else {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
            }
            
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            cell.selectionStyle = .none // to prevent cells from being "highlighted"
            return cell
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SkillCell
        
        if(tableView  == TblSelectSkill)
        {
            if  selectedSkills .contains(String(sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList![indexPath.row].ServiceID)) {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
                selectedSkills.remove(at: selectedSkills.index(of: String(sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList![indexPath.row].ServiceID))! )
            }
            else {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
                selectedSkills.append(String(sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList![indexPath.row].ServiceID))
            }
        }
        else
        {
            
            if  selectedCertificate .contains(String(sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList![indexPath.row].CertificateCategoryID)) {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
                selectedCertificate.remove(at: selectedCertificate.index(of: String(sharedManager.masters.DataList![selectedTrade].CertificateCategoryList![indexPath.row].CertificateCategoryID))! )
            }
            else {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
                selectedCertificate.append(String(sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList![indexPath.row].CertificateCategoryID))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SkillCell
        
        if(tableView  == TblSelectSkill)
        {
            if  selectedSkills .contains(String(sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList![indexPath.row].ServiceID)) {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
                selectedSkills.remove(at: selectedSkills.index(of: String(sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList![indexPath.row].ServiceID))! )
            }
            else {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
                selectedSkills.append(String(sharedManager.masters.DataList![self.selectedTradeIndex].ServiceList![indexPath.row].ServiceID))
            }
        }
        else
        {
            
            if  selectedCertificate .contains(String(sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList![indexPath.row].CertificateCategoryID)) {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
                selectedCertificate.remove(at: selectedCertificate.index(of: String(sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList![indexPath.row].CertificateCategoryID))! )
            }
            else {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
                selectedCertificate.append(String(sharedManager.masters.DataList![self.selectedTradeIndex].CertificateCategoryList![indexPath.row].CertificateCategoryID))
            }
        }
    }
}
extension ContractorSearch: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")
        print("Place attributions: \(place.attributions)")
        
        self.txtPostCode.text = place.formattedAddress!
    
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}
