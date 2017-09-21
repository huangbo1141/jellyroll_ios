//
//  
//
//
//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.
//

#import "B_Nav_VC.h"

@interface B_Nav_VC ()

@end

@implementation B_Nav_VC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:15.0/255.0 green:9.0/255.0 blue:27.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    

//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:138.0/255.0 green:19.0/255.0 blue:9.0/255.0 alpha:1.0]];
//    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    [super shouldAutorotate];
//    if (![Utils isIphone])
//        [self rotateVCOnrientation:[UIApplication sharedApplication].statusBarOrientation];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
//    if (![Utils isIphone])
//        [self rotateVCOnrientation:toInterfaceOrientation];
    return YES;
}

//-(NSUInteger)supportedInterfaceOrientations
//{
//    if ([Utils isIphone])
//        return UIInterfaceOrientationMaskPortrait;
//    else
//        return UIInterfaceOrientationMaskAll;
//}

/*- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self performSelector:@selector(updateFrames) withObject:nil afterDelay:duration];
}

- (void)updateFrames
{
    [self rotateVCOnrientation:[UIApplication sharedApplication].statusBarOrientation];
}
*/
#pragma mark
- (void)rotateVCOnrientation:(UIInterfaceOrientation)orientation
{
    
}

@end
