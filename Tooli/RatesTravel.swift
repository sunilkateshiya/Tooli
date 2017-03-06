//
//  RatesTravel.swift
//  Tooli
//
//  Created by Moin Shirazi on 19/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
class RatesTravel: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    @IBOutlet var txtfrom : UITextField!
    @IBOutlet var txtuntil : UITextField!
    
    @IBOutlet var tvtrades : UITableView!
    
    @IBOutlet var btntrades : UIButton!
    
    let options = ["Own Vehicle","Licence Held"]
    let sharedManager : Globals = Globals.sharedInstance
    var selectedOptions : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvtrades.delegate = self
        tvtrades.dataSource = self
        tvtrades.rowHeight = UITableViewAutomaticDimension
        tvtrades.estimatedRowHeight = 450
        tvtrades.tableFooterView = UIView()
        tvtrades.isHidden = true
        self.tvtrades.allowsMultipleSelection = true
        setValue()
        // Do any additional setup after loading the view.
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func setValue(){
        
        self.txtfrom.text = self.sharedManager.currentUser.PerDayRate
        self.txtuntil.text = self.sharedManager.currentUser.PerHourRate
        btntrades.isSelected = true
        tvtrades.isHidden = false
        tvtrades.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btntrades(_ sender: Any) {
        
        if btntrades.isSelected {
//            tvtrades.isHidden = true
//            btntrades.isSelected = false
        }
        else{
            btntrades.isSelected = true
            tvtrades.isHidden = false
            tvtrades.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        
        return  options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SkillCell
            cell.lblSkillName.text = "\(options[indexPath.row])"
        if selectedOptions.contains(options[indexPath.row]) {
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
        }
        else {
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
        }
        
            //cell.textLabel?.text = "\(options[indexPath.row])"
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SkillCell
        if selectedOptions.contains(options[indexPath.row]) {
            selectedOptions.remove(at: selectedOptions.index(of: options[indexPath.row])!)
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
        }
        else {
            selectedOptions.append(options[indexPath.row])
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SkillCell
        if selectedOptions.contains(options[indexPath.row]) {
            selectedOptions.remove(at: selectedOptions.index(of: options[indexPath.row])!)
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
        }
        else {
            selectedOptions.append(options[indexPath.row])
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
        }
    }
    
    @IBAction func btnNext(_ sender: Any) {
        var isValid = true;
        if txtfrom.text == "" {
            isValid = false
            self.view.makeToast("Please enter valid Hourly rates", duration: 3, position: .bottom)
        }
        else if txtuntil.text == "" {
            isValid = false
            self.view.makeToast("Please enter valid Dayily rates", duration: 3, position: .bottom)
        }
        if isValid {
            self.startAnimating()
            var param = [:] as [String : Any]
            param["ContractorID"] = sharedManager.currentUser.ContractorID
            param["PerHourRate"] = self.txtfrom.text
            param["PerDayRate"] = self.txtuntil.text
            param["IsLicenceHeld"] = selectedOptions.contains("Licence Held") ? "true" : "false"
            param["IsOwnVehicle"] = selectedOptions.contains("Own Vehicle") ? "true" : "false"
            
            
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.ContractorRateTravelUpdate, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                
                if JSONResponse != nil {
                    
                    if JSONResponse["status"].rawString()! == "1"
                    {
                        let userDefaults = UserDefaults.standard
                        
                        userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                        userDefaults.synchronize()
                        
                        self.stopAnimating()
                        
                        let obj : Certificates = self.storyboard?.instantiateViewController(withIdentifier: "Certificates") as! Certificates
                        self.navigationController?.pushViewController(obj, animated: true)
                        
                    }
                    else
                    {
                        self.stopAnimating()
                        self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
                    }
                    
                }
                
            }) {
                (error) -> Void in
                self.stopAnimating()
                self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
            }

        }
        
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        let obj : Certificates = self.storyboard?.instantiateViewController(withIdentifier: "Certificates") as! Certificates
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
