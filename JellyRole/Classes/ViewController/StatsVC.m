//
//  StatsVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/21/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "StatsVC.h"
#import "StatsScrollView.h"
#import "GameView.h"
#import "StatsRankingView.h"

@interface StatsVC ()
{
    NSMutableArray *_list;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet StatsScrollView *scrollView;
@property (weak, nonatomic) IBOutlet GameView *gameTableView;
@property (weak, nonatomic) IBOutlet StatsRankingView *rankTableView;

@property (weak, nonatomic) IBOutlet UILabel *currentWinning;
@property (weak, nonatomic) IBOutlet UILabel *longestWinning;
@property (weak, nonatomic) IBOutlet UILabel *rivalName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;


@end

@implementation StatsVC

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
    [self getStatsData];
    
    [_scrollView updateView];
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

- (void)viewDidLayoutSubviews {
    
    [_scrollView setContentSize:CGSizeMake(((20*30)+(20*3)+(20*10)), 0)];
}

#pragma mark
#pragma mark Private Methods
- (void)viewSettings {
    
    [self.navigationController setNavigationBarHidden:true];
    
    _list = [[NSMutableArray alloc] init];
    [_gameTableView setView];
    [_rankTableView setView];
    
    if ([Utils isIphone]) {
        
        if ([Utils isIphone5]) {
            
            _constraint.constant = 30;
        } else if ([Utils isIphone6]) {
            
            _constraint.constant = 5;
        } else if ([Utils isIphone6Plus]) {
            
            _constraint.constant = -30;
        }
    }
}

- (void)updateView:(NSDictionary *)dict games:(NSArray *)games {
    
    _currentWinning.text = dict[@"streak_current"];
    _longestWinning.text = dict[@"streak_longest"];
    _rivalName.text = dict[@"rival_name"];
    
    if (games != nil) {
    
        [_gameTableView updateData:games isRecent:false isState:true isSession:false];
    }
    
    int win = [dict[@"overall_win"] intValue];
    int losss = [dict[@"overall_loss"] intValue];
    losss += win;
    
    NSMutableDictionary* lDict = [NSMutableDictionary dictionary];
    [lDict setValue:dict[@"my_rank_overall"] forKey:@"rank"];
    [lDict setValue:@"Overall" forKey:@"location_name"];
    [lDict setValue:dict[@"overall_win"] forKey:@"win"];
    [lDict setValue:[NSString stringWithFormat:@"%d", losss] forKey:@"total"];
    
    [_list addObject:lDict];
    if (_list.count > 0) {
        
        [_rankTableView updateData:_list];
    }
    
    
}

- (void)getStatsData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString* API = [NSString stringWithFormat:kAPI_STATS, _gAppPrefData.userID];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                NSArray* mainArray = dict1[@"data"];
                /*NSArray*_locData = [NSMutableArray arrayWithArray:[mainArray sortedArrayUsingComparator:^NSComparisonResult(NSMutableDictionary* a, NSMutableDictionary* b) {
                    double first = [a[@"total"] doubleValue];
                    double second = [b[@"total"] doubleValue];
                    return first<second;
                }]];
                
                [_list addObjectsFromArray:_locData];*/
                [_list addObjectsFromArray:mainArray];
                [self updateView:dict1 games:dict1[@"games"]];
                
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

- (IBAction)menuAction:(UIButton *)sender {
    
    KYDrawerController* drawer = (KYDrawerController *)self.navigationController.parentViewController;
    [drawer setDrawerState:DrawerStateOpened animated:true];
}


#pragma mark
#pragma mark UITableView DataSource
/*-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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
*/
#pragma mark
#pragma mark UITableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];

}

@end
