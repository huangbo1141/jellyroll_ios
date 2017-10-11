//
//  FeedbackVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/19/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *tv_Comments;
@property (weak, nonatomic) IBOutlet UIView *bottomShadowVIew;
@property (weak, nonatomic) IBOutlet UIView *topShadowView;

@end

@implementation FeedbackVC

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
    [Utils dropShadow:_bottomShadowVIew];
    [Utils dropShadow:_topShadowView];
}


-(NSString *)validate
{
    if ([_tv_Comments.text isEqualToString:@"Let us know what you think"])
    {
        //[tv_Comments becomeFirstResponder];
        return @"Please Enter Your Comments";
    }
    return nil;
}


#pragma mark
#pragma mark UIButton Action's
- (IBAction)removeKeyboardAction:(UIControl *)sender {
    
    [self.view endEditing:true];
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)feedback_action:(id)sender
{
    [self.view endEditing:true];
    
    NSString *str = [self validate];
    if (str) {
        [_gAppDelegate showAlertDilog:@"Info" message:str];
        
    } else {
        
        NSString* escapedString = [_tv_Comments.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        NSString* API = [NSString stringWithFormat:kAPI_FEEDBACK, _gAppPrefData.userID, escapedString];
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [_gAppData sendGETRequest:API completion:^(id result) {
            
            [MBProgressHUD hideHUDForView:self.view animated:true];
            if (result != nil) {
                
                NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"post function tag  ==%@",dict1);
                
                if ([dict1[@"success"] isEqualToString:@"true"]) {
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"THANK YOU!" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [self.navigationController popViewControllerAnimated:true];
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

#pragma mark
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView == _tv_Comments)
    {
        if ([textView.text isEqualToString:@"Let us know what you think"])
        {
            _tv_Comments.text=@"";
        }
    }
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *rawString = [textView text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0 || textView.text.length==0)
    {
        _tv_Comments.text = @"Let us know what you think";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return textView.text.length + (text.length - range.length) <= 150;
}
@end
