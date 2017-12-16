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
#import "FriendsView.h"
#import <MapKit/MapKit.h>
#import "GooglePlaceResult.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

typedef enum
{
    PICKER_TYPE_NONE=0,
    PICKER_TYPE_USER,
    PICKER_TYPE_LOCATION,
    PICKER_TYPE_OPPONENT
}PICKER_TYPE;


@interface QuickPlayVC () <FriendsViewDelegates, UITextViewDelegate, MFMailComposeViewControllerDelegate>
{
    
    PICKER_TYPE _pickerType;
    NSMutableDictionary* _data;
    
    NSMutableDictionary* _allFriendsData;
    NSMutableDictionary* _userGamesData;
    
    NSMutableArray* _allGames;
    NSMutableArray* _recentGames;
    
    
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar1;
@property (weak, nonatomic) IBOutlet UITextField *searchBar2;

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *barLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherUserLabel;


@property (strong, nonatomic) IBOutlet UIView *userSuperView;
@property (strong, nonatomic) IBOutlet UIView *locationSuperView;
@property (strong, nonatomic) IBOutlet UIView *opponentSuperView;


@property (weak, nonatomic) IBOutlet UIView *winSuperView;
@property (strong, nonatomic) IBOutlet UIView *winView;

@property (weak, nonatomic) IBOutlet GameView *gameTableView;
@property (weak, nonatomic) IBOutlet GameView *gameLocationTableView;
@property (weak, nonatomic) IBOutlet UserComparisionView *comparisionVC;
@property (weak, nonatomic) IBOutlet LeaderboardView *leaderboardView;
@property (weak, nonatomic) IBOutlet FriendsView *friendsView;

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

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *opponentTrail;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *opponentLead;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *opponentTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *opponentBottom;


@property (weak, nonatomic) IBOutlet UIButton *myRecentBtn;
@property (weak, nonatomic) IBOutlet UIButton *allRecentBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myRecentLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myRecentTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allRecentTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allRecentLeading;


@property (weak, nonatomic) IBOutlet UIButton *myFriendsBtn;
@property (weak, nonatomic) IBOutlet UIButton *recentFriendsBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myFriendLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myFriendTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recentFriendsTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recentFriendsLeading;


@property (weak, nonatomic) IBOutlet UIButton *chooseOpponentBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *userUpDownButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;


@property (weak, nonatomic) IBOutlet UILabel *myRank;
@property (weak, nonatomic) IBOutlet UILabel *myMile;
@property (weak, nonatomic) IBOutlet UILabel *myAddress;
@property (weak, nonatomic) IBOutlet UILabel *myTime;
@property (weak, nonatomic) IBOutlet UILabel *myOpenClose;

@property (weak, nonatomic) IBOutlet UIView *chooseOponentView;
@property (weak, nonatomic) IBOutlet UIView *locationShadowView;
@property (weak, nonatomic) IBOutlet UIView *topShadowView;
@property (weak, nonatomic) IBOutlet UIView *oppoShadowView;

@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

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
    } else {
        
        [self getRecentGameDataforUser];
        _barLabel.text = [_selectedBar[@"location_name"] capitalizedString];
//        _userLabel.text = data[@"username"];
  //      [_otherUserLabel setText:data[@"username"]];
        
//        [self getGooglePlaces];
        //[self getUserGameData];
    }
    
    if (_isFromMap) {
        
        _chooseOpponentBtn.selected = true;
        [self locationView:true];
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
    
    _noRecordLabel.hidden = true;
    if (!_isLocation) {
        
        _selectedBar = [[NSMutableDictionary alloc] init];
    }
    
    //_reportButton.layer.cornerRadius = 15;
    //_reportButton.layer.masksToBounds = true;
    //_reportButton.layer.borderColor = [UIColor redColor].CGColor;
    //_reportButton.layer.borderWidth = 1.5;
    
    _myOpenClose.layer.cornerRadius = 6;
    _myOpenClose.layer.masksToBounds = true;
    
    _inviteButton.hidden = true;
    _allGames = [[NSMutableArray alloc] init];
    _recentGames = [[NSMutableArray alloc] init];
    _data = [[NSMutableDictionary alloc] init];
    _allFriendsData = [[NSMutableDictionary alloc] init];
    
    _userGamesData = [[NSMutableDictionary alloc] init];
    
    _inviteButton.layer.cornerRadius = 4.5;
    
    _pickerType = PICKER_TYPE_NONE;
    [self userView:false];
    [self opponentView:false];
//    [self locationView:_isLocation];
//    _chooseOpponentBtn.selected = _isLocation;
    [self locationView:false];
    _chooseOpponentBtn.selected = false;
    
    [_gameTableView setView];
    [_gameLocationTableView setView];
    [_comparisionVC setView];
    [_leaderboardView setView];
    [_friendsView setView];
    _friendsView.delegates = self;
    [_currentLabel setText:_gAppPrefData.userName];

    [Utils dropShadow:_chooseOponentView];
    [Utils dropShadow:_locationShadowView];
    [Utils dropShadow:_topShadowView];
    [Utils dropShadow:_oppoShadowView];
    [Utils dropShadow:_winSuperView];
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
        _pickerType = PICKER_TYPE_USER;

        
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
    
    _myFriendTrailing.active = false;
    _myFriendLeading.active = false;
    
    _recentFriendsLeading.active = true;
    _recentFriendsTrailing.active = true;
    
    [_recentFriendsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myFriendsBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    _allRecentLeading.active = false;
    _allRecentTrailing.active = false;
    
    _myRecentLeading.active = true;
    _myRecentTrailing.active = true;
    
    [_myRecentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_allRecentBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    if (isHide) {
        
        
        [self.view addSubview:_locationSuperView];
        
        [self.view addConstraint:_locationTop];
        [self.view addConstraint:_locationBottom];
        [self.view addConstraint:_locationLead];
        [self.view addConstraint:_locationTrail];
        
        //[_userSuperView removeFromSuperview];
        
        if (_pickerType == PICKER_TYPE_USER || _pickerType == PICKER_TYPE_NONE) {
        
            [_userSuperView removeFromSuperview];
        } else if (_pickerType == PICKER_TYPE_OPPONENT) {
            
            [_opponentSuperView removeFromSuperview];
        }
        
        if (!_isFromMap) {
            [self getAllRecentGameData];
            _pickerType = PICKER_TYPE_LOCATION;
        }
    } else {
        
        [_locationSuperView removeFromSuperview];
//        if (_isLocation) {
        if (false) {
        
            [self opponentView:true];
        } else {
        
            [self.view addSubview:_userSuperView];
            _pickerType = PICKER_TYPE_USER;
            
            [self.view addConstraint:_userMainTop];
            [self.view addConstraint:_userMainBottom];
            [self.view addConstraint:_userMainLead];
            [self.view addConstraint:_userMainTrail];
        }
    }
}


- (void)opponentView:(BOOL)isHide {
    
    _searchBar1.text = @"";
    _searchBar2.text = @"";
    
    [_searchBar1 resignFirstResponder];
    [_searchBar2 resignFirstResponder];
    
    if (isHide) {
        
        [self.view addSubview:_opponentSuperView];
        
        [self.view addConstraint:_opponentTrail];
        [self.view addConstraint:_opponentLead];
        [self.view addConstraint:_opponentTop];
        [self.view addConstraint:_opponentBottom];
        [_locationSuperView removeFromSuperview];
        
        [self getOpponentData];
        _pickerType = PICKER_TYPE_OPPONENT;
    } else {
        
        [_opponentSuperView removeFromSuperview];
    }
}



- (void)updateView:(NSDictionary *)dict games:(NSArray *)games session:(BOOL)session {
    
    if (_userGamesData.count <= 0) {
        
        return;
    }
    
    if (games != nil) {
        
        [_gameTableView updateData:games isRecent:false isState:false isSession:session];
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

-(NSString *)validate
{
    NSString* strinvalid = nil;
    if ([_searchBar2.text isEqualToString:@""] || ![Utils isValidEmail:_searchBar2.text])
    {
        strinvalid = @"Please enter a valid email address";
    }
    return strinvalid;
    
}


- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    @try {
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              
                              options:kNilOptions
                              error:&error];
        
        NSArray* places = [json objectForKey:@"results"];
        if (places.count > 0) {
            
            NSDictionary* dict = [places objectAtIndex:0];
            NSString* placeID = [dict valueForKey:@"place_id"];
            
            [self getLocationData:placeID];
        }
        NSLog(@"Google Data: %@", places);
        
        //[self plotPositions:places];
    } @catch (NSException *exception) {
        NSLog(@"error");
    }
}

- (NSString *)getOPeningTime:(NSArray *)times weekDay:(int)weekDay {
    
    NSString* locaDay = [times objectAtIndex:0];
    for (NSString* day in times) {
        
        if (weekDay == 2) {
            
            if ([day containsString:@"Monday"]) {
                
                locaDay = [day stringByReplacingOccurrencesOfString:@"Monday:" withString:@""];
                
            }
        } else if (weekDay == 3) {
            
            if ([day containsString:@"Tuesday"]) {
                
                locaDay = [day stringByReplacingOccurrencesOfString:@"Tuesday:" withString:@""];
                
            }
            
        } else if (weekDay == 4) {
            
            if ([day containsString:@"Wednesday"]) {
                
                locaDay = [day stringByReplacingOccurrencesOfString:@"Wednesday:" withString:@""];
                
            }
        } else if (weekDay == 5) {
            
            if ([day containsString:@"Thursday"]) {
                
                locaDay = [day stringByReplacingOccurrencesOfString:@"Thursday:" withString:@""];
                
            }
        } else if (weekDay == 6) {
            
            if ([day containsString:@"Friday"]) {
                
                locaDay = [day stringByReplacingOccurrencesOfString:@"Friday:" withString:@""];
                
            }
        } else if (weekDay == 7) {
            
            if ([day containsString:@"Saturday"]) {
                
                locaDay = [day stringByReplacingOccurrencesOfString:@"Saturday:" withString:@""];
                
            }
        } else if (weekDay == 1) {
            
            if ([day containsString:@"Sunday"]) {
                
                locaDay = [day stringByReplacingOccurrencesOfString:@"Sunday:" withString:@""];
                
            }
        }
    }
    
    return locaDay;

}

-(void)shareOnFacebook {
    NSString* text = [NSString stringWithFormat:kSHAREFACEBOOKTEXT2, _data[@"username"], _data[@"location_name"]];
    
    NSLog(text);
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController* fbSLComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSString* text = [NSString stringWithFormat:kSHAREFACEBOOKTEXT2, _data[@"username"], _data[@"location_name"]];
        [fbSLComposeViewController setInitialText:text];
        
        if (![Utils isIphone]) {
            fbSLComposeViewController.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:fbSLComposeViewController animated:YES completion:nil];
        
        fbSLComposeViewController.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"facebook: CANCELLED");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"facebook: SHARED");
                    break;
            }
            
            [self.navigationController popViewControllerAnimated:true];
        };
    }
    else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Facebook Unavailable" message:@"Sorry, we're unable to find a Facebook account on your device.\nPlease setup an account in your devices settings and try again." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:true];
        }]];
        
        if (![Utils isIphone]) {
            alert.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (void)showReportBarDialog {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Report" message:@"Please let us know if there’s no pool table here, or if the bar is out of business." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self reporBarData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    
    if (![Utils isIphone]) {
        alert.popoverPresentationController.sourceView = self.view;
    }
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)mailToUser
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"No pool table or bar out of business"];
        
        NSString* str = [NSString stringWithFormat:@"%@\n%@\n%@", _selectedBar[@"location_name"], _selectedBar[@"address"], _gAppPrefData.userName];
        
        NSLog(@"....%@", str);
        [mailController setMessageBody:str isHTML:NO];
        if (![Utils isIphone]) {
            mailController.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:mailController animated:true completion:nil];
    }
    else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Mail Unavailable" message:@"Sorry, we're unable to find a mail account on your device.\nPlease setup an account in your devices settings and try again." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        if (![Utils isIphone]) {
            alert.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:alert animated:true completion:nil];
    }
}

