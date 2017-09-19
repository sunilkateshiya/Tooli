//
//  TimelineCell.swift
//  Tooli
//
//  Created by Impero IT on 9/02/2017.
//  Copyright © 2017 impero. All rights reserved.
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
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return viewcontroller.AllDashBoradData.Result.UserSuggestionList.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserList", for: indexPath) as! UserCollectionViewCell
        
        cell.btnFollow.tag = indexPath.row
        cell.btnFollow.addTarget(self, action: #selector(FollowUnfollowTapped(_:)), for: UIControlEvents.touchUpInside)
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(btnDeleteTapped(_:)), for: UIControlEvents.touchUpInside)
        
        cell.btnTaped.tag = indexPath.row
        cell.btnTaped.addTarget(self, action: #selector(UserImageTaped(_:)), for: UIControlEvents.touchUpInside)
        
       
        cell.lblUserName.text = viewcontroller.AllDashBoradData.Result.UserSuggestionList[indexPath.row].Name as String!
        cell.lblTredaCatagory.text = viewcontroller.AllDashBoradData.Result.UserSuggestionList[indexPath.row].TradeName as String!
        let imgURL = viewcontroller.AllDashBoradData.Result.UserSuggestionList[indexPath.row].ProfileImageLink
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(lblNamedTaped(tapGestureRecognizer:)))
        cell.lblUserName.isUserInteractionEnabled = true
        cell.lblUserName.addGestureRecognizer(tapGestureRecognizer)
        cell.lblUserName.tag = indexPath.row
        
        let url = URL(string: imgURL)
        cell.imgUserProfile.kf.indicatorType = .activity
        cell.imgUserProfile.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    func UserImageTaped(_ sender:UIButton)
    {
        if(self.viewcontroller.AllDashBoradData.Result.UserSuggestionList[sender.tag].Role == 0)
        {
            print("Admin")
        }
        else if(self.viewcontroller.AllDashBoradData.Result.UserSuggestionList[sender.tag].Role == 1)
        {
            print("Contractor")
            let companyVC  = storyboard.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
            companyVC.userId = self.viewcontroller.AllDashBoradData.Result.UserSuggestionList[sender.tag].UserID
            viewcontroller.navigationController?.pushViewController(companyVC, animated: true)
        }
        else if(self.viewcontroller.AllDashBoradData.Result.UserSuggestionList[sender.tag].Role == 2)
        {
            print("Company")
            let companyVC  = storyboard.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            companyVC.userId = self.viewcontroller.AllDashBoradData.Result.UserSuggestionList[sender.tag].UserID
            viewcontroller.navigationController?.pushViewController(companyVC, animated: true)
        }
        else if(self.viewcontroller.AllDashBoradData.Result.UserSuggestionList[sender.tag].Role == 3)
        {
            print("Supplier")
            let companyVC  = storyboard.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
            companyVC.userId = self.viewcontroller.AllDashBoradData.Result.UserSuggestionList[sender.tag].UserID
            viewcontroller.navigationController?.pushViewController(companyVC, animated: true)
        }
    }
    
    func lblNamedTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let sender = tapGestureRecognizer.view as! UILabel
        OpenDetailPage(index: sender.tag)
    }
    func OpenDetailPage(index:Int)
    {
        if(viewcontroller.AllDashBoradData.Result.UserSuggestionList[index].Role == 0)
        {
            print("Admin")
        }
        else if(viewcontroller.AllDashBoradData.Result.UserSuggestionList[index].Role == 1)
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
            vc.userId = viewcontroller.AllDashBoradData.Result.UserSuggestionList[index].UserID
            self.viewcontroller.navigationController?.pushViewController(vc, animated: true)
        }
        else if(viewcontroller.AllDashBoradData.Result.UserSuggestionList[index].Role == 2)
        {
            print("Company")
            let vc = storyboard.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            vc.userId = viewcontroller.AllDashBoradData.Result.UserSuggestionList[index].UserID
            self.viewcontroller.navigationController?.pushViewController(vc, animated: true)
        }
        else if(viewcontroller.AllDashBoradData.Result.UserSuggestionList[index].Role == 3)
        {
            print("Supplier")
            let vc = storyboard.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
            vc.userId = viewcontroller.AllDashBoradData.Result.UserSuggestionList[index].UserID
            self.viewcontroller.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    func FollowUnfollowTapped(_ sender: UIButton) {
        viewcontroller.startAnimating()
        var param = [:] as! [String:Any]
        param = ["FollowingUserID":viewcontroller.AllDashBoradData.Result.UserSuggestionList[sender.tag].UserID] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.AccountFollowToggle, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.viewcontroller.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                self.viewcontroller.AllDashBoradData.Result.UserSuggestionList.remove(at: sender.tag)
                self.collection.reloadData()
            }
            self.viewcontroller.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
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
        strUrlTogaling = Constants.URLS.RemoveSuggestionUser
        param = ["RemoveUserID": viewcontroller.AllDashBoradData.Result.UserSuggestionList[sender.tag].UserID] as [String : Any]
        print(param)
        AFWrapper.requestPOSTURL(strUrlTogaling, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.viewcontroller.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                self.viewcontroller.AllDashBoradData.Result.UserSuggestionList.remove(at: sender.tag)
                self.collection.reloadData()
                self.viewcontroller.tvdashb.reloadData()
            }
            self.viewcontroller.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            
        }) {
            (error) -> Void in
            self.viewcontroller.stopAnimating()
            self.viewcontroller.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
}
