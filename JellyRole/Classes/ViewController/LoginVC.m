//
//  LoginVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/18/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "LoginVC.h"
#import "ViewMessage.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LoginVC ()<UITextViewDelegate, FBSDKLoginButtonDelegate>


@property (weak, nonatomic) IBOutlet UITextField *txt_username;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;

@property (weak, nonatomic) IBOutlet UIButton *btn_login;//*btn_verify
@property (weak, nonatomic) IBOutlet UIButton *btn_fb;

@end

@implementation LoginVC

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
    _btn_login.layer.cornerRadius = 2.5;
    _btn_fb.layer.cornerRadius = 2.5;
    
}

-(NSString *)validate
{
    NSString* strinvalid = nil;
    if ([_txt_username.text isEqualToString:@""])
    {
        //[txt_username becomeFirstResponder];
        strinvalid=@"Please enter user name";
    } else if ([_txt_password.text isEqualToString:@""]) {
        //[txt_password becomeFirstResponder];
        strinvalid=@"Please enter password";
    } else if ([_txt_password.text isEqualToString:@""]) {
    }
    
    return strinvalid;
    
}

#pragma mark
#pragma mark UIButton Action's
- (IBAction)fbLoginAction:(UIButton *)sender {
    
    [self.view endEditing:true];
    FBSDKLoginManager* login = [[FBSDKLoginManager alloc] init];
    //    [login logOut];
    
    [login setLoginBehavior:FBSDKLoginBehaviorNative];
    //    [login setLoginBehavior:FBSDKLoginBehaviorSystemAccount];
    
    [login logInWithReadPermissions:@[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
       
        if( error ){
            
            [login logOut];
            [self fbLoginAction:nil];
            return;
        }else if( result.isCancelled ){
            
            return;
        }else{
            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
            [parameters setValue:@"id,name,email,first_name,last_name,location" forKey:@"fields"];
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result, NSError *error) {
                 if (error == nil) {
                     
                     
                     
                     NSString* params = [NSString stringWithFormat:@"flag=facebook&fb_id=%@&firstname=%@&lastname=%@&image=%@&action=signfb&active_flag=yes&email=%@", result[@"id"], result[@"first_name"], result[@"last_name"], [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200&height=200",result[@"id"]], result[@"email"]];
                     
                     [_gAppDelegate checkFBLogin:result[@"email"] username:[result[@"first_name"] uppercaseString] params:params];
                     return;
                 }else{
                     //                     [CGlobal stopIndicator:self];
                     [login logOut];
                     [self fbLoginAction:nil];
                     return;
                 }
                 
                 
             }];
        }

    }];
}

- (IBAction)removeKeyboardAction:(UIControl *)sender {
    
    [self.view endEditing:true];
}


- (IBAction)login_action:(id)sender
{
    [self.view endEditing:true];
    
    NSString *str = [self validate];
    if (str) {
        [_gAppDelegate showAlertDilog:@"Info" message:str];
        
    } else {
        
        NSString *strEmailOrUsername;
        if (![Utils isValidEmail:_txt_username.text]) {
            strEmailOrUsername = @"username";
        } else {
            strEmailOrUsername = @"email";
        }
        
        NSString* params = [NSString stringWithFormat:kAPI_LoginParams, _txt_username.text, _txt_password.text, strEmailOrUsername, [_gAppDelegate deviceToken]];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [_gAppData sendPostRequest:kAPI_LOGIN params:params completion:^(id result) {
            
            [MBProgressHUD hideHUDForView:self.view animated:true];
            if (result != nil) {
                
                NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"post function tag  ==%@",dict1);
                
                if ([dict1[@"success"] isEqualToString:@"true"]) {
                    
                    AppPrefData* pref = _gAppPrefData;
                    [pref setUserName:dict1[@"username"]];
                    [pref setUserID:dict1[@"user_id"]];
                    [pref setImageURL:dict1[@"image"]];
                    //[pref setUserEmail:dict1[@"email"]];
                    [pref setAddress:dict1[@"address"]];
                    [pref setMemberSince:dict1[@"created_time"]];
                    [pref saveAllData];
                    [_gAppDelegate showViewMessage:self.view type:1];
                    
                } else {
                    
                    if ([dict1[@"active_flag"] isEqualToString:@"no"]) {
                        
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Info" message:dict1[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [self performSegueWithIdentifier:@"VerifySegue" sender:nil];
                        }]];
                        
                        if (![Utils isIphone]) {
                            alert.popoverPresentationController.sourceView = self.view;
                        }
                        
                        [self presentViewController:alert animated:true completion:nil];
                        
                    } else {
                        
                        [_gAppDelegate showViewMessage:self.view type:2];
                    }
                    
                    
                }
                
            }
        } failure:^(id result) {
            
            [MBProgressHUD hideHUDForView:self.view animated:true];
        }];
    }
}

#pragma mark
#pragma markUITextView Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([Utils isIphone])
    {
        if ([Utils isIphone5]) {
            
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *string = textField.text;
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    textField.text = trimmedString;
    
    if ([Utils isIphone])
    {
        if ([Utils isIphone5]) {
            
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txt_username) {
        
        [_txt_password becomeFirstResponder];
    } else {
        
        [textField resignFirstResponder];
    }
    
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *unacceptedInput = nil;
    
    if (textField == _txt_username)//USER NAME
    {
        NSInteger oldLength = [textField.text length];
        NSInteger newLength = oldLength + [string length] - range.length;
        
        if ([string isEqualToString:@" "])
        {
            return  NO;
        }
        if(newLength >= 61){
            return NO;
        }
        return YES;
    }
    
    if (textField == _txt_password)// PASSWORD
    {
        
        NSInteger oldLength = [textField.text length];
        NSInteger newLength = oldLength + [string length] - range.length;
        
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[TextNumericNospace stringByAppendingString:@""]] invertedSet];
        if(newLength >= 21){
            return NO;
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
    return YES;
}


#pragma mark
#pragma mark FBSDKLoginButton Delegates
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error
{
    NSLog(@"mayank fetched user:%@", result.description);
    //[self FBloginResult];
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"Logged out");
}




@end
