//
//  ProfileVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/21/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "ProfileVC.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileVC ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;


@end

@implementation ProfileVC

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
    [self getProfileData];
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
    
    _imageView.layer.cornerRadius = 30;
    _imageView.layer.masksToBounds = true;
    
    [self updateView:@""];
}

- (void)updateView:(NSString *)userName {
    
    [_imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_gAppPrefData.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholdernew"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        [_imageView setImage:image];
        [_indicatorView stopAnimating];
        
        [Utils saveContents:UIImageJPEGRepresentation(image, 1.0) toFile:[NSString stringWithFormat:@"Upload/%@.jpg", _gAppPrefData.userName]];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        [_indicatorView stopAnimating];
        
    }];
    
    NSString* comp = [[_gAppPrefData.memberSince componentsSeparatedByString:@"-"] objectAtIndex:0];
    
    [_label1 setText:_gAppPrefData.userName];
    [_label2 setText:[NSString stringWithFormat:@"Member since %@", comp]];
    [_label3 setText:userName];
    [_label4 setText:_gAppPrefData.userEmail];
}


- (void)getProfileData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString* API = [NSString stringWithFormat:kAPI_MYPROFILE, _gAppPrefData.userID];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                
                NSMutableArray *arr_GetData=[dict1 valueForKey:@"data"];
                
                AppPrefData* pref = _gAppPrefData;
                [pref setImageURL:[arr_GetData valueForKey:@"image"]];
                [pref saveAllData];

                [self updateView:[NSString stringWithFormat:@"%@ %@",[arr_GetData valueForKey:@"firstname"], [arr_GetData valueForKey:@"lastname"]]];
                
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
