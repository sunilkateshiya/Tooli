//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by Moin Shirazi on 24/12/16.
//  Copyright © 2016 Moin Shirazi. All rights reserved.
//

import UIKit
import Cosmos

class DashBoardTv1Cell: UITableViewCell{

    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var lbldate: UILabel!
    @IBOutlet var lblhtml: UILabel!
    @IBOutlet var btnfav: UIButton!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnPortfolio: UIButton!
    @IBOutlet var imguser: UIImageView!
    @IBOutlet var img1: UIImageView!
    var isReload:Bool = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                img1.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                img1.addConstraint(aspectConstraint!)
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setCustomImage(image : UIImage) {
        
        let aspect = image.size.width / image.size.height
        
        let constraint = NSLayoutConstraint(item: img1, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: img1, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = 900
        
        aspectConstraint = constraint
        img1.image = image
    }
}

