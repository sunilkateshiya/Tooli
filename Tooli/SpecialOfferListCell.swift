//
//  ClientDashBoardCell.swift
//  SMUJ
//
//  Created by impero on 24/12/16.
//  Copyright © 2016 impero. All rights reserved.
//

import UIKit

class SpecialOfferListCell: UITableViewCell{

     @IBOutlet weak var likeHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet var lblDis: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
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
    func setCustomImage(image : UIImage)
    {
        self.img1.image = setHeightBasedOnWidht(sourceImage: image, scaledToWidth: Float(self.img1.frame.width))
    }
    func setHeightBasedOnWidht(sourceImage: UIImage, scaledToWidth i_width: Float) -> UIImage
    {
        let oldWidth: Float = Float(sourceImage.size.width)
        let scaleFactor: Float = i_width / oldWidth
        let newHeight: Float = Float(sourceImage.size.height) * scaleFactor
        let newWidth: Float = oldWidth * scaleFactor
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
