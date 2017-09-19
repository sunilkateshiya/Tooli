//
//  SignupVC2.swift
//  Toolii
//
//  Created by Impero IT on 08/08/17.
//  Copyright © 2017 whollysoftware. All rights reserved.
//

import UIKit
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import MapKit
import SwiftyJSON
import GooglePlaces


class SignupVC2: UIViewController,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable,UITextFieldDelegate
{
    @IBOutlet var tabJobRole:UITableView!
    @IBOutlet var tabSubJobRole:UITableView!
    @IBOutlet var tabSelectedJobRole:UITableView!
    @IBOutlet var tabYourTrade:UITableView!
    @IBOutlet var tabselectedTrade:UITableView!
    @IBOutlet var tabSectors:UITableView!
    @IBOutlet weak var locationSlider: UISlider!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtTown: UITextField!
    @IBOutlet weak var txtSearchTrade: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYourTrade: UILabel!
    
    
    @IBOutlet weak var txtSkill1: UITextField!
    @IBOutlet weak var txtSkill2: UITextField!
    @IBOutlet weak var txtSkill3: UITextField!
    @IBOutlet weak var txtSkill4: UITextField!
    @IBOutlet weak var txtSkill5: UITextField!
    @IBOutlet weak var txtSkill6: UITextField!
    
    @IBOutlet weak var btnSelctedDepartment: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var tabJobRoleHeightConstraint: NSLayoutConstraint!
     @IBOutlet weak var tabSubJobRoleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabSelectedJobRoleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tabYourTradeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabSelectedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabSectoreHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnNext: UIButton!
    
    var selecteSectore:[Int] = []
    var selectedJobRole:[JobRoleListM] = []
    
    var DisplayTradeList:[SubTradeListM] = []
    
    var selectedSubTrade:[SubTradeListM] = []
    
    var DisplayJobRoleList:[JobRoleListM] = []

    var DataList:GetDefaultList = GetDefaultList()
    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var AllData:GetSignUp2 = GetSignUp2()
    var edit:Bool = false
    
