//
//  ViewController.swift
//  Tooli
//
//  Created by Moin Shirazi on 02/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
import SwiftyJSON
class Experience: UIViewController,UITableViewDelegate, UITableViewDataSource ,NVActivityIndicatorViewable {

    
    @IBOutlet weak var tvBlogList: UITableView!
    var i : Int = 0
    var experiences :[Experiences] = []
    var jsonExp : [String : AnyObject] = [:]
    
    let sharedManager : Globals = Globals.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        i = 1
        tvBlogList.delegate = self
        tvBlogList.dataSource = self
        tvBlogList.rowHeight = UITableViewAutomaticDimension
        tvBlogList.estimatedRowHeight = 450
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeRows(notiffy:)), name: NSNotification.Name(rawValue: "RemoveCell"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func removeRows(notiffy : Notification) {
     //   let dict = notiffy.userInfo as! [String:String]
        i = i - 1
        let indePath = NSIndexPath(row: (notiffy.userInfo!["index"]! as! Int), section: 0)
        self.tvBlogList.deleteRows(at: [indePath as IndexPath], with: UITableViewRowAnimation.automatic)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(i)
        return i
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExperienceCell
        cell.btnClose.tag = indexPath.row + 100
        return cell
    }
    
    @IBAction func btnAddExp(_ sender: Any) {
        
        i = i + 1
        tvBlogList.reloadData()
    }
    
    
    @IBAction func actionSubmit(sender : UIButton){
        var isAllValid : Bool = true
        
        for index in 0 ..< i {
            var isValid : Bool = true
            let expCell = tvBlogList.cellForRow(at: IndexPath(row: index, section: 0)) as! ExperienceCell
            if expCell.txtJobTitle.text == "" {
                isValid = false
                self.view.makeToast("Please enter valid Job Title", duration: 3, position: .bottom)
            }
            else if expCell.txtCompany.text == "" {
                isValid = false
                self.view.makeToast("Please enter valid Company", duration: 3, position: .bottom)
            }
            else if expCell.txtExperience.text == "" {
                isValid = false
                self.view.makeToast("Please enter valid Experience", duration: 3, position: .bottom)
            }
            if !isValid {
                isAllValid = false
                
                break;
            }
            if isValid {
                let tmpExp : Experiences = Experiences()
                tmpExp.Title = expCell.txtJobTitle.text!
                tmpExp.ExperienceYear = expCell.txtExperience.text!
                tmpExp.CompanyName = expCell.txtCompany.text!
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
                        
                        userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                        userDefaults.synchronize()
                        self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                        self.stopAnimating()
                        
                        let obj : RatesTravel = self.storyboard?.instantiateViewController(withIdentifier: "RatesTravel") as! RatesTravel
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
        let obj : RatesTravel = self.storyboard?.instantiateViewController(withIdentifier: "RatesTravel") as! RatesTravel
        self.navigationController?.pushViewController(obj, animated: true)
    }
    

}

