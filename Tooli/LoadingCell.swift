//
//  LoadingCell.swift
//  Tooli
//
//  Created by Impero IT on 27/01/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var activity : UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.activity.tintColor = UIColor.gray
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
