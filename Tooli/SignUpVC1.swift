//
//  SignUpVC1.swift
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
import Alamofire
import Kingfisher

class SignUpVC1: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,NVActivityIndicatorViewable
{
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtAbout: UITextView!
    
    @IBOutlet weak var btnEmailCheck: UIButton!
    @IBOutlet weak var btnPhoneCheck: UIButton!
    @IBOutlet weak var btnMobileCheck: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var imagePicker: UIImagePickerController!
    var selectedDate : Date!
    var placeholderLabel:UILabel!
    var selectedImage : UIImage?
    var AllData:GetSignUp1 = GetSignUp1()
    var edit:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        txtAbout.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "About me"
        //     placeholderLabel.font = UIFont(name: "BabasNeue", size: 106)
        placeholderLabel.font = UIFont.systemFont(ofSize: (txtAbout.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtAbout.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtAbout.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtAbout.text.isEmpty
        
        btnMobileCheck.isSelected = true
        btnPhoneCheck.isSelected = true
        btnEmailCheck.isSelected = true
    
        
        GetUserAllDataFromServer()
        
        if(self.edit)
        {
            self.lblTitle.text = "Edit"
            btnNext.setTitle("Update", for: UIControlState.normal)
            btnBack.isHidden = false
        }
        else
        {
            btnBack.isHidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnNext(_ sender: UIButton) {
        
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC2") as! SignupVC2
      //  self.navigationController?.pushViewController(vc, animated: true)
        
        if (self.txtEmail?.text?.characters.count)! == 0 && btnEmailCheck.isSelected{
            self.view.makeToast("Please enter valid email.", duration: 3, position: .bottom)
            
        }

        else if (self.txtEmail?.text?.characters.count)! == 0{
            self.view.makeToast("Please enter valid email.", duration: 3, position: .bottom)
            
        }
        else if(!(txtEmail.text?.contains("@"))!)
        {
             self.view.makeToast("Please enter valid email.", duration: 3, position: .bottom)
        }
        else if (self.txtDob.text == "")  {
            self.view.makeToast("Please enter date of birth.", duration: 3, position: .bottom)
            
        }
        else if (self.txtCompanyName?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter company name.", duration: 3, position: .bottom)
            
        }
        else if (self.txtPhone?.text?.characters.count)! == 0 && btnPhoneCheck.isSelected {
            self.view.makeToast("Please enter phone number.", duration: 3, position: .bottom)
            
        }
        else if (self.txtPhone?.text?.characters.count)! == 0 {
            self.view.makeToast("Please enter phone number.", duration: 3, position: .bottom)
            
        }
        else if (self.txtMobile?.text?.characters.count)! == 0 && btnMobileCheck.isSelected{
            self.view.makeToast("Please enter mobile number.", duration: 3, position: .bottom)
            
        }
        else if (self.txtAbout?.text?.characters.count)! == 0  || self.txtAbout.text == "" {
            self.view.makeToast("Please enter about me.", duration: 3, position: .bottom)
        }
        else
        {
            uploadDataOnServer()
        }
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHidePublicAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func btnSelectImageAction(_ sender: UIButton)
    {
        let alert : UIAlertController = UIAlertController(title: "Upload Image", message: "Select your profile picture", preferredStyle: UIAlertControllerStyle.actionSheet)
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfile.image = image
            selectedImage = image
            //uploadphoto()
        } else{
            print("Something went wrong")
        }
        picker.dismiss(animated: true, completion: nil);
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
    }
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        textView.resignFirstResponder()
        return true
    }
    @IBAction func btnDobAction(_ sender:UIButton)
    {
        if selectedDate == nil
        {
            selectedDate = Date()
        }
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.date, selectedDate: selectedDate, doneBlock: {
            picker, value, index in
            
            let dob : Date = value as! Date
            self.txtDob.text = dob.toDisplayString()
            self.selectedDate = dob

        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        
       // datePicker?.minimumDate = NSDate(timeInterval: -secondsInMinYear, since: NSDate() as Date) as Date!
        datePicker?.maximumDate = Date()
        datePicker?.show()
    }
    func GetUserAllDataFromServer()
    {
        self.startAnimating()
        AFWrapper.requestGetUrlWithParam(Constants.URLS.ProfileStep1, params : nil,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            if JSONResponse != nil {
                if JSONResponse["Status"].int == 1
                {
                    self.AllData = Mapper<GetSignUp1>().map(JSONObject: JSONResponse.rawValue)!
                    self.SetAllDataInForm()
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
    func SetAllDataInForm()
    {
        self.txtEmail.text = self.AllData.Result.CompanyEmailAddress
        self.txtDob.text = self.AllData.Result.DateOfBirth
        self.txtWebsite.text = self.AllData.Result.Website
        self.txtCompanyName.text = self.AllData.Result.CompanyName
        self.txtPhone.text = self.AllData.Result.PhoneNumber
        self.txtMobile.text = self.AllData.Result.MobileNumber
        self.txtAbout.text = self.AllData.Result.Description
        self.btnEmailCheck.isSelected = self.AllData.Result.IsEmailPublic
        self.btnPhoneCheck.isSelected = self.AllData.Result.IsPhonePublic
        self.btnMobileCheck.isSelected = self.AllData.Result.IsMobilePublic
        
        if self.AllData.Result.ProfileImageLink != "" {
            let imgURL = self.AllData.Result.ProfileImageLink
            let urlPro = URL(string: imgURL)
            self.imgProfile.kf.indicatorType = .activity
            let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: self.AllData.Result.ProfileImageLink)
            let optionInfo: KingfisherOptionsInfo = [
                .downloadPriority(0.5),
                .transition(ImageTransition.fade(1)),
                .forceRefresh
            ]
            self.imgProfile.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "DefualtImage"), options: optionInfo, progressBlock: nil, completionHandler: nil)
        }
        placeholderLabel.isHidden = !txtAbout.text.isEmpty
    }
    func uploadDataOnServer()
    {
        self.startAnimating()
        let parameters = [
            "DateOfBirth": "\(txtDob.text!)",
            "CompanyEmailAddress": "\(txtEmail.text!)",
            "IsEmailPublic": "\(btnEmailCheck.isSelected)",
            "CompanyName": "\(txtCompanyName.text!)",
            "Website": "\(txtWebsite.text!)",
            "PhoneNumber": "\(txtPhone.text!)",
            "IsPhonePublic": "\(btnPhoneCheck.isSelected)",
            "MobileNumber": "\(txtMobile.text!)",
            "IsMobilePublic": "\(btnMobileCheck.isSelected)",
            "Description": "\(txtAbout.text!)",
            ] as [String : Any]
        
        self.selectedImage = Globals.compressForUpload(original: imgProfile.image!, withHeightLimit: 1100, andWidthLimit: 800)
        let header = ["Authorization": String.localizedStringWithFormat("%@",UserDefaults.standard.string(forKey: Constants.KEYS.TOKEN)! as String)]
        print(parameters)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(self.selectedImage!, 1)!, withName: "ProfileImage", fileName: "toolicontractor.png", mimeType: "image/png")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:Constants.URLS.ProfileStep1,headers: header)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    
                })
                upload.responseJSON { response in
                    self.stopAnimating()
                    print(response)
                    switch  response.result  {
                    case .success(let JSON):
                        let response1 = JSON as! NSDictionary
                        if String(describing: response1.object(forKey: "Status")!) == "1"
                        {
                            if(self.edit)
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                                let vc  = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC2") as! SignupVC2
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        else
                        {
                            AppDelegate.sharedInstance().window?.rootViewController?.view.makeToast("\(response1.object(forKey: "Message")!)", duration: 3, position: .center)
                        }
                        print(response1)
                    case .failure(let error):
                        self.stopAnimating()
                        self.view.makeToast("Server error. Please try again later.", duration: 3, position: .center)
                    }
                }
                
            case .failure(let encodingError):
                self.stopAnimating()
                print(encodingError.localizedDescription)
                break
            }
        }
    }

}