//MARK: API's
- (void)reporBarData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString* API = [NSString stringWithFormat:kAPI_REPORTBAR, _gAppPrefData.userID, _selectedBar[@"bar_id"]];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            [self mailToUser];
            
            /*if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            } else {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            }*/
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)getLocationData:(NSString *)placeID {

    NSString *path = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@&language=en",placeID,GoogleDirectionAPI];
    
    [_gAppData sendGETRequest:path completion:^(id result) {
        
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            
            
            GooglePlaceResult* gresult = [[GooglePlaceResult alloc] initWithDictionary:dict1];
            if ([[gresult.status lowercaseString] isEqualToString:@"ok"]) {
                
                
            }else{
                
            }
            
            
            if (gresult != nil) {
                
                
                DebugLog(@".......%d", gresult.result.isOpen);
                DebugLog(@".......%@", gresult.result.weekday_text);
             
                if (gresult.result.formatted_address.length > 0) {
                
                    NSString* location = [gresult.result.formatted_address lowercaseString];
                    location = [location stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[location substringToIndex:1] uppercaseString]];
                    //_myAddress.text = location;
                    _myAddress.text = gresult.result.formatted_address;
                } else {
                    
                    _myAddress.text = gresult.result.formatted_address;
                }
                
                
                
                [_myTime setText:@"9:00 AM - 10:00 PM"];
                if (gresult.result.weekday_text != nil) {
                    
                    if ( gresult.result.weekday_text.count > 0) {
                 
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
                        int weekday = [comps weekday];
                        
                        [_myTime setText:[self getOPeningTime:gresult.result.weekday_text weekDay:weekday]];
                        
                        
                        DebugLog(@".....%d", weekday);
                    }
                }
                
                if (gresult.result.isOpen) {
                    
                    [_myOpenClose setBackgroundColor:[UIColor greenColor]];
                } else {
                    
                    [_myOpenClose setBackgroundColor:[UIColor redColor]];
                }
                
                CLLocation *locA = [[CLLocation alloc] initWithLatitude:_mylatitude longitude:_myLongitude];
                
                CLLocationDegrees lat2 = [_selectedBar[@"lat"] doubleValue];
                CLLocationDegrees long2 = [_selectedBar[@"long"] doubleValue];
                CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
                
                CLLocationDistance distance = [locA distanceFromLocation:locB];
                
                [_myMile setText:[NSString stringWithFormat:@"%.2f mi", (distance/1609.344)]];
                
                
               // @property (weak, nonatomic) IBOutlet UILabel *myRank;
                //@property (weak, nonatomic) IBOutlet UILabel *myMile;
                //@property (weak, nonatomic) IBOutlet UILabel *myTime;

            }
        }
    } failure:^(id result) {
        
    }];
}

