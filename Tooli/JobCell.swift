//
//  DemoCell.swift
//  TooliDemo
//
//  Created by Azharhussain on 22/08/17.
//  Copyright © 2017 Impero IT. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell
{
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var likeHeight: NSLayoutConstraint!
    @IBOutlet weak var Height: NSLayoutConstraint!
    
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet var lblCompany: UILabel!
    @IBOutlet var lblDateTime: UILabel!

    @IBOutlet weak var lblTradename: UILabel!
    @IBOutlet var lblStartDate: UILabel!
    @IBOutlet var lblFinishDate: UILabel!
    
    @IBOutlet weak var lblDis: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var imgUser: UIImageView!

    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnView: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
