//
//  Constants.swift
//  BlueCoupon
//
//  Created by Impero IT on 03/06/16.
//  Copyright © 2016 Impero IT. All rights reserved.
//

import UIKit

struct Constants {
    
    static let buildName = "Tooli"
    
    struct Keys
    {
        static let GOOGLE_PLACE_KEY = "AIzaSyCNKruzLdUXb55lvgRElDn8Qhe4yAdbf10"
    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    }
    
    struct URLS {
    
        
        static let BASE_URL = "http://tooli.blush.cloud/webservice.asmx/"
        
        static let CompanyProfileView = BASE_URL + "CompanyProfileView"
        
        static let ConnectionList = BASE_URL + "ConnectionList"
        static let ContractorCertificateUpdate = BASE_URL + "ContractorCertificateUpdate"
        static let ContractorCertificateDelete = BASE_URL + "ContractorCertificateDelete"
        static let ContractorChangeStatus = BASE_URL + "ContractorChangeStatus"
        static let ContractorDashboard = BASE_URL + "ContractorDashboard"
        static let ContractorExperienceAdd = BASE_URL + "ContractorExperienceAdd"
        static let ContractorFacebookSignIn = BASE_URL + "ContractorFacebookSignIn"
        static let ContractorInfo = BASE_URL +  "ContractorInfo"
        static let ContractorInfoUpdate = BASE_URL + "ContractorInfoUpdate"
        static let ContractorProfileUpdate = BASE_URL + "ContractorProfileUpdate"
        static let ContractorProfileView = BASE_URL + "ContractorProfileView"
        static let ContractorRateTravelUpdate = BASE_URL + "ContractorRateTravelUpdate"
        static let ContractorSignIn = BASE_URL + "ContractorSignIn"
        static let ContractorSignUp = BASE_URL + "ContractorSignUp"
        
        static let ContractorTradeUpdate = BASE_URL + "ContractorTradeUpdate"
        static let FollowUserToggle = BASE_URL + "FollowUserToggle"
        static let FollowContractorToggle = BASE_URL + "FollowContractorToggle"
        static let ForgotPassword = BASE_URL + "ForgotPassword"
        
        static let JobInfo = BASE_URL + "JobInfo"
        static let JobList = BASE_URL + "JobList"
        
        static let NotificationList = BASE_URL + "NotificationList"
        static let PageSaveToggle = BASE_URL + "PageSaveToggle"
        
        static let PortfolioAdd = BASE_URL + "PortfolioAdd"
        static let PortfolioDelete = BASE_URL + "PortfolioDelete"
        static let PortfolioEdit = BASE_URL + "PortfolioEdit"
        static let PortfolioInfo = BASE_URL + "PortfolioInfo"
        static let PortfolioList = BASE_URL + "PortfolioList"
        static let PortfolioImageDelete = BASE_URL + "PortfolioImageDelete"
        
        static let Z_MasterDataList = BASE_URL + "Z_MasterDataList"
        
    }
    
    struct Errors {
        static let ERROR_FACEBOOK = "There was some error with Facebook Login"
        static let ERROR_EMAIL_ID = "Please enter valid EmailId"
        static let ERROR_FIRST_NAME = "Please enter valid First Name"
        static let ERROR_LAST_NAME = "Please enter valid Last Name"
        static let ERROR_DATE_OF_BIRTH = "Please select Date of Birth"
        static let ERROR_COUNTRY = "Please select Country"
        static let ERROR_STATE = "Please select State"
        static let ERROR_CITY = "Please select City"
        static let ERROR_GENDER = "Please select Gender"
        static let ERROR_PASSWORD = "Please enter valid Password"
        static let ERROR_OLD_PASSWORD = "Please enter valid old Password"
        static let ERROR_NEW_PASSWORD = "Please enter valid Password"
        static let ERROR_PASSWORD_MIN = "Password should be of minimum 8 characters"
        static let ERROR_PASSWORD_ALPHA_NUM = "Password should be Alpha numeric"
        static let ERROR_PASSWORD_CONFIRM = "Please enter valid Confirm Password"
        static let ERROR_PASSWORD_MISMATCH = "Password and Confirm Password are not same"
        static let ERROR_LOGIN = "There was some problem while login, try again later."
        static let ERROR_REGISTER = "There was some problem while registration, try again later."
        static let ERROR_INTERNTE = "No Internet available"
        static let ERROR_COMING_SOON = "Under Development"
        static let ERROR_PROFILE = "Please complete your profile before you can participate in Lucky Draw"
        static let ERROR_FRIEND = "You are already connected"
        static let ERROR_NOT_FRIEND = "You are not friend with this user. First become friend in order to chat"
        static let ERROR_PROFILE_FRIEND = "Please complete your profile before you can send Friend request"
        static let ERROR_CHAT = "You can not chat with yourself."
        static let ERROR_GROUP_FRIEND = "Please complete your profile before you can join group"
        static let ERROR_CHAT_FRIEND = "Please complete your profile before you can start chatting"
        static let ERROR_FRIEND_SELF = "You can not send friend request to yourself."
        static let ERROR_PUBLIC_PROFILE = "User profile is not public!"
        
