//
//  AppDelegate.m
//
//
//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "ViewMessage.h"
#import <CoreLocation/CoreLocation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "B_Nav_VC.h"
#import "HomeVC.h"


@interface AppDelegate()<UNUserNotificationCenterDelegate, CLLocationManagerDelegate>
{
    UIView* _waitingScreen;
    
    CLLocationManager* _locationManager;
    CLLocation* _lastLocation;
    
    NSString* _newToken;
}
@end

@implementation AppDelegate

- (void)dealloc
{
    _window = nil;
    _waitingScreen = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSLog(@".....%f", [UIScreen mainScreen].bounds.size.height);
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!error) {
                                      //[self testAlrt];
                                  }
                              }];
        
    } else {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:  [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    
    [self startLocationService];
    AppPrefData* pref = _gAppPrefData;
    if (pref.userID.length > 0) {
        
        [self loginSucessful];
    }
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[application setApplicationIconBadgeNumber:0];
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication*)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //    [GlobalVars sharedInstance].g_userInfo.token = [NSString stringWithFormat:@"%@", newToken];
    NSLog(@"My token is: %@", newToken);
    
    _newToken = newToken;
    
    [self updateData:_newToken];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    completionHandler();
}

#pragma mark -
#pragma mark Private Methods
- (void)getAllNotifyData {
    
    if ([self.window.rootViewController isKindOfClass:[KYDrawerController class]]) {
    
        KYDrawerController* elDrawer = (KYDrawerController *)self.window.rootViewController;
                
        B_Nav_VC* navVC =  (B_Nav_VC *)elDrawer.mainViewController;
        HomeVC* mainVC = (HomeVC *)navVC.visibleViewController;
        
        NSString* API = [NSString stringWithFormat:kAPI_NOTIFICATIONS, _gAppPrefData.userID];
        
        [_gAppData sendGETRequest:API completion:^(id result) {
            
            if (result != nil) {
                
                NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
                if(dict1[@"bellcount"] != nil) {
                    
                    NSString* c = dict1[@"bellcount"][@"c"];
                    NSString* p = dict1[@"bellcount"][@"p"];
                    int confirm_cnt = [c intValue];
                    int pending_cnt = [p intValue];
                    
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:confirm_cnt];
                    confirm_cnt = confirm_cnt + pending_cnt;
                    
                    if ([mainVC isKindOfClass:[HomeVC class]]) {
                        
                        if (confirm_cnt > 0) {
                            
                            
                            [mainVC.notifyButton setTitle:[NSString stringWithFormat:@"%d", confirm_cnt] forState:UIControlStateNormal];
                            [mainVC.notifyImage setImage:[UIImage imageNamed:@"notification1"]];
                        } else {
                            
                            [mainVC.notifyButton setTitle:@"" forState:UIControlStateNormal];
                            [mainVC.notifyImage setImage:[UIImage imageNamed:@"notification"]];
                        }
                    }
                } else {
                    
                    if ([mainVC isKindOfClass:[HomeVC class]]) {
                        [mainVC.notifyButton setTitle:@"" forState:UIControlStateNormal];
                        [mainVC.notifyImage setImage:[UIImage imageNamed:@"notification"]];
                    }
                }
                
                [self getAllNotifyData];
            }
        } failure:^(id result) {
            
            [self getAllNotifyData];
        }];
        
    }
}


-(void)startLocationService {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        NSLog(@"%s: location services are not available.", __PRETTY_FUNCTION__);
        
        [_gAppDelegate showAlertDilog:@"Location services" message:@"Location services are not enabled on this device. Please enable location services in settings."];
        
        return;
    }
    
    // Request "when in use" location service authorization.
    // If authorization has been denied previously, we can display an alert if the user has denied location services previously.
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSLog(@"%s: location services authorization was previously denied by the user.", __PRETTY_FUNCTION__);
        
        [_gAppDelegate showAlertDilog:@"Location services" message:@"Location services were previously denied by the you. Please enable location services for this app in settings."];
        return;
    }
    
    [_locationManager startUpdatingLocation];
}

