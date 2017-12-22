//
//  AppDelegate.h
//  
//
//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong)UIWindow* window;

- (void) showLoadingView:(BOOL)isShown;
- (void)showAlertDilog:(NSString *)title message:(NSString *)message;
- (void)showViewMessage:(UIView *)view type:(int)type;
- (void)loginSucessful;
- (void)logoutSucessful;
- (void)checkFBLogin:(NSString *)email username:(NSString *)userName params:(NSString *)paramss;
- (NSString *)deviceToken;

@end

#define _gAppDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate]
