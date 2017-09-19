//
//  Rate&TravalVC.swift
//  Toolii
//
//  Created by Impero IT on 08/08/17.
//  Copyright © 2017 whollysoftware. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView

class RateTravalVC: UIViewController,NVActivityIndicatorViewable,UITextFieldDelegate
{
    @IBOutlet weak var btnHourlyCheck: UIButton!
    @IBOutlet weak var btnDayCheck: UIButton!
    
    @IBOutlet weak var btnDrivingCheck: UIButton!
    @IBOutlet weak var btnOwnVehicalCheck: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtDailyRate: UITextField!
    @IBOutlet weak var txtHourlyRate: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    var AllData:GetSignUp4 = GetSignUp4()
    var edit:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        txtDailyRate.delegate = self
        txtHourlyRate.delegate = self
        GetUserAllDataFromServer()
        if(self.edit)
        {
            self.lblTitle.text = "Edit"
            btnNext.setTitle("Update", for: UIControlState.normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: UIButton)
    {
        if self.txtHourlyRate.text == "" && btnHourlyCheck.isSelected
        {
            self.view.makeToast("Please enter valid hourly rate.", duration: 3, position: .bottom)
        }
        else if self.txtDailyRate.text == "" && btnDayCheck.isSelected
        {
            self.view.makeToast("Please enter valid daily rate.", duration: 3, position: .bottom)
        }
        else if(txtDailyRate.text != "" && txtHourlyRate.text != "")
        {
            if Double(txtHourlyRate.text!)! >= Double(txtDailyRate.text!)!
            {
                self.view.makeToast("The hourly rates should be smaller than the daily rates!", duration: 3, position: .bottom)
                return
            }
            else
            {
               sendDataToServer()  
            }
        }
        else
        {
            sendDataToServer()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func btnHidePublicAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
    }
    func GetUserAllDataFromServer()
    {
        self.startAnimating()
        AFWrapper.requestGetUrlWithParam(Constants.URLS.ProfileStep3, params : nil,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            if JSONResponse != nil {
                if JSONResponse["Status"].int == 1
                {
                     self.AllData = Mapper<GetSignUp4>().map(JSONObject: JSONResponse.rawValue)!
                    self.txtDailyRate.text = self.AllData.Result.PerDayRate
                    self.txtHourlyRate.text = self.AllData.Result.PerHourRate
                    if(self.AllData.Result.IsLicenceHeld)
                    {
                        self.btnDrivingCheck.isSelected = true
                    }
                    else
                    {
                        self.btnDrivingCheck.isSelected = false
                    }
                    if(self.AllData.Result.IsOwnVehicle)
                    {
                        self.btnOwnVehicalCheck.isSelected = true
                    }
                    else
                    {
                        self.btnOwnVehicalCheck.isSelected = false
                    }
                    if(self.AllData.Result.IsPerDayRatePublic)
                    {
                        self.btnDayCheck.isSelected = true
                    }
                    else
                    {
                        self.btnDayCheck.isSelected = false
                    }
                    if(self.AllData.Result.IsPerHourRatePublic)
                    {
                        self.btnHourlyCheck.isSelected = true
                    }
                    else
                    {
                       self.btnHourlyCheck.isSelected = false
                    }
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
    func sendDataToServer()
    {
        self.startAnimating()
        
        let param = [
            "PerHourRate": "\(txtHourlyRate.text!)",
            "IsPerHourRatePublic": "\(btnHourlyCheck.isSelected)",
            "PerDayRate": "\(txtDailyRate.text!)",
            "IsPerDayRatePublic": "\(btnDayCheck.isSelected)",
            "IsOwnVehicle": "\(btnOwnVehicalCheck.isSelected)",
            "IsLicenceHeld": "\(btnDrivingCheck.isSelected)",
            ] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ProfileStep3, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            if JSONResponse != nil {
                if JSONResponse["Status"].int == 1
                {
                    if(self.edit)
                    {
                        self.navigationController?.popViewController(animated: true) 
                    }
                    else
                    {
                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "CertificateVC") as! CertificateVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else
                {
                    self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
}
