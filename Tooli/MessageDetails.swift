//
//  MessageDetails.swift
//  Tooli
//
//  Created by Aadil Keshwani on 17/02/17.
<<<<<<< HEAD
//  Copyright © 2017 impero. All rights reserved.
=======
//  Copyright © 2017 Moin Shirazi. All rights reserved.
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
//

import UIKit
import Kingfisher
import JSQMessagesViewController
<<<<<<< HEAD
import NVActivityIndicatorView
import Alamofire
import ObjectMapper

class MessageDetails: JSQMessagesViewController,NVActivityIndicatorViewable
{
    var messages:[JSQMessage] = []
    var currentBuddy : BuddyM = BuddyM()
    var userDetails = UIView()
    @IBOutlet var headerView : UIView?
    var lblName : UILabel?
    var page = 1
    
    var isFirstTime : Bool = true
    var isFull : Bool = false
    var isCallWebService : Bool = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.startAnimating()
        chatHistory()
        NotificationCenter.default.addObserver(self, selector: #selector(chatMessage), name: NSNotification.Name(rawValue: Constants.Notifications.CHATHISTORYRETRIVED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatMessageRecived), name: NSNotification.Name(rawValue: Constants.Notifications.MESSAGERECEIVED), object: nil)
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true;
=======
class MessageDetails: JSQMessagesViewController {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var messages = NSMutableArray()
    var groupName : String!
    var groupId : String!
    var isGroup = false
    var firstTime = true
    var currentBuddy : Buddies!
    var userDetails = UIView()
    var senderName : String = ""
    var isBack : Bool = false
    var sharedManager : Globals = Globals.sharedInstance
    @IBOutlet var headerView : UIView?
    var lblName : UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true;
        
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        let hView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenSize.SCREEN_WIDTH, height: 60))
        let backButton = UIButton(frame: CGRect(x: 8, y: 20, width: 40, height: 40))
        backButton.setImage(UIImage(named: "ic_Backarrow"), for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(actionBack(sender:)), for: UIControlEvents.touchUpInside)
        self.lblName = UILabel(frame: CGRect(x: 48, y: 23, width: Constants.ScreenSize.SCREEN_WIDTH-80, height: 30))
        lblName?.text = self.currentBuddy.Name
        lblName?.textAlignment = NSTextAlignment.center
        lblName?.font = UIFont(name: "Oxygen-Bold", size: 18)
        lblName?.textColor = UIColor.white
<<<<<<< HEAD
        let navButton : UIButton = UIButton(frame: CGRect(x:80,y:0,width : Constants.ScreenSize.SCREEN_WIDTH - 160,height: 60))
        
