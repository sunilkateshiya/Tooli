//
//  PortfolioDetails.swift
//  Tooli
//
//  Created by Aadil on 2/9/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import Kingfisher
import NVActivityIndicatorView
import ObjectMapper

class PortfolioDetails: UIViewController, SKPhotoBrowserDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,NVActivityIndicatorViewable
{
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    var images = [SKPhotoProtocol]()
    @IBOutlet var lbltitle : UILabel!
    @IBOutlet var lblscreenTitle : UILabel!
    @IBOutlet var portfolioCollection : UICollectionView!
    @IBOutlet var lblLocation : UILabel!
    @IBOutlet var lblClient : UILabel!
    @IBOutlet var lblDescription : UILabel!
    var portfolio : PortfolioViewM = PortfolioViewM()
    var sharedManager : Globals = Globals.sharedInstance
    var portfolioId:Int = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if(portfolioId == 0)
        {
            SetDataInView()
        }
        else
        {
            btnInfoProtfolio()
        }
    }
    func SetDataInView()
    {
        portfolioCollection.reloadData()
        let flow = portfolioCollection.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        self.lbltitle.text = self.portfolio.Title
        self.lblClient.text = self.portfolio.CustomerName
        self.lblLocation.text = self.portfolio.Location
        self.lblDescription.text = self.portfolio.Description

    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    @IBAction func pushButton(_ sender: AnyObject) {
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return portfolio.PortfolioImageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PortfolioCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCell
        
        let imgURL = (portfolio.PortfolioImageList[indexPath.row].ImageLink)
        let urlPro = URL(string: imgURL)
        cell.PortfolioImage?.kf.indicatorType = .activity
        let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
        let optionInfo: KingfisherOptionsInfo = [
            .downloadPriority(0.5),
            .transition(ImageTransition.fade(1))
        ]
        cell.PortfolioImage?.kf.indicatorType = .activity
        cell.PortfolioImage?.kf.setImage(with: tmpResouce, placeholder: UIImage(named: "SplashImage"), options: optionInfo, progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Portfolio Details Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // your code here
        
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 10
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight : CGFloat = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    func btnInfoProtfolio()
    {
        self.startAnimating()
        let param = ["PortfolioID":portfolioId ] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.PortfolioDetail, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in

            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            
            if JSONResponse["Status"].int == 1
            {
                self.portfolio = Mapper<PortfolioViewM>().map(JSONObject: JSONResponse["Result"].rawValue)!
                self.SetDataInView()
            }
            else
            {
                _ = self.navigationController?.popViewController(animated: true)
                AppDelegate.sharedInstance().window?.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
            }
            
        }) {
            (error) -> Void in
            
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
}

// MARK: - SKPhotoBrowserDelegate

extension PortfolioDetails
{
    func didDismissAtPageIndex(_ index: Int)
    {
        
    }
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int)
    {
        
    }
    func removePhoto(index: Int, reload: (() -> Void)) {
        SKCache.sharedCache.removeImageForKey("somekey")
        reload()
    }
}

// MARK: - private

private extension PortfolioDetails {
    func createWebPhotos() -> [SKPhotoProtocol] {
        return (0..<portfolio.PortfolioImageList.count).map { (i: Int) -> SKPhotoProtocol in
<<<<<<< HEAD
            let img:UIImageView = UIImageView()
            let imgURL = portfolio.PortfolioImageList[i].ImageLink as String!
            
            let url = URL(string: imgURL!)
            img.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            if(img.image == nil)
            {
                let photo = SKPhoto.photoWithImageURL(imgURL!)
=======
            //            let photo = SKPhoto.photoWithImageURL("https://placehold.jp/150\(i)x150\(i).png", holder: UIImage(named: "image0.jpg")!)
//            let photo = SKPhoto.photoWithImageURL(portfolio.PortfolioImageList[i].PortfolioImageLink)
            let img:UIImageView = UIImageView()
            let imgURL = portfolio.PortfolioImageList[i].PortfolioImageLink as String!
            
            let url = URL(string: imgURL!)
            img.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
            
            if(img.image != nil)
            {
                let photo = SKPhoto.photoWithImage(img.image!)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                photo.caption = ("")
                photo.shouldCachePhotoURLImage = true
                return photo
            }
            else
            {
<<<<<<< HEAD
                let photo = SKPhoto.photoWithImage(img.image!)
=======
                let photo = SKPhoto.photoWithImageURL(imgURL!)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                photo.caption = ("")
                photo.shouldCachePhotoURLImage = true
                return photo
            }
        }
    }
}



