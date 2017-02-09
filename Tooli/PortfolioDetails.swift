//
//  PortfolioDetails.swift
//  Tooli
//
//  Created by Aadil on 2/9/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import Kingfisher
class PortfolioDetails: UIViewController, SKPhotoBrowserDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var images = [SKPhotoProtocol]()
    @IBOutlet var lbltitle : UILabel!
    @IBOutlet var lblscreenTitle : UILabel!
    @IBOutlet var portfolioCollection : UICollectionView!
    @IBOutlet var lblLocation : UILabel!
    @IBOutlet var lblClient : UILabel!
    @IBOutlet var lblDescription : UILabel!
    var portfolio : Portfolio! = Portfolio()
    override func viewDidLoad() {
        super.viewDidLoad()
        portfolioCollection.delegate = self
        portfolioCollection.dataSource = self
        
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
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if portfolio != nil {
            return portfolio.PortfolioImageList.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PortfolioCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCell
        
        let imgURL = (portfolio.PortfolioImageList[indexPath.row].PortfolioImageLink)
        let urlPro = URL(string: imgURL)
        cell.PortfolioImage?.kf.indicatorType = .activity
        cell.PortfolioImage?.kf.setImage(with: urlPro)
        let tmpResouce = ImageResource(downloadURL: urlPro!, cacheKey: imgURL)
        let optionInfo: KingfisherOptionsInfo = [
            .downloadPriority(0.5),
            .transition(ImageTransition.fade(1)),
            .forceRefresh
        ]
        cell.PortfolioImage?.kf.indicatorType = .activity
        cell.PortfolioImage?.kf.setImage(with: tmpResouce, placeholder: nil, options: optionInfo, progressBlock: nil, completionHandler: nil)
        
        return cell
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - SKPhotoBrowserDelegate

extension PortfolioDetails {
    func didDismissAtPageIndex(_ index: Int) {
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
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
            //            let photo = SKPhoto.photoWithImageURL("https://placehold.jp/150\(i)x150\(i).png", holder: UIImage(named: "image0.jpg")!)
            let photo = SKPhoto.photoWithImageURL(portfolio.PortfolioImageList[i].PortfolioImageLink)
            photo.caption = ("")
            photo.shouldCachePhotoURLImage = true
            return photo
        }
    }
}



