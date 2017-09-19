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
<<<<<<< HEAD
    struct URLS
    {
=======
    
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
        static let FollowCompanyToggle = BASE_URL + "FollowCompanyToggle"
        static let GetUserSearchByQuery = BASE_URL + "GetUserSearchByQuery"
        static let ContractorTradeUpdate = BASE_URL + "ContractorTradeUpdate"
        static let FollowUserToggle = BASE_URL + "FollowUserToggle"
        static let FollowContractorToggle = BASE_URL + "FollowContractorToggle"
        static let ForgotPassword = BASE_URL + "ForgotPassword"
        static let ChangePassword = BASE_URL + "ChangePassword"
        static let InviteReferral = BASE_URL + "InviteReferral"
        static let GetSavePageList = BASE_URL + "GetSavePageList"
        static let JobInfo = BASE_URL + "JobInfo"
        static let JobList = BASE_URL + "JobList"
        static let ContractorList = BASE_URL + "ContractorList"
        static let NotificationList = BASE_URL + "NotificationList"
        static let PageSaveToggle = BASE_URL + "PageSaveToggle"
        static let ContractorStatisticsReport = BASE_URL + "ContractorStatisticsReport"
        static let ConctractorUpdateStatus = BASE_URL + "ConctractorUpdateStatus"
        static let OfferInfo = BASE_URL + "OfferInfo"
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
>>>>>>> a6f4aee38bdcccc9873263992593cdc98263fd73
        
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
