//
//  PostJobVC.swift
//  Tooli
//
//  Created by Impero IT on 14/09/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher
import ActionSheetPicker_3_0
import ObjectMapper
import NVActivityIndicatorView
import GooglePlaces
import Toast_Swift
import Alamofire

class PostJobVC: UIViewController,NVActivityIndicatorViewable,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource
{
    var edit :Bool = false
    var JobID = 0
    var jobDetail:EditDetailJobDetail = EditDetailJobDetail()
    var JobRoleIdList:[Int] = []
    var TradeId = 0
    var CertificateIdList : [Int] = []
    var SectorIdList : [Int] = []
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    @IBOutlet var lblTitle:UILabel!

    var DataList:GetDefaultList = GetDefaultList()
    
    @IBOutlet weak var TblJobRole: UITableView!
    
    @IBOutlet weak var TblTrade: UITableView!
    @IBOutlet weak var TblSectoreSkill: UITableView!
    @IBOutlet weak var TblCertificate: UITableView!
    
    @IBOutlet weak var JobRoleHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var TradeHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var CertificateHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var SectoreHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var BtnTrade: UIButton!
    @IBOutlet weak var BtnJobRole: UIButton!
    
    @IBOutlet weak var txtDis: UITextView!
    var placeholderLabel:UILabel!
    
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtJobLocation: UITextField!
    var isVisible0 : Bool = false
    var isVisible : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if(edit)
        {
            lblTitle.text = "Edit job"
            getDetailsDetail()
        }
        else
        {
            lblTitle.text = "Post job"
        }
        JobRoleHeightConstraints.constant = 0
        CertificateHeightConstraints.constant = 0
        TradeHeightConstraints.constant = 0
        SectoreHeightConstraints.constant = 0
        JobRoleIdList = []
        TradeId = 0
        SectorIdList = []
        CertificateIdList = []
        
        self.BtnJobRole.setTitle("Select job-role", for: .normal);
        self.BtnJobRole.setTitleColor(Color.black, for: .normal)
        
        self.BtnTrade.setTitle("Select trade ", for: .normal);
        self.BtnTrade.setTitleColor(Color.black, for: .normal)
        
        GetAllDataFromServer()
        
