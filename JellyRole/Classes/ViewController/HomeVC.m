//
//  ViewController.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "HomeVC.h"
#import "LocationStateVC.h"
#import "MapVC.h"
#import "NotificationVC.h"
#import "QuickPlayVC.h"

@interface HomeVC () <MapVCDelegates, UINavigationControllerDelegate>
{
    UINavigationController* _mainVC;
}

@property (weak, nonatomic) IBOutlet UIImageView *notifyImage;
@property (weak, nonatomic) IBOutlet UIButton *notifyButton;

@end

@implementation HomeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self viewSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self getAllNotifyData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
 
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews {

 //       _mainVC.view.frame = CGRectMake(0, 0, 300, 400);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}


#pragma mark
#pragma mark Private Methods
- (void)viewSettings
{
    [self.navigationController setNavigationBarHidden:true];
 
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:[Utils getIpadResourceName:@"Main"] bundle:nil];
    MapVC* vc = [storyBoard instantiateViewControllerWithIdentifier:@"MapSB"];
    [vc setDelegate:self];
    
    _mainVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [_mainVC.view setBackgroundColor:[UIColor greenColor]];
    _mainVC.view.frame = CGRectMake(0, 68, self.view.frame.size.width, self.view.frame.size.height-68);
    
    [_mainVC setDelegate:self];
    [self.view addSubview:_mainVC.view];
}

- (void)getAllNotifyData {
    
    NSString* API = [NSString stringWithFormat:kAPI_NOTIFICATIONS, _gAppPrefData.userID];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            
            if(dict1[@"bellcount"] != nil) {
                
                NSString* c = dict1[@"bellcount"][@"c"];
                NSString* p = dict1[@"bellcount"][@"p"];
                int confirm_cnt = [c intValue];
                int pending_cnt = [p intValue];
                
                confirm_cnt = confirm_cnt + pending_cnt;
                if (confirm_cnt > 0) {
                
                    [_notifyButton setTitle:[NSString stringWithFormat:@"%d", confirm_cnt] forState:UIControlStateNormal];
                    [_notifyImage setImage:[UIImage imageNamed:@"notification1"]];
                } else {
                
                    [_notifyButton setTitle:@"" forState:UIControlStateNormal];
                    [_notifyImage setImage:[UIImage imageNamed:@"notification"]];
                }
                
            } else {
                
                [_notifyButton setTitle:@"" forState:UIControlStateNormal];
                [_notifyImage setImage:[UIImage imageNamed:@"notification"]];
            }
            
            [self getAllNotifyData];
        }
    } failure:^(id result) {
        
        [self getAllNotifyData];
    }];
}


#pragma mark
#pragma mark Public Methods
- (void)performIndexAction:(int)row {
    
    
    //    [NSArray arrayWithObjects:@"SCHEDULES", @"SAINTS & GURUS", @"PILGRIMAGE", @"FESTIVALS", @"PANCHAANG", @"VIDEOS", @"PHOTOS", @"EVENTS", @"KALYANAK", @"CONTACT US", nil];
    
    if (row == 0) {
        
        [self performSegueWithIdentifier:@"StatsSegue" sender:nil];
        
    } else if (row == 1) {
        
        [self performSegueWithIdentifier:@"FriendsSegue" sender:nil];
        
    } else if(row == 2) {
        
        [self performSegueWithIdentifier:@"RulesSegue" sender:nil];
        
    } else if(row == 3) {
        
        [self performSegueWithIdentifier:@"PrivacySegue" sender:nil];
        
    } else if(row == 4) {
        
        NSMutableArray *sharingItems = [NSMutableArray array];
        NSURL *shareURL = [NSURL URLWithString:@"http://jellyrollpool.com"];
        [sharingItems addObject:kSHARETEXT];
        [sharingItems addObject:shareURL];
        

        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
        if (![Utils isIphone]) {
            activityController.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:activityController animated:YES completion:nil];
        
        
    } else if(row == 5) {
        
        [self performSegueWithIdentifier:@"FeedbackSegue" sender:nil];
        
    } else if(row == 6) {
        
        [self performSegueWithIdentifier:@"ProfileSegue" sender:nil];        
    }
}


#pragma mark
#pragma mark UIButton Action Methods
- (IBAction)menuAction:(UIButton *)sender {
    
    KYDrawerController* drawer = (KYDrawerController *)self.navigationController.parentViewController;
    [drawer setDrawerState:DrawerStateOpened animated:true];
    
    
    if ([_mainVC.visibleViewController isKindOfClass:[MapVC class]]) {
        
        MapVC* mapVC = (MapVC *)_mainVC.visibleViewController;
     
        [mapVC hideDialogPublic];
    }
    
}

