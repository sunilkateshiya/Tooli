//
//  Statistics.swift
//  Tooli
//
//  Created by Impero IT on 22/02/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher


class Statistics: UIViewController,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable,WWCalendarTimeSelectorProtocol{

    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    
    @IBOutlet weak var btnAgain: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewError: UIView!
    @IBAction func btnAgainErrorAction(_ sender: UIButton)
    {
       getStataticReport()  
    }

    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    fileprivate let formatter1: DateFormatter = {
        let formatter1 = DateFormatter() 
        formatter1.dateFormat = "dd/MM/yyyy"
        return formatter1
    }()

    @IBOutlet weak var lblProfileView: UILabel!
    @IBOutlet weak var lblProfileSave: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var lblMessageCount: UILabel!
    var viewAllPortFolio = false
    var viewAllpost = false
    @IBOutlet weak var tabView: UITableView!
    var sharedManager : Globals = Globals.sharedInstance
    var stasticsDataList: StatisticsModal!
    var strFromDate = ""
    var strToDate = ""
    var strTemp = ""
    @IBOutlet weak var lblDate: UILabel!
    
    var From:Bool = true
    @IBAction func btnSelecteDateAction(_ sender: UIButton)
    {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionTopPanelBackgroundColor = UIColor.red
        selector.optionSelectorPanelBackgroundColor = UIColor.red.withAlphaComponent(0.8)
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates)
        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
        selector.optionSelectionType = WWCalendarTimeSelectorSelection.range
        present(selector, animated: true, completion: nil)
    
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Statistics Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        
    }
     func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool
     {
        if(date  > Date())
        {
            return false
        }
        return true
    }
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        print("Selected Multiple Dates \n\(dates)\n---")
        
        multipleDates = dates
        strFromDate = self.formatter.string(from: dates.first! )
        strToDate  = self.formatter.string(from: dates.last!)
        
        lblDate.text = "\(self.formatter1.string(from: self.formatter1.date(from: strFromDate)!))-\(self.formatter1.string(from: self.formatter1.date(from: strToDate)!))"
        
        getStataticReport()
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewError.isHidden = false
        
        tabView.rowHeight = UITableViewAutomaticDimension
        tabView.estimatedRowHeight = 1000
        strFromDate = self.formatter.string(from: Date())
        strToDate = self.formatter.string(from: Date())
        
        lblDate.text = "\(self.formatter1.string(from: self.formatter1.date(from: strFromDate)!))-\(self.formatter1.string(from: self.formatter1.date(from: strToDate)!))"
    
        getStataticReport()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.stasticsDataList != nil {
            //self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
            return 2
        }
        else {
            return 0
        }
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
       toggleSideMenuView()
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.moveToDashboard()
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatsticsCell
        if(indexPath.row == 0)
        {
            cell.PostList = self.stasticsDataList.PostList
            cell.viewAll = viewAllpost
            
            if(viewAllpost)
            {
                cell.lblTop5.text = "View All"
            }
            if(self.stasticsDataList.PostList.count <= 5)
            {
                cell.btnViewAllData.isHidden = true
            }
            else
            {
                cell.btnViewAllData.isHidden = false
            }
            cell.lblTitle.text = "Post"
            cell.lblTotleSave.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.TotalPostSave)", str: "SAVES")
            cell.lblTotleView.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.TotalPostView)", str: "VIEWS")
            cell.btnViewAllData.addTarget(self, action: #selector(Statistics.viewAllPost(_:)), for: UIControlEvents.touchUpInside)
        }
        else
        {
           cell.PostList = self.stasticsDataList.PortfolioList
            cell.lblTitle.text = "Portfolio"
            cell.viewAll = viewAllPortFolio
            if(viewAllPortFolio)
            {
                cell.lblTop5.text = "View All"
            }
            cell.lblTotleSave.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.TotalPortfolioSave)", str: "SAVES")
            cell.lblTotleView.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.TotalPortfolioView)", str: "VIEWS")
            if(self.stasticsDataList.PortfolioList.count <= 5)
            {
                cell.btnViewAllData.isHidden = true
            }
            else
            {
                cell.btnViewAllData.isHidden = false
            }
            cell.btnViewAllData.addTarget(self, action: #selector(Statistics.viewAllProtfolio(_:)), for: UIControlEvents.touchUpInside)
        }
        cell.tabView.delegate = cell
        cell.tabView.dataSource = cell
        cell.tabView.reloadData()
        cell.tabViewHieghtConstraint.constant = cell.tabView.contentSize.height
       
        return cell
    }
    func getStataticReport()
    {
        let param = ["ContractorID": self.sharedManager.currentUser.ContractorID,
                     "FromDate":strFromDate,"ToDate":strToDate] as [String : Any]
        self.startAnimating()
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.ContractorStatisticsReport, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.stastics = Mapper<StatisticsModal>().map(JSONObject: JSONResponse.rawValue)
            self.stopAnimating()
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil{
                self.viewError.isHidden = true
                self.imgError.isHidden = true
                self.btnAgain.isHidden = true
                self.lblError.isHidden = true
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stasticsDataList = self.sharedManager.stastics
                    self.setData()
                }
                else
                {
                     _ = self.navigationController?.popViewController(animated: true)
                    AppDelegate.sharedInstance().window?.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
             
            self.stopAnimating()
            self.viewError.isHidden = false
            self.imgError.isHidden = false
            self.btnAgain.isHidden = false
            self.lblError.isHidden = false
           // self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    func setData()
    {
        lblProfileSave.text = "\(self.stasticsDataList.TotalProfileSave)"
        lblProfileView.text = "\(self.stasticsDataList.TotalProfileView)"
        lblFollowingCount.text = "\(self.stasticsDataList.TotalFollowing)"
        lblFollowerCount.text = "\(self.stasticsDataList.TotalFollowers)"
        lblMessageCount.text = "\(self.stasticsDataList.TotalMessage)"
       // lblProfileSave.text = self.stasticsDataList.TotalProfileSave as! String
        tabView.reloadData()
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
    func viewAllProtfolio(_ sender:UIButton)
    {
        sender.isHidden = true
        viewAllPortFolio = true
        tabView.reloadData()
    }
    func viewAllPost(_ sender:UIButton)
    {
        sender.isHidden = true
        viewAllpost = true
        tabView.reloadData()
    }

}
