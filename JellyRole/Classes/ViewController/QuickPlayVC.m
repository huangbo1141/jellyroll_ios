//
//  QuickPlayVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 10/2/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "QuickPlayVC.h"
#import "GameView.h"
#import "UserComparisionView.h"
#import "LeaderboardView.h"

@interface QuickPlayVC ()
{
    
    NSMutableDictionary* _data;
    
    NSMutableArray* _allGames;
    NSMutableArray* _recentGames;
}

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *barLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherUserLabel;


@property (strong, nonatomic) IBOutlet UIView *userSuperView;
@property (strong, nonatomic) IBOutlet UIView *locationSuperView;


@property (weak, nonatomic) IBOutlet UIView *winSuperView;
@property (strong, nonatomic) IBOutlet UIView *winView;

@property (weak, nonatomic) IBOutlet GameView *gameTableView;
@property (weak, nonatomic) IBOutlet GameView *gameLocationTableView;
@property (weak, nonatomic) IBOutlet UserComparisionView *comparisionVC;
@property (weak, nonatomic) IBOutlet LeaderboardView *leaderboardView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userMTrail;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userMLead;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userMTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userMBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userMWinBottom;



@property (weak, nonatomic) IBOutlet UIButton *userGameBtn;
@property (weak, nonatomic) IBOutlet UIButton *userSessionBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userGameLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userGameTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userSessionTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userSessionLeading;



@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userMainTrail;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userMainLead;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userMainTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userMainBottom;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationTrail;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationLead;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationBottom;


@property (weak, nonatomic) IBOutlet UIButton *myRecentBtn;
@property (weak, nonatomic) IBOutlet UIButton *allRecentBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myRecentLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myRecentTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allRecentTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allRecentLeading;

@end

@implementation QuickPlayVC

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
    
    if (!_isLocation) {
    
        [self getRecentGameData];
    }
    
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
    _mapImageView.image = _mapView;
    
    
    if (!_isLocation) {
        
        _selectedBar = [[NSMutableDictionary alloc] init];
    }
    
    _allGames = [[NSMutableArray alloc] init];
    _recentGames = [[NSMutableArray alloc] init];
    _data = [[NSMutableDictionary alloc] init];
    
    [self userView:false];
    [self locationView:_isLocation];
    [_gameTableView setView];
    [_gameLocationTableView setView];
    [_comparisionVC setView];
    [_leaderboardView setView];
    [_currentLabel setText:_gAppPrefData.userName];

}

