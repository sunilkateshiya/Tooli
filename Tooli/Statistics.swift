//
//  Statistics.swift
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
import ENSwiftSideMenu
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher
<<<<<<< HEAD


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

=======
import FSCalendar

class Statistics: UIViewController,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
<<<<<<< HEAD
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    fileprivate let formatter1: DateFormatter = {
        let formatter1 = DateFormatter() 
        formatter1.dateFormat = "dd/MM/yyyy"
        return formatter1
    }()

=======
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    fileprivate let formatter1: DateFormatter = {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd/MM/yyyy"
        return formatter1
    }()
    @IBOutlet weak var lblTitle: UILabel!
    
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    @IBOutlet weak var lblProfileView: UILabel!
    @IBOutlet weak var lblProfileSave: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var lblMessageCount: UILabel!
    var viewAllPortFolio = false
    var viewAllpost = false
    @IBOutlet weak var tabView: UITableView!
    var sharedManager : Globals = Globals.sharedInstance
<<<<<<< HEAD
    var stasticsDataList: StatisticsModalAllData = StatisticsModalAllData()
    var strFromDate = ""
    var strToDate = ""
    var strTemp = ""
=======
    var stasticsDataList: StatisticsModal!
    var strFromDate = ""
    var strToDate = ""
    var strTemp = ""
    @IBOutlet weak var DateSelectionView: UIView!
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    @IBOutlet weak var lblDate: UILabel!
    
    var From:Bool = true
    @IBAction func btnSelecteDateAction(_ sender: UIButton)
    {
<<<<<<< HEAD
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
=======
         DateSelectionView.isHidden = false
        lblTitle.text = "Please selecte From Date"
    }
    @IBAction func btnCancelAction(_ sender: UIButton)
    {
        DateSelectionView.isHidden = true
    }
    @IBAction func btnNextAction(_ sender: UIButton)
    {
        
        if(strTemp == "")
        {
            if(!From)
            {
             self.view.makeToast("Please Select To Date", duration: 3, position: .center)
            }
            else
            {
             self.view.makeToast("Please Select From Date", duration: 3, position: .center)
            }
        }
        else
        {
            if(From)
            {
                strFromDate = strTemp
                From = false
                lblTitle.text = "Please selecte To Date"
                calendar.deselect(self.formatter.date(from: strTemp)!)
                strTemp = ""
                calendar.reloadData()
                lblDate.text = "\(self.formatter1.string(from: self.formatter1.date(from: strFromDate)!))-\(self.formatter1.string(from: self.formatter1.date(from: strToDate)!))"
                sender.setTitle("Apply", for: UIControlState.normal)
            }
            else
            {
                strToDate = strTemp
                 calendar.deselect(self.formatter.date(from: strTemp)!)
                
                calendar.reloadData()
                getStataticReport()
                lblDate.text = "\(self.formatter1.string(from: self.formatter1.date(from: strFromDate)!))-\(self.formatter1.string(from: self.formatter1.date(from: strToDate)!))"
                 From = true
                DateSelectionView.isHidden = true
                sender.setTitle("Next", for: UIControlState.normal)
                strTemp = ""
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DateSelectionView.isHidden = true
        
        tabView.rowHeight = UITableViewAutomaticDimension
        tabView.estimatedRowHeight = 1000
        strToDate = self.formatter.string(from: Date())
        strFromDate = self.formatter.string(from: Date())
        lblDate.text = "\(self.formatter1.string(from: self.formatter1.date(from: strFromDate)!))-\(self.formatter1.string(from: self.formatter1.date(from: strToDate)!))"
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.today = nil // Hide the today circle
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.allowsSelection = true
        calendar.select(Date())
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    
        getStataticReport()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
<<<<<<< HEAD
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.stasticsDataList.Result != nil
        {
=======
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.stasticsDataList != nil {
            //self.TblHeightConstraints.constant = self.TblTimeline.contentSize.height
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            return 2
        }
        else {
            return 0
        }
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
<<<<<<< HEAD
       toggleSideMenuView()
=======
        AppDelegate.sharedInstance().moveToDashboard()
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.moveToDashboard()
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
<<<<<<< HEAD
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatsticsCell
        if(indexPath.row == 0)
        {
            cell.PostList = self.stasticsDataList.Result.PostList
            cell.viewAll = viewAllpost
            
            if(viewAllpost)
            {
                cell.lblTop5.text = "View All"
            }
            if(self.stasticsDataList.Result.PostList.count <= 5)
            {
                cell.btnViewAllData.isHidden = true
            }
            else
            {
                cell.btnViewAllData.isHidden = false
            }
            cell.lblTitle.text = "Post"
            cell.lblTotleSave.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.Result.TotalPostSave)", str: "SAVES")
            cell.lblTotleView.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.Result.TotalPostView)", str: "VIEWS")
=======
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatsticsCell
        if(indexPath.row == 0)
        {
            cell.PostList = self.stasticsDataList.PostList
            cell.viewAll = viewAllpost
            cell.lblTitle.text = "Post"
            cell.lblTotleSave.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.TotalPostSave)", str: "SAVES")
            cell.lblTotleView.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.TotalPostView)", str: "VIWES")
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            cell.btnViewAllData.addTarget(self, action: #selector(Statistics.viewAllPost(_:)), for: UIControlEvents.touchUpInside)
        }
        else
        {
<<<<<<< HEAD
           cell.PostList = self.stasticsDataList.Result.PortfolioList
            cell.lblTitle.text = "Portfolio"
            cell.viewAll = viewAllPortFolio
            if(viewAllPortFolio)
            {
                cell.lblTop5.text = "View All"
            }
            cell.lblTotleSave.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.Result.TotalPortfolioSave)", str: "SAVES")
            cell.lblTotleView.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.Result.TotalPortfolioView)", str: "VIEWS")
            if(self.stasticsDataList.Result.PortfolioList.count <= 5)
            {
                cell.btnViewAllData.isHidden = true
            }
            else
            {
                cell.btnViewAllData.isHidden = false
            }
=======
           cell.PostList = self.stasticsDataList.PortfolioList
            cell.lblTitle.text = "PortFolio"
            cell.viewAll = viewAllPortFolio
            cell.lblTotleSave.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.TotalPortfolioSave)", str: "SAVES")
            cell.lblTotleView.attributedText = self.DisPlayCountInLabel(count: "\(self.stasticsDataList.TotalPortfolioView)", str: "VIWES")
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
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
<<<<<<< HEAD
        let param = ["FromDate":strFromDate,"ToDate":strToDate] as [String : Any]
        self.startAnimating()
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.StatisticsReport, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            self.viewError.isHidden = true
            self.imgError.isHidden = true
            self.btnAgain.isHidden = true
            self.lblError.isHidden = true
            if JSONResponse["Status"].int == 1
            {
               self.stasticsDataList = Mapper<StatisticsModalAllData>().map(JSONObject: JSONResponse.rawValue)!
                self.setData()
            }
            else
            {
                _ = self.navigationController?.popViewController(animated: true)
                AppDelegate.sharedInstance().window?.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
=======
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
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stasticsDataList = self.sharedManager.stastics
                    self.setData()
                }
                self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .center)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            }
            
        }) {
            (error) -> Void in
<<<<<<< HEAD
             
            self.stopAnimating()
            self.viewError.isHidden = false
            self.imgError.isHidden = false
            self.btnAgain.isHidden = false
            self.lblError.isHidden = false
           // self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
=======
            print(error.localizedDescription)
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        }
    }
    func setData()
    {
<<<<<<< HEAD
        lblProfileSave.text = "\(self.stasticsDataList.Result.TotalProfileSave)"
        lblProfileView.text = "\(self.stasticsDataList.Result.TotalProfileView)"
        lblFollowingCount.text = "\(self.stasticsDataList.Result.TotalFollowing)"
        lblFollowerCount.text = "\(self.stasticsDataList.Result.TotalFollowers)"
        lblMessageCount.text = "\(self.stasticsDataList.Result.TotalMessage)"
       // lblProfileSave.text = self.stasticsDataList.Result.TotalProfileSave as! String
=======
        lblProfileSave.text = "\(self.stasticsDataList.TotalProfileSave)"
        lblProfileView.text = "\(self.stasticsDataList.TotalProfileView)"
        lblFollowingCount.text = "\(self.stasticsDataList.TotalFollowing)"
        lblFollowerCount.text = "\(self.stasticsDataList.TotalFollowers)"
        lblMessageCount.text = "\(self.stasticsDataList.TotalMessage)"
       // lblProfileSave.text = self.stasticsDataList.TotalProfileSave as! String
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
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
<<<<<<< HEAD

=======
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
    
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        strTemp = "\(self.formatter.string(from: date))"
        print("did select date \(self.formatter.string(from: date))")
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
         strTemp = ""
        print("did deselect date \(self.formatter.string(from: date))")
        self.configureVisibleCells()
    }
    
    
    // MARK: - Private functions
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date, at: position)
        }
    }
    func maximumDate(for calendar: FSCalendar) -> Date {

        return Date()
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
        diyCell.circleImageView.isHidden = true
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                 diyCell.eventIndicator.isHidden = true
                selectionType = .none
            }
            if selectionType == .none {
                 diyCell.eventIndicator.isHidden = true
                diyCell.selectionLayer.isHidden = true
                return
            }
             diyCell.eventIndicator.isHidden = true
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
             diyCell.eventIndicator.isHidden = true
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
}
