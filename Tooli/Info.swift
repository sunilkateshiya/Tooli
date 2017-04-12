//
//  Info.swift
//  Tooli
//
//  Created by Moin Shirazi on 19/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Alamofire
import GooglePlaces
import ActionSheetPicker_3_0
import Kingfisher
class Info: UIViewController, NVActivityIndicatorViewable, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet var txtphone : UITextField!
    @IBOutlet var txtmobile : UITextField!
    @IBOutlet var txtdateofbirth : UITextField!
    
    @IBOutlet var imguser : UIImageView!
    @IBOutlet var txtabout : UITextView!
    
    var selectedImage : UIImage?
    var imagePicker: UIImagePickerController!
    var isImageSelected : Bool = false
    var sharedManager : Globals = Globals.sharedInstance
    var selectedDate : Date!
    var placeholderLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        imguser.isUserInteractionEnabled = true
        imguser.addGestureRecognizer(tapGestureRecognizer)
        
        txtabout.delegate = self
       
        
        setValues()
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "About me"
        //     placeholderLabel.font = UIFont(name: "BabasNeue", size: 106)
        placeholderLabel.font = UIFont.systemFont(ofSize: (txtabout.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtabout.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtabout.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtabout.text.isEmpty
    

        // Do any additional setup after loading the view.
     
    }

    
    func setValues() {
        if (sharedManager.currentUser != nil) {
            self.txtabout.text = sharedManager.currentUser.Aboutme
            self.txtphone.text = sharedManager.currentUser.LandlineNumber
            self.txtmobile.text = sharedManager.currentUser.MobileNumber
            self.txtdateofbirth.text = sharedManager.currentUser.DOB
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.selectedDate = dateFormatter.date(from: sharedManager.currentUser.DOB)
            if (self.selectedDate != nil) {
                self.txtdateofbirth.text = self.selectedDate.toDisplayString()
            }
            
            if self.sharedManager.currentUser.ProfileImageLink != "" {
                let imgURL = self.sharedManager.currentUser.ProfileImageLink as String
                let urlPro = URL(string: imgURL)
                self.imguser.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.sharedManager.currentUser.ProfileImageLink)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    .forceRefresh
                ]
                
                self.imguser.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
            }
            
        }
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        if textView.text == "About me" {
//            textView.text = ""
//            textView.textColor = UIColor.black
//        }
//        return true
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
//       func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        if textView.text == "" {
//            textView.text = "About me"
//             textView.textColor = UIColor.darkGray
//        }
//        return true
//    }
//    
    @IBAction func btnnext(_ sender: Any) {
        self.view.endEditing(true)
        var validflag = 0
        if (self.txtmobile?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter mobile number.", duration: 3, position: .bottom)
            validflag = 1
        }
        else if (self.txtabout?.text?.characters.count)! == 0  || self.txtabout.text == "" {
            self.view.makeToast("Please enter about me.", duration: 3, position: .bottom)
            validflag = 1
        }
//        else if isImageSelected == false  {
//            self.view.makeToast("Please select image.", duration: 3, position: .bottom)
//            validflag = 1
//        }
    
        if validflag == 0 {
            
            var Dob = ""
            if(self.selectedDate != nil)
            {
              Dob = self.selectedDate.toWebString()
            }
            self.startAnimating()
            let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                         "LandlineNumber": self.txtphone.text!,
                         "MobileNumber": self.txtmobile.text!,
                         "DOB":Dob,
                         "Aboutme":self.txtabout.text!] as [String : Any]
            
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.ContractorInfoUpdate, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                let userDefaults = UserDefaults.standard
                userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                userDefaults.synchronize()
                if  self.isImageSelected {
                
                    self.uploadphoto()
                    
                }
                //self.stopAnimating()
                
                print(JSONResponse["status"].rawValue as! String)
                
                if JSONResponse != nil{
                    
                    if JSONResponse["status"].rawString()! == "1"
                    {
                        let userDefaults = UserDefaults.standard
                        
                        userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                        userDefaults.synchronize()
                        if  !self.isImageSelected {
                            let obj : YourTrades = self.storyboard?.instantiateViewController(withIdentifier: "YourTrades") as! YourTrades
                            self.navigationController?.pushViewController(obj, animated: true)
                        }

                        
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
            self.imguser?.layer.cornerRadius = 39
            self.imguser?.clipsToBounds = true
            self.imguser?.image = selectedImage
        }
    }
    
    func uploadphoto(){
        
        self.startAnimating()
        
        var image = self.imguser.image!
        
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
        }, to:Constants.URLS.Base_Url+"/FileHandler.ashx?PrimaryID=" + String(sharedManager.currentUser.ContractorID) + "&PageType=contractor")
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
                                let obj : YourTrades = self.storyboard?.instantiateViewController(withIdentifier: "YourTrades") as! YourTrades
                                self.navigationController?.pushViewController(obj, animated: true)
                            }
                            else
                            {
                                self.view.makeToast("\(response1.object(forKey: "message")!)", duration: 3, position: .bottom)
                        }
                        
                        case .failure(let error):
                            self.stopAnimating()
                            self.view.makeToast("Server error. Please try again later. \(error)", duration: 3, position: .bottom)
                    
                    }
                    
                    
                }
                
            case .failure(let encodingError):
                self.stopAnimating()
                print(encodingError.localizedDescription)
                break
            }
        }
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - AutoComplete Code
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "info Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    @IBAction func autocompleteClicked(_ sender: UIButton) {
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
            self.txtdateofbirth.text = dob.toDisplayString()
            self.selectedDate = dob
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        
        //datePicker?.minimumDate = NSDate(timeInterval: -secondsInMinYear, since: NSDate() as Date) as Date!
        datePicker?.maximumDate = NSDate(timeInterval: -secondsInMinYear, since: NSDate() as Date) as Date!
        
        datePicker?.show()
        
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

extension Info: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
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
