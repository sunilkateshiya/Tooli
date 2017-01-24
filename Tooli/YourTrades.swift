//
//  YourTrades.swift
//  Tooli
//
//  Created by Moin Shirazi on 09/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import GooglePlaces
import Toast_Swift
import NVActivityIndicatorView
import ObjectMapper
import Alamofire
class YourTrades: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {

    @IBOutlet var vwhide : UIView!
    @IBOutlet var vwhideheight : NSLayoutConstraint!
    
    @IBOutlet var tvtrades : UITableView!
    @IBOutlet var tvtradesheight : NSLayoutConstraint!
  
    @IBOutlet var tvskills : UITableView!
    @IBOutlet var tvskillsheight : NSLayoutConstraint!
    
    @IBOutlet var btnskills : UIButton!
    @IBOutlet var btntrades : UIButton!

    var sharedManager : Globals = Globals.sharedInstance
    var isTradeSelected : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // vwhide.isHidden = true
        vwhideheight.constant = 0
        tvtradesheight.constant = 0
        tvskillsheight.constant = 0
        
        tvtrades.delegate = self
        tvtrades.dataSource = self
        tvtrades.rowHeight = UITableViewAutomaticDimension
        tvtrades.estimatedRowHeight = 450
        tvtrades.tableFooterView = UIView()
       
        tvskills.delegate = self
        tvskills.dataSource = self
        tvskills.rowHeight = UITableViewAutomaticDimension
        tvskills.estimatedRowHeight = 450
        tvskills.tableFooterView = UIView()
         getMasters()
        
        
    }
    
    func getMasters(){
        // Z_MasterDataList
        
        
        self.startAnimating()
        let param = [:] as [String : Any]
        
        print(param)
        AFWrapper.requestPOSTURL(Constants.URLS.Z_MasterDataList, params :param as [String : AnyObject]? ,headers : nil  ,  success: {
            (JSONResponse) -> Void in
            
            self.sharedManager.masters = Mapper<Masters>().map(JSONObject: JSONResponse.rawValue)
            
            
            print(JSONResponse["status"].rawValue as! String)
            
            if JSONResponse != nil {
                
                if JSONResponse["status"].rawString()! == "1"
                {
                    self.stopAnimating()
                    
                }
                else
                {
                    self.stopAnimating()
                    self.view.makeToast(JSONResponse["message"].rawString()!, duration: 3, position: .bottom)
                }
                
            }
            
        }) {
            (error) -> Void in
            self.stopAnimating()
            print(error.localizedDescription)
            self.view.makeToast("Server error. Please try again later", duration: 3, position: .bottom)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btntrades(_ sender: Any) {
  
        if btntrades.isSelected {
            tvtradesheight.constant = 0
            btntrades.isSelected = false
        }
        else{
            btntrades.isSelected = true
            tvtradesheight.constant = 44 * 10

            tvtrades.reloadData()
        }
    }
   
    @IBAction func btnskills(_ sender: Any) {
        
        if btnskills.isSelected {
            tvskillsheight.constant = 0
            btnskills.isSelected = false
        }
        else{
            btnskills.isSelected = true
            tvskillsheight.constant = 44 * 10
            
            tvskills.reloadData()
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //     print("COunt:",(sharedManager1.Timeline1.DataListTimeLine?.count)!)
        //  return (sharedManager1.Timeline1.DataListTimeLine?.count)!
        guard ((sharedManager.masters) != nil) else {
            return 0
        }
        if tableView == self.tvtrades {
            return  (sharedManager.masters.DataList?.count)!
        }
        else {
            return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == self.tvtrades {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = "Trades " +  "\(indexPath.row)"
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
            cell.textLabel?.text = "Skills " +  "\(indexPath.row)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == self.tvtrades {
            self.isTradeSelected = true
            
        }
        else {
            
        }
    }
    
    // MARK: - AutoComplete Code
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.tintColor = UIColor.red
        let header : UIView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: 60))
        header.backgroundColor=UIColor.red
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        autocompleteController.view.addSubview(header)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        autocompleteController.navigationController?.setToolbarHidden(false, animated: true)
        present(autocompleteController, animated: true, completion: nil)
    }

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension YourTrades: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
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