        txtDis.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "About me"
        //     placeholderLabel.font = UIFont(name: "BabasNeue", size: 106)
        placeholderLabel.font = UIFont.systemFont(ofSize: (txtDis.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtDis.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtDis.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtDis.text.isEmpty
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func locationSelection(_ sender: UIButton)
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
    @IBAction func btnStartDateAction(_ sender:UIButton)
    {
        let datePicker = ActionSheetDatePicker(title: "Start Date", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            let dob : Date = value as! Date
            self.txtStartDate.text = dob.toDisplayString()
            
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        datePicker?.show()
    }
    @IBAction func btnEndDateAction(_ sender:UIButton)
    {
        let datePicker = ActionSheetDatePicker(title: "End Date", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            let dob : Date = value as! Date
            self.txtEndDate.text = dob.toDisplayString()
            
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        datePicker?.show()
    }
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        textView.resignFirstResponder()
        return true
    }
    @IBAction func BtnJobRoleTapped(_ sender: UIButton)
    {
        if isVisible0 == true
        {
            self.JobRoleHeightConstraints.constant = 0
            isVisible0 = false
        }
        else
        {
            self.TradeHeightConstraints.constant = 0
            isVisible = false
            
            isVisible0 = true
            if(DataList.Result.JobRoleList.count > 5)
            {
                self.JobRoleHeightConstraints.constant = (self.view.frame.size.height/18.62)*5
            }
            else
            {
                self.JobRoleHeightConstraints.constant = (self.view.frame.size.height/18.62)*CGFloat(DataList.Result.JobRoleList.count)
            }
        }
        TblJobRole.reloadData()
    }
    
    @IBAction func BtnTradeTapped(_ sender: UIButton)
    {
        if isVisible == true
        {
            self.TradeHeightConstraints.constant = 0
            isVisible = false
        }
        else
        {
            self.JobRoleHeightConstraints.constant = 0
            isVisible0 = false
            
            isVisible = true
            if(DataList.Result.TradeList.count > 5)
            {
                self.TradeHeightConstraints.constant = (self.view.frame.size.height/18.62)*5
            }
            else
            {
                self.TradeHeightConstraints.constant = (self.view.frame.size.height/18.62)*CGFloat(DataList.Result.TradeList.count)
            }
        }
        TblTrade.reloadData()
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(TblTrade == tableView)
        {
            return DataList.Result.TradeList.count
        }
        else if(TblJobRole == tableView)
        {
            return DataList.Result.JobRoleList.count
        }
        else if(TblSectoreSkill == tableView)
        {
            return DataList.Result.SectorList.count
        }
        else
        {
            return DataList.Result.CertificateList.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(tableView == TblJobRole)
        {
            return self.view.frame.size.height/18.62
        }
        else if(tableView == TblTrade)
        {
           return self.view.frame.size.height/18.62
        }
        else if(tableView == TblSectoreSkill)
        {
           return self.view.frame.size.height/12.62
        }

        else if(tableView == TblCertificate)
        {
            return self.view.frame.size.height/12.62
        }
        else
        {
            return 0 
        }
    }
    func GetAllDataFromServer()
    {
        self.startAnimating()
        AFWrapper.requestGETURL(Constants.URLS.GetDefaultList, success: { (JSONResponse) in
            self.stopAnimating()
            if JSONResponse["Status"].int == 1
            {
                self.DataList = Mapper<GetDefaultList>().map(JSONObject: JSONResponse.rawValue)!
                self.TblSectoreSkill.reloadData()
                self.TblTrade.reloadData()
                self.TblCertificate.reloadData()
                
                if(self.DataList.Result.SectorList.count > 5)
                {
                    self.SectoreHeightConstraints.constant = (self.view.frame.size.height/12.62)*5
                }
                else
                {
                    self.SectoreHeightConstraints.constant = (self.view.frame.size.height/12.62)*CGFloat(self.DataList.Result.SectorList.count)
                }
                
                if(self.DataList.Result.CertificateList.count > 5)
                {
                    self.CertificateHeightConstraints.constant = (self.view.frame.size.height/12.62)*5
                }
                else
                {
                    self.CertificateHeightConstraints.constant = (self.view.frame.size.height/12.62)*CGFloat(self.DataList.Result.CertificateList.count)
                }
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
        }) { (error) in
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if(tableView  == TblTrade)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.lblName.text = DataList.Result.TradeList[indexPath.row].TradeName
            if(TradeId == DataList.Result.TradeList[indexPath.row].TradeID)
            {
                cell.btnSelction.isSelected = true
            }
            else
            {
                cell.btnSelction.isSelected = false
            }
            cell.btnSelction.tag = indexPath.row
            cell.btnSelction.addTarget(self, action: #selector(btnTradeSelctionAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        else if(tableView  == TblJobRole)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.lblName.text = DataList.Result.JobRoleList[indexPath.row].JobRoleName
            if(JobRoleIdList.contains(DataList.Result.JobRoleList[indexPath.row].JobRoleID))
            {
                cell.btnSelction.isSelected = true
            }
            else
            {
                cell.btnSelction.isSelected = false
            }
            cell.btnSelction.tag = indexPath.row
            cell.btnSelction.addTarget(self, action: #selector(btnJobRoleSelctionAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        else if(tableView  == TblSectoreSkill)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.lblName.text = DataList.Result.SectorList[indexPath.row].SectorName
            if(SectorIdList.contains(DataList.Result.SectorList[indexPath.row].SectorID))
            {
                cell.btnSelction.isSelected = true
            }
            else
            {
                cell.btnSelction.isSelected = false
            }
            cell.btnSelction.tag = indexPath.row
            cell.btnSelction.addTarget(self, action: #selector(btnSectoreSelctionAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.lblName.text = DataList.Result.CertificateList[indexPath.row].CertificateName
            if(CertificateIdList.contains(DataList.Result.CertificateList[indexPath.row].CertificateID))
            {
                cell.btnSelction.isSelected = true
            }
            else
            {
                cell.btnSelction.isSelected = false
            }
            cell.btnSelction.tag = indexPath.row
            cell.btnSelction.addTarget(self, action: #selector(btnCertificateSelctionAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    func btnTradeSelctionAction(_ sender: UIButton)
    {
        
        TradeId = DataList.Result.TradeList[sender.tag].TradeID
        
//        if(!TradeIdList.contains(DataList.Result.TradeList[sender.tag].TradeID))
//        {
//            TradeIdList.append(DataList.Result.TradeList[sender.tag].TradeID)
//        }
//        else
//        {
//            TradeIdList.remove(at: TradeIdList.index(of:DataList.Result.TradeList[sender.tag].TradeID)!)
//        }
        TblTrade.reloadData()
    }
    func btnCertificateSelctionAction(_ sender: UIButton)
    {
        if(!CertificateIdList.contains(DataList.Result.CertificateList[sender.tag].CertificateID))
        {
            CertificateIdList.append(DataList.Result.CertificateList[sender.tag].CertificateID)
        }
        else
        {
            CertificateIdList.remove(at: CertificateIdList.index(of:DataList.Result.CertificateList[sender.tag].CertificateID)!)
        }
        TblCertificate.reloadData()
    }
    func btnSectoreSelctionAction(_ sender: UIButton)
    {
        if(!SectorIdList.contains(DataList.Result.SectorList[sender.tag].SectorID))
        {
            SectorIdList.append(DataList.Result.SectorList[sender.tag].SectorID)
        }
        else
        {
            SectorIdList.remove(at: SectorIdList.index(of:DataList.Result.SectorList[sender.tag].SectorID)!)
        }
        TblSectoreSkill.reloadData()
    }
    func btnJobRoleSelctionAction(_ sender: UIButton)
    {
        if(!JobRoleIdList.contains(DataList.Result.JobRoleList[sender.tag].JobRoleID))
        {
            JobRoleIdList.append(DataList.Result.JobRoleList[sender.tag].JobRoleID)
        }
        else
        {
            JobRoleIdList.remove(at: JobRoleIdList.index(of:DataList.Result.JobRoleList[sender.tag].JobRoleID)!)
        }
        TblJobRole.reloadData()
    }
    @IBAction func btnPostJobAction(_ sender: UIButton)
    {
        if(JobRoleIdList.count == 0)
        {
            self.view.makeToast("Please select at least one Job Roles", duration: 3, position: .center)
        }
        else if(TradeId == 0)
        {
            self.view.makeToast("Please select at least one trade", duration: 3, position: .center)
        }
        else if(txtJobLocation.text == "")
        {
            self.view.makeToast("Please select job location", duration: 3, position: .center)
        }
        else if(txtStartDate.text == "")
        {
            self.view.makeToast("Please select start date", duration: 3, position: .center)
        }
        else if(txtEndDate.text == "")
        {
            self.view.makeToast("Please select end date", duration: 3, position: .center)
        }
        else if(SectorIdList.count == 0)
        {
            self.view.makeToast("Please select sector", duration: 3, position: .center)
        }
        else if(CertificateIdList.count == 0)
        {
            self.view.makeToast("Please select at least one certificate", duration: 3, position: .center                      )
        }
        
        else
        {
            sendDataToServer()
        }

    }
    
    func getDetailsDetail()
    {
        self.startAnimating()
        let param = ["JobID":JobID] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.JobEditDetail, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            
            if JSONResponse["Status"].int == 1
            {
               self.jobDetail = Mapper<EditDetailJobDetail>().map(JSONObject: JSONResponse.rawValue)!
                self.JobRoleIdList = self.jobDetail.Result.JobRoleIdList
                self.TradeId = self.jobDetail.Result.TradeID
                self.SectorIdList = self.jobDetail.Result.SectorIdList
                self.CertificateIdList = self.jobDetail.Result.CertificateIdList
                self.txtJobLocation.text = self.jobDetail.Result.Location
                self.txtStartDate.text = self.jobDetail.Result.StartOn
                self.txtEndDate.text = self.jobDetail.Result.EndOn
                self.txtDis.text = self.jobDetail.Result.Description
                self.placeholderLabel.isHidden = !self.txtDis.text.isEmpty
                self.coordinate = CLLocationCoordinate2DMake(self.jobDetail.Result.Latitude, self.jobDetail.Result.Longitude)
                
                self.TblTrade.reloadData()
                self.TblJobRole.reloadData()
                self.TblCertificate.reloadData()
                self.TblSectoreSkill.reloadData()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
            }
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func sendDataToServer()
    {
        self.startAnimating()
        var param = [:] as [String : Any]
        
        if(edit)
        {
            param["JobID"] = jobDetail.Result.JobID
        }
        else
        {
            param["JobID"] = 0
        }
        param["JobRoleIdList"] = JobRoleIdList
        param["SectorIdList"] = SectorIdList
        param["TradeID"] =  TradeId
        param["CertificateIdList"] =  CertificateIdList
        param["Description"] = txtDis.text!
        param["Location"] = txtJobLocation.text!
        param["Latitude"] = coordinate.latitude
        param["Longitude"] = coordinate.longitude
        param["StartOn"] = txtStartDate.text!
        param["EndOn"] = txtEndDate.text!

        AFWrapper.requestPOSTURLWithJson(Constants.URLS.AddorUpdate, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            if JSONResponse != nil {
                if JSONResponse["Status"].int == 1
                {
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
}
extension PostJobVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")
        print("Place attributions: \(place.attributions)")
        
        self.coordinate = (place.coordinate)
        var postcode = ""
        for tmt in place.addressComponents!
        {
            if tmt.type == "administrative_area_level_2"
            {
                print("City is : \(tmt.name) ")
            }
            if tmt.type == "postal_code" {
                print("Postal code is : \(tmt.name) ")
                postcode = tmt.name
            }
        }
        self.txtJobLocation.text = place.formattedAddress
        if(postcode == "")
        {
            viewController.view.makeToast("“Please enter full postcode, for example, PR1 1AA”", duration: 3, position: .bottom)
        }
        else
        {
            dismiss(animated: true, completion: nil)
        }
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
