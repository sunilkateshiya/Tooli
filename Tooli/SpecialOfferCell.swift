//
//  SpecialOfferCell.swift
//  Tooli
//
//  Created by Impero-Moin on 21/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class SpecialOfferCell: UITableViewCell {
     @IBOutlet weak var imgStar: UIImageView!

    @IBOutlet weak var lblRedirectLink: UILabel!
     @IBOutlet weak var ImgProfilepic: UIImageView!
     @IBOutlet weak var lblCompanyName: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
     @IBOutlet weak var lblWork: UILabel!
       @IBOutlet var btnProfile: UIButton!
    @IBOutlet weak var btnRedirectUrl: UIButton!
     @IBOutlet weak var ImgCompanyPic: UIImageView!
     
     @IBOutlet weak var lblLocation: UILabel!
    
     @IBOutlet var btnfav: UIButton!
    var isReload:Bool = true
     @IBOutlet weak var lblCompanyDescription: UILabel!
     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                ImgProfilepic.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                ImgProfilepic.addConstraint(aspectConstraint!)
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    func setCustomImage(image : UIImage) {
        
        let aspect = image.size.width / image.size.height
        
        let constraint = NSLayoutConstraint(item: ImgProfilepic, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: ImgProfilepic, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = 900
        
        aspectConstraint = constraint
        ImgProfilepic.image = image
    }
}
