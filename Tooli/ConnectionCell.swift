//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by impero on 24/12/16.
//  Copyright © 2016 impero. All rights reserved.
//

import UIKit
class ConnectionCell : UITableViewCell {

    @IBOutlet var lblAway: UILabel!

    @IBOutlet var lblcompany: UILabel!
    @IBOutlet var lblwork: UILabel!
    @IBOutlet var lbllocatn: UILabel!
    @IBOutlet var btnfav: UIButton!
    @IBOutlet var imguser: UIImageView!

    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblTitle1: UILabel!
<<<<<<< HEAD
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblhtml: UILabel!
    
    override func awakeFromNib()
    {
=======

    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblhtml: UILabel!
    override func awakeFromNib() {
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
