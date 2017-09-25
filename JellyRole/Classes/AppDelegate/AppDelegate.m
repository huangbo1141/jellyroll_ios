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

@interface AppDelegate()<UNUserNotificationCenterDelegate, CLLocationManagerDelegate>
{
    UIView* _waitingScreen;
    
    CLLocationManager* _locationManager;
    CLLocation* _lastLocation;
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
    
    
    /*if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!error) {
                                      //[self testAlrt];
                                  }
                              }];
        
    }*/
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
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    
    
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
    });
}

- (void)logoutSucessful {
    
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
