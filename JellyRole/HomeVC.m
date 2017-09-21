//
//  ViewController.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "HomeVC.h"
#import "LeaderboardView.h"
#import "GameView.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeVC ()

@property (weak, nonatomic) IBOutlet LeaderboardView *leaderboardView;
@property (weak, nonatomic) IBOutlet GameView *gameView;

@property (weak, nonatomic) IBOutlet UIButton *myRecentBtn;
@property (weak, nonatomic) IBOutlet UIButton *allRecentBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myRecentLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myRecentTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allRecentTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allRecentLeading;
@property (weak, nonatomic) IBOutlet UILabel *greeLabel;

@end

@implementation ViewController

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
}

- (UIStatusBarStyle)preferredStatusBarStyle {
 
    
    return UIStatusBarStyleLightContent;
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
    
    [self setStatusBarBackgroundColor:[UIColor colorWithRed:15.0/255.0 green:9.0/255.0 blue:27.0/255.0 alpha:1.0]];
    
    [_leaderboardView setView];
    [_gameView setView];
    
    _greeLabel.layer.cornerRadius = 5.5;
    _greeLabel.clipsToBounds = true;
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark
#pragma mark UIButton Action Methods
- (IBAction)recentGameAction:(UIButton *)sender {
 
    _allRecentLeading.active = false;
    _allRecentTrailing.active = false;
    
    _myRecentLeading.active = true;
    _myRecentTrailing.active = true;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_allRecentBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
}

- (IBAction)allGameAction:(UIButton *)sender {
    

    _allRecentLeading.active = true;
    _allRecentTrailing.active = true;
    
    _myRecentLeading.active = false;
    _myRecentTrailing.active = false;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myRecentBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
}


@end
