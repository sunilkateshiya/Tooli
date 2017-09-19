//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by impero on 24/12/16.
//  Copyright © 2016 impero. All rights reserved.
//

import UIKit

class OtherProfile01Cell: UITableViewCell{
     @IBOutlet var lbltitle: UILabel!
     @IBOutlet var lbldate: UILabel!
     @IBOutlet var lblhtml: UILabel!
     @IBOutlet var btnfav: UIButton!
     @IBOutlet var btnProfile: UIButton!
     @IBOutlet var imguser: UIImageView!
     
     @IBOutlet var img1: UIImageView!
     var isReload:Bool = true
     override func awakeFromNib() {
          super.awakeFromNib()
          // Initialization code
     }
     override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)
          
          // Configure the view for the selected state
     }
}





