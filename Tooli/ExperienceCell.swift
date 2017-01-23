//
//  ExperienceCell.swift
//  Tooli
//
//  Created by Impero-Moin on 19/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class ExperienceCell: UITableViewCell {

     @IBOutlet weak var LblJobTitle: UILabel!
     @IBOutlet weak var lblUntil: UILabel!
     @IBOutlet weak var lblFrom: UILabel!
     @IBOutlet weak var lblCompany: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
