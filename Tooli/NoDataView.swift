//
//  PopupView.swift
//  Jagt
//
//  Created by Aadil Keshwani on 16/06/17.
//  Copyright © 2017 Aadil Keshwani. All rights reserved.
//

import UIKit

class NoDataView: UIView
{
    @IBOutlet var lblTitle: UILabel!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        let xibView = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)!.first as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
}

