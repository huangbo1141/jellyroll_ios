//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.


#ifdef DEBUG
#define PUSHNOTIFICATION @"ParasTV_dev"   //Development
#define DebugLog(s, ...) NSLog(s, ##__VA_ARGS__)
#else
#define PUSHNOTIFICATION @"ParasTV"   //Production
#define DebugLog(s, ...)
#endif

#define kAppName @"ParasTV"
#define kPreferenceData @"keyPreferenceData"
#define kDataBaseName @"ParasTV.sqlite"


#define kContactUS @"http://www.vtechnolabs.com/parasgold/contact-us/"
#define kURL @"http://skassociates.me/iws/Personal/iws/ParasTV/getAddIDs.php/version=%@"

#define kHostURL @"http://jellyrollpool.com/"
#define kAPI_LOGIN [kHostURL stringByAppendingString:@"webservice/login.php"]
#define kAPI_LoginParams @"username=%@&password=%@&flag=app&login_flag=%@"

#define kAPI_SIGNUP [kHostURL stringByAppendingString:@"webservice/signup.php"]
#define kAPI_SignupParams @"username=%@&email=%@&password=%@&flag=app&firstname=%@&lastname=%@"

#define kAPI_FEEDBACK [kHostURL stringByAppendingString:@"webservice/feedback.php?user_id=%@&feedback=%@"]

#define kAPI_TREMS [kHostURL stringByAppendingString:@"webservice/get_terms_rules.php"]

#define kAPI_FRIENDS [kHostURL stringByAppendingString:@"webservice/get_frinds_count.php?user_id=%@"]

#define kAPI_INVITEFRIEND [kHostURL stringByAppendingString:@"webservice/invite_friend.php?user_id=%@&email=%@"]

#define kAPI_ADDFRIEND [kHostURL stringByAppendingString:@"webservice/add_friend.php?user_id=%@&email=%@"]

#define kAPI_MYPROFILE [kHostURL stringByAppendingString:@"webservice/get_my_profile.php?user_id=%@"]

//Functions
#define TextNumericNospace @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.~`@#$%^&*()_-+=|\?/>.<':;"
#define TextNumericspace @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.~`@#$%^&*()_-+=|\?/>.<':;"
#define TextName @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define TextNumber @"0123456789"

#define kSHARETEXT @"Start tracking your pool games with us at jellyrollpool.com."


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

// Device Specific
#define kScreenHeight             [[UIScreen mainScreen] bounds].size.height
#define kIS_IPHONE                 ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone"])
#define kIS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)






