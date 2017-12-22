//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.


#ifdef DEBUG
#define PUSHNOTIFICATION @"JellyRole_dev"   //Development
#define DebugLog(s, ...) NSLog(s, ##__VA_ARGS__)
#else
#define PUSHNOTIFICATION @"JellyRole"   //Production
#define DebugLog(s, ...)
#endif

#define kAppName @"JellyRole"
#define kPreferenceData @"keyPreferenceData"
#define kDataBaseName @"JellyRole.sqlite"


#define kContactUS @"http://www.vtechnolabs.com/parasgold/contact-us/"
#define kURL @"http://skassociates.me/iws/Personal/iws/ParasTV/getAddIDs.php/version=%@"

#define kHostURL @"http://jellyrollpool.com/"
#define kAPI_LOGIN [kHostURL stringByAppendingString:@"webservice/login.php"]
#define kAPI_LoginParams @"username=%@&password=%@&flag=app&login_flag=%@&device_token=%@"

#define kAPI_SIGNUP [kHostURL stringByAppendingString:@"webservice/signup.php"]
#define kAPI_SignupParams @"username=%@&email=%@&password=%@&flag=app&firstname=%@&lastname=%@&device_token=%@"

#define kAPI_FEEDBACK [kHostURL stringByAppendingString:@"webservice/feedback.php?user_id=%@&feedback=%@"]

#define kAPI_TREMS [kHostURL stringByAppendingString:@"webservice/get_terms_rules.php"]

#define kAPI_FRIENDS [kHostURL stringByAppendingString:@"webservice/get_frinds_count.php?user_id=%@"]

#define kAPI_INVITEFRIEND [kHostURL stringByAppendingString:@"webservice/invite_friend.php?user_id=%@&email=%@"]

#define kAPI_ADDFRIEND [kHostURL stringByAppendingString:@"webservice/add_friend.php?user_id=%@&email=%@"]
#define kAPI_ADDFRIEND2 [kHostURL stringByAppendingString:@"webservice/add_friend.php?action=share_byid&id1=%@&id2=%@"]


#define kAPI_MYPROFILE [kHostURL stringByAppendingString:@"webservice/get_my_profile.php?user_id=%@"]

#define kAPI_STATS [kHostURL stringByAppendingString:@"webservice/get_stats.php?user_id=%@"]

#define kAPI_FORGETPASSWORD [kHostURL stringByAppendingString:@"webservice/forgot_password.php?email=%@"]

#define kAPI_RESENDCODE [kHostURL stringByAppendingString:@"webservice/resend_code.php?email=%@"]

#define kAPI_VERIFIYCODE [kHostURL stringByAppendingString:@"webservice/verification.php?email=%@&guid=%@"]

#define kAPI_ALLBARS [kHostURL stringByAppendingString:@"webservice/get_all_bar.php?user_id=%@"]
#define kAPI_ALLRECENTBARS [kHostURL stringByAppendingString:@"webservice/get_recent_bars_byuser.php?user_id=%@"]


#define kAPI_ADDLOCATION [kHostURL stringByAppendingString:@"webservice/create_bar.php"]
#define kAPI_AddLocationParams @"location_name=%@&address=%@&city=%@&state=%@&zip=%@&lat=%@&long=%@&user_id=%@&bar_status=yes&place_id=%@&county=%@&country=%@"

#define kAPI_ADDHOMELOCATION [kHostURL stringByAppendingString:@"webservice/update_home_location.php"]
#define kAPI_AddHomeLocationParams @"user_id=%@&location_bar_id=%@"


#define kAPI_ALLPENDINGGAMES [kHostURL stringByAppendingString:@"webservice/get_all_bar_pending.php?user_id=%@"]

#define kAPI_CONFIRMGAME [kHostURL stringByAppendingString:@"webservice/confirm.php?game_id=%@&status=%@"]
#define kAPI_UPDATEPENDINGGAME [kHostURL stringByAppendingString:@"webservice/update_game.php?game_id=%@&show_pending=1"]

#define kAPI_NOTIFICATIONS [kHostURL stringByAppendingString:@"webservice/get_bell.php?user_id=%@"]

#define kAPI_RECENTGAMES [kHostURL stringByAppendingString:@"webservice/get_recent_geme.php?user_id=%@"]

#define kAPI_WINLOSSGAME [kHostURL stringByAppendingString:@"webservice/win_or_loss.php"]
#define kAPI_WinLossParams @"by_user_id=%@&other_user_id=%@&bar_id=%@&win_or_loss=%@"

#define kAPI_USERGAMESCORE [kHostURL stringByAppendingString:@"webservice/get_score_geme.php?user_id=%@&other_user_id=%@&bar_id=%@"]

