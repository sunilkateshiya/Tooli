//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by Moin Shirazi on 24/12/16.
//  Copyright © 2016 Moin Shirazi. All rights reserved.
//

import UIKit
import Cosmos

class MessageTabCell: UITableViewCell {
    @IBOutlet var viewBack: UIView!
    
    @IBOutlet var lblname: UILabel!
    @IBOutlet var lblmsg: UILabel!
    @IBOutlet var lbltime: UILabel!

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
