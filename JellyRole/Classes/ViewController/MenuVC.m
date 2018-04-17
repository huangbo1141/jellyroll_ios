//
//  MenuVCTableViewController.m
//  ParasTV
//
//  Created by Kapil Kumar on 8/9/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "MenuVC.h"
#import "B_Nav_VC.h"
#import "HomeVC.h"
#import "StatsVC.h"
#import "FriendsVC.h"
#import "PoolTermsVC.h"
#import "PrivacyPolicyVC.h"
#import "FeedbackVC.h"
#import "ProfileVC.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface MenuVC () <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    NSArray* _list;
    NSArray* _listImages;
}

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topShadowView;
@property (weak, nonatomic) IBOutlet UIView *topShadowView2;

@end

@implementation MenuVC

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
    
    [_imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_gAppPrefData.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholdernew"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        [_imageView setImage:image];
        [_indicatorView stopAnimating];
        
        [Utils saveContents:UIImageJPEGRepresentation(image, 1.0) toFile:[NSString stringWithFormat:@"Upload/%@.jpg", _gAppPrefData.userName]];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        [_indicatorView stopAnimating];
        
    }];
    
    NSArray* list = [_gAppPrefData.memberSince componentsSeparatedByString:@"-"];
    
//    NSString* comp = [[_gAppPrefData.memberSince componentsSeparatedByString:@"-"] objectAtIndex:0];
    
    [_label1 setText:_gAppPrefData.userName];
    [_label2 setText:_gAppPrefData.address];
    
    [_label3 setText:[NSString stringWithFormat:@"Member Since %@, %@", [self getMonth:[list[1] intValue]], list[0]]];
    
}

 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
      
}

- (NSString *)getMonth:(int)index {

    NSString* month = @"";
    switch (index) {
        case 1:
            month = @"Jan";
            break;
        case 2:
            month = @"Feb";
            break;
        case 3:
            month = @"Mar";
            break;
        case 4:
            month = @"Apr";
            break;
        case 5:
            month = @"May";
            break;
        case 6:
            month = @"Jun";
            break;
        case 7:
            month = @"Jul";
            break;
        case 8:
            month = @"Aug";
            break;
        case 9:
            month = @"Sep";
            break;
        case 10:
            month = @"Oct";
            break;
        case 11:
            month = @"Nov";
            break;
        case 12:
            month = @"Dec";
            break;
            
        default:
            month = @"Dec";
            break;
    }
    
    return month;
}

#pragma mark
#pragma mark Private Methods
- (void)viewSettings
{
    [self.navigationController setNavigationBarHidden:true];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    //self.tableView.clearsSelectionOnViewWillAppear = NO;
    
    _list = [NSArray arrayWithObjects:@"Stats", @"Friends", @"Pool Rules / Terms", @"Privacy Policy", @"Share this App", @"Feedback", @"Edit Profile", @"Logout", nil];
    _listImages = [NSArray arrayWithObjects:@"Stats", @"Friends", @"Pool", @"Privacy", @"Share", @"Feedback", @"user-2", @"Logout", nil];
    
    _imageView.layer.cornerRadius = 28;
    _imageView.layer.masksToBounds = true;
    _imageView.layer.borderWidth = 1.5;
    _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //[Utils dropShadow:_tableView];
    [Utils dropShadow:_topShadowView];
    [Utils dropShadow:_topShadowView2];
    
//    self.view.layer.shadowOpacity = 0.6;
//    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.view.layer.shadowRadius = 10.0;
//    self.view.layer.cornerRadius = 6.5;
    //        topImageView.layer.masksToBounds = true;
    
//    self.view.layer.shadowOffset = CGSizeMake(0, 50);
    
    
//    self.view.layer.shadowColor = [UIColor purpleColor].CGColor;
//    self.view.layer.shadowOffset = CGSizeMake(4, 4);
//    self.view.layer.shadowOpacity = 0.6;
//    self.view.layer.shadowRadius = 10.0;
    
    
//    _tableView.layer.shadowOpacity = 0.8;
//    _tableView.layer.shadowOffset = CGSizeMake(0, 0);
//    _tableView.layer.shadowRadius = 10.0;
//    _tableView.layer.shadowColor = [UIColor yellowColor].CGColor;
    
//    CGRect shadowRect = CGRectInset(self.view.bounds, 8, 8);
    //self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowRect].CGPath;
    
}

- (void)mailToUser
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        
        [mailController setSubject:kSHAREMAILSUBJECTTEXT];
        NSString* str = [NSString stringWithFormat:kSHAREMAILTEXT, _gAppPrefData.userName];
        
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


