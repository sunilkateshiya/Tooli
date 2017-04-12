//
//  NProfileFeed.swift
//  Tooli
//
//  Created by Impero IT on 21/02/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import Popover

class NProfileFeed: UIViewController,UITableViewDataSource, UITableViewDelegate
{
     var popover = Popover()
    @IBOutlet weak var SearchbarView: UISearchBar!
    @IBOutlet weak var tvListview: UITableView!
    @IBOutlet weak var BtnEditProfile: UIButton!
    @IBOutlet weak var BtnNotification: UIButton!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var btnFollwer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func BtnNotificationTapped(_ sender: UIButton) {
        
        self .popOver()
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    @IBAction func btnFollowingAction(_ sender: UIButton)
    {
        btnFollwer.isSelected = false
        btnFollowing.isSelected = true
        
        btnFollwer.backgroundColor = UIColor.clear
        btnFollowing.backgroundColor = UIColor.white
    }
    @IBAction func btnFollowersAction(_ sender: UIButton)
    {
        btnFollwer.isSelected = true
        btnFollowing.isSelected = false
        
        btnFollwer.backgroundColor = UIColor.white
        btnFollowing.backgroundColor = UIColor.clear
        
    }
    @IBAction func btnEditProfileAction(_ sender: UIButton)
    {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowingListCell
        
        
        return cell
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
        Share.tag = 20001
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
        Delete.tag = 20002
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
        MonthAvailiblity.tag = 20003
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
        
    }
}
