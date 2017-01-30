//
//  EditExperience.swift
//  Tooli
//
//  Created by Impero-Moin on 27/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import UIKit
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
import SwiftyJSON

class EditExperience:UIViewController,UITableViewDelegate, UITableViewDataSource ,NVActivityIndicatorViewable, UITextFieldDelegate {
     
     
     @IBOutlet weak var tvBlogList: UITableView!
     var experiences :[Experiences] = []
     var jsonExp : [String : AnyObject] = [:]
     
     let sharedManager : Globals = Globals.sharedInstance
     
     override func viewDidLoad() {
          super.viewDidLoad()
          // Do any additional setup after loading the view, typically from a nib.
      
     }
     override func viewWillAppear(_ animated: Bool) {
          experiences = []
          tvBlogList.delegate = self
          tvBlogList.dataSource = self
          tvBlogList.rowHeight = UITableViewAutomaticDimension
          tvBlogList.estimatedRowHeight = 450
          self.tvBlogList.reloadData()
          NotificationCenter.default.addObserver(self, selector: #selector(removeRows(notiffy:)), name: NSNotification.Name(rawValue: "RemoveCell"), object: nil)
          GetUserInfo()
          
     }
     
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
     }
     
     func removeRows(notiffy : Notification) {
          //   let dict = notiffy.userInfo as! [String:String]
          
          let indePath = NSIndexPath(row: (notiffy.userInfo!["index"]! as! Int), section: 0)
          self.sharedManager.currentUser.ExperienceList?.remove(at: (notiffy.userInfo!["index"]! as! Int))

          self.tvBlogList.deleteRows(at: [indePath as IndexPath], with: UITableViewRowAnimation.automatic)
          self.tvBlogList.reloadData()
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.sharedManager.currentUser.ExperienceList!.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExperienceCell

          cell.txtJobTitle.text = (sharedManager.currentUser.ExperienceList?[indexPath.row].Title)! as String
          cell.txtCompany.text = (sharedManager.currentUser.ExperienceList?[indexPath.row].CompanyName)! as String
          cell.txtExperience.text = (sharedManager.currentUser.ExperienceList?[indexPath.row].ExperienceYear)! as String
          cell.txtCompany.tag = 100000 + indexPath.row
            cell.txtCompany.delegate = self
            cell.txtJobTitle.delegate = self;
            cell.txtExperience.delegate = self
          cell.txtJobTitle.tag = 200000 + indexPath.row
          cell.txtExperience.tag = 300000 + indexPath.row
          cell.btnClose.tag = indexPath.row + 100
        
        
        
          return cell
     }
     
     @IBAction func btnAddExp(_ sender: Any) {
          
          let tmpEmp : Experiences = Experiences()
          self.sharedManager.currentUser.ExperienceList?.append(tmpEmp)
          tvBlogList.reloadData()
     }
     func GetUserInfo(){
          // Z_MasterDataList
          
          
          self.startAnimating()
          let param = ["ContractorID": self.sharedManager.currentUser.ContractorID] as [String : Any]

          print(param)
          AFWrapper.requestPOSTURL(Constants.URLS.ContractorInfo, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
               (JSONResponse) -> Void in
               
               self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
            let userDefaults = UserDefaults.standard
            userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
            userDefaults.synchronize()
               self.tvBlogList.reloadData()
               print(JSONResponse["status"].rawValue as! String)
               
               if JSONResponse != nil {
                    
                    if JSONResponse["status"].rawString()! == "1"
                    {
                         self.stopAnimating()
                         
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
     
     @IBAction func actionSubmit(sender : UIButton){
          var isAllValid : Bool = true
          for tmpExp in self.sharedManager.currentUser.ExperienceList! {
               var isValid : Bool = true

                if tmpExp.Title == "" {
                    isValid = false
                    self.view.makeToast("Please enter valid Job Title", duration: 3, position: .bottom)
               }
                    
               else if tmpExp.CompanyName == "" {
                    isValid = false
                    self.view.makeToast("Please enter valid Company", duration: 3, position: .bottom)
               }
               else if tmpExp.ExperienceYear == "" {
                    isValid = false
                    self.view.makeToast("Please enter valid Experience", duration: 3, position: .bottom)
               }
               if !isValid {
                    isAllValid = false
                    
                    break;
               }
               if isValid {
                
                    experiences.append(tmpExp)
               }
          }
          
          if isAllValid {
               self.startAnimating()
               var param = [:] as [String : Any]
               param["ContractorID"] = sharedManager.currentUser.ContractorID
               let tmpTotalExp : TotalExperience = TotalExperience();
               tmpTotalExp.ExperienceList = experiences
               let dictionary = Mapper<TotalExperience>().toJSON(tmpTotalExp)
               
               
               param["JsonData"] = JSON(dictionary)
               
               
               print(param)
               AFWrapper.requestPOSTURL(Constants.URLS.ContractorExperienceAdd, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                    (JSONResponse) -> Void in
                    
                    
                    
                    if JSONResponse != nil {
                         
                         if JSONResponse["status"].rawString()! == "1"
                         {
                              let userDefaults = UserDefaults.standard
                              
                            
                              self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                            userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                            userDefaults.synchronize()
                              self.stopAnimating()
                              let obj : EditCertificate = self.storyboard?.instantiateViewController(withIdentifier: "EditCertificate") as! EditCertificate
                              self.navigationController?.pushViewController(obj, animated: true)
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
                    self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
               }
          }
          
     }
     @IBAction func actionSkip(sender : UIButton){
          let obj : EditCertificate = self.storyboard?.instantiateViewController(withIdentifier: "EditCertificate") as! EditCertificate
          self.navigationController?.pushViewController(obj, animated: true)
     }
    
    // Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag >= 100000 && textField.tag < 200000  {
            sharedManager.currentUser.ExperienceList?[textField.tag-100000].CompanyName = textField.text!
        }
        else if textField.tag >= 200000 && textField.tag < 300000  {
            sharedManager.currentUser.ExperienceList?[textField.tag-200000].Title = textField.text!
        }
        else if textField.tag >= 300000 {
            sharedManager.currentUser.ExperienceList?[textField.tag-300000].ExperienceYear = textField.text!
        }
    }
    
    @IBAction func actionBack(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

