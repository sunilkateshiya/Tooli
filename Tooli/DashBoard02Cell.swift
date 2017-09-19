//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by impero on 24/12/16.
//  Copyright © 2016 impero. All rights reserved.
//

import UIKit


class DashBoard02Cell: UITableViewCell{

        @IBOutlet weak var likeHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblDis: UILabel!
    @IBOutlet var btnFav: UIButton!
    
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnPortfolio: UIButton!
    @IBOutlet var imgUser: UIImageView!
    
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet var img1: UIImageView!
    @IBOutlet var img2: UIImageView!
    
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnView: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

