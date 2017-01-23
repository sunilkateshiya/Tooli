//
//  Addportfolio.swift
//  Tooli
//
//  Created by Impero-Moin on 21/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class Addportfolio: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

     @IBOutlet weak var TxtDescription: UITextView!
     @IBOutlet weak var TxtLocation: UITextField!
     @IBOutlet weak var TxtName: UITextField!
   
     @IBOutlet weak var PortCollectionView: UICollectionView!
     
     @IBAction func BtnPostTapped(_ sender: Any) {
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
    

    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 2
     }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if section == 0  {
          return  10

          }
          else
          
         {
          return 1
          }
          
          
     }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          

          if indexPath.section == 0 {
               let Collectcell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PortfolioCell
               Collectcell.PortfolioImage.image = #imageLiteral(resourceName: "image")
               return Collectcell

          }
         else
          {
               let Addcell = collectionView.dequeueReusableCell(withReuseIdentifier: "Addcell", for: indexPath) as! Addcell

               return Addcell
          }
        
     }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
          let lastRowIndex = collectionView.numberOfItems(inSection: collectionView.numberOfSections-1)

          if (indexPath.row == lastRowIndex - 1) {
               print("last row selected")
          }
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          
          
          let itemsPerRow:CGFloat = 2
          let hardCodedPadding:CGFloat = 5
          let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
          let itemHeight : CGFloat = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
          return CGSize(width: itemWidth, height: itemHeight)
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 5
     }
     


}
