//
//  PrivacyPolicyVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/19/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "PrivacyPolicyVC.h"

@interface PrivacyPolicyVC ()

@property (nonatomic ,weak) IBOutlet UITextView* txt_privacyPolicy;

@end

@implementation PrivacyPolicyVC

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
    
}

- (void)getPrivacyData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [_gAppData sendGETRequest:kAPI_TREMS completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                _txt_privacyPolicy.text = dict1[@"privacy"];                
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

@end
