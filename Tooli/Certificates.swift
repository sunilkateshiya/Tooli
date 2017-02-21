//
//  Certificates.swift
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

class Certificates: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable , UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var tvcerts : UITableView!
    
    @IBOutlet var btncerts : UIButton!
    var selectedImage : UIImage?
    var imagePicker: UIImagePickerController!
    var isImageSelected : Bool = false
    var selectedCell : CertificateCell!
    let sharedManager : Globals = Globals.sharedInstance
    var certificates : [CertificateCategoryList] = []
    var selectedCertificates : CertificateCategoryList!
    var appDelegate : AppDelegate!
    var cellImages : [UIImageView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        tvcerts.delegate = self
        tvcerts.dataSource = self
        tvcerts.rowHeight = UITableViewAutomaticDimension
        tvcerts.estimatedRowHeight = 450
        tvcerts.tableFooterView = UIView()
        tvcerts.allowsMultipleSelection = true
        self.tvcerts.allowsSelection = true
        tvcerts.isHidden = false
        if sharedManager.masters == nil {
            getMasters()
        }
        else {
            for trade in self.sharedManager.masters.DataList! {
                if  trade.PrimaryID == self.sharedManager.currentUser.TradeCategoryID {
                    for cert in trade.CertificateCategoryList! {
                        let tmpCert : CertificateCategoryList = cert
                        self.certificates.append(tmpCert)
                    }
                }
            }
            tvcerts.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.updateUserInfo()
    }
    
    func getMasters(){
        // Z_MasterDataList
        
        self.startAnimating()
        let param = [:] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.Z_MasterDataList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil {
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    
                    self.sharedManager.masters = Mapper<Masters>().map(JSONObject: JSONResponse.rawValue)
                    
                    for trade in self.sharedManager.masters.DataList! {
                        if  trade.PrimaryID == self.sharedManager.currentUser.TradeCategoryID {
                            for cert in trade.CertificateCategoryList! {
                                let tmpCert : CertificateCategoryList = cert
                                self.certificates.append(tmpCert)
                            }
                        }
                    }
                    self.tvcerts.reloadData()
                    
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btncerts(_ sender: Any) {
        
//        if btncerts.isSelected {
//            tvcerts.isHidden = true
//            btncerts.isSelected = false
//        }
//        else{
//            btncerts.isSelected = true
//            tvcerts.isHidden = false
//            
//            tvcerts.reloadData()
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        
        guard (certificates != nil) else {
            return 0
        }
        return certificates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CertificateCell
        cell.lblTitle?.text = "\(certificates[indexPath.row].CertificateCategoryName)"
        cell.btnUpload.tag = 100 + indexPath.row
        var isFound : Bool = false
        
        for tmpcert in self.sharedManager.currentUser.CertificateFileList! {
            
            if tmpcert.CertificateCategoryID == certificates[indexPath.row].CertificateCategoryID {
                isFound = true
                let imgURL = tmpcert.FileLink as String
                
                let urlPro = URL(string: imgURL)
                cell.imgCertificate.kf.indicatorType = .activity
                cell.imgCertificate.kf.setImage(with: urlPro)
                cell.btnUpload.setImage(#imageLiteral(resourceName: "ic_check"), for: .normal)
                
            }
        }
        
        if !isFound {
            cell.imgCertificate.image = #imageLiteral(resourceName: "ic_certificate")
            cell.btnUpload.setImage(#imageLiteral(resourceName: "ic_uncheck"), for: .normal)
        }
        //cell.textLabel?.text = "\(certificates[indexPath.row].CertificateCategoryName)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CertificateCell
        
        selectedCertificates=(certificates[indexPath.row])
        selectedCell = cell
        //self.view.endEditing(true)
        let alert : UIAlertController = UIAlertController(title: "Upload Image", message: "Select your profile Picture", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take From Camera", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.takePhoto()
        }))
        
        alert.addAction(UIAlertAction(title: "Use Gallery", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.selectFromGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
            
        }))
        self.startAnimating()
        self.present(alert, animated: true) {
                self.stopAnimating()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CertificateCell
        
        selectedCertificates=(certificates[indexPath.row])
        selectedCell = cell
        //self.view.endEditing(true)
        let alert : UIAlertController = UIAlertController(title: "Upload Image", message: "Select your profile Picture", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take From Camera", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.takePhoto()
        }))
        
        alert.addAction(UIAlertAction(title: "Use Gallery", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.selectFromGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
            
        }))
        self.startAnimating()
        self.present(alert, animated: true) {
            self.stopAnimating()
        }
  
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! CertificateCell
//        cell.btnUpload.setImage(#imageLiteral(resourceName: "ic_uncheck"), for: UIControlState.normal)
//        cell.btnUpload.setTitle("  Upload", for: UIControlState.normal)
//        selectedCertificates.remove(at: selectedCertificates.index(of: certificates[indexPath.row])! )
//        selectedCell = nil
//    }
    
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
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
//            selectedImage = image
//            uploadphoto()
//            isImageSelected=true
//        } else{
//            print("Something went wrong")
//        }
//        
//        self.dismiss(animated: true, completion: nil)
//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = image
            uploadphoto()
            isImageSelected=true
        } else{
            print("Something went wrong")
        }
        
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    func uploadphoto(){
        
        self.startAnimating()
        
        let pid : String =  String(self.sharedManager.currentUser.ContractorID)
        
        let parameters = [
            "PrimaryID": String(sharedManager.currentUser.ContractorID) ,
            "CertificateCategoryID" : String(selectedCertificates.PrimaryID),
            "PageType" : "certificate"
            ] as [String : Any]
       self.selectedImage = Globals.compressForUpload(original: self.selectedImage!, withHeightLimit: 1100, andWidthLimit: 800)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(self.selectedImage!, 0.3)!, withName: "file", fileName: "toolicontractor.png", mimeType: "image/png")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:"http://tooli.blush.cloud/FileHandler.ashx?PrimaryID=" + String(sharedManager.currentUser.ContractorID) + "&CertificateCategoryID=" +  String(selectedCertificates.PrimaryID) + "&PageType=certificate")
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
                            self.selectedCell.btnUpload.setImage(#imageLiteral(resourceName: "ic_check"), for: UIControlState.normal)
                            self.selectedCell.btnUpload.setTitle("  Selected", for: UIControlState.normal)
                            
//                            if self.cellImages.count > self.selectedCell.btnUpload.tag-100 {
//                                self.cellImages[self.selectedCell.btnUpload.tag-100].image = self.selectedImage
//                            } else {
//                                let tmpImg : UIImageView = UIImageView(frame: self.selectedCell.imgCertificate.frame)
//                                tmpImg.image = self.selectedImage
//                                self.cellImages.append(tmpImg)
//                            }
                            
                            
                            
                            self.selectedCertificates = nil
                            
                            self.updateUserInfo()
                            
                            
                            self.tvcerts.reloadData()
                            
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
    func updateUserInfo(){
        self.startAnimating()
        var param = [:] as [String : Any]
        param["ContractorID"] = sharedManager.currentUser.ContractorID
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorInfo, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil {
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    
                    self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                    userDefaults.synchronize()
                    self.tvcerts.reloadData()
                    
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
    @IBAction func btnNext(_ sender: Any) {
        self.appDelegate.moveToDashboard()
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        self.appDelegate.moveToDashboard()
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
