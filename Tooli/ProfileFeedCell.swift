//
//  ProfileFeedCell.swift
//  Tooli
//
//  Created by Impero-Moin on 19/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class ProfileFeedCell: UITableViewCell {
    
    @IBOutlet var lblcompany: UILabel!
    @IBOutlet var lblwork: UILabel!
    @IBOutlet var lblexperience: UILabel!
    @IBOutlet var lblstart: UILabel!
    @IBOutlet var lblfinish: UILabel!
    @IBOutlet var lblcity: UILabel!
    @IBOutlet var lbldatetime: UILabel!
    
      @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnfav: UIButton!
    @IBOutlet var imguser: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