- (void)userView:(BOOL)isHide {
 
    if (isHide) {
        
        [_winSuperView addSubview:_winView];
        
        [_winSuperView addConstraint:_userMTrail];
        [_winSuperView addConstraint:_userMLead];
        [_winSuperView addConstraint:_userMTop];
        [_winSuperView addConstraint:_userMBottom];
        [_winSuperView addConstraint:_userMWinBottom];
        
        [self getUserGameData];
        
    } else {
        
        [_winView removeFromSuperview];
        
        _userSessionLeading.active = false;
        _userSessionTrailing.active = false;
        
        _userGameLeading.active = true;
        _userGameTrailing.active = true;
        
        [_userGameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_userSessionBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }
}


- (void)locationView:(BOOL)isHide {
    
    if (isHide) {
        
        [self.view addSubview:_locationSuperView];
        
        [self.view addConstraint:_locationTop];
        [self.view addConstraint:_locationBottom];
        [self.view addConstraint:_locationLead];
        [self.view addConstraint:_locationTrail];
        
        [_userSuperView removeFromSuperview];
        
        [self getAllRecentGameData];
    } else {
        
        [_locationSuperView removeFromSuperview];
        [self.view addSubview:_userSuperView];
        
        [self.view addConstraint:_userMainTop];
        [self.view addConstraint:_userMainBottom];
        [self.view addConstraint:_userMainLead];
        [self.view addConstraint:_userMainTrail];
        
        _allRecentLeading.active = false;
        _allRecentTrailing.active = false;
        
        _myRecentLeading.active = true;
        _myRecentTrailing.active = true;
        
        [_myRecentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_allRecentBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}

- (void)updateView:(NSDictionary *)dict games:(NSArray *)games {
    
    if (games != nil) {
        
        [_gameTableView updateData:games];
    }
    
    float overMyWin=0, overMyLoss=0, overOppWin=0, overOppLoss=0;
    
    
    for (NSDictionary* myDict in dict[@"data"]) {
     
        
        overMyWin += [myDict[@"win"] intValue];
        overMyLoss += [myDict[@"loss"] intValue];
        overOppWin += [myDict[@"win_o"] intValue];
        overOppLoss += [myDict[@"loss_o"] intValue];
    }
    
    
    
    NSMutableDictionary* lDict = [NSMutableDictionary dictionary];
    [lDict setValue:dict[@"my_rank_overall"] forKey:@"my_rank"];
    [lDict setValue:dict[@"other_rank_overall"] forKey:@"other_rank"];
    [lDict setValue:@"Overall" forKey:@"location"];
    
    [lDict setValue:[NSString stringWithFormat:@"%.0f", overMyWin] forKey:@"win"];
    [lDict setValue:[NSString stringWithFormat:@"%.0f", overMyLoss] forKey:@"loss"];
    [lDict setValue:[NSString stringWithFormat:@"%.0f", overOppWin] forKey:@"win_o"];
    [lDict setValue:[NSString stringWithFormat:@"%.0f", overOppLoss] forKey:@"loss_o"];
    
    [lDict setValue:[NSString stringWithFormat:@"%.0f",((overMyWin/(overMyLoss+overMyWin))*100)] forKey:@"percent"];
    [lDict setValue:[NSString stringWithFormat:@"%.0f",((overOppWin/(overOppLoss+overOppWin))*100)] forKey:@"percent_o"];
    
    
    NSMutableArray* mainArray = [NSMutableArray arrayWithArray:dict[@"data"]];
    [mainArray addObject:lDict];
    if (mainArray.count > 0) {
        
        [_comparisionVC updateData:mainArray];
    }    
}


- (void)showWinLossDialog:(int)type { // 0 Win 1 Loss
    
    if (_selectedBar == nil) {
        
        [_gAppDelegate showAlertDilog:@"Info" message:@"No Bar Selected"];
    } else {
        
        NSString* message = (type == 0) ? @"Congratulations!" : @"Sorry!";
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self getWinLossData:type];
            
        }]];
        
        if (![Utils isIphone]) {
            alert.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (void)getWinLossData:(int)type
{
    NSString* params = [NSString stringWithFormat:kAPI_WinLossParams, _gAppPrefData.userID, _data[@"user_id"], _selectedBar[@"bar_id"], (type == 0) ? @"win" : @"loss"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [_gAppData sendPostRequest:kAPI_WINLOSSGAME params:params completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Info" message:dict1[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:true];
                }]];
                
                if (![Utils isIphone]) {
                    alert.popoverPresentationController.sourceView = self.view;
                }
                
                [self presentViewController:alert animated:true completion:nil];
                
            } else {
                
                [_gAppDelegate showAlertDilog:@"Error!" message:dict1[@"message"]];
                
            }
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)getRecentGameData {
    
    _barLabel.text = @"";
    _userLabel.text = @"";
    _otherUserLabel.text = @"";
    [_selectedBar removeAllObjects];
    [_data removeAllObjects];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    NSString* url = [NSString stringWithFormat:kAPI_RECENTGAMES, _gAppPrefData.userID];
    
    [_gAppData sendGETRequest:url completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            NSDictionary* data = [dict1 valueForKey:@"data"];
            [_data addEntriesFromDictionary:data];
            
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                _barLabel.text = data[@"location_name"];
                _userLabel.text = data[@"username"];
                [_otherUserLabel setText:data[@"username"]];
                
                for (NSDictionary* bar in dict1[@"bars"]) {
                    
                    if ([bar[@"bar_id"] isEqualToString:data[@"bar_id"]]) {
                        
                        [_selectedBar addEntriesFromDictionary:bar];
                        DebugLog(@"...%@", _selectedBar);
                        break;
                    }
                }
            } else {
                
                
                [_gAppDelegate showAlertDilog:@"Error!" message:dict1[@"message"]];
            }
            
        }
        
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)getAllRecentGameData {
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    NSString* url = [NSString stringWithFormat:kAPI_ALLRECENTGAME, _gAppPrefData.userID, _selectedBar[@"bar_id"]];
    
    [_gAppData sendGETRequest:url completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            NSDictionary* data = [dict1 valueForKey:@"data"];
            [_data addEntriesFromDictionary:data];
            
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                NSArray* list = dict1[@"leaderboard"];
                if (list != nil && list.count > 0) {
                
                    [_leaderboardView updateData:list];
                }
                
                [_allGames removeAllObjects];
                [_recentGames removeAllObjects];
                
                [_allGames addObjectsFromArray:dict1[@"all"]];
                [_recentGames addObjectsFromArray:dict1[@"recent_game"]];
                
                [_gameLocationTableView updateData:_allGames];
                
            } else {
                
                
                NSString *strMESSAGE;
                NSRange range = [[dict1 objectForKey:@"msg"] rangeOfString:@"No game found"];
                
                if (range.location != NSNotFound)//@"No game found!!!!!"
                {
                    strMESSAGE=[NSString stringWithFormat:@"No previous game found for this bar"];
                }
                else
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Info" message:strMESSAGE preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self.navigationController popViewControllerAnimated:true];
                    }]];
                    
                    if (![Utils isIphone]) {
                        alert.popoverPresentationController.sourceView = self.view;
                    }
                    
                    [self presentViewController:alert animated:true completion:nil];
                    
                }
            }
            
        }
        
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}


