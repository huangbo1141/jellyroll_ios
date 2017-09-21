//
//  SignupVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/18/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "SignupVC.h"

@interface SignupVC ()<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *txt_username;
@property (weak, nonatomic) IBOutlet UITextField *txt_firstname;
@property (weak, nonatomic) IBOutlet UITextField *txt_lastname;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UITextField *txt_confirmpassword;
@property (weak, nonatomic) IBOutlet UIButton *btn_signup;
@property (weak, nonatomic) IBOutlet UIButton *btn_fb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation SignupVC

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
    _btn_signup.layer.cornerRadius = 2.5;
    _btn_fb.layer.cornerRadius = 2.5;
    
}

-(NSString *)validate
{
    NSString* strinvalid = nil;
    if ([_txt_username.text isEqualToString:@""] && [_txt_email.text isEqualToString:@""] && [_txt_password.text isEqualToString:@""])
    {
        strinvalid = @"Missing field";
    } else if ([_txt_username.text isEqualToString:@""]) {
        strinvalid=@"Please enter user name";
        return strinvalid;
    } else if ([_txt_email.text isEqualToString:@""]) {
        strinvalid=@"Please enter email";
    } else if (![Utils isValidEmail:_txt_email.text]) {
        strinvalid=@"Please enter valid email";
    } else if([_txt_password.text isEqualToString:@""] || _txt_password.text.length <= 3) {
        strinvalid=@"Please enter password";
    } else if ([_txt_confirmpassword.text isEqualToString:@""] || _txt_confirmpassword.text.length <= 3) {
        //[txt_confirmpassword becomeFirstResponder];
        strinvalid=@"Please enter confirm password";
    } else if (![_txt_password.text isEqualToString: _txt_confirmpassword.text]) {
        strinvalid=@"Password does not match";
    }
    return strinvalid;
    
}



#pragma mark
#pragma mark UIButton Action's
- (IBAction)removeKeyboardAction:(UIControl *)sender {
    
    [self.view endEditing:true];
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)signup_action:(id)sender
{
    [self.view endEditing:true];
    
    NSString *str = [self validate];
    if (str) {
        [_gAppDelegate showAlertDilog:@"Info" message:str];
        
    } else {
        
        NSString* params = [NSString stringWithFormat:kAPI_SignupParams, _txt_username.text, _txt_email.text, _txt_password.text, _txt_firstname.text, _txt_lastname.text];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [_gAppData sendPostRequest:kAPI_SIGNUP params:params completion:^(id result) {
            
            [MBProgressHUD hideHUDForView:self.view animated:true];
            if (result != nil) {
                
                NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"post function tag  ==%@",dict1);
                
                if ([dict1[@"success"] isEqualToString:@"true"]) {
                    
                    
                    AppPrefData* pref = _gAppPrefData;
                    [pref setUserEmail:_txt_email.text];
                    [pref saveAllData];
                    
                    [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
                    
                    //[_multiColorLoader stopAnimation];
                   /* NSLog(@"check 5");
                    UIAlertView *  Myalert=[[UIAlertView alloc]initWithTitle:@"Info" message:[dict1 objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [Myalert show];
                    
                    pref=[NSUserDefaults standardUserDefaults];
                    
                    NSString *Str_verify=txt_email.text;
                    
                    [pref setObject:Str_verify forKey:@"VERIFY_EMAIL"];
                    
                    VerificationViewController *login=[[VerificationViewController alloc]initWithNibName:@"VerificationViewController" bundle:nil];
                    login.Str_Email = txt_email.text;
                    [self.navigationController pushViewController:login animated:YES];
*/
                    
                    
                } else {
                    
                   [_gAppDelegate showAlertDilog:@"Error" message:dict1[@"msg"]];
                    
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
            
            if (textField == _txt_lastname) {
                
                _topConstraint.constant = -50;
            } else if (textField == _txt_email) {
                
                _topConstraint.constant = -90;
            } else if (textField == _txt_password) {
                
                _topConstraint.constant = -100;
            } else if (textField == _txt_confirmpassword) {
                
                _topConstraint.constant = -100;
            }
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _topConstraint.constant = 0;
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
        
        [_txt_firstname becomeFirstResponder];
    } else if (textField == _txt_firstname) {
        
        [_txt_lastname becomeFirstResponder];
    } else if (textField == _txt_lastname) {
        
        [_txt_email becomeFirstResponder];
    } else if (textField == _txt_email) {
        
        [_txt_password becomeFirstResponder];
    } else if (textField == _txt_password) {
        
        [_txt_confirmpassword becomeFirstResponder];
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
        
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[TextNumericNospace stringByAppendingString:@""]] invertedSet];
        if(newLength >= 21){
            return NO;
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
    
    if (textField == _txt_firstname)// FIRST NAME
    {
        
        NSInteger oldLength = [textField.text length];
        NSInteger newLength = oldLength + [string length] - range.length;
        
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[TextName stringByAppendingString:@""]] invertedSet];
        if(newLength >= 21){
            return NO;
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
    
    if (textField == _txt_lastname)// LASTNAME
    {
        
        NSInteger oldLength = [textField.text length];
        NSInteger newLength = oldLength + [string length] - range.length;
        
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[TextName stringByAppendingString:@""]] invertedSet];
        if(newLength >= 21){
            return NO;
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
    if (textField == _txt_email) {
        
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
    if (textField == _txt_confirmpassword)// CONFORM PASSWORD
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



@end
