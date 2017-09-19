//
//  ChatVC.swift
//  bizdeck
//
//  Created by Whollysoftware on 06/07/17.
//  Copyright © 2017 Wholly Software. All rights reserved.
//

import UIKit
import Kingfisher
import JSQMessagesViewController
import NVActivityIndicatorView
import Alamofire
import ObjectMapper

class ChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NVActivityIndicatorViewable
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet var txtMessage:UITextField!
    @IBOutlet var btnSendMessage:UIButton!
    var currentBuddy : BuddyM = BuddyM()
    var page = 1

    override func viewDidLoad()
    {
        super.viewDidLoad()
        chatHistory()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshThePage), name: NSNotification.Name(rawValue: Constants.Notifications.MESSAGERECEIVED), object: nil)
        self.lblTitle.text = currentBuddy.Name
        tabView.delegate = self
        tabView.dataSource = self
        tabView.rowHeight = UITableViewAutomaticDimension
        tabView.estimatedRowHeight = 450
        tabView.tableFooterView = UIView()
        btnSendMessage.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    func refreshThePage()
    {
        tabView.reloadData()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func BtnSendMsgAction(sender: UIButton)
    {
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(currentBuddy.ChatUserID, forKey: "ReceiverID")
        para.setValue(txtMessage.text, forKey: "MessageText")
        do
        {
            try AppDelegate.sharedInstance().simpleHub.invoke("SendMessage", arguments: [para])
        }
        catch
        {
            print(error)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return AppDelegate.sharedInstance().MsgListOfBuddy.Result.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if(AppDelegate.sharedInstance().MsgListOfBuddy.Result[indexPath.row].IsSendByMe)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverTabCell", for: indexPath) as! ReciverTabCell
            cell.lblMsg.text = AppDelegate.sharedInstance().MsgListOfBuddy.Result[indexPath.row].MessageText
            cell.selectionStyle = .none
            if(AppDelegate.sharedInstance().MsgListOfBuddy.Result.count-1 == indexPath.row)
            {
               
            }
            else
            {
                if(AppDelegate.sharedInstance().MsgListOfBuddy.Result[indexPath.row+1].ChatUserID != currentBuddy.ChatUserID)
                {
                   
                }
                else
                {
                   
                }
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTabCell", for: indexPath) as! SenderTabCell
            cell.lblMsg.text = AppDelegate.sharedInstance().MsgListOfBuddy.Result[indexPath.row].MessageText
            cell.selectionStyle = .none
            if(AppDelegate.sharedInstance().MsgListOfBuddy.Result.count-1 == indexPath.row)
            {
               
            }
            else
            {
                if(AppDelegate.sharedInstance().MsgListOfBuddy.Result[indexPath.row+1].ChatUserID == currentBuddy.ChatUserID)
                {
                    
                }
                else
                {
                
                }
            }
            return cell
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var strUpdated:NSString =  textField.text! as NSString
        strUpdated = strUpdated.replacingCharacters(in: range, with: string) as NSString
        
        if(strUpdated == "")
        {
            btnSendMessage.isEnabled = false
        }
        else
        {
            btnSendMessage.isEnabled = true
        }
        return true
    }
    func parasNoramalTimeOnly(formate:String)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = formate
        return dateFormatter1.string(from:Date())
    }
    func chatHistory()
    {
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(currentBuddy.ChatUserID, forKey: "ReceiverID")
        para.setValue(1, forKey: "PageIndex")
        do {
            try AppDelegate.sharedInstance().simpleHub.invoke("GetConversation", arguments: [para])
        }
        catch
        {
            print(error)
        }
    }
}
