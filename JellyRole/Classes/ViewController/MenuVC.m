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
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MenuVC ()
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
    
    NSString* comp = [[_gAppPrefData.memberSince componentsSeparatedByString:@"-"] objectAtIndex:0];
    
    [_label1 setText:_gAppPrefData.userName];
    [_label2 setText:_gAppPrefData.address];
    [_label3 setText:[NSString stringWithFormat:@"Member since %@", comp]];
    
}

 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
      
}



#pragma mark
#pragma mark Private Methods
- (void)viewSettings
{
    [self.navigationController setNavigationBarHidden:true];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    //self.tableView.clearsSelectionOnViewWillAppear = NO;
    
    _list = [NSArray arrayWithObjects:@"Stats", @"Friends", @"Pool Rules/Terms", @"Privacy Policy", @"Share this App", @"Feedback", @"Edit Profile", @"Logout", nil];
    _listImages = [NSArray arrayWithObjects:@"Stats", @"Friends", @"Pool", @"Privacy", @"Share", @"Feedback", @"user-2", @"Logout", nil];
    
    _imageView.layer.cornerRadius = 30;
    _imageView.layer.masksToBounds = true;
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
        
        B_Nav_VC* navVC =  (B_Nav_VC *)elDrawer.mainViewController;
        
        HomeVC* mainVC = (HomeVC *)navVC.visibleViewController;
        [mainVC performIndexAction:(int)indexPath.row];
        [elDrawer setDrawerState:DrawerStateClosed animated:YES];
    }
}

@end
