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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let sharedManager : Globals = Globals.sharedInstance
    var isTradeSelected : Bool = false;
    var selectedTrade = 0;
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
        
        self.BtnTrade.setTitle("All Trades" as String,for: .normal)
        
        selectedSkills = []
        selectedCertificate = []
        
        for skill in sharedManager.currentUser.ServiceList! {
            selectedSkills.append(String(skill.ServiceID))
        }
        for Certificate in sharedManager.currentUser.CertificateFileList!
        {
            selectedCertificate.append(String(Certificate.CertificateCategoryID))
        }
        
        self.BtnTrade.setTitleColor(Color.black, for: .normal)
        
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
    @IBAction func btnApplyFilterAction(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContractorResult") as! ContractorResult
        vc.selectedCertificate = selectedCertificate
        vc.selectedSkills = selectedSkills
        vc.selectedTrade = selectedTrade
        vc.postcode = txtPostCode.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getMasters(){
        // Z_MasterDataList
        
        
        self.startAnimating()
        let param = [:] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.Z_MasterDataList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.masters = Mapper<Masters>().map(JSONObject: JSONResponse.rawValue)
            
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil {
                
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
                                //  self.btntrades.setTitle(trades.TradeCategoryName, for: UIControlState.normal)
                            }
                            i = i + 1;
                        }
                    }
                    
                    self.SkillHeightConstraints.constant = 0
                    self.CertificateHeightConstraints.constant = 0
                    
                    self.integerCount = (self.sharedManager.masters.DataList![index].ServiceList?.count)! as NSInteger
                    let One = self.integerCount * 44 as NSInteger
                    self.SkillHeightConstraints.constant = CGFloat(One)
                    
                    self.integerCountCertificate = (self.sharedManager.masters.DataList![index].CertificateCategoryList?.count)! as NSInteger
                    let Two = self.integerCountCertificate * 44 as NSInteger
                    self.CertificateHeightConstraints.constant = CGFloat(Two)
                    self.selectedSkills = []
                    self.selectedCertificate = []
                    self.TblSelectSkill.reloadData()
                    self.TblSelectCertificate.reloadData()
                    
                    self.BtnTrade.setTitle(String(describing: self.sharedManager.masters.DataList![index].TradeCategoryName), for: UIControlState.normal)
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
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    @IBAction func BtnTradeTapped(_ sender: UIButton) {
        
        
        var trades : [String] = []
        for trade in  sharedManager.masters.DataList! {
            trades.append(trade.TradeCategoryName)
        }
        
        
        ActionSheetStringPicker.show(withTitle: "Select Trade", rows: trades, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            self.selectedTrade = value
            // Reload table
            self.BtnSkill.isUserInteractionEnabled = true
            
            self.integerCount = (self.sharedManager.masters.DataList![self.selectedTrade].ServiceList?.count)! as NSInteger
            let One = self.integerCount * 44 as NSInteger
            self.SkillHeightConstraints.constant = CGFloat(One)
        
            self.integerCountCertificate = (self.sharedManager.masters.DataList![self.selectedTrade].CertificateCategoryList?.count)! as NSInteger
            let Two = self.integerCountCertificate * 44 as NSInteger
            self.CertificateHeightConstraints.constant = CGFloat(Two)
            
            
            self.TblSelectSkill.reloadData()
            self.TblSelectCertificate.reloadData()
            
            self.BtnTrade.setTitle(String(describing: index!), for: UIControlState.normal)
            print("index = \(index!)")
            print("picker = \(picker)")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)

    }
    @IBAction func BtnSkillTapped(_ sender: UIButton)
    {
        self.integerCount = (self.sharedManager.masters.DataList![self.selectedTrade].ServiceList?.count)! as NSInteger
        let One = self.integerCount * 44 as NSInteger
        self.SkillHeightConstraints.constant = CGFloat(One)
    }
    @IBAction func BtnCertificateTapped(_ sender: UIButton)
    {
        self.integerCountCertificate = (self.sharedManager.masters.DataList![self.selectedTrade].CertificateCategoryList?.count)! as NSInteger
        let Two = self.integerCountCertificate * 44 as NSInteger
        self.CertificateHeightConstraints.constant = CGFloat(Two)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView  == TblSelectSkill)
        {
            guard ((sharedManager.masters) != nil) else {
                return 0
            }
            
            return  (sharedManager.masters.DataList![selectedTrade].ServiceList?.count)!
        }
        else
        {
            guard ((sharedManager.masters) != nil) else {
                return 0
            }
            
            return  (sharedManager.masters.DataList![selectedTrade].CertificateCategoryList?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if(tableView  == TblSelectSkill)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SkillCell
            
            cell.lblSkillName?.text = "\(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceName)"
            if  selectedSkills .contains(String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID)) {
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
            
            cell.lblSkillName?.text = "\(sharedManager.masters.DataList![selectedTrade].CertificateCategoryList![indexPath.row].CertificateCategoryName)"
            if  selectedCertificate .contains(String(sharedManager.masters.DataList![selectedTrade].CertificateCategoryList![indexPath.row].CertificateCategoryID)) {
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
            if  selectedSkills .contains(String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID)) {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
                selectedSkills.remove(at: selectedSkills.index(of: String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID))! )
            }
            else {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
                selectedSkills.append(String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID))
            }
        }
        else
        {
            
            if  selectedCertificate .contains(String(sharedManager.masters.DataList![selectedTrade].CertificateCategoryList![indexPath.row].CertificateCategoryID)) {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
                selectedCertificate.remove(at: selectedCertificate.index(of: String(sharedManager.masters.DataList![selectedTrade].CertificateCategoryList![indexPath.row].CertificateCategoryID))! )
            }
            else {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
                selectedCertificate.append(String(sharedManager.masters.DataList![selectedTrade].CertificateCategoryList![indexPath.row].CertificateCategoryID))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SkillCell
        
        if(tableView  == TblSelectSkill)
        {
            if  selectedSkills .contains(String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID)) {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
                selectedSkills.remove(at: selectedSkills.index(of: String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID))! )
            }
            else {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
                selectedSkills.append(String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID))
            }
        }
        else
        {
            
            if  selectedCertificate .contains(String(sharedManager.masters.DataList![selectedTrade].CertificateCategoryList![indexPath.row].CertificateCategoryID)) {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
                selectedCertificate.remove(at: selectedCertificate.index(of: String(sharedManager.masters.DataList![selectedTrade].CertificateCategoryList![indexPath.row].CertificateCategoryID))! )
            }
            else {
                cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
                selectedCertificate.append(String(sharedManager.masters.DataList![selectedTrade].CertificateCategoryList![indexPath.row].CertificateCategoryID))
            }
        }
    }
}
