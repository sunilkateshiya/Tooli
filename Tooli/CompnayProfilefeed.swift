//
//  CompnayProfilefeed.swift
//  Tooli
//
//  Created by Impero-Moin on 21/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Popover

class CompnayProfilefeed:UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
     var popover = Popover()
     
     var screenSize: CGRect!
     var screenWidth: CGFloat!
     var screenHeight: CGFloat!
     @IBOutlet weak var ObjScrollview: UIScrollView!
     @IBOutlet weak var ImgProfilePic: UIImageView!
     @IBOutlet weak var ImgStar: UIImageView!
     @IBOutlet weak var ImgOnOff: UIImageView!
     @IBOutlet weak var AboutviewHeight: NSLayoutConstraint!
     
     @IBOutlet weak var TBLSpecialOffer: UITableView!
     @IBOutlet weak var BtnJobs: UIButton!
     @IBOutlet weak var BtnNotification: UIButton!
     @IBAction func BtnNotificationTapped(_ sender: Any) {
          
          self .popOver()
     }
     @IBAction func BtnJobsTapped(_ sender: Any) {
          
          self.TblHeightConstraints.constant = 185 * 10
          self.ObjScrollview.contentSize.height = 237 + self.TblHeightConstraints.constant

          
          self.BtnPortfolio.isSelected = false
          self.BtnPortfolio.tintColor = UIColor.white
          self.BtnPortfolio.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
          
          self.BtnJobs.isSelected = true
          self.BtnJobs.tintColor = UIColor.white
          self.BtnJobs.setTitleColor(UIColor.red, for: UIControlState.selected)
          
          self.BtnAbout.isSelected = false
          self.BtnAbout.tintColor = UIColor.white
          self.BtnAbout.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
          
          self.TblTimeline.isHidden = false
          self.PortfolioView.isHidden = true
          self.AboutView.isHidden = true
//                    self.AboutviewHeight.constant = 185 * 10
//          
//                    self.PortCollectionHeight.constant = 185 * 10
//                    self.ObjScrollview.contentSize.height = self.TblHeightConstraints.constant

     }
     @IBOutlet weak var TblHeightConstraints: NSLayoutConstraint!
     @IBOutlet weak var lblName: UILabel!
     
     @IBOutlet weak var lblSkill: UILabel!
     
     @IBOutlet weak var PortfolioView: UIView!
     @IBOutlet weak var lblLocation: UILabel!
     @IBOutlet weak var AboutView: UIView!
     
     
     
     @IBOutlet weak var TblTimeline: UITableView!
     
     @IBOutlet weak var PortCollectionHeight: NSLayoutConstraint!
     @IBOutlet weak var BtnAbout: UIButton!
     
     @IBOutlet weak var BtnPortfolio: UIButton!
     
     @IBAction func BtnAboutTapped(_ sender: Any) {
          self.ObjScrollview.contentSize.height = 237 + 456
          
          
          
         

          
          
          self.BtnPortfolio.isSelected = false
          self.BtnPortfolio.tintColor = UIColor.white
          self.BtnPortfolio.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
          
          self.BtnAbout.isSelected = true
          self.BtnAbout.tintColor = UIColor.white
          self.BtnAbout.setTitleColor(UIColor.red, for: UIControlState.selected)

          self.BtnJobs.isSelected = true
          self.BtnJobs.tintColor = UIColor.white
          self.BtnJobs.setTitleColor(UIColor.lightGray, for: UIControlState.selected)

          
          self.TblTimeline.isHidden = true
          self.PortfolioView.isHidden = true
          self.AboutView.isHidden = false
          
          self.TblTimeline.tag = 1
          
          //          self.HeightConstraints.constant = 0
          //          self.PortCollectionHeight.constant = 0
     }
     @IBAction func BtnPortfolioTapped(_ sender: Any) {
          
          self.PortCollectionHeight.constant = 291 * 10
          self.ObjScrollview.contentSize.height = 237 + self.PortCollectionHeight.constant
          
          self.BtnAbout.isSelected = false
          self.BtnAbout.tintColor = UIColor.white
          self.BtnAbout.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
          
          self.BtnPortfolio.isSelected = true
          self.BtnPortfolio.tintColor = UIColor.white
          self.BtnPortfolio.setTitleColor(UIColor.red, for: UIControlState.selected)
          
          self.BtnJobs.isSelected = false
          self.BtnJobs.tintColor = UIColor.white
          self.BtnJobs.setTitleColor(UIColor.lightGray, for: UIControlState.selected)

          self.TblTimeline.isHidden = true
          self.PortfolioView.isHidden = false
          self.AboutView.isHidden = true
          
          
          //          self.PortCollectionHeight.constant = self.ObjCollectionView.contentSize.height
          
          
          
     }
     
     func popOver() {
          
          
          let width = self.view.frame.size.width
          let aView = UIView(frame: CGRect(x: 10, y: 25, width: width, height: 120))
          
          let Available = UIImageView(frame: CGRect(x: 10, y: 13, width: 14 , height: 14))
          Available.image = #imageLiteral(resourceName: "ic_circle_green")
          
          let Availableinweek = UIImageView(frame: CGRect(x: 10, y: 53, width: 14, height: 14))
          Availableinweek.image = #imageLiteral(resourceName: "ic_CircleYellow")
          
          let Availableinmonth = UIImageView(frame: CGRect(x: 10, y: 93, width: 14, height: 14))
          Availableinmonth.image = #imageLiteral(resourceName: "ic_circle_red")
          
          
          
          
          let Share = UIButton(frame: CGRect(x: 40, y: 0, width: width - 30, height: 40))
          Share.setTitle("I am availabale immediately", for: .normal)
          Share.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
          Share.contentHorizontalAlignment = .left
          Share.setTitleColor(UIColor.darkGray, for: .normal)
          Share.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
          
          
          let border = CALayer()
          let width1 = CGFloat(1.0)
          border.borderColor = UIColor.lightGray.cgColor
          border.frame = CGRect(x: 0, y: Share.frame.size.height - width1, width:  Share.frame.size.width, height: Share.frame.size.height)
          
          border.borderWidth = width1
          Share.layer.addSublayer(border)
          Share.layer.masksToBounds = true
          
          
          let Delete = UIButton(frame: CGRect(x: 40, y: 40, width: width - 30, height: 40))
          Delete.setTitle("I am Available in 2-4 weeks", for: .normal)
          Delete.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
          Delete.setTitleColor(UIColor.darkGray, for: .normal)
          Delete.contentHorizontalAlignment = .left
          Delete.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
          let borderDelete = CALayer()
          let widthDelete = CGFloat(1.0)
          borderDelete.borderColor = UIColor.lightGray.cgColor
          borderDelete.frame = CGRect(x: 0, y: Delete.frame.size.height - width1, width:  Delete.frame.size.width, height: Delete.frame.size.height)
          
          borderDelete.borderWidth = widthDelete
          Delete.layer.addSublayer(borderDelete)
          Delete.layer.masksToBounds = true
          
          
          let MonthAvailiblity = UIButton(frame: CGRect(x: 40, y: 80, width: width - 30, height: 40))
          MonthAvailiblity.setTitle("I am Available in 1-3 months", for: .normal)
          MonthAvailiblity.titleLabel!.font =  UIFont(name: "Oxygen-Regular", size: 16)
          MonthAvailiblity.setTitleColor(UIColor.darkGray, for: .normal)
          MonthAvailiblity.contentHorizontalAlignment = .left
          MonthAvailiblity.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
          
          
          aView.addSubview(Delete)
          aView.addSubview(Share)
          aView.addSubview(MonthAvailiblity)
          aView.addSubview(Available)
          aView.addSubview(Availableinmonth)
          aView.addSubview(Availableinweek)
          
          
          let options = [
               .type(.down),
               .cornerRadius(4)
               ] as [PopoverOption]
          popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
          popover.show(aView, fromView:BtnNotification)
          
          
          
     }
     func press(button: UIButton) {
          
          popover.dismiss()
          
     }
     
     
     
     
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          self.ObjScrollview.contentSize.height = 247 + AboutView.frame.size.height
          
          self.BtnPortfolio.isSelected = false
          self.BtnPortfolio.tintColor = UIColor.white
          self.BtnPortfolio.setTitleColor(UIColor.lightGray, for: UIControlState.selected)
          
          self.BtnAbout.isSelected = true
          self.BtnAbout.tintColor = UIColor.white
          self.BtnAbout.setTitleColor(UIColor.red, for: UIControlState.selected)
          
          
          self.TblTimeline.isHidden = true
          self.PortfolioView.isHidden = true
          self.AboutView.isHidden = false
          
          self.TblTimeline.tag = 1

          
          TblTimeline.delegate = self
          TblTimeline.dataSource = self
          TblTimeline.rowHeight = UITableViewAutomaticDimension
          TblTimeline.estimatedRowHeight = 450
          TblTimeline.tableFooterView = UIView()
          
          TBLSpecialOffer.delegate = self
          TBLSpecialOffer.dataSource = self
          TBLSpecialOffer.rowHeight = UITableViewAutomaticDimension
          TBLSpecialOffer.estimatedRowHeight = 450
          TBLSpecialOffer.tableFooterView = UIView()
          
          ObjScrollview.delegate = self
          
          
          
          
          
          
          
          
     }
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
          if AboutView.isHidden == true {
          }
     }
     override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
     }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if tableView == self.TblTimeline {
               return 10
          }
          else if tableView == TBLSpecialOffer
          {
               return 10;
          }
          else
          {
               return  10
               
          }
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
          
          if tableView == self.TblTimeline {
               let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
               
               //               cell.textLabel?.text = "Trades " +  "\(indexPath.row)"
               return cell
               
          }
          else if tableView == TBLSpecialOffer
          {
               let cell = tableView.dequeueReusableCell(withIdentifier: "specialCell", for: indexPath) as! SpecialOfferCell
               cell.lblCompanyName?.text = "lblCompanyName " +  "\(indexPath.row)"
               cell.lblWork?.text = "lblWork " +  "\(indexPath.row)"
               cell.lblLocation?.text = "lblLocation " +  "\(indexPath.row)"
               cell.lblCompanyDescription?.text = "lblCompanyDescription " +  "\(indexPath.row)"
               return cell

          }
          else
          {
               
               let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExperienceCell
               
//               cell.lblCompany?.text = "Company " +  "\(indexPath.row)"
//               cell.lblFrom?.text = "From " +  "\(indexPath.row)"
//               cell.LblJobTitle?.text = "Job title " +  "\(indexPath.row)"
//               cell.lblUntil?.text = "Until " +  "\(indexPath.row)"
               
               return cell
          }
     }
     
     
     
     
     
     
}
