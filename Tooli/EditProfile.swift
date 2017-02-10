//
//  EditProfile.swift
//  Tooli
//
//  Created by Impero-Moin on 19/01/17.
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

class EditProfile: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable
{
    var DobWebString : String!
    
    let sharedManager : Globals = Globals.sharedInstance
    
    @IBOutlet var lblDistance : UILabel!
    @IBOutlet var txtAddress : UITextField!
    @IBOutlet weak var BtnDob: UIButton!
    @IBAction func BTnDOBtapped(_ sender: UIButton) {
        
        //var selectedDate : Date!
        
        let secondsInMinYear: TimeInterval = 18 * 365 * 24 * 60 * 60;
        if selectedDate == nil {
            selectedDate = NSDate(timeInterval: -secondsInMinYear, since: NSDate() as Date) as Date!
        }
        
        
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.date, selectedDate: selectedDate, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            let dob : Date = value as! Date
            self.BtnDob.titleLabel?.text = dob.toDisplayString()
            self.DobWebString = dob.toWebString()
            
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        
        //datePicker?.minimumDate = NSDate(timeInterval: -secondsInMinYear, since: NSDate() as Date) as Date!
        datePicker?.maximumDate = NSDate(timeInterval: -secondsInMinYear, since: NSDate() as Date) as Date!
        
        datePicker?.show()
        
    }
    
    var selectedImage : UIImage?
    var selectedDate : Date!
    var imagePicker: UIImagePickerController!
    var isImageSelected : Bool = false
    var isTradeSelected : Bool = false;
    var isLicenceSelected : Bool = false;
    var isVehicleSelected : Bool = false;
    var lat = 0.0000
    var long = 0.0000
    var selectedTrade = 0;
    var selectedSkills : [String] = [];
    var integerCount = NSInteger()
    var city : String = ""
    var postcode : String = ""
    var FullAddress : String = ""
    var isVisible : Bool = false;
    
    
    @IBOutlet var slider : UISlider!
    
    @IBOutlet weak var TblSelectSkill: UITableView!
    @IBOutlet weak var SkillHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var BtnSkill: UIButton!
    
    @IBOutlet weak var BtnEdit: UIButton!
    
    @IBOutlet weak var TblSelectTrade: UITableView!
    @IBOutlet weak var TradeHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var BtnTrade: UIButton!
    