- (void)sendSMS
{
    if ([MFMessageComposeViewController canSendText])
    {
        NSString* str = [NSString stringWithFormat:kSHAREMAILTEXT, _gAppPrefData.userName];
        MFMessageComposeViewController* vc = [[MFMessageComposeViewController alloc] init];
        [vc setMessageComposeDelegate:self];
        [vc setBody:str];
        if (![Utils isIphone]) {
            vc.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:vc animated:true completion:nil];
    }
    else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message Unavailable" message:@"Sorry, Text message is not available on this device." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        if (![Utils isIphone]) {
            alert.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:alert animated:true completion:nil];
    }
}


-(BOOL)isFacebookAppInstalled {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"fbauth2";
    components.path = @"/";
    return [[UIApplication sharedApplication]
            canOpenURL:components.URL];
}

-(void)shareOnFacebook {
    if ([self isFacebookAppInstalled]) {
        
        SLComposeViewController* fbSLComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbSLComposeViewController setInitialText:kSHAREFACEBOOKTEXT];
//        [fbSLComposeViewController addImage:[UIImage imageNamed:@"481912407.jpg"]];
//        [fbSLComposeViewController addURL:[NSURL URLWithString:@"http://jellyrollpool.com/"]];
        
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
        };
    }
    else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Facebook Unavailable" message:@"Sorry, we're unable to find a Facebook app on your device.\nPlease install Facebook app on your device and try again." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        if (![Utils isIphone]) {
            alert.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:alert animated:true completion:nil];
    }
}
#pragma mark
#pragma mark UIButton Action Methods
- (IBAction)menuAction:(UIButton *)sender {
    
    KYDrawerController* drawer = (KYDrawerController *)self.navigationController.parentViewController;
    [drawer setDrawerState:DrawerStateClosed animated:true];    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView* imageView = [cell viewWithTag:102];
    [imageView setImage:[UIImage imageNamed:_listImages[indexPath.row]]];
    
    UILabel* label = [cell viewWithTag:101];    
    label.text = _list[indexPath.row];
    
    return cell;
}

#pragma mark - Table view Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (_list.count-1 == indexPath.row) {
        
        [_gAppDelegate logoutSucessful];
    } else {

        KYDrawerController* elDrawer = (KYDrawerController *)self.navigationController.parentViewController;
        [elDrawer setDrawerState:DrawerStateClosed animated:YES];

        B_Nav_VC* navVC =  (B_Nav_VC *)elDrawer.mainViewController;
        
        if (indexPath.row == 0 && [navVC.visibleViewController isKindOfClass:[StatsVC class]]) {
        
            return;
        }
        
        if (indexPath.row == 1 && [navVC.visibleViewController isKindOfClass:[FriendsVC class]]) {
            
            return;
        }
        
        if (indexPath.row == 2 && [navVC.visibleViewController isKindOfClass:[PoolTermsVC class]]) {
            
            return;
        }
        
        if (indexPath.row == 3 && [navVC.visibleViewController isKindOfClass:[PrivacyPolicyVC class]]) {
            
            return;
        }

        if (indexPath.row == 4) {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Share this app" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Mail" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self mailToUser];
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self sendSMS];
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self shareOnFacebook];
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [UIPasteboard generalPasteboard].string = kSHARECOPYTEXT;
            }]];
            UIAlertAction* cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancel];;
            
            [cancel setValue:kAlertCancelColor forKey:@"titleTextColor"];
            
            if (![Utils isIphone]) {
                alert.popoverPresentationController.sourceView = self.view;
            }
            
            [self presentViewController:alert animated:true completion:nil];
            return;
        }
        
        if (indexPath.row == 5 && [navVC.visibleViewController isKindOfClass:[FeedbackVC class]]) {
            
            return;
        }
        
        if (indexPath.row == 6 && [navVC.visibleViewController isKindOfClass:[ProfileVC class]]) {
            
            return;
        }
        
        if (![navVC.visibleViewController isKindOfClass:[HomeVC class]]) {
            
            [navVC popViewControllerAnimated:false];
        }
        
        HomeVC* mainVC = (HomeVC *)navVC.visibleViewController;
        [mainVC performIndexAction:(int)indexPath.row];
    }
}

#pragma mark
#pragma mark Mail ComposerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
        {
            break;
        }
        case MessageComposeResultFailed:
        {
            break;
        }
        case MessageComposeResultSent:
        {
            break;
        }
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
