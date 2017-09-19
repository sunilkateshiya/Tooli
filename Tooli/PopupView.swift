//
//  PopupView.swift
//  Jagt
//
//  Created by Aadil Keshwani on 16/06/17.
//  Copyright © 2017 Aadil Keshwani. All rights reserved.
//

import UIKit


protocol RetryButtonDeleget
{
    func RetrybuttonTaped()
}
class PopupView: UIView
{
    var delegate:RetryButtonDeleget?
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnRetry : UIButton!

    @IBAction func actionRetry(_ sender: UIButton)
    {
        self.removeFromSuperview()
        self.delegate?.RetrybuttonTaped()
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        let xibView = Bundle.main.loadNibNamed("PopupView", owner: self, options: nil)!.first as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
}

