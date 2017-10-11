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
    BOOL _isRecent;
}
@end

@implementation GameView

#pragma mark -
#pragma mark - Public Methods
- (void)setView {
    
    [self setDataSource:self];
    [self setDelegate:self];
    
    _list = [[NSArray alloc] init];

    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateIndicator) userInfo:nil repeats:true];
}

- (void)updateIndicator {
    
    [self flashScrollIndicators];
}

- (void)updateData:(NSArray *)array isRecent:(BOOL)isRecent {

    _list = array;
    _isRecent = isRecent;
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
    
    if (_isRecent) {
    
        for (NSLayoutConstraint* cos in imageView.constraints) {
            cos.constant = 0;
        }
    } else {
        
        for (NSLayoutConstraint* cos in imageView.constraints) {
            cos.constant = 18;
        }
    }
    
    if (_isRecent) {
        
        [label1 setTextColor:[UIColor colorWithRed:15.0/255.0 green:248.0/255.0 blue:15.0/255.0 alpha:1.0]];
        if ([[dict[@"by_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
            
            [label1 setText:dict[@"player1"]];
            [label2 setText:dict[@"player2"]];
            
        } else {
            
            [label1 setText:dict[@"player2"]];
            [label2 setText:dict[@"player1"]];
        }
    } else {

        [label1 setTextColor:[UIColor whiteColor]];
        if ([[[_gAppPrefData userName] lowercaseString] isEqualToString:[dict[@"player1"] lowercaseString]]) {
            
            [label2 setText:dict[@"player2"]];
            
            if ([[dict[@"by_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
                
                [imageView setImage:[UIImage imageNamed:@"thumb1"]];
                [label1 setText:@"Win"];
            } else {
                
                [imageView setImage:[UIImage imageNamed:@"thumb2"]];
                [label1 setText:@"Loss"];
            }
            
        } else {
            [label2 setText:dict[@"player1"]];
            
            if ([[dict[@"other_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
                
                [imageView setImage:[UIImage imageNamed:@"thumb1"]];
                [label1 setText:@"Win"];
            } else {
                
                [imageView setImage:[UIImage imageNamed:@"thumb2"]];
                [label1 setText:@"Loss"];
            }
        }
    }
    
    [label3 setText:[Utils stringToTime:dict[@"insertime"]]];
    [label4 setText:[Utils stringToDate:dict[@"insertime"]]];
    
    return cell;
}


#pragma mark - Table view Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

@end
