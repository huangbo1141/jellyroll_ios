//
//  VerifiyEmailVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/21/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "VerifiyEmailVC.h"

@interface VerifiyEmailVC ()<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_verifyCode;

@property (weak, nonatomic) IBOutlet UIButton *btn_submit;//*btn_verify
@property (weak, nonatomic) IBOutlet UIButton *btn_resend;

@end

@implementation VerifiyEmailVC

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
    _btn_submit.layer.cornerRadius = 2.5;
    _btn_resend.layer.cornerRadius = 2.5;
    
}

-(NSString *)validate
{
    NSString* strinvalid = nil;
    if ([_txt_email.text isEqualToString:@""])
    {
        //[txt_username becomeFirstResponder];
        strinvalid = @"Please enter email address";
    } else if (![Utils isValidEmail:_txt_email.text]) {
        //[txt_password becomeFirstResponder];
        strinvalid = @"Please enter valid email address";
    } else if ([_txt_verifyCode.text isEqualToString:@""]) {
        strinvalid = @"Please enter verification code";
    }
    
    return strinvalid;
    
}

-(NSString *)validate1
{
    NSString* strinvalid = nil;
    if ([_txt_email.text isEqualToString:@""])
    {
        //[txt_username becomeFirstResponder];
        strinvalid = @"Please enter email address";
    } else if (![Utils isValidEmail:_txt_email.text]) {
        //[txt_password becomeFirstResponder];
        strinvalid = @"Please enter valid email address";
    }
    
    return strinvalid;
    
}



#pragma mark
#pragma mark UIButton Action's
- (IBAction)removeKeyboardAction:(UIControl *)sender {
    
    [self.view endEditing:true];
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:true];
}


- (IBAction)submit_action:(id)sender
{
    [self.view endEditing:true];
    
    NSString *str = [self validate];
    if (str) {
        [_gAppDelegate showAlertDilog:@"Info" message:str];
        
    } else {
        
        NSString* api = [NSString stringWithFormat:kAPI_VERIFIYCODE, _txt_email.text, _txt_verifyCode.text];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [_gAppData sendGETRequest:api completion:^(id result) {
            
            [MBProgressHUD hideHUDForView:self.view animated:true];
            if (result != nil) {
                
                NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"post function tag  ==%@",dict1);
                
                if ([dict1[@"success"] isEqualToString:@"true"]) {
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Info" message:dict1[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self.navigationController popToRootViewControllerAnimated:true];
                    }]];
                    
                    if (![Utils isIphone]) {
                        alert.popoverPresentationController.sourceView = self.view;
                    }
                    
                    [self presentViewController:alert animated:true completion:nil];
                    
                } else {
                    
                    [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
                }
                
            }
        } failure:^(id result) {
            
            [MBProgressHUD hideHUDForView:self.view animated:true];
        }];
    }
}

- (IBAction)resend_action:(id)sender
{
    [self.view endEditing:true];
    
    NSString *str = [self validate1];
    if (str) {
        [_gAppDelegate showAlertDilog:@"Info" message:str];
        
    } else {
        
        NSString* api = [NSString stringWithFormat:kAPI_RESENDCODE, _txt_email.text];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [_gAppData sendGETRequest:api completion:^(id result) {
            
            [MBProgressHUD hideHUDForView:self.view animated:true];
            if (result != nil) {
                
                NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"post function tag  ==%@",dict1);
                
                if ([dict1[@"success"] isEqualToString:@"true"]) {
                    
                    [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"] ];
                } else {
                    
                    [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
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
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *unacceptedInput = nil;
    
    if (textField == _txt_verifyCode)//USER NAME
    {
        
        NSInteger oldLength = [textField.text length];
        NSInteger newLength = oldLength + [string length] - range.length;
        
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[TextNumber stringByAppendingString:@""]] invertedSet];
        if(newLength >= 7){
            return NO;
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
        
        
    } else if (textField == _txt_email) {
        
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
    return YES;
}


@end
