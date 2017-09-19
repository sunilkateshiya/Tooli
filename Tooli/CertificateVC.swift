
//
//  CertificateVC.swift
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

class CertificateVC: UIViewController,UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NVActivityIndicatorViewable {
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tabCerti: UITableView!
    var imagePicker: UIImagePickerController!
    var selectedImage : UIImage?
    @IBOutlet weak var lblTitle: UILabel!
    var CertificateList:GetDefaultCertificate = GetDefaultCertificate()
    var AllCertificateList:GetCertificateList = GetCertificateList()
    var uploadedId:[Int] = []
    var selectedCertificateId:Int = 0
    var edit:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        tabCerti.estimatedRowHeight = 100
        tabCerti.rowHeight = UITableViewAutomaticDimension
        GetAllDataFromServer()
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
        return AllCertificateList.Result.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CertificateCell
        cell.lblTitle.text = AllCertificateList.Result[indexPath.row].CertificateName
        if(uploadedId.contains(AllCertificateList.Result[indexPath.row].CertificateID))
        {
            cell.btnStatus.isSelected = true
            cell.btnRemove.isHidden = false
            cell.btnUpload.isHidden = true
        }
        else
        {
            cell.btnStatus.isSelected = false
            cell.btnRemove.isHidden = true
            cell.btnUpload.isHidden = false
        }
        cell.btnUpload.tag = indexPath.row
        cell.btnUpload.addTarget(self, action: #selector(CertificateVC.selecteImage(_:)), for: UIControlEvents.touchUpInside)
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(CertificateVC.DeleteCertificateToServer(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func takePhoto() {
        self.view.endEditing(true)
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func selectFromGallery() {
        self.view.endEditing(true)
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = image
            uploadCertificate()
            //uploadphoto()
        } else{
            print("Something went wrong")
        }
        picker.dismiss(animated: true, completion: nil);
    }
    func selecteImage(_ sender:UIButton)
    {
        selectedCertificateId = AllCertificateList.Result[sender.tag].CertificateID
        let alert : UIAlertController = UIAlertController(title: "Upload Image", message: "Select your certificates", preferredStyle: UIAlertControllerStyle.actionSheet)
        
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
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: UIButton)
    {
        if(self.edit)
        {
             self.navigationController?.popViewController(animated: true)
        }
        else
        {
            FinishSetupProfile()
        }
        
    }
    func GetAllCertificateDataFromServer()
    {
        self.startAnimating()
         AFWrapper.requestGetUrlWithParam(Constants.URLS.GetDefaultCertificate, params : nil,headers : nil  ,  success: { (JSONResponse) in
            self.stopAnimating()
            if JSONResponse["Status"].int == 1
            {
                self.AllCertificateList = Mapper<GetCertificateList>().map(JSONObject: JSONResponse.rawValue)!
                
                self.tabCerti.reloadData()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
        }) { (error) in
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func GetAllDataFromServer()
    {
        self.startAnimating()
        AFWrapper.requestGetUrlWithParam(Constants.URLS.GetCertificate, params : nil,headers : nil  ,  success: { (JSONResponse) in
            self.stopAnimating()
            if JSONResponse["Status"].int == 1
            {
                self.CertificateList = Mapper<GetDefaultCertificate>().map(JSONObject: JSONResponse.rawValue)!
                for temp in self.CertificateList.Result
                {
                    self.uploadedId.append(temp.CertificateID)
                }
                self.tabCerti.reloadData()
                self.GetAllCertificateDataFromServer()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
        }) { (error) in
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func FinishSetupProfile()
    {
        self.startAnimating()
        var param = [:] as [String : Any]
     //   param[""] = ""
        print(param)
        AFWrapper.requestGetUrlWithParam(Constants.URLS.ProfileStepFinish, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            if JSONResponse != nil {
                if JSONResponse["Status"].int == 1
                {
                   UserDefaults.standard.set(true, forKey: Constants.KEYS.IS_SET_PROFILE)
                   AppDelegate.sharedInstance().initSignalR()
                   AppDelegate.sharedInstance().moveToDashboard()
                    
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
    func DeleteCertificateToServer(_ sender:UIButton)
    {
        self.startAnimating()
        var param = [:] as [String : Any]
        param["CertificateID"] = AllCertificateList.Result[sender.tag].CertificateID
        print(param)
        
        AFWrapper.requestPOSTURL(Constants.URLS.CertificateDelete, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            if JSONResponse != nil {
                if JSONResponse["Status"].int == 1
                {
                    self.uploadedId.remove(at: self.uploadedId.index(of: self.AllCertificateList.Result[sender.tag].CertificateID)!)
                    self.tabCerti.reloadData()
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
    
    func uploadCertificate()
    {
        self.startAnimating()
        let parameters = [
            "CertificateID": "\(selectedCertificateId)"
            ] as [String : Any]
        self.selectedImage = Globals.compressForUpload(original: self.selectedImage!, withHeightLimit: 1100, andWidthLimit: 800)
        let header = ["Authorization": String.localizedStringWithFormat("%@",UserDefaults.standard.string(forKey: Constants.KEYS.TOKEN)! as String)]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(self.selectedImage!, 0.3)!, withName: "CertificateFile", fileName: "toolicontractor.png", mimeType: "image/png")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:Constants.URLS.CertificateAdd,headers: header)
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
                        if "\(response1.object(forKey: "Status")!)" == "1"
                        {
                            self.uploadedId.append(self.selectedCertificateId)
                            self.tabCerti.reloadData()
                            self.view.makeToast("\(response1.object(forKey: "Message")!)",duration: 3, position: .center)
                        }
                        else
                        {
                            self.view.makeToast("\(response1.object(forKey: "Message")!)", duration: 3, position: .center)
                        }
                    case .failure(let error):
                        self.stopAnimating()
                        self.view.makeToast("Server error. Please try again later. \(error)", duration: 3, position: .center)
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
