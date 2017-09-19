//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by impero on 24/12/16.
//  Copyright © 2016 impero. All rights reserved.
//

import UIKit


class OtherProfile03Cell: UITableViewCell{

    @IBOutlet weak var lblPhotoCount: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var lbldate: UILabel!
    @IBOutlet var lblhtml: UILabel!
    @IBOutlet var btnfav: UIButton!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnPortfolio: UIButton!
    @IBOutlet var imguser: UIImageView!
    
    @IBOutlet var img1: UIImageView!
    @IBOutlet var img2: UIImageView!
    @IBOutlet var img3: UIImageView!

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