    var isVisibleDepartment:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.txtSearchTrade.delegate = self
        self.locationSlider.value = 10.0
        GetUserAllDataFromServer()
        if(self.edit)
        {
            self.lblTitle.text = "Edit"
            btnNext.setTitle("Update", for: UIControlState.normal)
        }
        btnSelctedDepartment.setTitle("Department", for: UIControlState.normal)
        self.tabJobRoleHeightConstraint.constant = 0
        self.tabSubJobRoleHeightConstraint.constant = 0
        self.tabSelectedJobRoleHeightConstraint.constant = 0
        self.tabYourTradeHeightConstraint.constant = 0
        self.tabSelectedHeightConstraint.constant = 0
        self.tabSectoreHeightConstraint.constant = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func locationValueChanged(_ sender: UISlider)
    {
        print(sender.value)
        if(sender.value < 10.0)
        {
            sender.value = 10.0
        }
        lblDistance.text = "\(Int(sender.value)) miles"
    }
    @IBAction func BtnDepartmentSelection(_ sender: UIButton)
    {
        if(isVisibleDepartment)
        {
            isVisibleDepartment = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.tabJobRoleHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { (true) in
                
            }
        }
        else
        {
            isVisibleDepartment = true
            
            UIView.animate(withDuration: 0.5, animations: {
                if(self.DataList.Result.DepartmentList.count > 5)
                {
                    self.tabJobRoleHeightConstraint.constant = (self.view.frame.size.height/18.62)*5
                }
                else
                {
                    self.tabJobRoleHeightConstraint.constant = (self.view.frame.size.height/18.62)*CGFloat(self.DataList.Result.DepartmentList.count)
                }
                self.view.layoutIfNeeded()
            }) { (true) in
                
            }
        }
    }
    @IBAction func locationSelection(_ sender: UIButton)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.tintColor = UIColor.red
        let header : UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: 60))
        header.backgroundColor=UIColor.red
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        autocompleteController.view.addSubview(header)
        
        let filter = GMSAutocompleteFilter()
        filter.country = "UK"
        autocompleteController.autocompleteFilter = filter
        
        autocompleteController.navigationController?.setToolbarHidden(false, animated: true)
        present(autocompleteController, animated: true, completion: nil)
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var strUpdated:NSString =  textField.text! as NSString
        strUpdated = strUpdated.replacingCharacters(in: range, with: string) as NSString
        if(txtSearchTrade == textField)
        {
            if(strUpdated == "")
            {
                DataList.Result.SerachTradeList = []
            }
            else
            {
                DataList.Result.SerachTradeList =  DataList.Result.TradeDefaultList.filter( { (user: SubTradeListM) -> Bool in
                    return user.Name.lowercased().range(of:strUpdated.lowercased as String) != nil
                })
            }
            if(DataList.Result.SerachTradeList.count > 5)
            {
                self.tabYourTradeHeightConstraint.constant = (self.view.frame.size.height/22.4)*5
            }
            else
            {
                self.tabYourTradeHeightConstraint.constant = (self.view.frame.size.height/22.4)*CGFloat(self.DataList.Result.SerachTradeList.count)+20
            }
            if(DataList.Result.SerachTradeList.count == 0)
            {
                self.tabYourTradeHeightConstraint.constant = 0
            }
            self.tabYourTrade.reloadData()
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        scroll.setContentOffset(CGPoint(x: 0, y: lblYourTrade.frame.origin.y), animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tabJobRole)
        {
            return DataList.Result.DepartmentList.count
        }
        else if(tableView == tabSubJobRole)
        {
            return DisplayJobRoleList.count
        }
        else if(tableView == tabSelectedJobRole)
        {
            return self.selectedJobRole.count
        }
        else if(tableView == tabYourTrade)
        {
             return DataList.Result.SerachTradeList.count
        }
        else if(tableView == tabselectedTrade)
        {
            return selectedSubTrade.count
        }
        else if(tableView == tabSectors)
        {
            return DataList.Result.SectorList.count
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tabJobRole)
        {
            return self.view.frame.size.height/18.62
        }
        else if(tableView == tabSubJobRole)
        {
            return self.view.frame.size.height/22.4
        }
        else if(tableView == tabSelectedJobRole)
        {
            return self.view.frame.size.height/22.4
        }
        else if(tableView == tabYourTrade)
        {
            return self.view.frame.size.height/22.4
        }
        else if(tableView == tabselectedTrade)
        {
            return self.view.frame.size.height/22.4
        }
        else if(tableView == tabSectors)
        {
            return self.view.frame.size.height/12.62
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(tableView == tabJobRole)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.lblName.text = DataList.Result.DepartmentList[indexPath.row].DepartmentName
            return cell
        }
        else if(tableView == tabSubJobRole)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.btnSelction.setTitle( self.DisplayJobRoleList[indexPath.row].JobRoleName, for: UIControlState.normal)
            cell.btnSelction.setTitle( self.DisplayJobRoleList[indexPath.row].JobRoleName, for: UIControlState.selected)
            
            var temp:[JobRoleListM] = []
            temp =  selectedJobRole.filter( { (user: JobRoleListM) -> Bool in
                return user.JobRoleID == self.DisplayJobRoleList[indexPath.row].JobRoleID
            })
            if(temp.count != 0)
            {
                cell.btnSelction.isSelected = true
            }
            else
            {
                cell.btnSelction.isSelected = false
            }
            cell.btnSelction.tag = indexPath.row
            cell.btnSelction.addTarget(self, action: #selector(btnSubJobRoleSelctionAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        else if(tableView == tabSelectedJobRole)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.btnRemove.tag = indexPath.row
            cell.btnRemove.addTarget(self, action: #selector(btnRemoveJobRole(_:)), for: UIControlEvents.touchUpInside)
            cell.lblName.text = selectedJobRole[indexPath.row].JobRoleName
            
            return cell
        }
        else if(tableView == tabYourTrade)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.btnSelction.setTitle( DataList.Result.SerachTradeList[indexPath.row].Name, for: UIControlState.normal)
            cell.btnSelction.setTitle( DataList.Result.SerachTradeList[indexPath.row].Name, for: UIControlState.selected)
            var temp:[SubTradeListM] = []
            temp =  selectedSubTrade.filter( { (user: SubTradeListM) -> Bool in
                return user.Id == DataList.Result.SerachTradeList[indexPath.row].Id && user.IsTrade == DataList.Result.SerachTradeList[indexPath.row].IsTrade
            })
            if(temp.count != 0)
            {
                cell.btnSelction.isSelected = true
            }
            else
            {
                cell.btnSelction.isSelected = false
            }
            cell.btnSelction.tag = indexPath.row
            cell.btnSelction.addTarget(self, action: #selector(btnTradeSelctionAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        else if(tableView == tabselectedTrade)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.btnRemove.tag = indexPath.row
            cell.btnRemove.addTarget(self, action: #selector(btnRemoveTrade(_:)), for: UIControlEvents.touchUpInside)
            cell.lblName.text = selectedSubTrade[indexPath.row].Name
            
            return cell
        }
        else if(tableView == tabSectors)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.lblName.text = DataList.Result.SectorList[indexPath.row].SectorName
            if(selecteSectore.contains(DataList.Result.SectorList[indexPath.row].SectorID))
            {
                cell.btnSelction.isSelected = true
            }
            else
            {
                cell.btnSelction.isSelected = false
            }
            cell.btnSelction.tag = indexPath.row
            cell.btnSelction.addTarget(self, action: #selector(btnSectoreSelctionAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.btnSelction.tag = indexPath.row
            cell.btnSelction.addTarget(self, action: #selector(SignupVC2.btnTradeSelctionAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(tableView == tabJobRole)
        {
            self.DisplayJobRoleList = DataList.Result.DepartmentList[indexPath.row].JobRoleList
             self.btnSelctedDepartment.setTitle(self.DataList.Result.DepartmentList[indexPath.row].DepartmentName, for: UIControlState.normal)
            if(self.DisplayJobRoleList.count > 5)
            {
                self.tabSubJobRoleHeightConstraint.constant = (self.view.frame.size.height/22.4)*5+26
            }
            else
            {
                self.tabSubJobRoleHeightConstraint.constant = (self.view.frame.size.height/22.4)*CGFloat(self.DisplayJobRoleList.count)+26
            }
            
            self.tabSubJobRole.reloadData()
            isVisibleDepartment = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.tabJobRoleHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { (true) in
                self.tabJobRole.reloadData()
            }
        }
        else if(tableView == tabSelectedJobRole)
        {
            
        }
        else if(tableView == tabYourTrade)
        {
        
        }
        else if(tableView == tabselectedTrade)
        {
            
        }
        else if(tableView == tabSectors)
        {
            
        }
    }
    func btnSubJobRoleSelctionAction(_ sender: UIButton)
    {
        if(!sender.isSelected)
        {
            if(selectedJobRole.count == 10)
            {
                self.view.makeToast("job-role selection should be less than or equl to 10.", duration: 3, position: .center)
                return
            }
        }
        
        sender.isSelected = !sender.isSelected
        if(sender.isSelected)
        {
            selectedJobRole.append(self.DisplayJobRoleList[sender.tag])
        }
        else
        {
            var temp:[JobRoleListM] = []
            temp =  selectedJobRole.filter( { (user: JobRoleListM) -> Bool in
                return user.JobRoleID == DisplayJobRoleList[sender.tag].JobRoleID
            })
            if(temp.count != 0)
            {
             selectedJobRole.remove(at: selectedJobRole.index(of:temp[0])!)
            }
        }
        tabSubJobRole.reloadData()
        
        if(self.selectedJobRole.count > 5)
        {
            
            self.tabSelectedJobRoleHeightConstraint.constant = (self.view.frame.size.height/22.4)*5+26
        }
        else
        {
            if(self.selectedJobRole.count == 0)
            {
                self.tabSelectedJobRoleHeightConstraint.constant = 0
            }
            else
            {
                self.tabSelectedJobRoleHeightConstraint.constant = (self.view.frame.size.height/22.4)*CGFloat(self.selectedJobRole.count)+26
            }
          
        }
        tabSelectedJobRole.reloadData()
    }
    func btnTradeSelctionAction(_ sender: UIButton)
    {
        if(!sender.isSelected)
        {
            if(selectedSubTrade.count == 10)
            {
                self.view.makeToast("Sub trade selection should be less than or equl to 10.", duration: 3, position: .center)
                return
            }
        }
        sender.isSelected = !sender.isSelected
        if(sender.isSelected)
        {
            selectedSubTrade.append(DataList.Result.SerachTradeList[sender.tag])
        }
        else
        {
            var temp:[SubTradeListM] = []
            temp =  selectedSubTrade.filter( { (user: SubTradeListM) -> Bool in
                return user.Id == DataList.Result.SerachTradeList[sender.tag].Id && user.IsTrade == DataList.Result.SerachTradeList[sender.tag].IsTrade
            })
            if(temp.count != 0)
            {
                selectedSubTrade.remove(at: selectedSubTrade.index(of:temp[0])!)
            }
        }
        if(self.selectedSubTrade.count > 5)
        {
            self.tabSelectedHeightConstraint.constant = (self.view.frame.size.height/22.4)*5+26
        }
        else
        {
            if(self.selectedSubTrade.count == 0)
            {
                self.tabSelectedHeightConstraint.constant = 0
            }
            else
            {
                self.tabSelectedHeightConstraint.constant = (self.view.frame.size.height/22.4)*CGFloat(self.selectedSubTrade.count)+26
            }
        }
        
        tabYourTrade.reloadData()
        tabselectedTrade.reloadData()
    }
    func btnSectoreSelctionAction(_ sender: UIButton)
    {
        if(!selecteSectore.contains(DataList.Result.SectorList[sender.tag].SectorID))
        {
            selecteSectore.append(DataList.Result.SectorList[sender.tag].SectorID)
        }
        else
        {
            selecteSectore.remove(at: selecteSectore.index(of:DataList.Result.SectorList[sender.tag].SectorID)!)
        }
        tabSectors.reloadData()
    }
    func btnRemoveJobRole(_ sender:UIButton)
    {
        selectedJobRole.remove(at: sender.tag)
        if(self.selectedJobRole.count > 5)
        {
            
            self.tabSelectedJobRoleHeightConstraint.constant = (self.view.frame.size.height/22.4)*5+26
        }
        else
        {
            if(self.selectedJobRole.count == 0)
            {
                self.tabSelectedJobRoleHeightConstraint.constant = 0
            }
            else
            {
                self.tabSelectedJobRoleHeightConstraint.constant = (self.view.frame.size.height/22.4)*CGFloat(self.selectedJobRole.count)+26
            }
            
        }
        tabSubJobRole.reloadData()
        tabSelectedJobRole.reloadData()
    }

    
    func btnRemoveTrade(_ sender:UIButton)
    {
        selectedSubTrade.remove(at: sender.tag)
        if(self.selectedSubTrade.count > 5)
        {
            self.tabSelectedHeightConstraint.constant = (self.view.frame.size.height/22.4)*5+26
        }
        else
        {
            if(self.selectedSubTrade.count == 0)
            {
                self.tabSelectedHeightConstraint.constant = 0
            }
            else
            {
                self.tabSelectedHeightConstraint.constant = (self.view.frame.size.height/22.4)*CGFloat(self.selectedSubTrade.count)+26
            }
        }
        tabYourTrade.reloadData()
        tabselectedTrade.reloadData()
    }
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: UIButton)
    {
        if(selectedJobRole.count == 0)
        {
            self.view.makeToast("Please select at least one Job Roles", duration: 3, position: .bottom)
        }
        else if(selectedSubTrade.count == 0)
        {
           self.view.makeToast("Please select at least one trade", duration: 3, position: .bottom)
        }
        else if(selecteSectore.count == 0)
        {
            self.view.makeToast("Please select sector", duration: 3, position: .bottom)
        }
        else if(txtAddress.text == "")
        {
            self.view.makeToast("Please select address", duration: 3, position: .bottom)
        }
        else
        {
           sendDataToServer()
        }
    }
    func GetAllDataFromServer()
    {
        self.startAnimating()
        AFWrapper.requestGETURL(Constants.URLS.GetDefaultList, success: { (JSONResponse) in
            self.stopAnimating()
            if JSONResponse["Status"].int == 1
            {
                self.DataList = Mapper<GetDefaultList>().map(JSONObject: JSONResponse.rawValue)!
                self.DisplayJobRoleList = self.DataList.Result.DepartmentList[0].JobRoleList
                self.btnSelctedDepartment.setTitle(self.DataList.Result.DepartmentList[0].DepartmentName, for: UIControlState.normal)
                self.DisplayTradeList = self.DataList.Result.TradeDefaultList
                for temp in self.DataList.Result.JobRoleList
                {
                    if(self.AllData.Result.JobRoleIdList.contains(temp.JobRoleID))
                    {
                        self.selectedJobRole.append(temp)
                    }
                }
                self.txtAddress.text = self.AllData.Result.Address
                self.txtTown.text = self.AllData.Result.CityName
                self.txtPostCode.text = self.AllData.Result.Postcode
                self.coordinate.latitude = self.AllData.Result.Latitude
                self.coordinate.longitude = self.AllData.Result.Longitude
                self.txtAddress.text = self.AllData.Result.Address
                
                if(Float(self.AllData.Result.DistanceRadius) < 10)
                {
                    self.locationSlider.value = 10
                    self.lblDistance.text = "10 miles"
                }
                else
                {
                    self.locationSlider.value = Float(self.AllData.Result.DistanceRadius)
                    self.lblDistance.text = "\(Int(self.locationSlider.value)) miles"
                }
//               
//                if(self.DataList.Result.DepartmentList.count > 5)
//                {
//                    self.tabJobRoleHeightConstraint.constant = (self.view.frame.size.height/18.62)*5
//                }
//                else
//                {
//                    self.tabJobRoleHeightConstraint.constant = (self.view.frame.size.height/18.62)*CGFloat(self.DataList.Result.DepartmentList.count)
//                }
                
                if(self.DisplayJobRoleList.count > 5)
                {
                    self.tabSubJobRoleHeightConstraint.constant = (self.view.frame.size.height/22.4)*5+26
                }
                else
                {
                    self.tabSubJobRoleHeightConstraint.constant = (self.view.frame.size.height/22.4)*CGFloat(self.DisplayJobRoleList.count)+26
                }

                if(self.selectedJobRole.count > 5)
                {
                    self.tabSelectedJobRoleHeightConstraint.constant = (self.view.frame.size.height/22.4)*5+26
                }
                else
                {
                    self.tabSelectedJobRoleHeightConstraint.constant = (self.view.frame.size.height/22.4)*CGFloat(self.selectedJobRole.count)+26
                }
                
                
                if(self.DisplayTradeList.count > 8)
                {
                   self.tabYourTradeHeightConstraint.constant = (self.view.frame.size.height/22.4)*8+20
                }
                else
                {
                  self.tabYourTradeHeightConstraint.constant = (self.view.frame.size.height/22.4)*CGFloat(self.DisplayTradeList.count)+20
                }
                
                if(self.selectedSubTrade.count > 5)
                {
                  self.tabSelectedHeightConstraint.constant = (self.view.frame.size.height/22.4)*5+26
                }
                else
                {
                    self.tabSelectedHeightConstraint.constant = (self.view.frame.size.height/22.4)*CGFloat(self.selectedSubTrade.count)+26
                }
                
                if(self.DataList.Result.SectorList.count > 5)
                {
                  self.tabSectoreHeightConstraint.constant = (self.view.frame.size.height/12.62)*5
                }
                else
                {
                    self.tabSectoreHeightConstraint.constant = (self.view.frame.size.height/12.62)*CGFloat(self.DataList.Result.SectorList.count)
                }
                self.tabJobRole.reloadData()
                self.tabSubJobRole.reloadData()
                self.tabSelectedJobRole.reloadData()
                self.tabSectors.reloadData()
                self.tabYourTrade.reloadData()
                self.tabselectedTrade.reloadData()
            }
            else
            {
                self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
            }
        }) { (error) in
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    
    func GetUserAllDataFromServer()
    {
        self.startAnimating()
        AFWrapper.requestGetUrlWithParam(Constants.URLS.ProfileStep2, params : nil,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            if JSONResponse != nil {
                if JSONResponse["Status"].int == 1
                {
                    self.AllData = Mapper<GetSignUp2>().map(JSONObject: JSONResponse.rawValue)!
                    self.selectedJobRole = self.AllData.Result.JobRoleList
                    self.selecteSectore = self.AllData.Result.SectorIdList
                    self.setAllserviceNameList()
                    self.selectedSubTrade = self.AllData.Result.TradeSubtradeList
                    self.GetAllDataFromServer()
                }
                else
                {
                    self.GetAllDataFromServer()
                    self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .center)
                }
            }
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func setAllserviceNameList()
    {
        if(AllData.Result.ServiceNameList.count > 0)
        {
            self.txtSkill1.text = AllData.Result.ServiceNameList[0]
        }
        if(AllData.Result.ServiceNameList.count > 1)
        {
            self.txtSkill2.text = AllData.Result.ServiceNameList[1]
        }

        if(AllData.Result.ServiceNameList.count > 2)
        {
            self.txtSkill3.text = AllData.Result.ServiceNameList[2]
        }

        if(AllData.Result.ServiceNameList.count > 3)
        {
            self.txtSkill4.text = AllData.Result.ServiceNameList[3]
        }
        
        if(AllData.Result.ServiceNameList.count > 4)
        {
            self.txtSkill5.text = AllData.Result.ServiceNameList[4]
        }

        if(AllData.Result.ServiceNameList.count > 5)
        {
            self.txtSkill6.text = AllData.Result.ServiceNameList[5]
        }
    }
    func getAllSkill()->[String]
    {
        var TempSkill:[String] = []
        if(txtSkill1.text != "")
        {
            TempSkill.append(txtSkill1.text!)
        }
        if(txtSkill2.text != "")
        {
            TempSkill.append(txtSkill2.text!)
        }
        if(txtSkill3.text != "")
        {
            TempSkill.append(txtSkill3.text!)
        }
        if(txtSkill4.text != "")
        {
            TempSkill.append(txtSkill4.text!)
        }
        if(txtSkill5.text != "")
        {
            TempSkill.append(txtSkill5.text!)
        }
        if(txtSkill6.text != "")
        {
            TempSkill.append(txtSkill6.text!)
        }
        return TempSkill
    }
    func sendDataToServer()
    {
        var SubJobRoleIdList:[Int] = []
        for temp in selectedJobRole
        {
            SubJobRoleIdList.append(temp.JobRoleID)
        }
        var selecteTrade:[Int] = []
        var selecteSubTrade:[Int] = []
        for temp in selectedSubTrade
        {
            if(temp.IsTrade == true)
            {
              selecteTrade.append(temp.Id)
            }
            else
            {
               selecteSubTrade.append(temp.Id)
            }
        }
        
        self.startAnimating()
        var param = [:] as [String : Any]
        param["JobRoleIdList"] = SubJobRoleIdList
        param["SectorIdList"] = selecteSectore
        param["TradeIdList"] =  selecteTrade
        param["SubTradeIdList"] =  selecteSubTrade
        param["DistanceRadius"] = Int(self.locationSlider.value)
        param["Address"] = txtAddress.text!
        param["CityName"] = txtTown.text!
        param["Postcode"] = txtPostCode.text!
        param["Latitude"] = coordinate.latitude
        param["Longitude"] = coordinate.longitude
        param["ServiceNameList"] = getAllSkill()
        
        AFWrapper.requestPOSTURLWithJson(Constants.URLS.ProfileStep2, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            if JSONResponse != nil {
                if JSONResponse["Status"].int == 1
                {
                    if(self.edit)
                    {
                        self.navigationController?.popViewController(animated: true) 
                    }
                    else
                    {
                        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "Experience1") as! Experience1
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                   
                }
                else
                {
                    self.view.makeToast(JSONResponse["Message"].rawString()!, duration: 3, position: .bottom)
                }
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
extension SignupVC2: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")
        print("Place attributions: \(place.attributions)")
        
        self.coordinate = (place.coordinate)
        var postcode = ""
        for tmt in place.addressComponents!
        {
            if tmt.type == "administrative_area_level_2"
            {
                print("City is : \(tmt.name) ")
                self.txtTown.text = tmt.name
            }
            if tmt.type == "postal_code" {
                print("Postal code is : \(tmt.name) ")
                self.txtPostCode.text = tmt.name
                postcode = tmt.name
            }
        }
        self.txtAddress.text = place.formattedAddress
        if(postcode == "")
        {
            viewController.view.makeToast("“Please enter full postcode, for example, PR1 1AA”", duration: 3, position: .bottom)
        }
        else
        {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
