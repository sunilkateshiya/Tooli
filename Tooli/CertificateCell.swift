//
//  CertificateCell.swift
//  Tooli
//
//  Created by Impero IT on 26/01/2017.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit

class CertificateCell: UITableViewCell {
    @IBOutlet var btnUpload : UIButton!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var imgCertificate : UIImageView!
    @IBOutlet var btnRemove : UIButton!
    
    @IBOutlet var btnStatus : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnRemove.isHidden = true
        // Initialization code
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