    @IBAction func ManageExpTapped(_ sender: Any) {
        let obj : EditExperience = self.storyboard?.instantiateViewController(withIdentifier: "EditExperience") as! EditExperience
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    @IBAction func ManageCertTapped(_ sender: Any) {
        let obj : EditCertificate = self.storyboard?.instantiateViewController(withIdentifier: "EditCertificate") as! EditCertificate
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func BtnUpdateProfileTapped(_ sender: Any) {
        var isValid : Bool = true
        if TxtName.text == "" {
            isValid = false
            self.view.makeToast("Please enter your firstname", duration: 3, position: .bottom)
        }
        else if TxtSurname.text == "" {
            isValid = false
            self.view.makeToast("Please enter your surname", duration: 3, position: .bottom)
        }
            
        else if TxtViewAboutme.text == "" {
            isValid = false
            self.view.makeToast("Please enter your details", duration: 3, position: .bottom)
        }
        else if TxtPerDayRate.text == "" {
            isValid = false
            self.view.makeToast("Please enter your workout perhour rate", duration: 3, position: .bottom)
        }
        else if TxtPerhourRate.text == "" {
            isValid = false
            self.view.makeToast("Please enter your workout perday rate", duration: 3, position: .bottom)
        }
        else if TxtReferalCode.text == "" {
            isValid = false
            self.view.makeToast("Please enter zip code", duration: 3, position: .bottom)
        }
        else if selectedSkills.count == 0 {
            isValid = false
            self.view.makeToast("Please select at least one skill", duration: 3, position: .bottom)
        }
        else if txtAddress.text == "" {
            isValid = false
            self.view.makeToast("Please enter valid", duration: 3, position: .bottom)
        }
        
        if  isValid {
            self.startAnimating()
            var param = [:] as [String : Any]
            param["ContractorID"] = sharedManager.currentUser.ContractorID
            param["TradeCategoryID"] = sharedManager.masters.DataList?[selectedTrade].PrimaryID
            param["Aboutme"] = self.TxtViewAboutme.text
            param["Latitude"] = self.lat
            param["Longitude"] = self.long
            param["FullAddress"] = self.FullAddress
            param["StreetAddress"] = self.FullAddress
            param["CityName"] = self.city
            param["Zipcode"] = self.postcode
            param["DOB"] = self.DobWebString
            param["strPerHourRate"] = self.TxtPerhourRate.text
            param["strPerDayRate"] = self.TxtPerDayRate.text
            param["IsLicenceHeld"] = self.isLicenceSelected  ? "true" : "false"
            param["IsOwnVehicle"] = self.isVehicleSelected ? "true" : "false"
            param["DistanceRadius"] = Int(self.slider.value)
            param["CompanyName"] = Int(self.slider.value)
            param["ServiceIDGroup"] = self.selectedSkills.joined(separator: ",")
            
            
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.ContractorProfileUpdate, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                let userDefaults = UserDefaults.standard
                userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                userDefaults.synchronize()
                if JSONResponse != nil {
                    
                    if JSONResponse["status"].rawString()! == "1"
                    {
                        let userDefaults = UserDefaults.standard
                        
                        userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                        userDefaults.synchronize()
                        
                        self.stopAnimating()
                        self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                       // let obj : EditExperience = self.storyboard?.instantiateViewController(withIdentifier: "EditExperience") as! EditExperience
                       // self.navigationController?.pushViewController(obj, animated: true)
                        
                        
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
    @IBAction func LicenceSwitchTapped(_ sender: Any) {
        if LicenceSwitch.isOn {
            isLicenceSelected = true
            
        } else {
            isLicenceSelected = false
        }
        
        
    }
    @IBAction func SwitchVehicleTapped(_ sender: Any) {
        if SwitchVehicle.isOn {
            isVehicleSelected = true
            
        } else {
            isVehicleSelected = false
        }
    }
    @IBOutlet weak var lblIsOwnVehicle: UILabel!
    @IBOutlet weak var LicenceSwitch: UISwitch!
    @IBOutlet weak var SwitchVehicle: UISwitch!
    @IBOutlet weak var islicence: UILabel!
    @IBOutlet weak var TxtPerhourRate: UITextField!
    
    @IBOutlet weak var lblIslicense: UILabel!
    @IBOutlet weak var TxtPerDayRate: UITextField!
    @IBOutlet weak var ImgProfilePic: UIImageView!
    @IBOutlet weak var TxtName: UITextField!
    @IBOutlet weak var TxtSurname: UITextField!
    @IBOutlet weak var TxtViewAboutme: UITextView!
    @IBOutlet weak var TxtReferalCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMasters()
        self.TblSelectSkill.allowsMultipleSelection = true
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        BtnEdit.isUserInteractionEnabled = true
        BtnEdit.addGestureRecognizer(tapGestureRecognizer1)
        
        self.BtnSkill.isUserInteractionEnabled = false
        SkillHeightConstraints.constant = 0
        
        
        
        TblSelectSkill.delegate = self
        TblSelectSkill.dataSource = self
        //     TblSelectSkill.rowHeight = UITableViewAutomaticDimension
        //     TblSelectSkill.estimatedRowHeight = 450
        TblSelectSkill.tableFooterView = UIView()
        
        if self.sharedManager.currentUser.ProfileImageLink != "" {
            let imgURL = self.sharedManager.currentUser.ProfileImageLink as String
            let urlPro = URL(string: imgURL)
            ImgProfilePic.kf.indicatorType = .activity
            ImgProfilePic.kf.setImage(with: urlPro)
            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.sharedManager.currentUser.ProfileImageLink)
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1)),
                .forceRefresh
            ]
            
            ImgProfilePic.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
        }

        self.TxtName.text = self.sharedManager.currentUser.FirstName as String
        self.TxtSurname.text = self.sharedManager.currentUser.LastName as String
        
        
        let iString:Int = self.sharedManager.currentUser.DistanceRadius
        let strString = String(iString)
        
        self.lblDistance.text = strString + " Miles"
        self.slider.value = Float(iString)
        self.TxtViewAboutme.text = self.sharedManager.currentUser.Aboutme as String
        self.TxtReferalCode.text = self.sharedManager.currentUser.Zipcode as String
        self.TxtPerhourRate.text = self.sharedManager.currentUser.PerHourRate as String
        self.TxtPerDayRate.text = self.sharedManager.currentUser.PerDayRate as String
        if self.sharedManager.currentUser.FullAddress != "" {
            self.txtAddress.text = self.sharedManager.currentUser.FullAddress as String
            self.FullAddress = self.sharedManager.currentUser.FullAddress as String
        }
        self.lat = self.sharedManager.currentUser.Latitude
        self.lat = self.sharedManager.currentUser.Longitude
        self.postcode = self.sharedManager.currentUser.Zipcode as String
        self.city = self.sharedManager.currentUser.CityName as String
        self.TxtReferalCode.text = self.sharedManager.currentUser.Zipcode as String
        self.BtnTrade.setTitle(self.sharedManager.currentUser.TradeCategoryName as String,for: .normal)
        self.BtnDob.setTitle(self.sharedManager.currentUser.DOB as String,for: .normal)
        
        // Set DOB
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sdate = dateFormatter.date(from: sharedManager.currentUser.DOB)
        selectedDate = sdate;
        self.DobWebString = sdate?.toWebString()
        
        selectedSkills = []
        for skill in sharedManager.currentUser.ServiceList! {
            selectedSkills.append(String(skill.ServiceID))
        }
        
        
        
        
        self.BtnDob.setTitleColor(Color.black, for: .normal)
        
        
        self.BtnTrade.setTitleColor(Color.black, for: .normal)
        if  self.sharedManager.currentUser.ServiceList?.count == 0 {
            self.BtnSkill.setTitle("Select ", for: .normal);
        }
        else {
            self.BtnSkill.setTitle(self.sharedManager.currentUser.ServiceList?[0].ServiceName,for: .normal)
        }
        self.BtnSkill.setTitleColor(Color.black, for: .normal)
        if self.sharedManager.currentUser.IsOwnVehicle == true {
            SwitchVehicle.setOn(true, animated: true)
        }
        else
            
        {
            SwitchVehicle.setOn(false, animated: true)
            
        }
        if self.sharedManager.currentUser.IsLicenceHeld == true
        {
            LicenceSwitch.setOn(true, animated: true)
            
        }
        else
        {
            LicenceSwitch.setOn(false, animated: true)
            
        }
        
    }
    
    
    //     func setValues() {
    //          if (sharedManager.currentUser != nil) {
    //               self.txtabout.text = sharedManager.currentUser.Aboutme
    //               self.txtphone.text = sharedManager.currentUser.LandlineNumber
    //               self.txtmobile.text = sharedManager.currentUser.MobileNumber
    //               self.txtdateofbirth.text = sharedManager.currentUser.DOB
    //               let dateFormatter = DateFormatter()
    //               dateFormatter.dateFormat = "yyyy-MM-dd"
    //               self.selectedDate = dateFormatter.date(from: sharedManager.currentUser.DOB)
    //
    //               self.txtdateofbirth.text = self.selectedDate.toDisplayString()
    //          }
    //     }
    @IBAction func ValueChanged(_ sender: UISlider) {
        self.lblDistance.text = "\(Int(sender.value)) Miles"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func BtnBackTapped(_ sender: Any) {
        
//        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        app.moveToDashboard()
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func BtnEditProfileTapped(_ sender: Any) {
        
        
        
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
                    self.BtnSkill.isUserInteractionEnabled = true
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
                    
                    self.integerCount = (self.sharedManager.masters.DataList![index].ServiceList?.count)! as NSInteger
                    let One = self.integerCount * 44 as NSInteger
                    self.SkillHeightConstraints.constant = CGFloat(One)
                    self.TblSelectSkill.reloadData()
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
    @IBAction func BtnTradeTapped(_ sender: Any) {
        
        //          if BtnTrade.isSelected {
        //               TradeHeightConstraints.constant = 0
        //               BtnTrade.isSelected = false
        //          }
        //          else{
        //               BtnTrade.isSelected = true
        //               TradeHeightConstraints.constant = 44 * 10
        //
        //               TblSelectTrade.reloadData()
        //          }
        
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
            self.isVisible = true
            
            self.TblSelectSkill.reloadData()

            self.BtnTrade.setTitle(String(describing: index!), for: UIControlState.normal)
            print("index = \(index!)")
            print("picker = \(picker)")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
        
    }
    @IBAction func BtnSkillTapped(_ sender: Any) {
        
        if isVisible == true {
            self.SkillHeightConstraints.constant = 0
            isVisible = false
        }
        else
        {
            
            self.integerCount = (self.sharedManager.masters.DataList![self.selectedTrade].ServiceList?.count)! as NSInteger
            let One = self.integerCount * 44 as NSInteger
            self.SkillHeightConstraints.constant = CGFloat(One)
            isVisible = true
            
            
        }
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
        //          if tableView == self.TblSelectTrade {
        //               let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //
        //               cell.textLabel?.text = "Skills " +  "\(sharedManager.masters.DataList![selectedTrade].ServiceList![indexPath.row].ServiceName)"
        //               cell.accessoryType = cell.isSelected ? .checkmark : .none
        //               cell.selectionStyle = .none // to prevent cells from being "highlighted"
        //               return cell
        //          }
        //          else{
        //               let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //
        //               cell.textLabel?.text = "Skills " +  "\(indexPath.row)"
        //               return cell
        //          }
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
    
    
    
    func imageTapped(img: AnyObject) {
        
        self.view.endEditing(true)
        let alert : UIAlertController = UIAlertController(title: "Upload Image", message: "Select your profile Picture", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take From Camera", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.takePhoto()
        }))
        
        alert.addAction(UIAlertAction(title: "Use Gallery", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.selectFromGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
            
        }))
        self.present(alert, animated: true) {
            
        }
    }
    func takePhoto() {
        self.view.endEditing(true)
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    func selectFromGallery() {
        self.view.endEditing(true)
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil);
        
        isImageSelected=true
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = image
            self.ImgProfilePic?.layer.cornerRadius = self.ImgProfilePic.frame.size.height/2
            self.ImgProfilePic?.clipsToBounds = true
            self.ImgProfilePic?.image = selectedImage
            self.uploadphoto()
        }
    }
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
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        autocompleteController.navigationController?.setToolbarHidden(false, animated: true)
        present(autocompleteController, animated: true, completion: nil)
    }
    func uploadphoto(){
        
        self.startAnimating()
        
        var image = self.ImgProfilePic.image!
        
        print(image)
        let pid : String =  String(self.sharedManager.currentUser.ContractorID)
        
        let parameters = [
            "PrimaryID": pid ,
            "PageType" : "contractor"
            ] as [String : Any]
        image = Globals.compressForUpload(original: image, withHeightLimit: 1100, andWidthLimit: 800)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(image, 0.3)!, withName: "file", fileName: "toolicontractor.png", mimeType: "image/png")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:"http://tooli.blush.cloud/FileHandler.ashx?PrimaryID=" + String(sharedManager.currentUser.ContractorID) + "&PageType=contractor")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                })
                
                upload.responseJSON { response in
                    self.stopAnimating()
                    
                    print(response.result)
                    switch  response.result  {
                    case .success(let JSON):
                        let response1 = JSON as! NSDictionary
                        if String(describing: response1.object(forKey: "status")!) == "1" {
                            self.sharedManager.currentUser.ProfileImageLink=response1.object(forKey: "FileLink")! as! String
                            
                            
                            
                        }
                        else
                        {
                            self.view.makeToast("\(response1.object(forKey: "message")!)", duration: 3, position: .bottom)
                        }
                        
                    case .failure(let error):
                        self.view.makeToast("Server error. Please try again later. \(error)", duration: 3, position: .bottom)
                        
                    }
                    
                    
                }
                
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                break
            }
        }
    }
    
    
    
    
    
}
extension EditProfile: GMSAutocompleteViewControllerDelegate {
    
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
                self.TxtReferalCode.text = tmt.name
                
            }
        }
        self.txtAddress.text = place.formattedAddress!
        self.FullAddress = place.formattedAddress!
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