        static let ERROR_OPINION = "Please enter valid opinion"
        static let ERROR_STATUS = "Please enter valid status"
        static let ERROR_MIN_STATUS = "Status should be of max 120 characters"
        
        static let ERROR_SUBJECT = "Please enter valid Subject"
        static let ERROR_MESSAGE = "Please enter valid Message"
    }
    
    struct  KEYS {
        static let LOGINKEY = "isLogin"
        static let USERINFO = "userInfo"
        static let ISCLIENT = "isClient"
        static let ISONTABLE = "isOnTable"
        static let BUSINESSNAME = "businessName"
        static let BUSINESSID = "businessId"
        static let TABLEUSERID = "tableUserId"
    }
    struct NoData {
        static let FRIEND_BLOCK_TITLE = "Blocked Users"
        static let FRIEND_BLOCK_DESCRIPTION = "You don't have any blocked users list. All your blocked list will show up here."
        static let FRIEND_BLOCK_IMAGE = "ic_friend"
        
        static let FRIEND_REQUEST_TITLE = "Friend Request"
        static let FRIEND_REQUEST_DESCRIPTION = "You don't have any friend request yet. All your friend request will show up here."
        static let FRIEND_REQUEST_IMAGE = "ic_friend"
        
        static let FRIEND_TITLE = "Friends"
        static let FRIEND_DESCRIPTION = "You don't have any friends yet. All your friend  will show up here."
        static let FRIEND_IMAGE = "ic_friend"
        
        static let PRIZE_TITLE = "Prize"
        static let PRIZE_DESCRIPTION = "We dont have any prizes yet. All prizes will be displayed here"
        static let PRIZE_IMAGE = "ic_noPrize"

        static let CHATS_TITLE = "Chats"
        static let CHATS_DESCRIPTION = "You don't have any active chats yet. All your chats will show up here."
        static let CHATS_IMAGE = "ic_nochat"
        
        static let GROUPS_TITLE = "Groups"
        static let GROUPS_DESCRIPTION = "We don't have any groups yet. All groups will show up here."
        static let GROUPS_IMAGE = "ic_nogroup"
    }
    
    struct  AppConstants {
        static let ktimer = 6
        static let ktime = 7
    }
    
    struct Notifications {
        static let BUDDYLISTREFRESHED = "buddyListRefreshed"
        static let MESSAGERECEIVED = "messageReceived"
        static let CHATHISTORYRETRIVED = "chatHistory"
    }
    
    struct ImagePaths {
        static let USERAVTAR = "myavtar"
    }
    
    struct THEME {
        static let BGCOLOR = UIColor.white
        
        static let BUTTON_BGCOLOR = UIColor.white
        
        static let BUTTON_DARK_BGCOLOR = UIColor(colorLiteralRed: 63.0/255.0, green: 73.0/255.0, blue: 88.0/255.0, alpha: 1)
        
        
        static let BUTTON_HIGHLIGHT_COLOR = TEXT_COLOR
       // static let BUTTON_COLOR = UIColor(colorLiteralRed: 93.0/255.0, green: 110.0/255.0, blue: 129.0/255.0, alpha: 1)
        
        static let BUTTON_COLOR = UIColor(colorLiteralRed: 76.0/255.0, green: 77.0/255.0, blue: 76.0/255.0, alpha: 1)
        
        static let TEXT_COLOR = UIColor(colorLiteralRed: 69.0/255.0, green: 67.0/255.0, blue: 68.0/255.0, alpha: 1)
        
        static let BORDER_COLOR = UIColor(colorLiteralRed: 76.0/255.0, green: 77.0/255.0, blue: 76.0/255.0, alpha: 0.6)
    }
    
    enum ErrorTypes: Error {
        case Empty
        case Short
    }
}
