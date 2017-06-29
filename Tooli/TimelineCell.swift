//
//  TimelineCell.swift
//  Tooli
//
//  Created by Impero IT on 9/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    @IBOutlet var imgProfile : UIImageView!
    @IBOutlet var lblCaption : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var imgStatus : UIImageView!
    @IBOutlet var imgView : UIView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var btnFav : UIButton!
    @IBOutlet var imgFav : UIImageView!
    @IBOutlet var btnProfile : UIButton!
    @IBOutlet var btnPortfolio : UIButton!
    @IBOutlet var imgHeight : NSLayoutConstraint!
    @IBOutlet var portfolioHeight : NSLayoutConstraint!
    var isReload:Bool = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


class HederViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
class SuggestionViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var viewcontroller:DashBoardTab = DashBoardTab()
    @IBOutlet var collection:UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard  ((self.viewcontroller.contractorList) != nil) else {
            return 0
        }
        if  (self.viewcontroller.contractorList == nil){
            return  (self.viewcontroller.contractorList!.DataList!.count);
        }
        return  (self.viewcontroller.contractorList!.DataList!.count);
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserList", for: indexPath) as! UserCollectionViewCell
        
        cell.btnFollow.tag = indexPath.row
        cell.btnFollow.addTarget(self, action: #selector(FollowUnfollowTapped(_:)), for: UIControlEvents.touchUpInside)
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(btnDeleteTapped(_:)), for: UIControlEvents.touchUpInside)
        
        cell.btnTaped.tag = indexPath.row
        cell.btnTaped.addTarget(self, action: #selector(UserImageTaped(_:)), for: UIControlEvents.touchUpInside)
        
        cell.lblUserName.text = self.viewcontroller.contractorList!.DataList?[indexPath.row].Name as String!
        cell.lblTredaCatagory.text = self.viewcontroller.contractorList!.DataList?[indexPath.row].TradeCategoryName as String!
        let imgURL = self.viewcontroller.contractorList!.DataList?[indexPath.row].ImageLink as String!
        
        let url = URL(string: imgURL!)
        cell.imgUserProfile.kf.indicatorType = .activity
        cell.imgUserProfile.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    func UserImageTaped(_ sender:UIButton)
    {
        print(sender.tag)
        if(self.viewcontroller.contractorList!.DataList?[sender.tag].IsContractor == false)
        {
            let companyVC : CompnayProfilefeed = storyboard.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
            companyVC.companyId = (self.viewcontroller.contractorList!.DataList?[sender.tag].CompanyID)!
            viewcontroller.navigationController?.pushViewController(companyVC, animated: true)
        }
        else
        {
            let companyVC : ProfileFeed = storyboard.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            companyVC.contractorId = (self.viewcontroller.contractorList!.DataList?[sender.tag].ContractorID)!
            viewcontroller.navigationController?.pushViewController(companyVC, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    func FollowUnfollowTapped(_ sender: UIButton) {
        viewcontroller.startAnimating()
        var strUrlTogaling = ""
        
        var param = [:] as! [String:Any]
        
        if(self.viewcontroller.contractorList?.DataList![sender.tag].IsContractor)!
        {
            strUrlTogaling = Constants.URLS.FollowContractorToggle
            param = ["FollowContractorID": self.viewcontroller.contractorList?.DataList![sender.tag].ContractorID ?? 0,
                     "ContractorID": viewcontroller.sharedManager.currentUser.ContractorID,] as [String : Any]
        }
        else
        {
            strUrlTogaling = Constants.URLS.FollowCompanyToggle
            param = ["FollowCompanyID": self.viewcontroller.contractorList?.DataList![sender.tag].CompanyID ?? 0,
                     "ContractorID": viewcontroller.sharedManager.currentUser.ContractorID,] as [String : Any]
        }
        
        print(param)
        AFWrapper.requestPOSTURL(strUrlTogaling, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.viewcontroller.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.viewcontroller.contractorList?.DataList?.remove(at: sender.tag)
                    self.viewcontroller.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
                    self.collection.reloadData()
                }
                else
                {
                    self.viewcontroller.stopAnimating()
                    self.viewcontroller.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.viewcontroller.stopAnimating()
            self.viewcontroller.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func btnDeleteTapped(_ sender: UIButton) {
        self.viewcontroller.startAnimating()
        var strUrlTogaling = ""
        var param = [:] as! [String:Any]
        strUrlTogaling = Constants.URLS.RemoveFromSuggestionUserList
        param = ["RemoveUserID": self.viewcontroller.contractorList?.DataList![sender.tag].UserID ?? 0,
                 "ContractorID": self.viewcontroller.sharedManager.currentUser.ContractorID,] as [String : Any]
        print(param)
        
        
        AFWrapper.requestPOSTURL(strUrlTogaling, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.viewcontroller.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.viewcontroller.contractorList?.DataList?.remove(at: sender.tag)
                    self.viewcontroller.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
                    self.collection.reloadData()
                }
                else
                {
                    self.viewcontroller.stopAnimating()
                    self.viewcontroller.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.viewcontroller.stopAnimating()
            self.viewcontroller.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
}
