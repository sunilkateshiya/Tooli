//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by impero on 24/12/16.
//  Copyright © 2016 impero. All rights reserved.
//

import UIKit

class CompanySpecialOfferCell: UITableViewCell{

    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
     @IBOutlet weak var likeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: UILabel!
     @IBOutlet var lblDis: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var btnPortfolio: UIButton!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnView: UIButton!
    
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
    func setCustomImage(image : UIImage) {
        
        let aspect = image.size.width / image.size.height
        let constraint = NSLayoutConstraint(item: img1, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: img1, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = 1000
        
        aspectConstraint = constraint
        img1.image = image
    }
}





