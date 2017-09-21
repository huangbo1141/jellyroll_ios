//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.

#import "AppPrefData.h"

static AppPrefData*	sAppPrefData = nil;

@implementation AppPrefData

#pragma mark
#pragma mark Release Memory
- (void)dealloc
{
	_userName = nil;
	_userID = nil;
    _imageURL = nil;
    _userEmail = nil;
    _address = nil;
    _memberSince = nil;
    _bannerID = nil;
    _fullScreenBannerID = nil;
}


+ (AppPrefData*)sharedObject
{
	if (sAppPrefData == nil)
	{
		sAppPrefData = [[AppPrefData alloc] init];
	}
	return sAppPrefData;
}

- (id)init
{
	if (self = [super init])
	{
		[self loadAppPrefData];
	}
	return self;
}

- (void)loadAppPrefData
{
	NSDictionary* dictionary = [kUserDefaults objectForKey:kPreferenceData];
	if (dictionary == nil)
	{
        self.userName = @"";
		self.userID = @"";
        self.userEmail = @"";
        self.imageURL = @"0";
        self.memberSince = @"";
        self.address = @"";
        self.bannerID = @"ca-app-pub-6508526601344465/7391646435";
        self.fullScreenBannerID = @"ca-app-pub-6508526601344465/2562664039";
	}
	else
	{
        self.userName = [dictionary objectForKey:@"keyUserName"];
		self.userID = [dictionary objectForKey:@"keyUserID"];
        self.userEmail = [dictionary objectForKey:@"keyUserEmail"];
        self.imageURL = [dictionary objectForKey:@"keyUserImage"];
        self.address = [dictionary objectForKey:@"keyAddress"];
        self.memberSince = [dictionary objectForKey:@"keyMember"];
        
        self.bannerID = [dictionary objectForKey:@"keyBannerID"];
        self.fullScreenBannerID = [dictionary objectForKey:@"keyFullBannerID"];
	}
}

- (NSDictionary*)dataAsDictionary
{
	NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.userName forKey:@"keyUserName"];
	[dictionary setObject:self.userID forKey:@"keyUserID"];
    [dictionary setObject:self.userEmail forKey:@"keyUserEmail"];    
    [dictionary setObject:self.imageURL forKey:@"keyUserImage"];
    
    [dictionary setObject:self.address forKey:@"keyAddress"];
    [dictionary setObject:self.memberSince forKey:@"keyMember"];
    
    
    [dictionary setObject:self.bannerID forKey:@"keyBannerID"];
    [dictionary setObject:self.fullScreenBannerID forKey:@"keyFullBannerID"];
    
	return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)saveAppPrefData
{
	NSUserDefaults* defaults = kUserDefaults;
	[defaults setObject:[self dataAsDictionary] forKey:kPreferenceData];
	[defaults synchronize];
}


#pragma mark
#pragma mark - Public Methods
- (void)saveAllData
{
	[self saveAppPrefData];
}

@end
