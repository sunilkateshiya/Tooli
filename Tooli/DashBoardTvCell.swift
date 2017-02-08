//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by Moin Shirazi on 24/12/16.
//  Copyright © 2016 Moin Shirazi. All rights reserved.
//

import UIKit
import Cosmos

class DashBoardTvCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var lbldate: UILabel!
    @IBOutlet var lblhtml: UILabel!
    @IBOutlet var btnfav: UIButton!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnPortfolio: UIButton!
    @IBOutlet var imguser: UIImageView!
    var cvimgcnt: Int!
    var portimgs : [PortfolioImageL]!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    @IBOutlet var cvport : UICollectionView!
    @IBOutlet var cvheightconst : NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width - 46
        screenHeight = screenSize.height
        
      
        self.cvport.delegate = self
        self.cvport.dataSource = self
        self.cvport.reloadData()
        self.selectionStyle = .none
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return cvimgcnt
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! DashBoardCvCell
        
        
        let imgURL = self.portimgs?[indexPath.row].PortfolioImageLink as String!
        let url = URL(string: imgURL!)
        cell.imgport.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
}

//extension DashBoardTvCell : UICollectionViewDelegate, UICollectionViewDataSource {
//   
//    
//    
//}

