//
//  ContractorSearch.swift
//  Tooli
//
//  Created by Impero IT on 15/02/2017.
//  Copyright © 2017 impero. All rights reserved.
//
//b76 2sx - southport

//brimgram

//southport
import UIKit
import Kingfisher
import ActionSheetPicker_3_0
import ObjectMapper
import NVActivityIndicatorView
import GooglePlaces
import Toast_Swift
import Alamofire

class ContractorSearch: UIViewController, UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate, NVActivityIndicatorViewable
{
    @IBOutlet weak var btnAgain: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewError: UIView!
    @IBAction func btnAgainErrorAction(_ sender: UIButton)
    {
        self.imgError.isHidden = true
        self.btnAgain.isHidden = true
        self.lblError.isHidden = true
        GetAllDataFromServer()
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let sharedManager : Globals = Globals.sharedInstance
    var isTradeSelected : Bool = false;
    var integerCount = NSInteger()
    var integerCountCertificate = NSInteger()
    var postcode : String = ""
    
    var JobRoleIdList:[Int] = []
    var TradeIdList:[Int] = []
    var CertificateIdList : [Int] = []
    var SectorIdList : [Int] = []
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var DataList:GetDefaultList = GetDefaultList()
    
    @IBOutlet weak var TblJobRole: UITableView!
    
    @IBOutlet weak var TblTrade: UITableView!
    @IBOutlet var txtPostCode:UITextField!
    @IBOutlet weak var TblSectoreSkill: UITableView!
    @IBOutlet weak var TblCertificate: UITableView!
    
    @IBOutlet weak var JobRoleHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var TradeHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var CertificateHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var SectoreHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var BtnSkill: UIButton!
    @IBOutlet weak var BtnCertificate: UIButton!
    @IBOutlet weak var BtnTrade: UIButton!
    @IBOutlet weak var BtnJobRole: UIButton!
    var isVisible0 : Bool = false
    var isVisible : Bool = false
    var isVisible1 : Bool = false
    var isVisible2 : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        bottomConstraint.constant = 20

        JobRoleHeightConstraints.constant = 0
        CertificateHeightConstraints.constant = 0
        TradeHeightConstraints.constant = 0
        SectoreHeightConstraints.constant = 0
        JobRoleIdList = []
        TradeIdList = []
        SectorIdList = []
        CertificateIdList = []
        
        
        self.BtnJobRole.setTitle("Select job-role", for: .normal);
        self.BtnJobRole.setTitleColor(Color.black, for: .normal)
        
        self.BtnSkill.setTitle("Select sector", for: .normal);
        self.BtnSkill.setTitleColor(Color.black, for: .normal)
        
        self.BtnCertificate.setTitle("Select certificate ", for: .normal);
        self.BtnCertificate.setTitleColor(Color.black, for: .normal)
        
        self.BtnTrade.setTitle("Select trade ", for: .normal);
        self.BtnTrade.setTitleColor(Color.black, for: .normal)

        GetAllDataFromServer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.moveToDashboard()
    }
    @IBAction func btnAddressSelection(_ sender: UIButton)
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
    @IBAction func btnApplyFilterAction(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContractorResult") as! ContractorResult
        vc.TradeIdList = TradeIdList
        vc.CertificateIdList = CertificateIdList
        vc.SectorIdList = self.SectorIdList
        vc.coordinate = self.coordinate
        vc.postcode = txtPostCode.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Contractor Search Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    @IBAction func BtnJobRoleTapped(_ sender: UIButton)
    {
        if isVisible0 == true
        {
            self.JobRoleHeightConstraints.constant = 0
            isVisible0 = false
        }
        else
        {
            self.TradeHeightConstraints.constant = 0
            isVisible = false
            self.SectoreHeightConstraints.constant = 0
            isVisible1 = false
            self.CertificateHeightConstraints.constant = 0
            isVisible2 = false
            
            isVisible0 = true
            if(DataList.Result.JobRoleList.count > 5)
            {
                self.JobRoleHeightConstraints.constant = (self.view.frame.size.height/17.62)*5
            }
            else
            {
                self.JobRoleHeightConstraints.constant = (self.view.frame.size.height/17.62)*CGFloat(DataList.Result.JobRoleList.count)
            }
        }
        TblJobRole.reloadData()
    }
    
    @IBAction func BtnTradeTapped(_ sender: UIButton)
    {
        if isVisible == true
        {
            self.TradeHeightConstraints.constant = 0
            isVisible = false
        }
        else
        {
            self.JobRoleHeightConstraints.constant = 0
            isVisible0 = false
            self.SectoreHeightConstraints.constant = 0
            isVisible1 = false
            self.CertificateHeightConstraints.constant = 0
            isVisible2 = false
            
            isVisible = true
            if(DataList.Result.TradeList.count > 5)
            {
                self.TradeHeightConstraints.constant = (self.view.frame.size.height/17.62)*5
            }
            else
            {
                self.TradeHeightConstraints.constant = (self.view.frame.size.height/17.62)*CGFloat(DataList.Result.TradeList.count)
            }
        }
         TblTrade.reloadData()
    }
    @IBAction func BtnSkillTapped(_ sender: UIButton)
    {
        if isVisible1 == true
        {
            self.SectoreHeightConstraints.constant = 0
            isVisible1 = false
        }
        else
        {
            self.JobRoleHeightConstraints.constant = 0
            isVisible0 = false
            self.CertificateHeightConstraints.constant = 0
            isVisible2 = false
            self.TradeHeightConstraints.constant = 0
            isVisible = false
            
            isVisible1 = true
            if(DataList.Result.SectorList.count > 5)
            {
                self.SectoreHeightConstraints.constant = (self.view.frame.size.height/17.62)*5
            }
            else
            {
                self.SectoreHeightConstraints.constant = (self.view.frame.size.height/17.62)*CGFloat(DataList.Result.SectorList.count)
            }
        }
         TblSectoreSkill.reloadData()
    }
    @IBAction func BtnCertificateTapped(_ sender: UIButton)
    {
        if isVisible2 == true
        {
            self.CertificateHeightConstraints.constant = 0
            isVisible2 = false
        }
        else
        {
            self.JobRoleHeightConstraints.constant = 0
            isVisible0 = false
            self.TradeHeightConstraints.constant = 0
            isVisible = false
            self.SectoreHeightConstraints.constant = 0
            isVisible1 = false

            
            isVisible2 = true
            if(DataList.Result.CertificateList.count > 5)
            {
                self.CertificateHeightConstraints.constant = (self.view.frame.size.height/17.62)*5
            }
            else
            {
                self.CertificateHeightConstraints.constant = (self.view.frame.size.height/17.62)*CGFloat(DataList.Result.CertificateList.count)
            }
        }
        TblCertificate.reloadData()
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(TblTrade == tableView)
        {
           return DataList.Result.TradeList.count
        }
        else if(TblJobRole == tableView)
        {
            return DataList.Result.JobRoleList.count
        }
        else if(TblSectoreSkill == tableView)
        {
            return DataList.Result.SectorList.count
        }
        else
        {
            return DataList.Result.CertificateList.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.view.frame.size.height/17.62
    }
    func GetAllDataFromServer()
    {
        self.startAnimating()
        AFWrapper.requestGETURL(Constants.URLS.GetDefaultList, success: { (JSONResponse) in
            self.stopAnimating()
            if JSONResponse["Status"].int == 1
            {
                self.DataList = Mapper<GetDefaultList>().map(JSONObject: JSONResponse.rawValue)!
                self.TblSectoreSkill.reloadData()
                self.TblTrade.reloadData()
                self.TblCertificate.reloadData()
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if(tableView  == TblTrade)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.lblName.text = DataList.Result.TradeList[indexPath.row].TradeName
            if(TradeIdList.contains(DataList.Result.TradeList[indexPath.row].TradeID))
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
        else if(tableView  == TblJobRole)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.lblName.text = DataList.Result.JobRoleList[indexPath.row].JobRoleName
            if(JobRoleIdList.contains(DataList.Result.JobRoleList[indexPath.row].JobRoleID))
            {
                cell.btnSelction.isSelected = true
            }
            else
            {
                cell.btnSelction.isSelected = false
            }
            cell.btnSelction.tag = indexPath.row
            cell.btnSelction.addTarget(self, action: #selector(btnJobRoleSelctionAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        else if(tableView  == TblSectoreSkill)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelctionCell
            cell.lblName.text = DataList.Result.SectorList[indexPath.row].SectorName
            if(SectorIdList.contains(DataList.Result.SectorList[indexPath.row].SectorID))
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
            cell.lblName.text = DataList.Result.CertificateList[indexPath.row].CertificateName
            if(CertificateIdList.contains(DataList.Result.CertificateList[indexPath.row].CertificateID))
            {
                cell.btnSelction.isSelected = true
            }
            else
            {
                cell.btnSelction.isSelected = false
            }
            cell.btnSelction.tag = indexPath.row
            cell.btnSelction.addTarget(self, action: #selector(btnCertificateSelctionAction(_:)), for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    func btnTradeSelctionAction(_ sender: UIButton)
    {
        if(!TradeIdList.contains(DataList.Result.TradeList[sender.tag].TradeID))
        {
            TradeIdList.append(DataList.Result.TradeList[sender.tag].TradeID)
        }
        else
        {
            TradeIdList.remove(at: TradeIdList.index(of:DataList.Result.TradeList[sender.tag].TradeID)!)
        }
        TblTrade.reloadData()
    }
    func btnCertificateSelctionAction(_ sender: UIButton)
    {
        if(!CertificateIdList.contains(DataList.Result.CertificateList[sender.tag].CertificateID))
        {
            CertificateIdList.append(DataList.Result.CertificateList[sender.tag].CertificateID)
        }
        else
        {
            CertificateIdList.remove(at: CertificateIdList.index(of:DataList.Result.CertificateList[sender.tag].CertificateID)!)
        }
        TblCertificate.reloadData()
    }
    func btnSectoreSelctionAction(_ sender: UIButton)
    {
        if(!SectorIdList.contains(DataList.Result.SectorList[sender.tag].SectorID))
        {
            SectorIdList.append(DataList.Result.SectorList[sender.tag].SectorID)
        }
        else
        {
            SectorIdList.remove(at: SectorIdList.index(of:DataList.Result.SectorList[sender.tag].SectorID)!)
        }
        TblSectoreSkill.reloadData()
    }
    func btnJobRoleSelctionAction(_ sender: UIButton)
    {
        if(!JobRoleIdList.contains(DataList.Result.JobRoleList[sender.tag].JobRoleID))
        {
            JobRoleIdList.append(DataList.Result.JobRoleList[sender.tag].JobRoleID)
        }
        else
        {
            JobRoleIdList.remove(at: JobRoleIdList.index(of:DataList.Result.JobRoleList[sender.tag].JobRoleID)!)
        }
        TblJobRole.reloadData()
    }

}
extension ContractorSearch: GMSAutocompleteViewControllerDelegate
{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")

        self.txtPostCode.text = place.formattedAddress!
        self.coordinate = place.coordinate
        dismiss(animated: true, completion: nil)
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
