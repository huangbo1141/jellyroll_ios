
//
//  ProfileVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/21/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "ProfileVC.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "B_Nav_VC.h"
#import "HomeVC.h"
#import "UIImage+fixOrientation.h"
#import <TOCropViewController/TOCropViewController.h>
@interface ProfileVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *topShadowView;


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
    _imageView.layer.borderWidth = 1.5;
    _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self updateView:@"" emailID:@""];
    [self getProfileData];
    [Utils dropShadow:_topShadowView];
}

- (void)updateView:(NSString *)userName emailID:(NSString *)emailID {
    
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
    [_label4 setText:emailID];
}

- (void)showPickerType:(UIImagePickerControllerSourceType)source {
    
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = source;
    
    if (![Utils isIphone]) {
        picker.popoverPresentationController.sourceView = self.view;
    }
    
    [self presentViewController:picker animated:true completion:nil];
    
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

                [self updateView:[NSString stringWithFormat:@"%@ %@",[arr_GetData valueForKey:@"firstname"], [arr_GetData valueForKey:@"lastname"]] emailID:[arr_GetData valueForKey:@"email"]];
                
            } else {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            }
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)changePasswodAPI:(NSString *)params {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [_gAppData sendPostRequest:kAPI_CHANGEPASSWORD params:params completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            } else {
                
                [_gAppDelegate showAlertDilog:@"Error" message:dict1[@"msg"]];
            }
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}


- (void)showCameraDialog {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Import image from..?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            [self showPickerType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [_gAppDelegate showAlertDilog:kAppName message:@"Device has no camera"];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showPickerType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }]];
    
    UIAlertAction* cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];;
    
    [cancel setValue:kAlertCancelColor forKey:@"titleTextColor"];
    
    if (![Utils isIphone]) {
        alert.popoverPresentationController.sourceView = self.view;
    }
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showAlertDilog2:(NSString *)title message:(NSString *)message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showChangePasswordDialog];
    }]];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showChangePasswordDialog {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Change Password" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"OLD PASSWORD";
        textField.secureTextEntry = true;
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"NEW PASSWORD";
        textField.secureTextEntry = true;
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"CONFIRM PASSWORD";
        
        textField.secureTextEntry = true;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString* text1 = [[alert textFields][0] text];
        NSString* text2 = [[alert textFields][1] text];
        NSString* text3 = [[alert textFields][2] text];
        if (text1.length <= 0) {
            [self showAlertDilog2:@"Info" message:@"Please enter old password"];                    
        } else if (text2.length <= 3) {
            [self showAlertDilog2:@"Info" message:@"Please enter new password"];
            
        } else if (![text2 isEqualToString:text3]) {
            [self showAlertDilog2:@"Info" message:@"Password and confirm password does not match"];
            
        } else {
            
            NSString* params = [NSString stringWithFormat:kAPI_CHANGEPASSWORDParams, _gAppPrefData.userID, text2, text1];
            
            [self changePasswodAPI:params];
        }
        
    }]];
    
    UIAlertAction* cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];;
    
    [cancel setValue:kAlertCancelColor forKey:@"titleTextColor"];
    
    if (![Utils isIphone]) {
        alert.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:alert animated:true completion:nil];
}

- (void)uploadProfileImage:(NSData *)data {
 
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    [_gAppData uploadPost:@"kapil.jpg" data:data userID:_gAppPrefData.userID url:kAPI_IMAGEUPLOAD completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
                AppPrefData* pref = _gAppPrefData;
                [pref setImageURL:dict1[@"picture"]];
                [pref saveAllData];
            } else {
                
                [_gAppDelegate showAlertDilog:@"Error" message:dict1[@"msg"]];
            }
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

#pragma mark
#pragma mark UIButton Action's
- (IBAction)menuAction:(UIButton *)sender {
    
    KYDrawerController* drawer = (KYDrawerController *)self.navigationController.parentViewController;
    [drawer setDrawerState:DrawerStateOpened animated:true];
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)cameraAction:(UIButton *)sender {
    
    [self showCameraDialog];
}

- (IBAction)setHomeAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
    KYDrawerController* elDrawer = (KYDrawerController *)self.navigationController.parentViewController;
    
    B_Nav_VC* navVC =  (B_Nav_VC *)elDrawer.mainViewController;
    HomeVC* mainVC = (HomeVC *)navVC.visibleViewController;
    
    [mainVC setHomeLocationAction];
}
- (IBAction)changePasswordAction:(id)sender {
    
    [self showChangePasswordDialog];
}

#pragma mark
#pragma mark UIImagePickerController Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    image = [image fixOrientation];
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:image];
    cropViewController.delegate = self;
    
    [picker dismissViewControllerAnimated:true completion:^{
    
        
        _imageView.image = image;
        if (![Utils isIphone]) {
            cropViewController.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:cropViewController animated:true completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    // 'image' is the newly cropped, circular version of the original image
    image = [image imageWithImage:image convertToSize:CGSizeMake(100, image.size.height)];
    [cropViewController dismissViewControllerAnimated:true completion:^{
 
        
        _imageView.image = image;
        
        [self uploadProfileImage:UIImageJPEGRepresentation(image, 0.4)];
    }];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
    [cropViewController dismissViewControllerAnimated:true completion:nil];
}


@end