- (void)getUserGameData {
    
    if (_isLocation) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    NSString* url = [NSString stringWithFormat:kAPI_USERGAMESCORE, _gAppPrefData.userID, _data[@"user_id"]];
    
    [_gAppData sendGETRequest:url completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                NSArray* mainArray = dict1[@"data"];
                NSArray*_locData = [NSMutableArray arrayWithArray:[mainArray sortedArrayUsingComparator:^NSComparisonResult(NSMutableDictionary* a, NSMutableDictionary* b) {
                    double first = [a[@"total"] doubleValue];
                    double second = [b[@"total"] doubleValue];
                    return first<second;
                }]];
                
                //[_list addObjectsFromArray:_locData];
                [self updateView:dict1 games:dict1[@"recent_game"]];
            } else {
                
            
                [_gAppDelegate showAlertDilog:@"Error!" message:dict1[@"msg"]];
            }
            
        }
        
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

#pragma mark
#pragma mark UIButton Actions

#pragma mark
#pragma mark Public Methods


#pragma mark
#pragma mark UIButton Action Methods
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)winAction:(id)sender {
    
    [self showWinLossDialog:0];
}

- (IBAction)lossAction:(id)sender {
    
    [self showWinLossDialog:1];
}

- (IBAction)userViewAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;    
    [self userView:sender.selected];
}

- (IBAction)locationViewAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [self locationView:sender.selected];
}

- (IBAction)userGameAction:(UIButton *)sender {
    
    if (_userGameLeading.active) {
        
        return;
    }
    _userSessionLeading.active = false;
    _userSessionTrailing.active = false;
    
    _userGameLeading.active = true;
    _userGameTrailing.active = true;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_userSessionBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self getUserGameData];
}

- (IBAction)userSessionAction:(UIButton *)sender {
    
    if (_userSessionLeading.active) {
        
        return;
    }
    
    _userSessionLeading.active = true;
    _userSessionTrailing.active = true;
    
    _userGameLeading.active = false;
    _userGameTrailing.active = false;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_userGameBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self getUserGameData];
    
}


- (IBAction)recentGameAction:(UIButton *)sender {
    
    _allRecentLeading.active = false;
    _allRecentTrailing.active = false;
    
    _myRecentLeading.active = true;
    _myRecentTrailing.active = true;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_allRecentBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [_gameLocationTableView updateData:_allGames];
}

- (IBAction)allGameAction:(UIButton *)sender {
    
    
    _allRecentLeading.active = true;
    _allRecentTrailing.active = true;
    
    _myRecentLeading.active = false;
    _myRecentTrailing.active = false;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myRecentBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [_gameLocationTableView updateData:_recentGames];
    
}

@end
