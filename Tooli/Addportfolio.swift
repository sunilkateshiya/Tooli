//
//  Addportfolio.swift
//  Tooli
//
//  Created by Impero-Moin on 21/01/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
import ENSwiftSideMenu
import BSImagePicker
import Photos


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
    var placeholderLabel:UILabel!
    var assets: [PHAsset]!
    var imageArr:[UIImage] = []
    
    var isFromProfile:Bool = false
    @IBOutlet weak var btnMenu : UIButton!
    
    @IBAction func actionBack(sender : UIButton)
    {
        if(isFromProfile)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            toggleSideMenuView()
        }
        //
    }
    @IBAction func actionPost(sender : UIButton)
    {
        var isValid : Bool = true
        if TxtProjectTitle.text == ""
        {
            isValid = false;
            self.view.makeToast("Please enter valid Project Title", duration: 3, position: .center)
        }
        else if TxtLocation.text == ""
        {
            isValid = false
            self.view.makeToast("Please enter valid Location", duration: 3, position: .center)
        }
        else if TxtCustomerName.text == ""
        {
            isValid = false
            self.view.makeToast("Please enter valid Customer Name", duration: 3, position: .center)
        }
        else if TxtDescription.text == "Enter Description"
        {
            isValid = false;
            self.view.makeToast("Please enter valid Description", duration: 3, position: .center)
        }
        else if(imageArr.count == 0)
        {
            isValid = false;
            self.view.makeToast("Please select at least one image", duration: 3, position: .center)
        }
        if isValid
        {
            uploadPortfolioWithImage()
        }
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    @IBAction func btnBack(_ sender: UIButton)
    {
        if(isFromProfile)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            app.moveToDashboard()
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
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter Description"
        //     placeholderLabel.font = UIFont(name: "BabasNeue", size: 106)
        placeholderLabel.font = UIFont.systemFont(ofSize: (TxtDescription.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        TxtDescription.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (TxtDescription.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !TxtDescription.text.isEmpty
        
        if(isFromProfile)
        {
            self.btnMenu.isHidden = true
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0
        {
            var totalItems = ceil(Double(imageArr.count + 1) / 3)
            if totalItems == 0
            {
                totalItems = 1
            }
            self.collectionHeight.constant = CGFloat( CGFloat(totalItems) * ((Constants.ScreenSize.SCREEN_WIDTH / 3)))
            return  imageArr.count + 1
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.row == imageArr.count
        {
            let Addcell = collectionView.dequeueReusableCell(withReuseIdentifier: "Addcell", for: indexPath) as! Addcell
            return Addcell
        }
        else
        {
            let Collectcell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCell
            Collectcell.PortfolioImage.image = imageArr[indexPath.row]
            Collectcell.btnRemove.addTarget(self, action: #selector(removePortfolio(sender:)), for: UIControlEvents.touchUpInside)
            Collectcell.btnRemove.tag = indexPath.row + 1000
            return Collectcell
        }
    }
    
    func removePortfolio(sender : UIButton)
    {
        let index = sender.tag - 1000
        self.imageArr.remove(at: index)
        self.PortCollectionView.reloadData();
    }
    override func viewWillAppear(_ animated: Bool)
    {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Add portfolio Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lastRowIndex = collectionView.numberOfItems(inSection: collectionView.numberOfSections-1)
        
        if (indexPath.row == lastRowIndex - 1)
        {
            let alert : UIAlertController = UIAlertController(title: "Upload Image", message: "Select image from", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            alert.addAction(UIAlertAction(title: "Take From Camera", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.takePhoto()
            }))
            
            alert.addAction(UIAlertAction(title: "Use Gallery", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                let vc = BSImagePickerViewController()
                vc.maxNumberOfSelections = 50
                self.bs_presentImagePickerController(vc, animated: true,
                                                select: { (asset: PHAsset) -> Void in
                                                    print("Selected: \(asset)")
                }, deselect: { (asset: PHAsset) -> Void in
                    print("Deselected: \(asset)")
                }, cancel: { (assets: [PHAsset]) -> Void in
                    print("Cancel: \(assets)")
                }, finish: { (assets: [PHAsset]) -> Void in
                    print("Finish: \(assets)")
        
                    DispatchQueue.main.async {
                        if(assets.count != 0)
                        {
                            for assat in assets
                            {
                                self.imageArr.append(self.getAssetThumbnail(asset: assat))
                            }
                        }
                        self.PortCollectionView.reloadData()
                    }
                }, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
                
            }))
            self.startAnimating()
            self.present(alert, animated: true) {
                self.stopAnimating()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
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
        imagePicker.allowsEditing = false
        
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
            self.imageArr.append(image)
            self.PortCollectionView.reloadData()
            isImageSelected=true
        } else{
            print("Something went wrong")
        }
        picker.dismiss(animated: true, completion: nil);
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil);
    }
    func uploadPortfolioWithImage()
    {
        self.startAnimating()
        var param = [:] as [String : Any]
        param["Title"] = self.TxtProjectTitle.text
        param["CustomerName"] = self.TxtCustomerName.text
        param["Location"] = self.TxtLocation.text
        param["Description"] = self.TxtDescription.text

        let header = ["Authorization": String.localizedStringWithFormat("%@",UserDefaults.standard.string(forKey: Constants.KEYS.TOKEN)! as String)]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for assat in self.imageArr
            {
                multipartFormData.append(UIImageJPEGRepresentation(assat, 1)!, withName: "PortfolioImageList", fileName: "toolicontractor.png", mimeType: "image/png")
            }
            for (key, value) in param
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:Constants.URLS.PortfolioAdd,headers: header)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                })
                
                upload.responseJSON { response in
                    self.stopAnimating()
                    print(response.result)
                    switch  response.result
                    {
                    case .success(let JSON):
                        let response1 = JSON as! NSDictionary
                        if String(describing: response1.object(forKey: "Status")!) == "1"
                        {
                            self.TxtDescription.text = ""
                            self.TxtLocation.text = ""
                            self.TxtCustomerName.text = ""
                            self.TxtProjectTitle.text = ""
                            self.portfolio = Portfolio()
                            self.PortCollectionView.reloadData()
                            
                            self.imageArr = []
                            self.selectedImage = nil
                            
                            AppDelegate.sharedInstance().window?.rootViewController?.view.makeToast("\(response1.object(forKey: "Message")!)", duration: 3, position: .center)
                            
                            if(self.isFromProfile == true)
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                                let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                app.moveToDashboard()
                            }
                        }
                        else
                        {
                            self.view.makeToast("\(response1.object(forKey: "Message")!)", duration: 3, position: .center)
                        }
                        
                    case .failure(let error):
                        self.view.makeToast("Server error. Please try again later. \(error)", duration: 3, position: .center)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                self.stopAnimating()
                break
            }
        }
    }
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 800, height: 1100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            if(result != nil)
            {
                thumbnail = result!
            }
        })
        return thumbnail
    }
}
