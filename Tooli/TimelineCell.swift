//
//  TimelineCell.swift
//  Tooli
//
//  Created by Impero IT on 9/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    @IBOutlet var imgProfile : UIImageView!
    @IBOutlet var lblCaption : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var imgStatus : UIImageView!
    @IBOutlet var imgView : UIView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var btnFav : UIButton!
    @IBOutlet var imgFav : UIImageView!
    @IBOutlet var btnProfile : UIButton!
    @IBOutlet var btnPortfolio : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
