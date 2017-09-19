//
//  ConnectionNewCell.swift
//  Tooli
//
//  Created by Impero IT on 21/08/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit

class ConnectionNewCell: UITableViewCell
{
    @IBOutlet var lblAway: UILabel!
    @IBOutlet var lblDis: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnFav: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var imgUser: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
