//
//  Editportfolio.swift
//  Tooli
//
//  Created by Impero IT on 7/02/2017.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
import Kingfisher
import BSImagePicker
import Photos

class Editportfolio: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate,NVActivityIndicatorViewable , UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate
{
    @IBOutlet weak var TxtDescription: UITextView!
    @IBOutlet weak var TxtLocation: UITextField!
    @IBOutlet weak var TxtProjectTitle: UITextField!
    @IBOutlet weak var TxtCustomerName: UITextField!
    @IBOutlet var collectionHeight : NSLayoutConstraint!
    @IBOutlet weak var PortCollectionView: UICollectionView!
    let sharedManager : Globals = Globals.sharedInstance
    var portfolio : GetProtfolioM = GetProtfolioM()
    var selectedImage : UIImage?
    var imagePicker: UIImagePickerController!
    var isImageSelected : Bool = false
    var assets: [PHAsset]!
    
    // Make this dynamic
    var portfolioId = 0
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.startAnimating()
        
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = false
        self.sideMenuController()?.sideMenu?.allowPanGesture = false
        self.sideMenuController()?.sideMenu?.allowRightSwipe = false
        
        var param = [:] as [String : Any]
        param["PortfolioID"] = self.portfolioId
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PortfolioDetail, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            if JSONResponse["Status"].int == 1
            {
                self.portfolio = Mapper<GetProtfolioM>().map(JSONObject: JSONResponse.rawValue)!
                self.stopAnimating()
                self.TxtDescription.text = self.portfolio.Result.Description
                self.TxtLocation.text = self.portfolio.Result.Location
                self.TxtCustomerName.text = self.portfolio.Result.CustomerName
                self.TxtProjectTitle.text = self.portfolio.Result.Title
                self.PortCollectionView.reloadData()
            }
            else
            {
                self.stopAnimating()
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
            }
            
        })
        {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Edit portfolio Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    @IBAction func actionBack(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
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
        else if(self.portfolio.Result.PortfolioImageList.count == 0)
        {
            isValid = false;
            self.view.makeToast("Please select at least one image", duration: 3, position: .center)
        }
        if isValid
        {
            uploadPortfolioWithImage()
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.PortCollectionView.delegate = self
        self.PortCollectionView.dataSource = self
        let flow = PortCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        // Do any additional setup after loading the view.
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
        if section == 0
        {
            var totalItems = ceil(Double(portfolio.Result.PortfolioImageList.count + 1) / 3)
            if totalItems == 0
            {
                totalItems = 1
            }
            self.collectionHeight.constant = CGFloat( CGFloat(totalItems) * ((Constants.ScreenSize.SCREEN_WIDTH / 3)))
            return  portfolio.Result.PortfolioImageList.count + 1
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == portfolio.Result.PortfolioImageList.count
        {
            let Addcell = collectionView.dequeueReusableCell(withReuseIdentifier: "Addcell", for: indexPath) as! Addcell
            
            return Addcell
        }
        else
        {
            let Collectcell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCell
            if  portfolio.Result.PortfolioImageList[indexPath.row].addedByMe == false
            {
                let imgURL = portfolio.Result.PortfolioImageList[indexPath.row].ImageLink
                let urlPro = URL(string: imgURL)
                Collectcell.PortfolioImage.kf.indicatorType = .activity
                let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: portfolio.Result.PortfolioImageList[indexPath.row].ImageLink)
                let optionInfo: KingfisherOptionsInfo = [
                    .downloadPriority(0.5),
                    .transition(ImageTransition.fade(1)),
                    .forceRefresh
                ]
                
                Collectcell.PortfolioImage?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
            }
            else
            {
                Collectcell.PortfolioImage.image = portfolio.Result.PortfolioImageList[indexPath.row].image
            }
            
            
            Collectcell.btnRemove.addTarget(self, action: #selector(removePortfolio(sender:)), for: UIControlEvents.touchUpInside)
            Collectcell.btnRemove.tag = indexPath.row + 1000
            return Collectcell
        }
    }
    
    func removePortfolio(sender : UIButton)
    {
        let index = sender.tag - 1000
        if  portfolio.Result.PortfolioImageList[index].addedByMe
        {
            portfolio.Result.PortfolioImageList.remove(at: index)
        }
        else
        {
            // Load webservice to delete
            var param = [:] as [String : Any]
            param["ImageID"] = portfolio.Result.PortfolioImageList[index].ImageID
            print(param)
            AFWrapper.requestPOSTURL(Constants.URLS.PortfolioDeleteImage, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
                (JSONResponse) -> Void in
                
                if JSONResponse["Status"].int == 1
                {
                    self.stopAnimating()
                    self.portfolio.Result.PortfolioImageList.remove(at: index)
                    self.PortCollectionView.reloadData()
                    self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
                }
                else
                {
                    self.stopAnimating()
                    self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
                }
                
            }) {
                (error) -> Void in
                self.stopAnimating()
                self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
            }
        }
        self.PortCollectionView.reloadData();
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lastRowIndex = collectionView.numberOfItems(inSection: collectionView.numberOfSections-1)
        
        if (indexPath.row == lastRowIndex - 1) {
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
                    
                    DispatchQueue.main.async
                        {
                        if(assets.count != 0)
                        {
                            for assat in assets
                            {
                                var temp:PortfolioImageM = PortfolioImageM()
                                temp.addedByMe = true
                                temp.image = self.getAssetThumbnail(asset: assat)
                                self.portfolio.Result.PortfolioImageList.append(temp)
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
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            selectedImage = image
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
        param["PortfolioID"] = "\(self.portfolio.Result.PortfolioID)"
        
        let header = ["Authorization": String.localizedStringWithFormat("%@",UserDefaults.standard.string(forKey: Constants.KEYS.TOKEN)! as String)]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for temp in self.portfolio.Result.PortfolioImageList
            {
                if(temp.addedByMe == true)
                {
                   multipartFormData.append(UIImageJPEGRepresentation(temp.image, 0.5)!, withName: "PortfolioImageList", fileName: "toolicontractor.png", mimeType: "image/png")
                }
            }
            for (key, value) in param
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:Constants.URLS.PortfolioEdit,headers: header)
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
                            self.PortCollectionView.reloadData()
                            self.selectedImage = nil
                            
                            self.view.makeToast("\(response1.object(forKey: "Message")!)", duration: 3, position: .center)
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
    func getAssetThumbnail(asset: PHAsset) -> UIImage
    {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 800, height: 1100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}
