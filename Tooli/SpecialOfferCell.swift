//
//  SpecialOfferCell.swift
//  Tooli
//
//  Created by Impero-Moin on 21/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class SpecialOfferCell: UITableViewCell {
     @IBOutlet weak var imgStar: UIImageView!

     @IBOutlet weak var ImgProfilepic: UIImageView!
     @IBOutlet weak var lblCompanyName: UILabel!
    
     @IBOutlet weak var lblWork: UILabel!
     
     @IBOutlet weak var ImgCompanyPic: UIImageView!
     
     @IBOutlet weak var lblLocation: UILabel!
    
     @IBOutlet var btnfav: UIButton!
    
     @IBOutlet weak var lblCompanyDescription: UILabel!
     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
