//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.



@interface AppPrefData : NSObject 
{
    
}

// Login
@property (nonatomic, retain)NSString* userName;
@property (nonatomic, retain)NSString* userID;
@property (nonatomic, retain)NSString* userEmail;
@property (nonatomic, retain)NSString* imageURL;
@property (nonatomic, retain)NSString* address;
@property (nonatomic, retain)NSString* memberSince;

@property (nonatomic, retain)NSString* bannerID;
@property (nonatomic, retain)NSString* fullScreenBannerID;



+ (AppPrefData*)sharedObject;
- (void)saveAllData;

@end

#define _gAppPrefData [AppPrefData sharedObject]
