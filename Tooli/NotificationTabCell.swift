//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by Moin Shirazi on 24/12/16.
//  Copyright © 2016 Moin Shirazi. All rights reserved.
//

import UIKit
import Cosmos
import TTTAttributedLabel
class NotificationTabCell: UITableViewCell {

    
    @IBOutlet var lbltitle: TTTAttributedLabel!
    @IBOutlet var lbldate: UILabel!
    @IBOutlet var imguser: UIImageView!

    
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
