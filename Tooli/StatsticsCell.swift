//
//  StatsticsCell.swift
//  Tooli
//
//  Created by Impero IT on 22/02/17.
<<<<<<< HEAD
//  Copyright © 2017 impero. All rights reserved.
=======
//  Copyright © 2017 Moin Shirazi. All rights reserved.
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
//

import UIKit

class StatsticsCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

<<<<<<< HEAD
    @IBOutlet weak var lblTop5: UILabel!
=======
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    @IBOutlet weak var tabViewHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotleSave: UILabel!
    @IBOutlet weak var lblTotleView: UILabel!
    @IBOutlet weak var btnViewAllData: UIButton!
    
    var viewAllPortFolio = false
    var viewAll = false
    var PostList:[TopsView] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.PostList != nil {
            //self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
            if(self.PostList.count > 5)
            {
                if(viewAll)
                {
                    return PostList.count
                }
                else
                {
                    return 5
                }
            }
            else
            {
                 return (self.PostList.count)
            }
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatsticsCell
        cell.lblTitle.text = PostList[indexPath.row].Title
        cell.lblTotleSave.attributedText = self.DisPlayCountInLabel(count: "\(PostList[indexPath.row].TotalPageSave)", str: "SAVES")
<<<<<<< HEAD
        cell.lblTotleView.attributedText = self.DisPlayCountInLabel(count: "\(PostList[indexPath.row].TotalPageView)", str: "VIEWS")
=======
        cell.lblTotleView.attributedText = self.DisPlayCountInLabel(count: "\(PostList[indexPath.row].TotalPageView)", str: "VIWES")
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        return cell
    }
    func DisPlayCountInLabel(count:String,str:String) -> NSMutableAttributedString
    {
        let myString = "\(count) \(str)"
        let myRange = NSRange(location: 0, length: count.length)
        let myRange1 = NSRange(location: count.length+1, length: 5)
        
        let anotherAttribute = [ NSForegroundColorAttributeName: UIColor.black]
        let anotherAttribute1 = [ NSForegroundColorAttributeName: UIColor.lightGray]
        let myAttrString = NSMutableAttributedString(string: myString)
        myAttrString.addAttributes(anotherAttribute, range: myRange)
        myAttrString.addAttributes(anotherAttribute1, range: myRange1)
        return myAttrString
    }
}