- (void)getGooglePlaces {
  
    NSString* escapedString = [_selectedBar[@"location_name"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    
    CLLocationDegrees lat2 = [_selectedBar[@"lat"] doubleValue];
    CLLocationDegrees long2 = [_selectedBar[@"long"] doubleValue];
    
    NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&key=%@&types=bar%%7cnight_club&rankby=distance&keyword=%@", lat2, long2, GoogleDirectionAPI,escapedString];
    
    NSURL* googleRequestURL = [NSURL URLWithString:url];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)addFriendsData:(NSString *)userID {
    
    NSString* API = [NSString stringWithFormat:kAPI_ADDFRIEND2, _gAppPrefData.userID, userID];
    
    NSLog(@"...kAPI_ADDFRIEND2......%@", API);
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"....%@",dict1);
            NSLog(@"kAPI_ADDFRIEND2 Success");
        }
    } failure:^(id result) {
        
        NSLog(@"kAPI_ADDFRIEND2 Failed");
    }];
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
                
                [self addFriendsData:_data[@"user_id"]];
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"Game recorded" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (!_chooseOpponentBtn.selected) {
                     
                      //  [self locationViewAction:_chooseOpponentBtn];
                    }
                    //[self.navigationController popViewControllerAnimated:true];
                }]];
                
                if (![Utils isIphone]) {
                    alert.popoverPresentationController.sourceView = self.view;
                }
                
                [self presentViewController:alert animated:true completion:nil];
                
                /*if (type == 0) {
                    
                    [self shareOnFacebook];
                } else {
                
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Info" message:dict1[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self.navigationController popViewControllerAnimated:true];
                    }]];
                    
                    if (![Utils isIphone]) {
                        alert.popoverPresentationController.sourceView = self.view;
                    }
                    
                    [self presentViewController:alert animated:true completion:nil];

                }*/
            } else {
                
                [_gAppDelegate showAlertDilog:@"Error!" message:dict1[@"message"]];
                
            }
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)getRecentGameDataforUser {
    
    _userLabel.text = @"";
    _otherUserLabel.text = @"";
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
                
                _userLabel.text = [data[@"username"] capitalizedString];
                [_otherUserLabel setText:[data[@"username"] capitalizedString]];
                
                for (NSDictionary* bar in dict1[@"bars"]) {
                    
                    if ([bar[@"bar_id"] isEqualToString:data[@"bar_id"]]) {
                        
                        //[_selectedBar addEntriesFromDictionary:bar];
                        DebugLog(@"...%@", _selectedBar);
                        [self getUserGameData];
                        [self getGooglePlaces];
                        break;
                    }
                }
            } else {
                
                
              //  [_gAppDelegate showAlertDilog:@"Error!" message:dict1[@"msg"]];
                [self getGooglePlaces];
                if (_isFromMap) {
                    
                    _isFromMap = false;
                    _chooseOpponentBtn.selected = true;
                    [self locationView:true];
                }
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
                
                _barLabel.text = [data[@"location_name"] capitalizedString];
                _userLabel.text = [data[@"username"] capitalizedString];
                [_otherUserLabel setText:[data[@"username"] capitalizedString]];
                
                for (NSDictionary* bar in dict1[@"bars"]) {
                    
                    if ([bar[@"bar_id"] isEqualToString:data[@"bar_id"]]) {
                        
                        [_selectedBar addEntriesFromDictionary:bar];
                        DebugLog(@"...%@", _selectedBar);
                        [self getUserGameData];
                        [self getGooglePlaces];
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
            
            
            [_allGames removeAllObjects];
            [_recentGames removeAllObjects];
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                _noRecordLabel.hidden = true;
                NSArray* list = dict1[@"leaderboard"];
                if (list != nil && list.count > 0) {
                
                    [_leaderboardView updateData:list];
                }
                
                [_allGames addObjectsFromArray:dict1[@"all"]];
                [_recentGames addObjectsFromArray:dict1[@"recent_game"]];
                
                [_gameLocationTableView updateData:_recentGames isRecent:false isState:false isSession:false];
                [_myRank setText:[NSString stringWithFormat:@"My Ranking #%d", [dict1[@"my_rank_overall"] intValue]]];
                
            } else {
                
                
                [_leaderboardView updateData:nil];
                
                [_gameLocationTableView updateData:nil isRecent:false isState:false isSession:false];
                [_myRank setText:[NSString stringWithFormat:@"My Ranking #%d", [dict1[@"my_rank_overall"] intValue]]];
                
                _noRecordLabel.hidden = false;
                
                /*NSString *strMESSAGE;
                NSRange range = [[dict1 objectForKey:@"msg"] rangeOfString:@"No game found"];
                
                if (range.location != NSNotFound)//@"No game found!!!!!"
                {
                    _noRecordLabel.hidden = false;
                    strMESSAGE=[NSString stringWithFormat:@"No previous game found for this bar"];
                }
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Info" message:strMESSAGE preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    //[self.navigationController popViewControllerAnimated:true];
                }]];
                
                if (![Utils isIphone]) {
                    alert.popoverPresentationController.sourceView = self.view;
                }
                
                [self presentViewController:alert animated:true completion:nil];*/

            }
            
        }
        
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}