        navButton.addTarget(self, action: #selector(navigateTofriend), for: UIControlEvents.touchUpInside)
    
=======
        let navButton : UIButton = UIButton(frame: CGRect(x:40,y:0,width : Constants.ScreenSize.SCREEN_WIDTH - 80,height: 60))
        
        navButton.addTarget(self, action: #selector(navigateTofriend), for: UIControlEvents.touchUpInside)
        
        
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        hView.addSubview(lblName!)
        hView.addSubview(backButton)
        hView.addSubview(navButton)
        hView.backgroundColor = Constants.THEME.BGCOLOR
        hView.backgroundColor = UIColor.init(colorLiteralRed: 235.0/255.0, green: 38.0/255.0, blue: 40.0/255.0, alpha: 1)

        self.view.addSubview(hView)
        self.collectionView!.collectionViewLayout.springinessEnabled = false
        self.view.backgroundColor = Constants.THEME.BGCOLOR
        self.topContentAdditionalInset = 60
        //self.view.bringSubview(toFront: self.headerView!)
        self.collectionView.backgroundColor = Constants.THEME.BGCOLOR
        self.inputToolbar!.contentView!.leftBarButtonItem!.isHidden = true
        self.inputToolbar!.contentView!.backgroundColor = Constants.THEME.BGCOLOR
        self.inputToolbar.contentView.rightBarButtonItem.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "ic_send"), for: UIControlState.normal)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("", for: UIControlState.normal)
        self.inputToolbar.contentView.leftBarButtonItemWidth = CGFloat(0.0)
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 241.0/255.0, green: 242.0/255.0, blue: 243.0/255.0, alpha: 1)
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 0.1, height: 0.1)
<<<<<<< HEAD
        self.senderId = "true"
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 0.1, height: 0.1)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = false
        self.sideMenuController()?.sideMenu?.allowPanGesture = false
        self.sideMenuController()?.sideMenu?.allowRightSwipe = false
        
        //logintoXMPP()
        AppDelegate.sharedInstance().isChatActive = true
        AppDelegate.sharedInstance().cureentChatUserId = currentBuddy.ChatUserID
        
        self.finishReceivingMessage(animated: true)
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Message Details Screen.")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    func chatMessage()
    {
        if(AppDelegate.sharedInstance().MsgListOfBuddy.Result.count == 0)
        {
            isFull = true
        }

        AppDelegate.sharedInstance().MsgListOfBuddy.Result = AppDelegate.sharedInstance().MsgListOfBuddy.Result.sorted { $0.ChatMessageID > $1.ChatMessageID }
        
        for temp in AppDelegate.sharedInstance().MsgListOfBuddy.Result
        {
            let msg:JSQMessage = JSQMessage(senderId: "\(temp.IsSendByMe)", senderDisplayName: temp.Name , date: Date(timeIntervalSince1970: temp.TotalMiliSecond), text: temp.MessageText)
            
            if(!self.isCallWebService)
            {
               self.messages.append(msg)
            }
            else
            {
                self.messages.insert(msg, at: 0)
            }
        }
        AppDelegate.sharedInstance().MsgListOfBuddy.Result = []
        self.stopAnimating()
        self.isCallWebService = false
        self.collectionView.reloadData()
        
        if(self.page == 1)
        {
            self.finishReceivingMessage(animated: true)
            self.scrollToBottom(animated: true)
        }
        
        self.page = page + 1
    }
    func chatMessageRecived()
    {
        for temp in AppDelegate.sharedInstance().MsgListOfBuddy.Result
        {
            let msg:JSQMessage = JSQMessage(senderId: "\(temp.IsSendByMe)", senderDisplayName: temp.Name, date: Date(timeIntervalSince1970: temp.TotalMiliSecond), text: temp.MessageText)
            
            self.messages.append(msg)
        }
        AppDelegate.sharedInstance().MsgListOfBuddy.Result = []
        self.collectionView.reloadData()
        self.finishReceivingMessage(animated: true)
        self.scrollToBottom(animated: true)
    }
    func navigateTofriend (sender : UIButton)
    {
        if(currentBuddy.Role == 1)
        {
            let companyVC  = self.storyboard?.instantiateViewController(withIdentifier: "OtherContractorProfile") as! OtherContractorProfile
            companyVC.userId = "\(currentBuddy.ChatUserID)"
=======
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 0.1, height: 0.1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //logintoXMPP()
        NotificationCenter.default.addObserver(self, selector: #selector(chatHistory), name: NSNotification.Name(rawValue: Constants.Notifications.CHATHISTORYRETRIVED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatMessage), name: NSNotification.Name(rawValue: Constants.Notifications.MESSAGERECEIVED), object: nil)
        self.finishReceivingMessage(animated: true)
        
    }
    
    func chatHistory(){
        
        for msg in (appDelegate?.currentHistory.DataList)!
        {
            var userId = 0
            if msg.IsMe == true {
                userId = (msg.UserID)
            }
            else {
                userId = (msg.UserID)
            }
            
            let newMessage : JSQMessage = JSQMessage(senderId: String(userId), senderDisplayName: msg.Name, date: NSDate(timeIntervalSince1970: (msg.MilliSecond/1000)) as Date!, text: msg.MessageText)
            
            
            self.messages.add(newMessage)
        }
        self.collectionView.reloadData()
        self.finishReceivingMessage(animated: false)
    self.scrollToBottom(animated: true)
        
        
        
    }
    func chatMessage(){
        let msg = appDelegate?.newMessage
        
        var userId = 0
        if msg?.IsMe == true {
            userId = (msg?.UserID)!
        }
        else {
            userId = (msg?.UserID)!
        }
        
        let newMessage : JSQMessage = JSQMessage(senderId: String(userId), senderDisplayName: msg!.Name, date: NSDate() as Date!, text: msg!.MessageText)
        
        appDelegate?.currentHistory.DataList.append(msg!)
        
        self.messages.add(newMessage)
        self.collectionView.reloadData()
        
        self.finishReceivingMessage(animated: true)
        
        self.scrollToBottom(animated: true)
    }

    
    func navigateTofriend (sender : UIButton) {
        if(currentBuddy.IsContractor == false)
        {
            let companyVC : CompnayProfilefeed = self.storyboard?.instantiateViewController(withIdentifier: "CompnayProfilefeed") as! CompnayProfilefeed
            companyVC.companyId = currentBuddy.CompanyID
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
        else
        {
<<<<<<< HEAD
            let companyVC = self.storyboard?.instantiateViewController(withIdentifier: "CompanyView") as! CompanyView
            companyVC.userId = "\(currentBuddy.ChatUserID)"
=======
            let companyVC : ProfileFeed = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeed") as! ProfileFeed
            companyVC.contractorId = currentBuddy.ContractorID
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
    }
    
<<<<<<< HEAD
    func actionBack(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        do
        {
            try AppDelegate.sharedInstance().simpleHub.invoke("GetBuddyList", arguments: [])
        }
        catch
        {
            print(error)
        }
        userDetails.removeFromSuperview()
        AppDelegate.sharedInstance().isChatActive = false
        AppDelegate.sharedInstance().cureentChatUserId = currentBuddy.ChatUserID
    }
    var isComposing = false
    var timer: Timer?
    
    override func textViewDidChange(_ textView: UITextView)
    {
        super.textViewDidChange(textView)
        
        if textView.text.characters.count == 0
        {
            if isComposing
            {
                hideTypingIndicator()
            }
        }
        else
        {
            timer?.invalidate()
            if !isComposing
            {
                self.isComposing = true
            }
            else
            {
=======
    func actionBack(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.appDelegate!.persistentConnection.state == .connected {
            self.appDelegate!.persistentConnection.send(Command.readReceiptCommand(friendId: String(currentBuddy.ChatUserID)))
            
            
        }
        self.scrollToBottom(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        userDetails.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
        if  self.appDelegate!.persistentConnection == nil {
            return
        }
        
        if self.appDelegate!.persistentConnection.state == .connected {
            
            self.appDelegate!.persistentConnection.send(Command.readReceiptCommand(friendId: String(currentBuddy.ChatUserID)))
            self.appDelegate!.persistentConnection.send(Command.buddyListCommand())
            
        }
    }
    
    
    // Mark: JSQMessagesViewController method overrides
    
    var isComposing = false
    var timer: Timer?
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        
        if textView.text.characters.count == 0 {
            if isComposing {
                hideTypingIndicator()
            }
        } else {
            timer?.invalidate()
            if !isComposing {
                self.isComposing = true
                if isGroup {
                    // For chat
                    //                    OneMessage.sendIsComposingMessage((groupId)!, completionHandler: { (stream, message) -> Void in
                    //                        self.timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(ChatVC.hideTypingIndicator), userInfo: nil, repeats: false)
                    //                    })
                }
                else {
                    
                }
            } else {
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
                
            }
        }
    }
    
<<<<<<< HEAD
    func hideTypingIndicator()
    {
        
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        if (text == "")
        {
            return;
        }
        if(!Reachability.isConnectedToNetwork())
        {
            self.view.makeToast("Please Check Network Connection..", duration: 3, position: .center)
            return
        }
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(currentBuddy.ChatUserID, forKey: "ReceiverID")
        para.setValue(text, forKey: "MessageText")
        do
        {
            try AppDelegate.sharedInstance().simpleHub.invoke("SendMessage", arguments: [para])
        }
        catch
        {
            
        }
        
        self.inputToolbar.contentView.textView.text = ""
        self.collectionView.reloadData()
        self.scrollToBottom(animated: true)
    }
    // Mark: JSQMessages CollectionView DataSource
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        let message: JSQMessage = self.messages[indexPath.item]
        return message
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message: JSQMessage = self.messages[indexPath.item]
=======
    func hideTypingIndicator() {
        
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        if (text == "") {
            return;
        }
        if self.appDelegate!.persistentConnection.state == .connected {
            appDelegate?.persistentConnection.send(Command.messageSendCommand(friendId: String(currentBuddy.ChatUserID), msg: text))
        }
        self.inputToolbar.contentView.textView.text = ""
        let newMessage : JSQMessage = JSQMessage(senderId: String(self.senderId), senderDisplayName: "", date: NSDate() as Date!, text: text)
        //  NSDate(timeIntervalSince1970: (msg.MilliSecond/1000))
        
        self.messages.add(newMessage)
        self.collectionView.reloadData()
        self.scrollToBottom(animated: true)
    }
    
    
    
    
    
    // Mark: JSQMessages CollectionView DataSource
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let message: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        
        return message
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let outgoingBubbleImageData = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(colorLiteralRed: 254.0/255.0, green: 210.0/255.0, blue: 209.0/255.0, alpha: 0.7))
        let incomingBubbleImageData = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor(colorLiteralRed: 89.0/255.0, green: 87.0/255.0, blue: 88.0/255.0, alpha: 0.1))
        
<<<<<<< HEAD
        if message.senderId == self.senderId
        {
            return outgoingBubbleImageData
        }
        return incomingBubbleImageData
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        var senderAvatar : JSQMessagesAvatarImage = JSQMessagesAvatarImage(placeholder: UIImage())
        senderAvatar = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "SR", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.60, alpha: 1.0), font: UIFont(name: "Helvetica Neue", size: 14.0), diameter: 30)
        return senderAvatar
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return nil;
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
//        let message: JSQMessage = self.messages[indexPath.item]
//        if message.senderId == self.senderId
//        {
//            return nil
//        }
//        
//        if indexPath.item - 1 > 0
//        {
//            let previousMessage: JSQMessage = self.messages[indexPath.item - 1]
//            if previousMessage.senderId == message.senderId
//            {
//                return nil
//            }
//        }
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return nil
    }
    // Mark: UICollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        let cell: JSQMessagesCollectionViewCell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let msg: JSQMessage = self.messages[indexPath.item]
        if !msg.isMediaMessage
        {
            if msg.senderId == self.senderId
            {
                cell.textView!.textColor = UIColor.black
                cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.red, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            }
            else
            {
                cell.textView!.textColor = UIColor.black
                cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.red, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            }
        }
        return cell

    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        let currentMessage: JSQMessage = self.messages[indexPath.item]
        if currentMessage.senderId == self.senderId
        {
            return 0.0
        }
        
        if indexPath.item - 1 > 0
        {
            let previousMessage: JSQMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId
            {
                return 0.0
            }
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat
    {
         return 0.0
    }
   
    @IBAction func actionBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if !self.isCallWebService
        {
            if(!isFull)
            {
                if(scrollView.contentOffset.y <= -50)
                {
                    chatHistory()
                }
            }
        }
    }
    func chatHistory()
    {
        self.isCallWebService = true
        let para:NSMutableDictionary = NSMutableDictionary()
        para.setValue(currentBuddy.ChatUserID, forKey: "ReceiverID")
        para.setValue(page, forKey: "PageIndex")
        do {
            try AppDelegate.sharedInstance().simpleHub.invoke("GetConversation", arguments: [para])
        }
        catch
        {
            print(error)
        }
    }
=======
        if message.senderId == self.senderId {
            return outgoingBubbleImageData
        }
        
        return incomingBubbleImageData
    }
    

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        if (appDelegate?.currentHistory.DataList.count)! <= indexPath.item {
            return JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "SR", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.60, alpha: 1.0), font: UIFont(name: "Helvetica Neue", size: 14.0), diameter: 30)
        }
        
        var senderAvatar : JSQMessagesAvatarImage = JSQMessagesAvatarImage(placeholder: UIImage())
        let imgMsg : Messages = (appDelegate?.currentHistory.DataList[indexPath.item])!
        // print(message.senderDisplayName + message.text + message.userAvtar)
        guard (imgMsg.UserImageLink != "") else {
            senderAvatar = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "SR", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.60, alpha: 1.0), font: UIFont(name: "Helvetica Neue", size: 14.0), diameter: 30)
            return senderAvatar
        }
        let imgURL = imgMsg.UserImageLink
        
        let strURL  = String(imgURL)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = NSURL(string:  strURL!)
        
        KingfisherManager.shared.retrieveImage(with: url! as! Resource, options: nil, progressBlock: nil) { (image, error, catchType, imageURL) in
            if (error != nil) {
                senderAvatar = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "SR", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.60, alpha: 1.0), font: UIFont(name: "Helvetica Neue", size: 14.0), diameter: 30)
            }
            else {
                senderAvatar = JSQMessagesAvatarImage .avatar(with: JSQMessagesAvatarImageFactory.circularAvatarImage(image, withDiameter: 20))
            }
        }
        
        
        
        return senderAvatar
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message: JSQMessage = self.messages[indexPath.item] as! JSQMessage
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        return nil;
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        
        if message.senderId == self.senderId {
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage: JSQMessage = self.messages[indexPath.item - 1] as! JSQMessage
            if previousMessage.senderId == message.senderId {
                return nil
            }
        }
        
        return nil
    }
    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
