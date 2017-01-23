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
    @IBOutlet var imguser: UIImageView!

    @IBOutlet var cvport : UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cvport.delegate = self
        self.cvport.dataSource = self
        self.cvport.reloadData()
        
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! DashBoardCvCell
        
        cell.imgport.image = UIImage(named: "image")
        return cell
    }
}

//extension DashBoardTvCell : UICollectionViewDelegate, UICollectionViewDataSource {
//   
//    
//    
//}

