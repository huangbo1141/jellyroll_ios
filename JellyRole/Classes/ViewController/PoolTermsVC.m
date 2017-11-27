//
//  PoolTermsVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/19/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "PoolTermsVC.h"

@interface PoolTermsVC ()
{
    NSMutableDictionary* _list;
    int _constraintHeight;
}
@property (nonatomic ,weak) IBOutlet UITextView* txt_field1;
@property (nonatomic ,weak) IBOutlet UITextView* txt_field2;
@property (nonatomic ,weak) IBOutlet UITextView* txt_field3;

@property (nonatomic ,weak) IBOutlet NSLayoutConstraint* constraint1;
@property (nonatomic ,weak) IBOutlet NSLayoutConstraint* constraint2;
@property (nonatomic ,weak) IBOutlet NSLayoutConstraint* constraint3;
@property (weak, nonatomic) IBOutlet UIButton *apaButton;
@property (weak, nonatomic) IBOutlet UIButton *barButton;
@property (weak, nonatomic) IBOutlet UIButton *poolButton;

@property (weak, nonatomic) IBOutlet UILabel *barRow;
@property (weak, nonatomic) IBOutlet UILabel *apaRow;
@property (weak, nonatomic) IBOutlet UILabel *poolRule;
@property (weak, nonatomic) IBOutlet UIView *_topShadow1;
@property (weak, nonatomic) IBOutlet UIView *_topShadow2;
@property (weak, nonatomic) IBOutlet UIView *_topShadow3;

@end

@implementation PoolTermsVC

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
    [self getPrivacyData];
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
- (void)viewSettings {
    
    [self.navigationController setNavigationBarHidden:true];
 
    _list = [[NSMutableDictionary alloc] init];
 
    _barButton.selected = true;
    _constraintHeight = self.view.frame.size.height - (170 + 64);
    _constraint1.constant = _constraintHeight;
    
    _constraint2.constant = 50;
    _constraint3.constant = 50;
    
    _apaRow.hidden = true;
    _poolRule.hidden = true;
    
    [Utils dropShadow:__topShadow1];
    [Utils dropShadow:__topShadow2];
    [Utils dropShadow:__topShadow2];
}


- (void)getPrivacyData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [_gAppData sendGETRequest:kAPI_TREMS completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [_list setObject:dict1[@"apa_rule"] forKey:@"apa_rule"];
                [_list setObject:dict1[@"bar_rule"] forKey:@"bar_rule"];
                [_list setObject:dict1[@"terms"] forKey:@"terms"];
                [_list setObject:dict1[@"privacy"] forKey:@"privacy"];
                
                _txt_field1.text = _list[@"bar_rule"];
            } else {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            }
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

#pragma mark
#pragma mark UIButton Action's
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)menuAction:(UIButton *)sender {
    
    KYDrawerController* drawer = (KYDrawerController *)self.navigationController.parentViewController;
    [drawer setDrawerState:DrawerStateOpened animated:true];
}

- (IBAction)barRuleAction:(id)sender {
    
    if (_barButton.selected) {
        
        _barButton.selected = false;
        _constraint1.constant = 50;
        _txt_field1.text = @"";
        _barRow.hidden = true;
    } else {
        
        _barButton.selected = true;
        _constraint1.constant = _constraintHeight;
        _txt_field1.text = _list[@"bar_rule"];
        _barRow.hidden = false;
    }

    _constraint2.constant = 50;
    _constraint3.constant = 50;
    
    _apaButton.selected = false;
    _poolButton.selected = false;
    
    _txt_field2.text = @"";
    _txt_field3.text = @"";
    
    _apaRow.hidden = true;
    _poolRule.hidden = true;
    
}

- (IBAction)apiRuleAction:(id)sender {
    
    
    if (_apaButton.selected) {
        
        _apaButton.selected = false;
        _constraint2.constant = 50;
        _txt_field2.text = @"";
        _apaRow.hidden = true;
    } else {
        
        _apaButton.selected = true;
        _constraint2.constant = _constraintHeight;
        _txt_field2.text = _list[@"apa_rule"];
        _apaRow.hidden = false;
    }
    
    _constraint1.constant = 50;
    _constraint3.constant = 50;
    
    _barButton.selected = false;
    _poolButton.selected = false;
    
    _txt_field1.text = @"";
    _txt_field3.text = @"";
    
    _barRow.hidden = true;
    _poolRule.hidden = true;
}

- (IBAction)poolTermsAction:(id)sender {
    
    if (_poolButton.selected) {
        
        _poolButton.selected = false;
        _constraint3.constant = 50;
        _txt_field3.text = @"";
        _poolRule.hidden = true;
    } else {
        
        _poolButton.selected = true;
        _constraint3.constant = _constraintHeight;
        _txt_field3.text = _list[@"terms"];
        _poolRule.hidden = false;
    }
    
    _constraint1.constant = 50;
    _constraint2.constant = 50;
    
    _barButton.selected = false;
    _apaButton.selected = false;
    
    _txt_field1.text = @"";
    _txt_field2.text = @"";
    
    _barRow.hidden = true;
    _apaRow.hidden = true;
}

@end