- (void)getUserGameData {
    
    /*if (_isLocation) {
        return;
    }*/
    
    [_userGamesData removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    NSString* url = [NSString stringWithFormat:kAPI_USERGAMESCORE, _gAppPrefData.userID, (_data != nil) ? _data[@"user_id"] : _gAppPrefData.userID];
    
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
                
                [_userGamesData addEntriesFromDictionary:dict1];
                //[_list addObjectsFromArray:_locData];
                [self updateView:dict1 games:dict1[@"recent_game"] session:false];
            } else {
                
            
                [_gameTableView updateData:nil isRecent:false isState:false isSession:false];
                [_comparisionVC updateData:nil];
               // [_gAppDelegate showAlertDilog:@"Error!" message:dict1[@"msg"]];
            }
            
            if (_isFromMap) {
                
                _isFromMap = false;
                _chooseOpponentBtn.selected = true;
                [self locationView:true];
            }
        }
        
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (_isFromMap) {
            
            _isFromMap = false;
            _chooseOpponentBtn.selected = true;
            [self locationView:true];
        }
    }];
}

- (void)getOpponentData {
    
   
    [_allFriendsData removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];    
    NSString* url = [NSString stringWithFormat:kAPI_OPPONENTDATA, _gAppPrefData.userID, _selectedBar[@"bar_id"]];
    
    [_gAppData sendGETRequest:url completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                //[_allFriendsData addEntriesFromDictionary:dict1];
                
                
                
                NSArray* sortedFriends = [NSMutableArray arrayWithArray:[dict1[@"friends"] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* a, NSDictionary* b) {
                    
                    return [[a[@"username"] lowercaseString] compare:[b[@"username"] lowercaseString]];
                }]];
                
                NSArray* sortedRecent = [NSMutableArray arrayWithArray:[dict1[@"recent"] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* a, NSDictionary* b) {
                    
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                    
                    [formatter setTimeZone:timeZone];
                    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
                    NSDate *dateTime1 = [formatter dateFromString:a[@"date"]];
                    if (dateTime1 == nil) {
                        
                        dateTime1 = [NSDate date];
                    }
                    
                    NSDate *dateTime2 = [formatter dateFromString:b[@"date"]];
                    if (dateTime2 == nil) {
                        
                        dateTime2 = [NSDate date];
                    }
                    
                    return [dateTime2 compare:dateTime1];
                }]];
                
                NSDictionary* lDict = [NSDictionary dictionaryWithObjectsAndKeys:sortedFriends, @"friends", sortedRecent, @"recent", dict1[@"all"], @"all", nil];
                [_allFriendsData addEntriesFromDictionary:lDict];
                [_friendsView updateData:_allFriendsData[@"recent"] isSearch:false myRank:_myRank.text];
            } else {
                
                
                [_gAppDelegate showAlertDilog:@"No contacts!" message:@"Add some friends using the Friends screen from the menu"];
            }
            
        }
        
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)invitewFriendAPI:(NSString *)emailID win:(NSString *)win loss:(NSString *)loss {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString* API = [NSString stringWithFormat:kAPI_INVITEGAME, _selectedBar[@"bar_id"], _gAppPrefData.userID, win, loss, emailID];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        _searchBar1.text = @"";
        _searchBar2.text = @"";
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            } else {
                
                [_gAppDelegate showAlertDilog:nil message:dict1[@"msg"]];
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
- (BOOL)removeOpponetFromView {
    
    if (_pickerType == PICKER_TYPE_OPPONENT) {
        
        [self locationViewAction:_chooseOpponentBtn];
        return true;
    }
    
    if (_pickerType == PICKER_TYPE_USER && _winView.superview != nil) {
        [self chooseOpponent:nil];
        return true;
    }
    
    return false;
}


#pragma mark
#pragma mark UIButton Action Methods
- (IBAction)backAction:(id)sender {
    
    if (_pickerType == PICKER_TYPE_USER && _winView.superview != nil) {
    
        [self chooseOpponent:nil];
    } else {
    
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (IBAction)winAction:(id)sender {
    
    if ([_data count] > 0) {
    
        [self showWinLossDialog:0];
    }
    
}

- (IBAction)lossAction:(id)sender {
    
    if ([_data count] > 0) {
        
        [self showWinLossDialog:1];
    }
}

- (IBAction)userViewAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;    
    [self userView:sender.selected];
}

- (IBAction)locationViewAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [self locationView:sender.selected];
}

- (IBAction)chooseOpponent:(UIButton *)sender {
    
    _chooseOpponentBtn.selected = false;
    [self opponentView:true];
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
    
    [self updateView:_userGamesData games:_userGamesData[@"recent_game"] session:false];
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
    
    //[self getUserGameData];
    
    NSMutableArray* list = [NSMutableArray array];
    int totalGames = 0;
    int totalWin = 0;
    int sessionDiff = 0;
    int index = 0 ;
    NSString* lastSession = @"0";
    for (NSDictionary* dict in _userGamesData[@"recent_game"]) {
        
        
        if ([lastSession isEqualToString:@"0"]) {
            
            lastSession = dict[@"insertime"];
        } else {
            
            NSDate* currentSession = [Utils stringToDate2:dict[@"insertime"]];
            NSDate* lSession = [Utils stringToDate2:lastSession];
            
            NSTimeInterval distanceBetweenDates = [lSession timeIntervalSinceDate:currentSession];
            double secondsInAnHour = 3600;
            NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
            
            NSLog(@"hoursBetweenDates: %ld", (long)hoursBetweenDates);
            sessionDiff = hoursBetweenDates;
        }
        
        
        if (sessionDiff <= 3) {
            
            totalGames = totalGames + 1;
            if ([[[_gAppPrefData userName] lowercaseString] isEqualToString:[dict[@"player1"] lowercaseString]]) {
                if ([[dict[@"by_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
                    
                    totalWin = totalWin + 1;
                } else {
                    
                }
            } else {
                if ([[dict[@"other_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
                    
                    totalWin = totalWin + 1;
                } else {
                }
            }
            
            
            if (index == [_userGamesData[@"recent_game"] count]-1) {
                
                NSDictionary *lDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", totalGames], @"totalGame", [NSString stringWithFormat:@"%d", totalWin], @"status", dict[@"player1"], @"player1", dict[@"player2"], @"player2", lastSession, @"insertime", nil];
                
                [list addObject:lDict];
            }
            
        } else {
            
            NSDictionary *lDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", totalGames], @"totalGame", [NSString stringWithFormat:@"%d", totalWin], @"status", dict[@"player1"], @"player1", dict[@"player2"], @"player2", lastSession, @"insertime", nil];
            
            [list addObject:lDict];
            //Session Record Ended
            
            // New Session Started
            totalGames = 1;
            sessionDiff = 0;
            lastSession = dict[@"insertime"];
            if ([[[_gAppPrefData userName] lowercaseString] isEqualToString:[dict[@"player1"] lowercaseString]]) {
                if ([[dict[@"by_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
                    
                    totalWin = 1;
                } else {
                    
                }
            } else {
                if ([[dict[@"other_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
                    
                    totalWin = 1;
                } else {
                }
            }
            
        }
        
        index++;
        
    }
    
    [self updateView:_userGamesData games:list session:true];
    
}

- (IBAction)recentGameAction:(UIButton *)sender {
    
    _allRecentLeading.active = false;
    _allRecentTrailing.active = false;
    
    _myRecentLeading.active = true;
    _myRecentTrailing.active = true;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_allRecentBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [_gameLocationTableView updateData:_recentGames isRecent:false isState:false isSession:false];
}

- (IBAction)allGameAction:(UIButton *)sender {
    
    
    _allRecentLeading.active = true;
    _allRecentTrailing.active = true;
    
    _myRecentLeading.active = false;
    _myRecentTrailing.active = false;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myRecentBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [_gameLocationTableView updateData:_allGames isRecent:true isState:false isSession:false];
}

- (IBAction)recentFriendsAction:(UIButton *)sender {
    
    [_searchBar1 resignFirstResponder];
    [_searchBar2 resignFirstResponder];
    _myFriendTrailing.active = false;
    _myFriendLeading.active = false;
    
    _recentFriendsLeading.active = true;
    _recentFriendsTrailing.active = true;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_myFriendsBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [_friendsView updateData:_allFriendsData[@"recent"] isSearch:false myRank:_myRank.text];
}

- (IBAction)myFriendsAction:(UIButton *)sender {
    
    [_searchBar1 resignFirstResponder];
    [_searchBar2 resignFirstResponder];
    _myFriendTrailing.active = true;
    _myFriendLeading.active = true;
    
    _recentFriendsLeading.active = false;
    _recentFriendsTrailing.active = false;
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_recentFriendsBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [_friendsView updateData:_allFriendsData[@"friends"] isSearch:false myRank:_myRank.text];
}

- (IBAction)inviteFriendAction:(UIButton *)sender {
 
    NSString *str = [self validate];
    if (str) {
        [_gAppDelegate showAlertDilog:@"Info" message:str];
        
    } else {
        
        [_searchBar1 resignFirstResponder];
        [_searchBar2 resignFirstResponder];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Win" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self invitewFriendAPI:_searchBar2.text win:@"win" loss:@"loss"];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Loose" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self invitewFriendAPI:_searchBar2.text win:@"loss" loss:@"win"];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        
        if (![Utils isIphone]) {
            alert.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:alert animated:true completion:nil];
    }
    
}

- (IBAction)reportButtonAction:(UIButton *)sender {
    
    [self showReportBarDialog];
}


#pragma mark
#pragma mark FriendsView Delegates
- (void)selectedUser:(NSDictionary *)selctedUser {
    
    [_searchBar1 resignFirstResponder];
    [_searchBar2 resignFirstResponder];
    
    [_data addEntriesFromDictionary:selctedUser];
    
    _userLabel.text = [_data[@"username"] capitalizedString];
    [_otherUserLabel setText:[_data[@"username"] capitalizedString] ];
    
    [self opponentView:false];
    
    [self.view addSubview:_userSuperView];
    [self.view addConstraint:_userMainTop];
    [self.view addConstraint:_userMainBottom];
    [self.view addConstraint:_userMainLead];
    [self.view addConstraint:_userMainTrail];
    
    [_userUpDownButton setSelected:true];
    [self userView:true];
}

#pragma mark
#pragma markUITextView Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        _inviteButton.hidden = false;
    } else {
        _inviteButton.hidden = true;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        _inviteButton.hidden = false;
    } else {
        _inviteButton.hidden = true;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.text.length > 0) {
        _inviteButton.hidden = false;
    } else {
        _inviteButton.hidden = true;
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSInteger oldLength = [textField.text length];
    NSInteger newLength = oldLength + [string length] - range.length;
    
    if (newLength > 0) {
        
        _inviteButton.hidden = false;
    } else {
        _inviteButton.hidden = true;
    }
    
    return YES;
}


#pragma mark
#pragma mark UISearchBar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return true;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return true;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchBar.text.length == 0) {
        
        [_friendsView updateData:_allFriendsData[@"recent"] isSearch:false myRank:_myRank.text];
        
    } else {
       
        NSMutableArray* list = [NSMutableArray array];
        for (NSDictionary* dict in _allFriendsData[@"all"]) {
            
            
            NSString* name = [dict[@"username"] lowercaseString];
            NSString* aname = [dict[@"name"] lowercaseString];
            
//            NSString* email = [dict[@"email"] lowercaseString];
 //           NSLog(@"...%@....%@", email, _gAppPrefData.userEmail);
  //          if([email isEqualToString:[_gAppPrefData.userEmail lowercaseString]]){
    //            continue;
      //      }
            if ([name hasPrefix:[searchText lowercaseString]] || [aname hasPrefix:[searchText lowercaseString]])
            {
                [list addObject:dict];
            }
            
        }
        
        [_friendsView updateData:list isSearch:true myRank:_myRank.text];
       
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
}

#pragma mark
#pragma mark Mail ComposerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
