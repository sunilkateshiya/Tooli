//
//  DemoCell.swift
//  TooliDemo
//
//  Created by Azharhussain on 22/08/17.
//  Copyright © 2017 Impero IT. All rights reserved.
//

import UIKit

class MyJobNewJobCell: UITableViewCell
{
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet var lblJobRole: UILabel!
    @IBOutlet weak var lblTradename: UILabel!
    @IBOutlet weak var lblDis: UILabel!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var imgUser: UIImageView!
    
     @IBOutlet var lblView: UILabel!
     @IBOutlet var lblSave: UILabel!
     @IBOutlet var lblLikes: UILabel!
     @IBOutlet var lblApplication: UILabel!
    
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