#define kAPI_ALLRECENTGAME [kHostURL stringByAppendingString:@"webservice/get_recent_all_geme.php?user_id=%@&bar_id=%@"]

#define kAPI_OPPONENTDATA [kHostURL stringByAppendingString:@"webservice/get_apponent_by_user_id.php?user_id=%@&bar_id=%@"]

#define kAPI_INVITEGAME [kHostURL stringByAppendingString:@"webservice/invite_game.php?bar_id=%@&by_user_id=%@&by_win_or_lost=%@&other_win_or_lost=%@&other_email=%@"]

#define kAPI_SIGNFB [kHostURL stringByAppendingString:@"webservice/signup_fb.php"]
#define kAPI_SIGNFBParams @"user_id=%@&device_token=%@&action=%@"


#define kAPI_CHANGEPASSWORD [kHostURL stringByAppendingString:@"webservice/change_password.php"]
#define kAPI_CHANGEPASSWORDParams @"user_id=%@&password=%@&oldpassword=%@"

#define kAPI_REPORTBAR [kHostURL stringByAppendingString:@"webservice/report_bar.php?user_id=%@&bar_id=%@"]

#define kAPI_IMAGEUPLOAD [kHostURL stringByAppendingString:@"webservice/user_image_upload.php"]

#define GoogleDirectionAPI @"AIzaSyCmvC_H5S08MvkO-ixoQTpJQGXdu5qyVWg"

//Functions
#define TextNumericNospace @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.~`@#$%^&*()_-+=|\?/>.<':;"
#define TextNumericspace @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.~`@#$%^&*()_-+=|\?/>.<':;"
#define TextName @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define TextNumber @"0123456789"


#define kSHAREMAILSUBJECTTEXT @"JellyRoll -- Pool game tracking and stats"
#define kSHAREMAILTEXT @"%@ wants to play you in pool! Download JellyRoll on the iOS app store and start tracking your pool games with us. Visit the site at jellyrollpool.com"
#define kSHAREFACEBOOKTEXT @"Download JellyRoll on the iOS app store and track your pool games with me! See what the app is about or drop the creators a line at jellyrollpool.com"
#define kSHARECOPYTEXT @"Download JellyRoll on the iOS app store and start tracking your pool games with me! Visit the site at jellyrollpool.com"

#define kSHAREFACEBOOKTEXT2 @"I just beat %@ at pool at %@. Track your pool games with JellyRoll on iOS or visit jellyrollpool.com"


#define kUserDefaults               [NSUserDefaults standardUserDefaults]
#define kIsSame_String(str1,str2)   [str1 isEqualToString:str2]

#define	kResourcePath(path)          [[NSBundle mainBundle] pathForResource:path ofType:nil]
#define	kImageWithPath(path)         [UIImage imageWithContentsOfFile:path]
#define kDeviceVersion				[[[UIDevice currentDevice] systemVersion] intValue]
#define kGET_COLOR(r,g,b,alpha)    [UIColor colorWithRed:r green:g blue:b alpha:alpha]
#define lGET_FONT(name,size)       [UIFont fontWithName:name size:size]

#define kNSLocalizedString(a, b) [[NSBundle bundleWithPath:_gAppPrefData.langBundle] localizedStringForKey:a value:b table:nil]
#define kDispatchQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul)


#define kYellowColor [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:53.0/255.0 alpha:1.0]
#define kLightBlueColor [UIColor colorWithRed:241.0/255.0 green:244.0/255.0 blue:254.0/255.0 alpha:1.0]
#define kDarkBlackColor [UIColor colorWithRed:82.0/255.0 green:84.0/255.0 blue:95.0/255.0 alpha:1.0]
#define kLightBlackColor [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:215.0/255.0 alpha:1.0]

#define kYalletColor [UIColor colorWithRed:133.0/255.0 green:44.0/255.0 blue:139.0/255.0 alpha:1.0]
#define kOrangeColor [UIColor colorWithRed:238.0/255.0 green:160.0/255.0 blue:55.0/255.0 alpha:1.0]
#define kRedColor [UIColor colorWithRed:219.0/255.0 green:59.0/255.0 blue:50.0/255.0 alpha:1.0]
#define kFroColor [UIColor colorWithRed:88.0/255.0 green:177.0/255.0 blue:204.0/255.0 alpha:1.0]
#define kGreenColor [UIColor colorWithRed:153.0/255.0 green:196.0/255.0 blue:85.0/255.0 alpha:1.0]

#define kAppThemeColor [UIColor colorWithRed:15.0/255.0 green:9.0/255.0 blue:27.0/255.0 alpha:1.0]

// Device Specific
#define kScreenHeight             [[UIScreen mainScreen] bounds].size.height
#define kIS_IPHONE                 ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone"])
#define kIS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)






