//
//  GameView.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "GameView.h"

@interface GameView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* _list;
}
@end

@implementation GameView

#pragma mark -
#pragma mark - Public Methods
- (void)setView {
    
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
    
    UIImageView* imageView = [cell viewWithTag:101];
    
    UILabel* label1 = [cell viewWithTag:102];
    
    UILabel* label2 = [cell viewWithTag:103];
    
    UILabel* label3 = [cell viewWithTag:104];
    
    UILabel* label4 = [cell viewWithTag:105];
    
    //[label1 setText:dict[@"player1"]];
    [label2 setText:dict[@"player1"]];
    [label3 setText:[Utils stringToTime:dict[@"insertime"]]];
    [label4 setText:[Utils stringToDate:dict[@"insertime"]]];
    
    if ([[dict[@"other_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
     
        [imageView setImage:[UIImage imageNamed:@"thumb2"]];
        [label1 setText:@"Loss"];
    } else {
        
        [imageView setImage:[UIImage imageNamed:@"thumb1"]];
        [label1 setText:@"Win"];
    }
    
    return cell;
}


#pragma mark - Table view Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

@end
