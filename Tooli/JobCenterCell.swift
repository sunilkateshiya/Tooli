//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by impero on 24/12/16.
//  Copyright © 2016 impero. All rights reserved.
//

import UIKit


class JobCenterCell : UITableViewCell {

    
    @IBOutlet var lblcompany: UILabel!
    @IBOutlet var lblwork: UILabel!
    @IBOutlet var lblexperience: UILabel!
    @IBOutlet var lblstartfinish: UILabel!
    @IBOutlet var btnfav: UIButton!
    @IBOutlet var imguser: UIImageView!
    @IBOutlet var cvport : UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

 
}

//extension DashBoardTvCell : UICollectionViewDelegate, UICollectionViewDataSource {
//   
//    
//    
//}

