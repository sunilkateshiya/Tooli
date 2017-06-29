//
//  ExperienceCell.swift
//  Tooli
//
//  Created by Impero IT on 25/01/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class ExperienceCell: UITableViewCell {
    @IBOutlet var btnClose : UIButton!
    @IBOutlet var txtJobTitle : UITextField!
    @IBOutlet var txtCompany : UITextField!
    @IBOutlet var txtExperience : UITextField!
    @IBOutlet var lblJobTitle : UILabel!
    @IBOutlet var lblCompanyName : UILabel!
    @IBOutlet var lblFrom : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func closeCell (sender : UIButton) {
        let indexpath = NSIndexPath(row: sender.tag-100, section: 0)
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "RemoveCell"), object: nil, userInfo: ["index":indexpath.row] ))
    }

}
