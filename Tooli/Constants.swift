//
//  Constants.swift
//  BlueCoupon
//
//  Created by Impero IT on 03/06/16.
//  Copyright © 2016 Impero IT. All rights reserved.
//
/*
 public enum PageTypes
 {
 Contractor = 1,
 Company = 2,
 Supplier = 3,
 Offer = 4,
 Portfolio = 5,
 Job = 6,
 Post = 7,
 }
 
 public enum Role
 {
 Admin = 0, // for admin
 Contractor = 1, // for contractor user
 Company = 2, // for Company user
 Supplier = 3, // for Supplier user
 }
 
 */
import UIKit

struct Constants {
    
    static let buildName = "Tooli"
    
    struct Keys
    {
       // static let GOOGLE_PLACE_KEY = "AIzaSyCSjUAmNJo5QyPBNNyfgcfr5d2BpOOcz54" //provided by client
        static let GOOGLE_PLACE_KEY = "AIzaSyBVzYxUg3nl_Ie2bzhLWuGkgK5940FNEE0"
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
    struct URLS
    {
        
        static let ChatUrl_Base_Url = "http://tooli.blush.cloud/Chat/"//for live test chat
        static let BASE_URL = "http://tooli.blush.cloud/API/"//live test server
        static let Base_Url = "http://tooli.blush.cloud/API/"//live test server
 
      /*
        static let ChatUrl_Base_Url = "http://192.168.0.110/TOOLiChat_Dev/signalr/hubs"//for test chat
        static let BASE_URL = "http://192.168.0.110/TOOLiapi_Dev/"//local test server
        static let Base_Url = "http://192.168.0.110/TOOLiChat_Dev/signalr/hubs"//local test server
 */
        
        static let Signup = BASE_URL + "API/Account/Signup"
        static let Signin = BASE_URL + "API/Account/Signin"
        static let FacebookConnect = BASE_URL + "API/Account/FacebookConnect"
        static let ChangePassword = BASE_URL + "API/Account/ChangePassword"
        static let ForgotPassword = BASE_URL + "API/Account/ForgotPassword"
        static let Signout = BASE_URL + "API/Account/Signout"
        static let AccountFollowToggle = BASE_URL + "API/Account/FollowToggle"
        static let AccountSearchUser = BASE_URL + "API/Account/SearchUser"
        
        static let ProfileStep1 = BASE_URL + "API/Contractor/ProfileStep1"
        static let ProfileStep2 = BASE_URL + "API/Contractor/ProfileStep2"
        static let ProfileStep3 = BASE_URL + "API/Contractor/ProfileStep3"
        static let ContractorSearch = BASE_URL + "API/Contractor/Search"
        static let ContractorProfileView = BASE_URL + "API/Contractor/ProfileView"
        static let ProfileStepFinish = BASE_URL + "API/Contractor/ProfileStepFinish"
        static let ConctractorUpdateStatus = BASE_URL + "API/Contractor/AvailableStatus/Update"
        
        static let ExperiencePut = BASE_URL + "API/Experience/Put"
        static let ExperienceGet = BASE_URL + "API/Experience/Get"
        
        static let GetCertificate = BASE_URL + "API/Certificate/Get"
        static let CertificateDelete = BASE_URL + "API/Certificate/Delete"
        static let CertificateAdd = BASE_URL + "API/Certificate/Add"
        
        static let PortfolioDetail = BASE_URL + "API/Portfolio/Detail"
        static let PortfolioDeleteImage = BASE_URL + "API/Portfolio/DeleteImage"
        static let PortfolioDelete = BASE_URL + "API/Portfolio/Delete"
        static let PortfolioEdit = BASE_URL + "API/Portfolio/Edit"
        static let PortfolioAdd = BASE_URL + "API/Portfolio/Add"
        
        static let JobList = BASE_URL + "API/Job/List"
        static let JobDetail = BASE_URL + "API/Job/Detail"
        static let JobApply = BASE_URL + "API/Job/Apply"
        static let JobCloseToggle = BASE_URL + "API/Job/CloseToggle"
        static let GetJobApplicant = BASE_URL + "API/Job/GetJobApplicant"
        static let JobEdit = BASE_URL + "API/Job/Edit"
        static let AddorUpdate = BASE_URL + "API/Job/AddorUpdate"
        static let MyJobList = BASE_URL + "API/Job/MyJobList"
        static let JobEditDetail = BASE_URL + "API/Job/EditDetail"
        
        static let Dashboard = BASE_URL + "API/Dashboard"
        static let RemoveSuggestionUser = BASE_URL + "API/RemoveSuggestionUser"
        static let GetSuggestionUsers = BASE_URL + "API/GetSuggestionUsers"
        static let AccountNotification = BASE_URL + "API/Notification/Read"
        
        static let SaveToggle = BASE_URL + "API/PageSave/Toggle"
        static let SaveList = BASE_URL + "API/PageSave/List"
        static let ConnectionList = BASE_URL + "API/ConnectionList"
        static let SendInvitation = BASE_URL + "API/SendInvitation"
        
        static let OfferDetail = BASE_URL + "API/Offer/Detail"
        static let OfferList = BASE_URL + "API/Offer/List"
        
        static let StatisticsReport = BASE_URL + "API/StatisticsReport"
        static let CompanyProfileView = BASE_URL + "API/Company/ProfileView"
        static let SupplierProfileView = BASE_URL + "API/Supplier/ProfileView"
        static let NotificationList = BASE_URL + "API/Notification/List"
        static let PostAdd = BASE_URL + "API/Post/Add"
        static let GetDefaultList = BASE_URL + "API/GetDefaultList"
        static let GetDefaultCertificate = BASE_URL + "API/GetCertificate"
        
    }
    
    struct  KEYS
    {
        static let LOGINKEY = "isLogin"
        static let TOKEN = "Token"
        static let IS_SET_PROFILE = "isProfileSetup"
        static let USERINFO = "userInfo"
        static let ISCLIENT = "isClient"
        static let ISONTABLE = "isOnTable"
        static let BUSINESSNAME = "businessName"
        static let BUSINESSID = "businessId"
        static let TABLEUSERID = "tableUserId"
        static let ISINITSIGNALR = "isCallSignalR"
    }
   
    struct  AppConstants
    {
        static let ktimer = 6
        static let ktime = 7
    }
    
    struct Notifications {
        static let BUDDYLISTREFRESHED = "buddyListRefreshed"
        static let MESSAGERECEIVED = "messageReceived"
        static let CHATHISTORYRETRIVED = "chatHistory"
    }
    struct Money {
        static let Pound = "£"
    }
    
    struct THEME {
        static let BGCOLOR = UIColor.white
        static let BUTTON_BGCOLOR = UIColor.white
        static let BUTTON_DARK_BGCOLOR = UIColor(colorLiteralRed: 63.0/255.0, green: 73.0/255.0, blue: 88.0/255.0, alpha: 1)
        static let BUTTON_HIGHLIGHT_COLOR = TEXT_COLOR
        static let BUTTON_COLOR = UIColor(colorLiteralRed: 76.0/255.0, green: 77.0/255.0, blue: 76.0/255.0, alpha: 1)
        static let TEXT_COLOR = UIColor(colorLiteralRed: 69.0/255.0, green: 67.0/255.0, blue: 68.0/255.0, alpha: 1)
        static let BORDER_COLOR = UIColor(colorLiteralRed: 76.0/255.0, green: 77.0/255.0, blue: 76.0/255.0, alpha: 0.6)
    }
    
    enum ErrorTypes: Error
    {
        case Empty
        case Short
    }
}
