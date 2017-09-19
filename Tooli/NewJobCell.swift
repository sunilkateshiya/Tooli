//
//  DemoCell.swift
//  TooliDemo
//
//  Created by Azharhussain on 22/08/17.
//  Copyright © 2017 Impero IT. All rights reserved.
//

import UIKit

class NewJobCell: UITableViewCell
{
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet var lblJobRole: UILabel!

    @IBOutlet weak var lblTradename: UILabel!
    @IBOutlet weak var lblDis: UILabel!
    
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var imgUser: UIImageView!
    
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