- (void)initializeApplication:(UIViewController*)initialViewController
{
    self.window.rootViewController = initialViewController;
}

- (UIViewController*)initialSetUpView:(NSString *)identifier
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:[Utils getIpadResourceName:@"Main"] bundle:nil];
    id vc = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    return vc;
}

- (void)logoutSucessful2 {
    
    AppPrefData* pref = _gAppPrefData;
    [pref setUserID:@""];
    [pref setUserName:@""];
    [pref setImageURL:@""];
    [pref setUserEmail:@""];
    [pref saveAllData];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self initializeApplication:[self initialSetUpView:@"Login_SB"]];
    });
}


- (void)updateData:(NSString *)token {
    
    if (_gAppPrefData.userID > 0) {

        NSString* params = [NSString stringWithFormat:kAPI_SIGNFBParams, _gAppPrefData.userID, token, @"update"];
        
        [_gAppData sendPostRequest:kAPI_SIGNFB params:params completion:^(id result) {
            
            if (result != nil) {
                
                NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"post function tag  ==%@",dict1);
                
                
                
            }
        } failure:^(id result) {
        }];
    }
    
    
}

- (void)loginFBLogin:(NSString *)params {
    
    
    [MBProgressHUD showHUDAddedTo:self.window animated:true];
    [_gAppData sendPostRequest:kAPI_SIGNFB params:params completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.window animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if (dict1[@"row"] != nil) {
                
                NSDictionary* row = dict1[@"row"];
                
                AppPrefData* pref = _gAppPrefData;
                [pref setUserName:row[@"username"]];
                [pref setUserID:row[@"user_id"]];
                [pref setImageURL:row[@"image"]];
                //[pref setUserEmail:dict1[@"email"]];
                [pref setAddress:@""];
                
                if ([row[@"created_time"] containsString:@"0000"]) {
                    
                    [pref setMemberSince:[Utils stringToDate:row[@"created_time"]]];
                } else {
                    [pref setMemberSince:row[@"created_time"]];
                }
                [pref saveAllData];
                [self showViewMessage:self.window type:1];
                
            } else {
                
                [self showViewMessage:self.window type:2];
                
            }
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.window animated:true];
    }];
}


#pragma mark -
#pragma mark Show Loading View
- (UIView *)getWaitingScreen
{
    if (_waitingScreen == nil)
    {
        CGRect bound = [UIScreen mainScreen].bounds;
        UIView* loadingView = [[UIView alloc] initWithFrame:bound];
        [loadingView setBackgroundColor:[UIColor blackColor]];
        [loadingView setAutoresizesSubviews:63];
        
        UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((bound.size.width-30)/2, (bound.size.height-30)/2, 30, 30)];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setBackgroundColor:[UIColor clearColor]];
        [activityIndicator startAnimating];
        [loadingView addSubview:activityIndicator];
        
        [loadingView setAlpha:0.70];
        _waitingScreen = loadingView;
    }
    
    return _waitingScreen;
}



#pragma mark -
#pragma mark Public Methods
- (void)loginSucessful {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self initializeApplication:[self initialSetUpView:@"Main_SB"]];
        
        [self getAllNotifyData];
    });
    
    
}

- (void)logoutSucessful {
    
    [self updateData:@"111"];
    [self logoutSucessful2];
    
  /*  NSString* body = [NSString stringWithFormat:kAPI_LOGOUT_PARAM,manager.getUserID, _deviceToken];
    [manager sendPostRequest:[NSString stringWithFormat:@"%@%@",kHostURL,kAPI_LOGOUT] param:body completion:^(NSDictionary * dict) {
        
        [self logoutSucessful2];
    }];*/
    
    
    //Reveal_SB_Segue
}


