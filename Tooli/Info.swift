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

class Info: UIViewController, NVActivityIndicatorViewable, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var txtphone : UITextField!
    @IBOutlet var txtmobile : UITextField!
    @IBOutlet var txtdateofbirth : UITextField!

    
    @IBOutlet var imguser : UIImageView!
    @IBOutlet var txtabout : UITextView!
    
    var selectedImage : UIImage?
    var imagePicker: UIImagePickerController!
    var isImageSelected : Bool = false
    var sharedManager : Globals = Globals.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        imguser.isUserInteractionEnabled = true
        imguser.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnnext(_ sender: Any) {
        
        var validflag = 0
        if (self.txtmobile?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter mobile number.", duration: 3, position: .bottom)
            validflag = 1
        }
        else if (self.txtabout?.text?.characters.count)! == 0  {
            self.view.makeToast("Please enter about me.", duration: 3, position: .bottom)
            validflag = 1
        }
        else if isImageSelected == false  {
            self.view.makeToast("Please select image.", duration: 3, position: .bottom)
            validflag = 1
        }
        
        
        if validflag == 0 {
            
            self.startAnimating()
            let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                         "LandlineNumber": self.txtphone.text!,
                         "MobileNumber": self.txtmobile.text!,
                         "DOB":self.txtdateofbirth.text!,
                         "Aboutme":self.txtabout.text!] as [String : Any]
            
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.ContractorInfoUpdate, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                
                self.stopAnimating()
                
                print(JSONResponse["status"].rawValue as! String)
                
                if JSONResponse != nil{
                    
                    if JSONResponse["status"].rawString()! == "1"
                    {
                        let userDefaults = UserDefaults.standard
                        
                        userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                        userDefaults.synchronize()
                        
                        let obj : YourTrades = self.storyboard?.instantiateViewController(withIdentifier: "YourTrades") as! YourTrades
                        self.navigationController?.pushViewController(obj, animated: true)
                        
                    }
                    else
                    {
                        
                    }
                    
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
                
            }) {
                (error) -> Void in
                print(error.localizedDescription)
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
            self.imguser?.image = selectedImage
        }
    }
    
    func uploadphoto(){
        
        self.startAnimating()
        
        let image = self.imguser.image!
        
        print(image)
        let pid : String =  String(self.sharedManager.currentUser.ContractorID)
        
        let parameters = [
            "PrimaryID": pid ,
            "Mode" : "Contractor"
            ] as [String : Any]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(image, 0.2)!, withName: "file", fileName: "toolicontractor.png", mimeType: "image/png")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:"http://tooli.blush.cloud/FileHandler.ashx?PrimaryID=" + String(sharedManager.currentUser.ContractorID) + "&Mode=Contractor")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                })
                
                upload.responseJSON { response in
                    self.stopAnimating()
                    
                    print(response.result)
                }
                
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                break
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
