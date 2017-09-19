//
//  ViewController.swift
//  Tooli
//
//  Created by impero on 02/01/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView

class Experience1: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,NVActivityIndicatorViewable
{
    @IBOutlet weak var tabView: UITableView!
    var ExpiraceList:[ExperienceM] = []
    var AllData:GetSignUp3 = GetSignUp3()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    var isRemove:Bool = false
    var edit:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
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
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AllData.Result.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExperienceCell
        cell.txtCompany.tag = 100000 + indexPath.row
        cell.txtJobTitle.tag = 200000 + indexPath.row
        cell.txtExperience.tag = 300000 + indexPath.row
        
        cell.txtJobTitle.text = self.AllData.Result[indexPath.row].Title
        cell.txtExperience.text = self.AllData.Result[indexPath.row].ExperienceYear
        cell.txtCompany.text = self.AllData.Result[indexPath.row].CompanyName
        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(Experience1.btnRemoveExpirance(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField.tag >= 300000)
        {
            var strUpdated:NSString =  textField.text! as NSString
            strUpdated = strUpdated.replacingCharacters(in: range, with: string) as NSString
            if(strUpdated.length > 2)
            {
                return false
            }
            else
            {
                if(strUpdated != "")
                {
                    if(Int(strUpdated as String)! <= 0)
                    {
                        return false
                    }
                }
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(isRemove)
        {
            
            if(self.AllData.Result.count > (textField.tag-100000))
            {
                if textField.tag >= 100000 && textField.tag < 200000  {
                    self.AllData.Result[textField.tag-100000].CompanyName = textField.text!
                }
                else if textField.tag >= 200000 && textField.tag < 300000  {
                    self.AllData.Result[textField.tag-200000].Title = textField.text!
                }
                else if textField.tag >= 300000 {
                    self.AllData.Result[textField.tag-300000].ExperienceYear = textField.text!
                }
            }
            else
            {
                isRemove = false
            }
        }
        else
        {
            if textField.tag >= 100000 && textField.tag < 200000  {
                self.AllData.Result[textField.tag-100000].CompanyName = textField.text!
            }
            else if textField.tag >= 200000 && textField.tag < 300000  {
                self.AllData.Result[textField.tag-200000].Title = textField.text!
            }
            else if textField.tag >= 300000 {
                self.AllData.Result[textField.tag-300000].ExperienceYear = textField.text!
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddExpirance(_ sender: UIButton) {
        let temp:ExperienceM = ExperienceM()
        self.AllData.Result.append(temp)
        self.tabView.reloadData()
    }
    func btnRemoveExpirance(_ sender: UIButton)
    {
        isRemove = true
        self.AllData.Result.remove(at: sender.tag)
        self.tabView.reloadData()
    }
    @IBAction func btnNext(_ sender: UIButton)
    {
        for temp in self.AllData.Result
        {
            if(temp.CompanyName == "" || temp.ExperienceYear == "" || temp.Title == "")
            {
                self.view.makeToast("There are one or many field empty", duration: 3, position: .bottom)
                return
            }
        }
        if(self.AllData.Result.count > 0)
        {
            sendDataToServer()
        }
        else
        {
             self.view.makeToast("At least one job experience required.", duration: 3, position: .bottom)
        }
    }
    func GetUserAllDataFromServer()
    {
        self.startAnimating()
        AFWrapper.requestGetUrlWithParam(Constants.URLS.ExperienceGet, params : nil,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            if JSONResponse != nil {
                if JSONResponse["Status"].int == 1
                {
                    self.AllData = Mapper<GetSignUp3>().map(JSONObject: JSONResponse.rawValue)!
                    self.tabView.reloadData()
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
        var param = [:] as [String : Any]
        param["ExperienceList"] = self.AllData.Result.toJSON()
        print(param)
        AFWrapper.requestPUTURLWithJson(Constants.URLS.ExperiencePut, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
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
                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "RateTravalVC") as! RateTravalVC
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