- (IBAction)backButtonAction:(UIButton *)sender {
    
    if ([_mainVC.visibleViewController isKindOfClass:[MapVC class]]) {
        
        MapVC* mapVC = (MapVC *)_mainVC.visibleViewController;
        [mapVC hideDialogPublic];
    }

    [_mainVC popViewControllerAnimated:true];
}

- (IBAction)notificationAction:(UIButton *)sender {
    
    if ([_mainVC.visibleViewController isKindOfClass:[NotificationVC class]]) {
        
        return;
    }
    
    UIImage* image = nil;
    if ([_mainVC.visibleViewController isKindOfClass:[QuickPlayVC class]]) {
        
        QuickPlayVC* vc = (QuickPlayVC *)_mainVC.visibleViewController;
        image = vc->_mapView;
    } else if ([_mainVC.visibleViewController isKindOfClass:[NotificationVC class]]) {
        
        NotificationVC* vc = (NotificationVC *)_mainVC.visibleViewController;
        image = vc->_mapView;
    }
    
    
    [_mainVC popViewControllerAnimated:false];
    
    if ([_mainVC.visibleViewController isKindOfClass:[MapVC class]]) {
        
        MapVC* mapVC = (MapVC *)_mainVC.visibleViewController;

        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:[Utils getIpadResourceName:@"Main"] bundle:nil];
        NotificationVC* vc = [storyBoard instantiateViewControllerWithIdentifier:@"NotificationSB"];
        vc->_mapView = image != nil ? image : [mapVC captureViewS];
        [_mainVC pushViewController:vc animated:true];
    }
}

- (IBAction)quickPlayAction:(UIButton *)sender {
    
    UIImage* image = nil;
    if ([_mainVC.visibleViewController isKindOfClass:[QuickPlayVC class]]) {
        
        QuickPlayVC* quickVC = (QuickPlayVC *)_mainVC.visibleViewController;
        
        if (quickVC->_isLocation) {
            
            image = quickVC->_mapView;
        } else {
        
            return;
        }
    }
    
    
    if ([_mainVC.visibleViewController isKindOfClass:[NotificationVC class]]) {
        
        NotificationVC* vc = (NotificationVC *)_mainVC.visibleViewController;
        image = vc->_mapView;
    }
    
    [_mainVC popViewControllerAnimated:false];
    
    if ([_mainVC.visibleViewController isKindOfClass:[MapVC class]]) {
        
        MapVC* mapVC = (MapVC *)_mainVC.visibleViewController;
        
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:[Utils getIpadResourceName:@"Main"] bundle:nil];
        QuickPlayVC* vc = [storyBoard instantiateViewControllerWithIdentifier:@"QuickSB"];
        vc->_mapView = image != nil ? image : [mapVC captureViewS];
        [_mainVC pushViewController:vc animated:true];
    }
    
    
}

#pragma mark
#pragma mark UIButton Action Methods
- (void)loadLocationStateVC:(UIImage *)image data:(NSDictionary *)data {
    
    /*UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:[Utils getIpadResourceName:@"Main"] bundle:nil];
    LocationStateVC* vc = [storyBoard instantiateViewControllerWithIdentifier:@"StatsSB"];
    vc->_mapView = image;
    [_mainVC pushViewController:vc animated:true];*/
    
    if ([_mainVC.visibleViewController isKindOfClass:[QuickPlayVC class]]) {
        
        return;
    }
    
    /*UIImage* image = nil;
    if ([_mainVC.visibleViewController isKindOfClass:[NotificationVC class]]) {
        
        NotificationVC* vc = (NotificationVC *)_mainVC.visibleViewController;
        image = vc->_mapView;
    }*/
    
    [_mainVC popViewControllerAnimated:false];
    
    if ([_mainVC.visibleViewController isKindOfClass:[MapVC class]]) {
        
        MapVC* mapVC = (MapVC *)_mainVC.visibleViewController;
        
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:[Utils getIpadResourceName:@"Main"] bundle:nil];
        QuickPlayVC* vc = [storyBoard instantiateViewControllerWithIdentifier:@"QuickSB"];
        vc->_mapView = image != nil ? image : [mapVC captureViewS];
        vc->_isLocation = true;
        vc->_selectedBar = [NSMutableDictionary dictionaryWithDictionary:data];
        
        [_mainVC pushViewController:vc animated:true];
    }

    
}

#pragma mark
#pragma mark UINavigationController Delegets
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    NSArray * viewControllers = [[self navigationController] viewControllers];
    
    DebugLog(@"....%d", viewControllers.count);
    if (viewControllers.count > 0) {
        
    }
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    DebugLog(@"operation...%ld", (long)operation);
    
    if (operation == UINavigationControllerOperationPush) {
        
    } else if (operation == UINavigationControllerOperationPop) {
        
    }
    
    return nil;
}


@end
