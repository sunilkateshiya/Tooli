//
//  JobCenter.swift
//  Tooli
//
//  Created by impero on 11/01/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit
import Popover
import ENSwiftSideMenu
import ObjectMapper
import Toast_Swift
import NVActivityIndicatorView
import Kingfisher

class JobCenter1: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate, NVActivityIndicatorViewable,UISearchBarDelegate
{
    @IBOutlet var TBLSearchView:UITableView!
    @IBOutlet var viewSearch:UIView!
    var Searchdashlist : [SerachDashBoardM] = []
    @IBOutlet weak var SearchbarView: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SearchbarView.delegate = self
        TBLSearchView.delegate = self
        TBLSearchView.dataSource = self
        
        AppDelegate.sharedInstance().setSearchBarWhiteColor(SearchbarView: SearchbarView)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Job Center Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        var strUpdated:NSString =  searchBar.text! as NSString
        strUpdated = strUpdated.replacingCharacters(in: range, with: text) as NSString
        if(Reachability.isConnectedToNetwork())
        {
            onSerach(str: strUpdated as String)
        }
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        SearchbarView.text = ""
        SearchbarView.resignFirstResponder()
        viewSearch.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(searchBar.text == "")
        {
            SearchbarView.resignFirstResponder()
            viewSearch.isHidden = true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        SearchbarView.resignFirstResponder()
        SearchbarView.text = ""
        viewSearch.isHidden = true
    }
    @IBAction func btnJobSearchAction(_ sender : UIButton)
    {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "JobSearchVC") as! JobSearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnMyjobAction(_ sender : UIButton)
    {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "JobMyVC") as! JobMyVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func onSerach(str:String)
    {
        self.startAnimating()
        let param = ["QueryText":str] as [String : Any]
        
        AFWrapper.requestPOSTURL(Constants.URLS.AccountSearchUser, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            self.stopAnimating()
            print(JSONResponse["Status"].rawValue)
            if JSONResponse["Status"].int == 1
            {
                let temp:SearchContractoreList =  Mapper<SearchContractoreList>().map(JSONObject: JSONResponse.rawValue)!
                self.Searchdashlist = temp.DataList
                if(self.Searchdashlist.count > 0)
                {
                    self.viewSearch.isHidden = false
                    self.TBLSearchView.reloadData()
                }
                else
                {
                    self.viewSearch.isHidden = true
                }
            }
            else
            {
                
            }
            
        }) {
            (error) -> Void in
            
            self.stopAnimating()
            
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .center)
        }
    }
    @IBAction func btnMenu(button: AnyObject)
    {
        toggleSideMenuView()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: Any)
    {
        let app : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        app.moveToDashboard()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  self.Searchdashlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.Searchdashlist[indexPath.row].Name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell

    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(self.Searchdashlist[indexPath.row].Role == 0)
        {
            print("Admin")
        }
        else if(self.Searchdashlist[indexPath.row].Role == 1)
        {
            print("Contractor")
            
            if(self.Searchdashlist[indexPath.row].IsMe)
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContractorProfileView") as! ContractorProfileView
                vc.userId = self.Searchdashlist[indexPath.row].UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
                vc.userId = self.Searchdashlist[indexPath.row].UserID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(self.Searchdashlist[indexPath.row].Role == 2)
        {
            print("Company")
            let companyVC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            companyVC.userId = self.Searchdashlist[indexPath.row].UserID
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else if(self.Searchdashlist[indexPath.row].Role == 3)
        {
            print("Supplier")
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "SupplierView") as! SupplierView
            companyVC.userId = self.Searchdashlist[indexPath.row].UserID
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        SearchbarView.text = ""
        SearchbarView.resignFirstResponder()
        viewSearch.isHidden = true
    }
    @IBAction func BtnBackMainScreen(_ sender: UIButton)
    {
        AppDelegate.sharedInstance().moveToDashboard()
    }
}