//        let message: JSQMessage = self.messages[indexPath.item] as! JSQMessage
//        
//        if message.senderId == self.senderId {
//            return nil
//        }
//        
//        if indexPath.item - 1 > 0 {
//            let previousMessage: JSQMessage = self.messages[indexPath.item - 1] as! JSQMessage
//            if previousMessage.senderId == message.senderId {
//                return nil
//            }
//        }
//        
//        return nil
//    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        return nil
    }
    

    
    
    // Mark: UICollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: JSQMessagesCollectionViewCell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        
        let msg: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        
        if !msg.isMediaMessage {
            if msg.senderId == self.senderId {
                cell.textView!.textColor = UIColor.black
                cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            } else {
                cell.textView!.textColor = UIColor.black
                cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            }
        }
        
        return cell

    }
    
   
    
    // Mark: JSQMessages collection view flow layout delegate
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let currentMessage: JSQMessage = self.messages[indexPath.item] as! JSQMessage
        if currentMessage.senderId == self.senderId {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage: JSQMessage = self.messages[indexPath.item - 1] as! JSQMessage
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
         return 0.0
    }
    
   
    @IBAction func actionBack(){
        if isBack {
            var allViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            isBack = false
            allViewController=allViewController.reversed()
            for aviewcontroller : UIViewController in allViewController
            {
                if aviewcontroller .isKind(of: CompanyProfileM.classForCoder()) || aviewcontroller.isKind(of: ProfileFeed.classForCoder())
                {
                    self.navigationController?.popToViewController(aviewcontroller, animated: true)
                }
            }
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
}
