//
//  Addportfolio.swift
//  Tooli
//
//  Created by Impero-Moin on 21/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
class Addportfolio: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate,NVActivityIndicatorViewable , UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var TxtDescription: UITextView!
    @IBOutlet weak var TxtLocation: UITextField!
    @IBOutlet weak var TxtProjectTitle: UITextField!
    @IBOutlet weak var TxtCustomerName: UITextField!
    @IBOutlet var collectionHeight : NSLayoutConstraint!
    @IBOutlet weak var PortCollectionView: UICollectionView!
    let sharedManager : Globals = Globals.sharedInstance
    var portfolio : Portfolio = Portfolio()
    var selectedImage : UIImage?
    var imagePicker: UIImagePickerController!
    var isImageSelected : Bool = false
    @IBAction func actionBack(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionPost(sender : UIButton) {
        var isValid : Bool = true
        if TxtProjectTitle.text == "" {
            isValid = false;
            self.view.makeToast("Please enter valid Project Title", duration: 3, position: .center)
        }
        else if TxtLocation.text == "" {
            isValid = false
            self.view.makeToast("Please enter valid Location", duration: 3, position: .center)
        }
        else if TxtCustomerName.text == "" {
            isValid = false
            self.view.makeToast("Please enter valid Customer Name", duration: 3, position: .center)
        }
        else if TxtDescription.text == "Enter Description" {
            isValid = false;
            self.view.makeToast("Please enter valid Description", duration: 3, position: .center)
        }
        
        if isValid {
            // Call web services
            var selectedImages : [String] = []
            for img in portfolio.PortfolioImageList {
                selectedImages.append(img.imgName)
            }
            
            
            self.startAnimating()
            var param = [:] as [String : Any]
            param["ContractorID"] = sharedManager.currentUser.ContractorID
            param["Title"] = self.TxtProjectTitle.text
            param["CustomerName"] = self.TxtCustomerName.text
            param["Location"] = self.TxtLocation.text
            param["Description"] = self.TxtDescription.text
            param["UploadImageNameGroup"] = selectedImages.joined(separator: ",")
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.PortfolioAdd, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                
                
                if JSONResponse != nil {
                    
                    if JSONResponse["status"].rawString()! == "1"
                    {
                        let userDefaults = UserDefaults.standard
                        
                        userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                        userDefaults.synchronize()
                        self.sharedManager.currentUser = Mapper<SignIn>().map(JSONObject: JSONResponse.rawValue)
                        let userinfo  = userDefaults.object(forKey: Constants.KEYS.USERINFO)
                        userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.USERINFO)
                        userDefaults.synchronize()
                        self.stopAnimating()
                        self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                        
                        self.TxtDescription.text = ""
                        self.TxtLocation.text = ""
                        self.TxtCustomerName.text = ""
                        self.TxtProjectTitle.text = ""
                        self.portfolio = Portfolio()
                        self.PortCollectionView.reloadData()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PortCollectionView.delegate = self
        self.PortCollectionView.dataSource = self
        let flow = PortCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Enter Description" {
            textView.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            textView.text = "Enter Description"
        }
        return true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0  {
            var totalItems = ceil(Double(portfolio.PortfolioImageList.count + 1) / 3)
            if totalItems == 0 {
                totalItems = 1
            }
            self.collectionHeight.constant = CGFloat( CGFloat(totalItems) * ((Constants.ScreenSize.SCREEN_WIDTH / 3)))
            return  portfolio.PortfolioImageList.count + 1
            
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == portfolio.PortfolioImageList.count  {
            let Addcell = collectionView.dequeueReusableCell(withReuseIdentifier: "Addcell", for: indexPath) as! Addcell
            
            return Addcell
        }
        else
        {
            let Collectcell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCell
            Collectcell.PortfolioImage.image = portfolio.PortfolioImageList[indexPath.row].img
            Collectcell.btnRemove.addTarget(self, action: #selector(removePortfolio(sender:)), for: UIControlEvents.touchUpInside)
            Collectcell.btnRemove.tag = indexPath.row + 1000
            return Collectcell
            
        }
        
    }
    
    func removePortfolio(sender : UIButton){
        let index = sender.tag - 1000
        self.portfolio.PortfolioImageList.remove(at: index)
        self.PortCollectionView.reloadData();
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lastRowIndex = collectionView.numberOfItems(inSection: collectionView.numberOfSections-1)
        
        if (indexPath.row == lastRowIndex - 1) {
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
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 10
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight : CGFloat = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
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
            "PageType" : "Portfolio"
            ] as [String : Any]
        
        self.selectedImage = Globals.compressForUpload(original: self.selectedImage!, withHeightLimit: 1100, andWidthLimit: 800)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(self.selectedImage!, 0.3)!, withName: "file", fileName: "toolicontractor.png", mimeType: "image/png")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:"http://tooli.blush.cloud/FileHandler.ashx?PrimaryID=" + String(sharedManager.currentUser.ContractorID) + "&PageType=Portfolio")
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
                            
                            let tmpPortfolio = PortfolioImages();
                            tmpPortfolio.PortfolioImageLink = response1.object(forKey: "FileLink") as! String
                            tmpPortfolio.img = self.selectedImage!
                            tmpPortfolio.imgName = response1.object(forKey: "FileLink") as! String
                            self.portfolio.PortfolioImageList.append(tmpPortfolio)
                            self.PortCollectionView.reloadData()
                            self.selectedImage = nil
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
