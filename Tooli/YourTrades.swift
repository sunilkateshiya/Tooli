//
//  YourTrades.swift
//  Tooli
//
//  Created by Moin Shirazi on 09/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import GooglePlaces
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
import ActionSheetPicker_3_0
class YourTrades: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {

    @IBOutlet var vwhide : UIView!
    @IBOutlet var vwhideheight : NSLayoutConstraint!
    
    @IBOutlet var tvtrades : UITableView!
    @IBOutlet var tvtradesheight : NSLayoutConstraint!
  
    @IBOutlet var tvskills : UITableView!
    @IBOutlet var tvskillsheight : NSLayoutConstraint!
    
    @IBOutlet var btnskills : UIButton!
    @IBOutlet var btntrades : UIButton!

    @IBOutlet var txtAdderess : UITextField!
    @IBOutlet var lblDistance : UILabel!
    @IBOutlet var txtPostcode : UITextField!
    
    @IBOutlet var slider : UISlider!
    
    var city : String = ""
    var postcode : String = ""
    
    var sharedManager : Globals = Globals.sharedInstance
    var isTradeSelected : Bool = false;
    var selectedTrade = 0;
    var selectedSkills : [String] = [];
    var lat = 0.0000
    var long = 0.0000

    override func viewDidLoad() {
        super.viewDidLoad()

       // vwhide.isHidden = true
        vwhideheight.constant = 0
        tvtradesheight.constant = 0
        tvskillsheight.constant = 0
        
        tvtrades.delegate = self
        tvtrades.dataSource = self
        tvtrades.rowHeight = UITableViewAutomaticDimension
        tvtrades.estimatedRowHeight = 450
        tvtrades.tableFooterView = UIView()
       
        tvskills.delegate = self
        tvskills.dataSource = self
        tvskills.rowHeight = UITableViewAutomaticDimension
        tvskills.estimatedRowHeight = 450
        tvskills.tableFooterView = UIView()
        getMasters()
       
        
        self.tvskills.allowsMultipleSelection = true

        let leftTrackImage = UIImage(named: "mySlider")
        slider.setThumbImage(leftTrackImage, for: .normal)
        //setValues()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "YourTrades Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func setValues() {
        if (sharedManager.currentUser != nil) {
            self.txtAdderess.text = sharedManager.currentUser.StreetAddress
            self.txtPostcode.text = sharedManager.currentUser.Zipcode
            self.slider.value = Float(Int(sharedManager.currentUser.DistanceRadius))
           
            self.postcode=sharedManager.currentUser.Zipcode
            self.city = sharedManager.currentUser.CityName
            
            self.lat = sharedManager.currentUser.Latitude
            self.long = sharedManager.currentUser.Longitude
            
            if sharedManager.currentUser.TradeCategoryID == 0 && sharedManager.currentUser.TradeCategoryName == "" {
                 self.btntrades.setTitle(String(describing: "Select Trade"), for: UIControlState.normal)
                
                return;
            }
            
            for currentService in sharedManager.currentUser.ServiceList! {
                selectedSkills.append(String(currentService.ServiceID))
            }
            
            var i = 0;
            if (sharedManager.masters != nil) {
                for trades in sharedManager.masters.DataList! {
                    
                    if trades.PrimaryID == sharedManager.currentUser.TradeCategoryID {
                        selectedTrade = i
                        self.btntrades.setTitle(trades.TradeCategoryName, for: UIControlState.normal)
                    }
                    i = i + 1;
                }
            }
            
            //btnskills.isSelected = true
            tvskillsheight.constant = 44 * 10
            
            self.tvskills.isHidden = false
            self.tvskills.reloadData()

        }
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
                    self.setValues()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btntrades(_ sender: Any) {

        var trades : [String] = []
        for trade in  sharedManager.masters.DataList! {
            trades.append(trade.TradeCategoryName)
        }
        
        
        ActionSheetStringPicker.show(withTitle: "Select Trade", rows: trades, initialSelection: 0, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            self.selectedTrade = value
            
            // Reload table
            self.tvskills.reloadData()
            self.btntrades.setTitle(String(describing: index!), for: UIControlState.normal)
            
            print("index = \(index!)")
            print("picker = \(picker)")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
//        if btntrades.isSelected {
//            tvtradesheight.constant = 0
//            btntrades.isSelected = false
//        }
//        else{
//            btntrades.isSelected = true
//            tvtradesheight.constant = 44 * 10
//
//            tvtrades.reloadData()
//        }
    }
   
    @IBAction func btnskills(_ sender: Any) {
        
        if btnskills.isSelected {
//            tvskillsheight.constant = 0
//            btnskills.isSelected = false
        }
        else{
           // btnskills.isSelected = true
            tvskillsheight.constant = 44 * 10
            
            tvskills.reloadData()
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        guard ((sharedManager.masters) != nil) else {
            return 0
        }
        
        return  (sharedManager.masters.DataList![selectedTrade].ServiceList?.count)!
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SkillCell
        
        cell.lblSkillName?.text = "Skills " +  "\(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceName)"
        if  selectedSkills .contains(String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID)) {
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
        }
        else {
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SkillCell
        
        if  selectedSkills .contains(String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID)) {
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
            selectedSkills.remove(at: selectedSkills.index(of: String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID))! )
        }
        else {
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
            selectedSkills.append(String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID))
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SkillCell
        if  selectedSkills .contains(String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID)) {
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_uncheck")
            selectedSkills.remove(at: selectedSkills.index(of: String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID))! )
        }
        else {
            cell.ImgAccesoryView.image = #imageLiteral(resourceName: "ic_check")
            selectedSkills.append(String(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceID))
        }
    }
    // MARK: - AutoComplete Code
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.tintColor = UIColor.red
        let header : UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: 60))
        header.backgroundColor=UIColor.red
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        autocompleteController.view.addSubview(header)
        
        let filter = GMSAutocompleteFilter();
        filter.type = GMSPlacesAutocompleteTypeFilter.city
        
        //autocompleteController.autocompleteFilter = filter
        
        autocompleteController.navigationController?.setToolbarHidden(false, animated: true)
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBAction func valueChanged (sender : UISlider) {
        self.lblDistance.text = "\(Int(sender.value)) Miles"
    }
    
    @IBAction func actionBack(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSubmit(sender : UIButton) {
        var isValid : Bool = true
        if txtPostcode.text == "" {
            isValid = false
            self.view.makeToast("Please enter valid postcode", duration: 3, position: .center)
        }
        else if txtAdderess.text == "" {
            isValid = false
            self.view.makeToast("Please enter valid address", duration: 3, position: .center)
        }
        else if selectedSkills.count == 0 {
            isValid = false
            self.view.makeToast("Please select at least one skill", duration: 3, position: .center)
        }
        
        if  isValid {
            self.startAnimating()
            var param = [:] as [String : Any]
            param["ContractorID"] = sharedManager.currentUser.ContractorID
            param["TradeCategoryID"] = sharedManager.masters.DataList?[selectedTrade].PrimaryID
            param["FullAddress"] = self.txtAdderess.text
            param["CityName"] = self.city
            param["StreetAddress"] = self.txtAdderess.text
            param["Zipcode"] = self.postcode
            param["DistanceRadius"] = Int(self.slider.value)
            param["Latitude"] = self.lat
            param["Longitude"] = self.long
            param["ServiceIDGroup"] = self.selectedSkills.joined(separator: ",")
            
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.ContractorTradeUpdate, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                
                if JSONResponse != nil {
                    
                    if JSONResponse["status"].rawString()! == "1"
                    {
                        let userDefaults = UserDefaults.standard
                        
                        userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                        userDefaults.synchronize()

                        self.stopAnimating()
                        
                        let obj : Experience = self.storyboard?.instantiateViewController(withIdentifier: "Experience") as! Experience
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
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension YourTrades: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")
        print("Place attributions: \(place.attributions)")
        
        self.lat = (place.coordinate.latitude)
        self.long = (place.coordinate.longitude)
        
        for tmt in place.addressComponents! {
            if tmt.type == "administrative_area_level_2" {
                 print("City is : \(tmt.name) ")
                 self.city = tmt.name
            }
            if tmt.type == "postal_code" {
                print("Postal code is : \(tmt.name) ")
                self.postcode = tmt.name
                self.txtPostcode.text = tmt.name
            }
        }
        
        self.txtAdderess.text = place.formattedAddress
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
