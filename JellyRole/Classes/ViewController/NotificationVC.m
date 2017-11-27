//
//  NotificationVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/25/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "NotificationVC.h"
#import "NotificationRequetVC.h"
@interface NotificationVC ()
{

    NSMutableArray *_allConfirmRequest;
    NSMutableArray *_allPendingRequest;
}

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet NotificationRequetVC *confirmRequest;
@property (weak, nonatomic) IBOutlet NotificationRequetVC *pendingRequest;
@property (weak, nonatomic) IBOutlet UIView *confirmationView;
@property (weak, nonatomic) IBOutlet UIView *pendingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pendingViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;
@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;
@property (weak, nonatomic) IBOutlet UILabel *pendingLabel;
@end

@implementation NotificationVC

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
    
    [self getAllPendingData];
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
    
    _confirmViewHeight.constant = 0.0;
    _pendingViewHeight.constant = 0.0;
    _confirmLabel.hidden = true;
    _pendingLabel.hidden = true;
    
    _mapImageView.image = _mapView;
    
    _allConfirmRequest = [[NSMutableArray alloc] init];
    _allPendingRequest = [[NSMutableArray alloc] init];
    
    [_confirmRequest setView:false];
    [_pendingRequest setView:true];
    [_pendingRequest setDelegates:self];
    [_confirmRequest setDelegates:self];
    
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(confirmLeftGesture:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer * rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(confirmRightGesture:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    //[_confirmRequest addGestureRecognizer:rightSwipe];
    //[_confirmRequest addGestureRecognizer:leftSwipe];
    
    [Utils dropShadow:_confirmationView];
    [Utils dropShadow:_pendingView];
    
}

-(void)updateBottomConstraint {

    NSLog(@"....%f", [UIScreen mainScreen].bounds.size.height);
    NSLog(@"....%f", self.view.bounds.size.height);
    NSLog(@"....%f", self.view.frame.size.height);
    NSLog(@"....%f", _pendingView.frame.origin.y);
    
    if (_allPendingRequest.count > 0) {
        
        if (_allConfirmRequest.count > 0) {
            
            if ([Utils isIphone]) {
                
                if ([Utils isIphone5]) {
                    
                    if (_allConfirmRequest.count > 1) {
                        
                        _centerConstraint.constant = 28;
                    } else if (_allConfirmRequest.count == 1) {
                        
                        _centerConstraint.constant = -48;
                    }
                } else if ([Utils isIphone6]) {
                    
                    if (_allConfirmRequest.count > 2) {
                        
                        _centerConstraint.constant = 52;
                    } else if (_allConfirmRequest.count == 2) {
                        
                        _centerConstraint.constant = -22;
                    } else {
                       _centerConstraint.constant = -(75+22);
                    }
                    
                } else if ([Utils isIphone6Plus]) {
                 
                    if (_allConfirmRequest.count > 3) {
                        
                        _centerConstraint.constant = 93;
                    } else if (_allConfirmRequest.count == 3) {
                        
                        _centerConstraint.constant = 18;
                    } else {
                        
                        if (_allConfirmRequest.count == 2) {
                         
                         _centerConstraint.constant = -(1*57);
                         } else if(_allConfirmRequest.count == 1) {
                         
                         _centerConstraint.constant = -((2*57)+18);
                         }
                    }
                }
            } else {
                
            }
        } else {
            
            _centerConstraint.constant = -((self.view.frame.size.height/2) - 50);
        }
        
    } else {
        _centerConstraint.constant = (self.view.frame.size.height/2) + 20;
    }
}


- (void)getAllPendingData {
    
    [_allConfirmRequest removeAllObjects];
    [_allPendingRequest removeAllObjects];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString* API = [NSString stringWithFormat:kAPI_ALLPENDINGGAMES, _gAppPrefData.userID];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [_allConfirmRequest addObjectsFromArray:[dict1 objectForKey:@"data"]];
                [_allPendingRequest addObjectsFromArray:[dict1 objectForKey:@"data2"]];
                
                
                [_confirmRequest updateData:_allConfirmRequest];
                [_pendingRequest updateData:_allPendingRequest];
                
                if (_allConfirmRequest.count > 0) {
                    
                    _confirmLabel.hidden = false;
                    _confirmViewHeight.constant = 50.0;
                } else {
                    _confirmLabel.hidden = true;
                    _confirmViewHeight.constant = 0.0;
                }
                
                if (_allPendingRequest.count > 0) {
                    
                    _pendingLabel.hidden = false;
                    _pendingViewHeight.constant = 50.0;
                } else {
                    
                    _pendingLabel.hidden = true;
                    _pendingViewHeight.constant = 0.0;
                }
                
                [self updateBottomConstraint];
            } else {
                
                _confirmLabel.hidden = true;
                _pendingLabel.hidden = true;
                _confirmViewHeight.constant = 0.0;
                _pendingViewHeight.constant = 0.0;
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            }
            
        }
    } failure:^(id result) {
        
        _confirmLabel.hidden = true;
        _pendingLabel.hidden = true;
        _confirmViewHeight.constant = 0.0;
        _pendingViewHeight.constant = 0.0;
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)updateStatusDataConfirmrequest:(NSString *)gameID status:(NSString *)status {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    NSString* url = [NSString stringWithFormat:kAPI_CONFIRMGAME, gameID, status];

    [_gAppData sendGETRequest:url completion:^(id result) {
       
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [self getAllPendingData];
                
            } else {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            }
            
        }

    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)updateStatusDataPendingrequest:(NSString *)gameID {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    NSString* url = [NSString stringWithFormat:kAPI_UPDATEPENDINGGAME, gameID];
    
    [_gAppData sendGETRequest:url completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            [self getAllPendingData];
        }
        
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}


