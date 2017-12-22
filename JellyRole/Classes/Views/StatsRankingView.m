//
//  StatsRankingView.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/21/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "StatsRankingView.h"

@interface StatsRankingView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* _list;
    CGFloat mainWidth;
}
@end


@implementation StatsRankingView

#pragma mark -
#pragma mark - Public Methods
- (void)setView {
    
    mainWidth = self.frame.size.width;
    
    [self setDataSource:self];
    [self setDelegate:self];
    
    _list = [[NSArray alloc] init];
}

- (void)updateData:(NSArray *)array {
    
    _list = array;
    [self reloadData];
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
    
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    UILabel* label1 = [cell viewWithTag:101];
    UILabel* label2 = [cell viewWithTag:102];
    UILabel* label3 = [cell viewWithTag:103];
    UILabel* label4 = [cell viewWithTag:104];
    UILabel* label5 = [cell viewWithTag:105];
    UILabel* label6 = [cell viewWithTag:106];
    UILabel* label7 = [cell viewWithTag:107];
    
    UIView* view = [cell viewWithTag:108];
    view.layer.cornerRadius = 1.5;
    view.layer.masksToBounds = true;
    
    label7.layer.cornerRadius = 1.5;
    label7.layer.masksToBounds = true;
    
    [label1 setText:[NSString stringWithFormat:@"#%@",dict[@"rank"]]];
    [label2 setText:dict[@"location_name"]];
    [label3 setText:dict[@"win"]];
    [label4 setText:[NSString stringWithFormat:@"of %@",dict[@"total"]]];
    
    
    int total = [dict[@"total"] intValue];
    int win = [dict[@"win"] intValue];
    
    if (win != 0) {
    
        win = (win*100)/total;
    }
    
    
    for (NSLayoutConstraint* consts in label7.constraints) {
        
        NSLog(@"....%f", mainWidth);
        if (win == 0) {            
            //consts.constant = 20;
            //[label7 setText:@"0%  "];
            consts.constant = 0;
        } else {
            consts.constant = (mainWidth*win)/100;
            
            [label7 setText:[NSString stringWithFormat:@"%d%%", win]];
        }
    }
    
    
    if (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 10 || indexPath.row == 15 || indexPath.row == 20 || indexPath.row == 25 || indexPath.row == 30) {
    
        
        [label3 setTextColor:kYalletColor];
        [label7 setBackgroundColor:kYalletColor];
        
    } else if (indexPath.row == 1 || indexPath.row == 6 || indexPath.row == 11 || indexPath.row == 16 || indexPath.row == 21 || indexPath.row == 26 || indexPath.row == 31) {
        
        [label3 setTextColor:kOrangeColor];
        [label7 setBackgroundColor:kOrangeColor];
        
    } else if (indexPath.row == 2 || indexPath.row == 7 || indexPath.row == 12 || indexPath.row == 17 || indexPath.row == 22 || indexPath.row == 27 || indexPath.row == 32) {
        
        [label3 setTextColor:kRedColor];
        [label7 setBackgroundColor:kRedColor];
        
    } else if (indexPath.row == 3 || indexPath.row == 8 || indexPath.row == 13 || indexPath.row == 18 || indexPath.row == 23 || indexPath.row == 28 || indexPath.row == 33) {
        
        [label3 setTextColor:kFroColor];
        [label7 setBackgroundColor:kFroColor];
        
    } else if (indexPath.row == 4 || indexPath.row == 9 || indexPath.row == 14 || indexPath.row == 19 || indexPath.row == 24 || indexPath.row == 29 || indexPath.row == 34) {
        
        [label3 setTextColor:kGreenColor];
        [label7 setBackgroundColor:kGreenColor];
        
    }
    
    
    [label5 setText:@"0%"];
    [label6 setText:@"100%"];
    
    
    return cell;
}


#pragma mark - Table view Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

@end
