//
//  SenderTabCell.swift
//  bizdeck
//
//  Created by Gaurav on 7/8/17.
//  Copyright © 2017 Wholly Software. All rights reserved.
//

import UIKit

class SenderTabWithTimeCell: UITableViewCell
{

    @IBOutlet var backGroundView: UIView!
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var lblTime: UILabel!
    
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
