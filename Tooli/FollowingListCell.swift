//
//  FollowingListCell.swift
//  Tooli
//
//  Created by Impero IT on 21/02/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class FollowingListCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!

    @IBOutlet weak var btnFollowButton: UIButton!
    @IBOutlet weak var lblCategory: UILabel!
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
