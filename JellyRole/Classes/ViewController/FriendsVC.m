    //
//  FriendsVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/21/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "FriendsVC.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface FriendsVC () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* _list;
    NSMutableArray* _listTemp;
    NSMutableArray* _listUser;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,weak) IBOutlet UISearchBar* searchBar;

@end

@implementation FriendsVC

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
    [self getFriendsData];
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
    
    _list = [[NSMutableArray alloc] init];
    _listUser = [[NSMutableArray alloc] init];
    _listTemp = [[NSMutableArray alloc] init];
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        
        [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
    } else {
    
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    }
    
    
    
    
}

-(NSString *)validate:(NSString*)emailText
{
    NSString *strinvalid = nil;
    
    if ([emailText isEqualToString:@""])
    {
        strinvalid = @"Please enter email address";
    }
    else if (![Utils isValidEmail:emailText])
    {
        strinvalid=@"Please enter valid email address";
    }
    
    return strinvalid;
}



- (void)getFriendsData {
    
    [_list removeAllObjects];
    [_listUser removeAllObjects];
    [_listTemp removeAllObjects];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString* API = [NSString stringWithFormat:kAPI_FRIENDS, _gAppPrefData.userID];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            _searchBar.text = @"";
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [_listUser addObjectsFromArray:[dict1 valueForKey:@"user"]];
                NSMutableArray* temp = [dict1 valueForKey:@"data"];
                if(temp != nil) {
                    
                    temp = [NSMutableArray arrayWithArray:[temp sortedArrayUsingComparator:^NSComparisonResult(NSMutableDictionary* a, NSMutableDictionary* b) {
                        double first = [a[@"percent"] doubleValue];
                        double second = [b[@"percent"] doubleValue];
                        return first<second;
                    }]];
                    
                    for (int i=0; i<[temp count]; i++) {
                        NSMutableDictionary*dict = temp[i];
                        double p = [dict[@"percent"] doubleValue];
                        if (p<50) {
                            //dict[@"mark"] = @"1";
                            break;
                        }
                    }
                    
                    [_list addObjectsFromArray:temp];
                    [_listTemp addObjectsFromArray:temp];
                }
                
                [_tableView reloadData];
            } else {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            }
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)addFriendsData:(NSString *)email {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString* API = [NSString stringWithFormat:kAPI_ADDFRIEND, _gAppPrefData.userID, email];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            _searchBar.text = @"";
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            [_gAppDelegate showAlertDilog:nil message:@"Friend Added to List"];
            [self getFriendsData];
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)invitewFriendAPI:(NSString *)emailID {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString* API = [NSString stringWithFormat:kAPI_INVITEFRIEND, _gAppPrefData.userID, emailID];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        _searchBar.text = @"";
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            } else {
                
                [_gAppDelegate showAlertDilog:nil message:dict1[@"msg"]];
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

- (IBAction)invitewAction:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invite Friend" message:@"Enter friend's email id here" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter friend's email id here";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Invite" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString* text = [[alert textFields][0] text];
        NSLog(@"Current password %@", text);
        NSString *str = [self validate:text ];
        if (str) {
            [_gAppDelegate showAlertDilog:@"Info" message:str];
            //[self invitewAction:nil];
        } else {
            
            [self invitewFriendAPI:text];
        }
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    if (![Utils isIphone]) {
        alert.popoverPresentationController.sourceView = self.view;
    }
    
    [self presentViewController:alert animated:true completion:nil];
    
}

#pragma mark
#pragma mark UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* dict = _listTemp[indexPath.row];
    
    if (_searchBar.text.length > 0  && dict[@"address"] == nil) {
        
        return 44;
    } else {
        
        return 60;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_listTemp count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* dict = _listTemp[indexPath.row];
    if (_searchBar.text.length > 0 && dict[@"address"] == nil) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSearch" forIndexPath:indexPath];
        
        UILabel* userName = [cell viewWithTag:101];
        userName.text = dict[@"username"];
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        UIActivityIndicatorView* indicator = [cell viewWithTag:105];
        [indicator startAnimating];
        [indicator hidesWhenStopped];
        
        UIImageView* imageView = [cell viewWithTag:101];
        imageView.layer.cornerRadius = 20;
        imageView.layer.masksToBounds = true;
        
        __weak typeof(UIImageView) *weakSelf = imageView;
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"image"]]] placeholderImage:[UIImage imageNamed:@"placeholdernew"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            [weakSelf setImage:image];
            [indicator stopAnimating];
            
            [Utils saveContents:UIImageJPEGRepresentation(image, 1.0) toFile:[NSString stringWithFormat:@"Upload/%@.jpg", dict[@"username"]]];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
            [indicator stopAnimating];
            
        }];
        
        UILabel* userName = [cell viewWithTag:102];
        userName.text = dict[@"username"];
        
        UILabel* name = [cell viewWithTag:103];
        name.text = dict[@"name"];
        
        UILabel* address = [cell viewWithTag:104];
        address.text = dict[@"address"];
        
        return cell;
    }
}

#pragma mark
#pragma mark UITableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary* dict = _listTemp[indexPath.row];
    if (_searchBar.text.length > 0 && dict[@"address"] == nil) {
        
        [_searchBar resignFirstResponder];
        NSString* str = [NSString stringWithFormat:@"Do you want to add \"%@\" into your friend list?", dict[@"username"]];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes, Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self addFriendsData:dict[@"email"]];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        if (![Utils isIphone]) {
            alert.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:alert animated:true completion:nil];
    }
    
}

#pragma mark
#pragma mark UISearchBar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return true;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return true;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchBar.text.length == 0) {
        
        [_listTemp removeAllObjects];
        [_listTemp addObjectsFromArray:_list];
        [self.tableView reloadData];
    } else {
        
        [_listTemp removeAllObjects];
        for (NSDictionary* dict in _listUser) {
            
            
            NSString* name = [dict[@"username"] lowercaseString];
            NSString* email = [dict[@"email"] lowercaseString];
            NSLog(@"...%@....%@", email, _gAppPrefData.userEmail);
            if([email isEqualToString:[_gAppPrefData.userEmail lowercaseString]]){
                continue;
            }
            if ([name hasPrefix:[searchText lowercaseString]])
            {
                [_listTemp addObject:dict];
            }
            
        }
        
        if (_listTemp.count <= 0 ) {
            [_listTemp addObjectsFromArray:_list];
        }
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
}

@end