- (void)showAcceptDialog:(NSDictionary *)dict {

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to confirm?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self updateStatusDataConfirmrequest:dict[@"game_id"] status:@"confirm"];
        
    }]];
    
    if (![Utils isIphone]) {
        alert.popoverPresentationController.sourceView = self.view;
    }
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showCancelDialog:(NSDictionary *)dict {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to decline?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Decline" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self updateStatusDataConfirmrequest:dict[@"game_id"] status:@"decline"];
    }]];
    
    if (![Utils isIphone]) {
        alert.popoverPresentationController.sourceView = self.view;
    }
    
    [self presentViewController:alert animated:true completion:nil];
}



#pragma mark
#pragma mark UIGestureRecognizer Actions
-(IBAction)confirmLeftGesture:(UIGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:_confirmRequest];
    NSIndexPath* indexPath = [_confirmRequest indexPathForRowAtPoint:point];
    
    if (indexPath != nil) {
        
        NSDictionary* dict = [_allConfirmRequest objectAtIndex:indexPath.row];
        [self showAcceptDialog:dict];
    }

    
}

-(IBAction)confirmRightGesture:(UIGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:_confirmRequest];
    
    NSIndexPath* indexPath = [_confirmRequest indexPathForRowAtPoint:point];
    
    
    if (indexPath != nil) {
        
        NSDictionary* dict = [_allConfirmRequest objectAtIndex:indexPath.row];
        [self showCancelDialog:dict];
    }
}

#pragma mark
#pragma mark Public Methods
- (void)performIndexAction:(int)row {
    
    
}


#pragma mark
#pragma mark UIButton Action Methods
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark
#pragma mark NotificationVC Delegates

- (void)selectedDeleteDict:(NSDictionary *)dict {
    
    [self updateStatusDataPendingrequest:dict[@"game_id"]];
}

- (void)selectedConfirmDict:(NSDictionary *)dict {
 
    [self showAcceptDialog:dict];
}

- (void)selectedDeclineDict:(NSDictionary *)dict {
    
    [self showCancelDialog:dict];
}


@end
