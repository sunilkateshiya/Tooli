//
//  SkillCell.swift
//  Tooli
//
//  Created by Impero-Moin on 26/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class SkillCell: UITableViewCell {

     @IBOutlet weak var lblSkillName: UILabel!
     @IBOutlet weak var ImgAccesoryView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
