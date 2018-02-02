//
//  LeaderboardView.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "LeaderboardView.h"

@interface LeaderboardView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* _list;
}

@end

@implementation LeaderboardView

#pragma mark -
#pragma mark - Public Methods
- (void)setView {

    [self setDataSource:self];
    [self setDelegate:self];
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
    
    NSDictionary* dict = _list[indexPath.row];
    
    UIImageView* imageView = [cell viewWithTag:101];
    imageView.image = [UIImage imageNamed:[Utils selectRandomBallImageName:[NSString stringWithFormat:@"%ld", (long)indexPath.row+1]]];
    
    
    UILabel* userName = [cell viewWithTag:102];
    userName.text = dict[@"username"];
    
    UILabel* win = [cell viewWithTag:103];
    win.text = dict[@"win"];

    UILabel* loss = [cell viewWithTag:104];
    loss.text = [NSString stringWithFormat:@"/ %@", dict[@"loss"]];
    
    return cell;
}


#pragma mark - Table view Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
 
    if (_delegates != nil) {
 
        NSDictionary* dict = _list[indexPath.row];
        [_delegates selectedUserDict:dict];
    }
}


@end
