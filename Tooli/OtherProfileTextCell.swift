//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by impero on 24/12/16.
//  Copyright © 2016 impero. All rights reserved.
//

import UIKit


class OtherProfileTextCell: UITableViewCell
{

     @IBOutlet var imgProfile : UIImageView!
     @IBOutlet var lblName : UILabel!
     @IBOutlet var lblTitle : UILabel!
     @IBOutlet var lblDate : UILabel!
     @IBOutlet var btnFav : UIButton!
     @IBOutlet var imgFav : UIImageView!
     @IBOutlet var btnProfile : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

   
}