- (void)showViewMessage:(UIView *)view type:(int)type {

    ViewMessage* message = [[[NSBundle mainBundle] loadNibNamed:@"ViewMessage" owner:self options:nil] objectAtIndex:0];
    [message setData:type];
    
    [view addSubview:message];
    message.frame = CGRectMake(0, 0, 300, 60);
    message.center = view.center;
    
    if (type == 1) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [message removeFromSuperview];
            
            if (type == 1) {
                
                [self loginSucessful];
            }
            
        });
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [message removeFromSuperview];
            
            if (type == 1) {
                
                [self loginSucessful];
            }
            
        });
    }
    
}

- (void)showAlertDilog:(NSString *)title message:(NSString *)message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self.window.rootViewController presentViewController:alert animated:true completion:nil];
}

- (void)showAlertDilog2:(NSString *)title message:(NSString *)message params:(NSString *)paramss userName:(NSString *)userName {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showFBLoginDialog:paramss userName:userName];
    }]];
    
    [self.window.rootViewController presentViewController:alert animated:true completion:nil];
}

- (void)showFBLoginDialog:(NSString *)paramss userName:(NSString *)userName {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"USERNAME";
        textField.text = userName;
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"PASSWORD";
        textField.secureTextEntry = true;
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"CONFIRM PASSWORD";
        
        textField.secureTextEntry = true;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString* text1 = [[alert textFields][0] text];
        NSString* text2 = [[alert textFields][1] text];
        NSString* text3 = [[alert textFields][2] text];
        if (text1.length <= 0) {
            [_gAppDelegate showAlertDilog2:@"Info" message:@"INPUT USERNAME" params:paramss userName:userName];
            
        } else if (text2.length <= 0) {
            [_gAppDelegate showAlertDilog2:@"Info" message:@"INPUT PASSWORD"  params:paramss userName:userName];
            
        } else if (![text2 isEqualToString:text3]) {
            [_gAppDelegate showAlertDilog2:@"Info" message:@"PASSWORD DON'T MATCH"  params:paramss userName:userName];
            
        } else {
            
            NSString* params = [NSString stringWithFormat:@"%@&username=%@&password=%@", paramss, text1, text2];
            
            [self loginFBLogin:params];
        }
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    if (![Utils isIphone]) {
        alert.popoverPresentationController.sourceView = self.window.rootViewController.view;
    }
    
    [self.window.rootViewController presentViewController:alert animated:true completion:nil];
}


- (void)checkFBLogin:(NSString *)email username:(NSString *)userName params:(NSString *)paramss {
    
    NSString* params = [NSString stringWithFormat:@"email=%@&action=check", email];
    
    [MBProgressHUD showHUDAddedTo:self.window animated:true];
    [_gAppData sendPostRequest:kAPI_SIGNFB params:params completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.window animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if (dict1[@"row"] != nil) {
                
                NSDictionary* row = dict1[@"row"];
                
                NSString* params = [NSString stringWithFormat:@"username=%@&password=%@&image=%@&action=signfb", row[@"username"], row[@"password"], row[@"image"]];
                
                [self loginFBLogin:params];
                
            } else {
                
                [self showFBLoginDialog:paramss userName:userName];
                
            }
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.window animated:true];
    }];
}

#pragma mark -
#pragma mark ActivityIndicatorMethod
- (void)showLoadingView:(BOOL)isShown
{
    if (isShown)
    {
        
        [self.window addSubview:[self getWaitingScreen]];
        [self.window bringSubviewToFront:_waitingScreen];
    }
    else
    {
        if ([_waitingScreen superview] != NULL)
            [_waitingScreen removeFromSuperview];
    }
}

#pragma mark -
#pragma mark- CLLocation Manager Delegates
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    _lastLocation = newLocation;
    [_locationManager stopUpdatingLocation];
    [_locationManager setDelegate:nil];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
}

@end
